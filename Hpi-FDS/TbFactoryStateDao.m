//
//  TbFactoryStateDao.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TbFactoryStateDao.h"
#import "TbFactoryState.h"

@implementation TbFactoryStateDao
static sqlite3	*database;

+(NSString  *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"database.db"];
	return	 path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open TbFactoryState error");
		return;
	}
	NSLog(@"open TbFactoryState database succes ....");
}
+(void) initDb
{	
 
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TbFactoryState  (STID INTEGER PRIMARY KEY ",
                         @",FACTORYCODE TEXT ",
						 @",RECORDDATE DATE ",
                         @",IMPORT INTEGER ",
						 @",EXPORT INTEGER ",
						 @",STORAGE INTEGER ",
						 @",CONSUM INTEGER ",
                         @",AVALIABLE INTEGER ",
                         @",MONTHIMP INTEGER ",
                         @",YEARIMP INTEGER ",
                         @",ELECGENER INTEGER ",
                         @",STORAGE7 INTEGER ",
                         @",TRANSNOTE TEXT ",
						 @",NOTE TEXT )"];
    
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TbFactoryState error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TbFactoryState*) tbFactoryState
{
	NSLog(@"Insert begin TbFactoryState");
	const char *insert="INSERT INTO TbFactoryState (STID, FACTORYCODE, RECORDDATE, IMPORT, EXPORT, STORAGE, CONSUM, AVALIABLE, MONTHIMP, YEARIMP, ELECGENER, STORAGE7, TRANSNOTE, NOTE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }

	NSLog(@"STID=%d", tbFactoryState.STID);
    NSLog(@"FACTORYCODE=%@", tbFactoryState.FACTORYCODE);
	NSLog(@"RECORDDATE=%@", tbFactoryState.RECORDDATE);
	NSLog(@"IMPORT=%d", tbFactoryState.IMPORT);
	NSLog(@"EXPORT=%d", tbFactoryState.EXPORT);
	NSLog(@"STORAGE=%d", tbFactoryState.STORAGE);
	NSLog(@"CONSUM=%d", tbFactoryState.CONSUM);
	NSLog(@"AVALIABLE=%d", tbFactoryState.AVALIABLE);
    NSLog(@"MONTHIMP=%d", tbFactoryState.MONTHIMP);
    NSLog(@"YEARIMP=%d", tbFactoryState.YEARIMP);
    NSLog(@"ELECGENER=%d", tbFactoryState.ELECGENER);
    NSLog(@"STORAGE7=%d", tbFactoryState.STORAGE7);
    NSLog(@"TRANSNOTE=%@", tbFactoryState.TRANSNOTE);
    NSLog(@"NOTE=%@", tbFactoryState.NOTE);

    
    sqlite3_bind_int(statement, 1, tbFactoryState.STID);
	sqlite3_bind_text(statement, 2,[tbFactoryState.FACTORYCODE UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 3, [tbFactoryState.RECORDDATE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 4, tbFactoryState.IMPORT);
    sqlite3_bind_int(statement, 5, tbFactoryState.EXPORT);
    sqlite3_bind_int(statement, 6, tbFactoryState.STORAGE);
    sqlite3_bind_int(statement, 7, tbFactoryState.CONSUM);
    sqlite3_bind_int(statement, 8, tbFactoryState.AVALIABLE);
    sqlite3_bind_int(statement, 9, tbFactoryState.MONTHIMP);
    sqlite3_bind_int(statement, 10, tbFactoryState.YEARIMP);
    sqlite3_bind_int(statement, 11, tbFactoryState.ELECGENER);
    sqlite3_bind_int(statement, 12, tbFactoryState.STORAGE7);
    sqlite3_bind_text(statement, 13,[tbFactoryState.TRANSNOTE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 14,[tbFactoryState.NOTE UTF8String], -1, SQLITE_TRANSIENT);

  	re = sqlite3_step(statement);
	if(re!=SQLITE_DONE)
    {
		NSLog( @"Error: insert tbFactoryState error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
    }
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TbFactoryState*) tbFactoryState
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  tbFactoryState where STID =%d ",tbFactoryState.STID];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete tbFactoryState error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}

+(NSMutableArray *) getTbFactoryState:(NSString *)factoryCode
{
	NSString *query=[NSString stringWithFormat:@" factoryCode = '%@' ",factoryCode];
	NSMutableArray * array=[TbFactoryStateDao getTbFactoryStateBySql:query];
	return array;
}

+(NSMutableArray *) getTbFactoryStateBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT STID, FACTORYCODE, RECORDDATE, IMPORT, EXPORT, STORAGE, CONSUM, AVALIABLE, MONTHIMP, YEARIMP, ELECGENER, STORAGE7, TRANSNOTE, NOTE FROM  tbFactoryState WHERE %@ ",sql1];
    NSLog(@"执行 getTbFactoryStateBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TbFactoryState *tbFactoryState=[[TbFactoryState alloc] init];
            
            tbFactoryState.STID = sqlite3_column_int(statement,0);

			char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tbFactoryState.FACTORYCODE = nil;
            else
                tbFactoryState.FACTORYCODE = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tbFactoryState.RECORDDATE = nil;
            else
                tbFactoryState.RECORDDATE = [NSString stringWithUTF8String: rowData2];
            
            tbFactoryState.IMPORT = sqlite3_column_int(statement,3);
            tbFactoryState.EXPORT = sqlite3_column_int(statement,4);
            tbFactoryState.STORAGE = sqlite3_column_int(statement,5);
            tbFactoryState.CONSUM = sqlite3_column_int(statement,6);
            tbFactoryState.AVALIABLE = sqlite3_column_int(statement,7);
            tbFactoryState.MONTHIMP = sqlite3_column_int(statement,8);
            tbFactoryState.YEARIMP = sqlite3_column_int(statement,9);
            tbFactoryState.STORAGE7 = sqlite3_column_int(statement,10);

            
            char * rowData11=(char *)sqlite3_column_text(statement,11);
            if (rowData11 == NULL)
                tbFactoryState.TRANSNOTE = nil;
            else
                tbFactoryState.TRANSNOTE = [NSString stringWithUTF8String: rowData11];
            
            char * rowData12=(char *)sqlite3_column_text(statement,12);
            if (rowData12 == NULL)
                tbFactoryState.NOTE = nil;
            else
                tbFactoryState.NOTE = [NSString stringWithUTF8String: rowData12];
            
			[array addObject:tbFactoryState];
            [tbFactoryState release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	//zhangcx add
	[array autorelease];
	return array;
}
@end
