//
//  TfFactoryDao.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TfFactoryDao.h"
#import "TfFactory.h"


@implementation TfFactoryDao
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
		NSLog(@"open database.db error");
		return;
	}
	NSLog(@"open database.db database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TfFactory  (FACTORYCODE TEXT PRIMARY KEY ",
                         @",FACTORYNAME TEXT ",
						 @",CAPACITYSUM TEXT ",
                         @",DESCRIPTION TEXT ",
						 @",SORT INTEGER ",
						 @",BERTHNUM INTEGER ",
						 @",BERTHWET TEXT ",
                         @",CHANNELDEPTH TEXT ",
                         @",CATEGORY TEXT ",
                         @",MAXSTORAGE INTEGER ",
                         @",ORGANCODE TEXT )" ];
                   
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TfFactory error");
		printf("%s",errorMsg);
		return;
		
	}
}
/*******电厂靠泊动态***********/
//获得  tffactory  数据实体 根据 电厂名
+(TfFactory *)getTfFactoryByName:(NSString *)factoryName
{
    
    TfFactory *tfFactory=[[[TfFactory   alloc] init] autorelease];
    
    NSString *query=[NSString stringWithFormat:@" FACTORYNAME = '%@'  ORDER BY sort",factoryName];
    if ([[TfFactoryDao getTfFactoryBySql:query] count]>0) {
        tfFactory=  [[TfFactoryDao getTfFactoryBySql:query] objectAtIndex:0];
    }
    
    
    
    return tfFactory;
    
}


/*******电厂靠泊动态***********/
+(void)insert:(TfFactory*) tfFactory
{
//	NSLog(@"Insert begin TfFactory");
	const char *insert="INSERT INTO TfFactory (FACTORYCODE,FACTORYNAME,CAPACITYSUM,DESCRIPTION,SORT,BERTHNUM,BERTHWET,CHANNELDEPTH,CATEGORY,MAXSTORAGE,ORGANCODE) values(?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
//	NSLog(@"FACTORYCODE=%@", tfFactory.FACTORYCODE);
//    NSLog(@"FACTORYNAME=%@", tfFactory.FACTORYNAME);
//	NSLog(@"CAPACITYSUM=%@", tfFactory.CAPACITYSUM);
//	NSLog(@"DESCRIPTION=%@", tfFactory.DESCRIPTION);
//	NSLog(@"SORT=%d", tfFactory.SORT);
//	NSLog(@"BERTHNUM=%d", tfFactory.BERTHNUM);
//	NSLog(@"BERTHWET=%@", tfFactory.BERTHWET);
//	NSLog(@"CHANNELDEPTH=%@", tfFactory.CHANNELDEPTH);
//    NSLog(@"CATEGORY=%@", tfFactory.CATEGORY);
//    NSLog(@"MAXSTORAGE=%d", tfFactory.MAXSTORAGE);
//    NSLog(@"ORGANCODE=%@", tfFactory.ORGANCODE);
//
//    
	sqlite3_bind_text(statement, 1,[tfFactory.FACTORYCODE UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 2, [tfFactory.FACTORYNAME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [tfFactory.CAPACITYSUM UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 4, [tfFactory.DESCRIPTION UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 5, tfFactory.SORT);
    sqlite3_bind_int(statement, 6, tfFactory.BERTHNUM);
    sqlite3_bind_text(statement, 7,[tfFactory.BERTHWET UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8,[tfFactory.CHANNELDEPTH UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 9,[tfFactory.CATEGORY UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 10, tfFactory.MAXSTORAGE);
    sqlite3_bind_text(statement, 11,[tfFactory.ORGANCODE UTF8String], -1, SQLITE_TRANSIENT);

    
	re = sqlite3_step(statement);
	if(re!=SQLITE_DONE)
    {
		NSLog( @"Error: insert tfFactory error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
    }
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TfFactory*) tfFactory
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  tfFactory where factoryCode ='%@' ",tfFactory.FACTORYCODE];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete tfFactory error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}
+(void) deleteAll
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  tfFactory  "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete tfFactory error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(NSMutableArray *) getTfFactory:(NSString *)factoryCode
{
	NSString *query=[NSString stringWithFormat:@" factoryCode = '%@' ",factoryCode];
	NSMutableArray * array=[TfFactoryDao getTfFactoryBySql:query];
	return array;
}

+(NSMutableArray *) getTfFactoryBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT FACTORYCODE,FACTORYNAME,CAPACITYSUM,DESCRIPTION,SORT,BERTHNUM,BERTHWET,CHANNELDEPTH,CATEGORY,MAXSTORAGE,ORGANCODE FROM  tfFactory WHERE %@ ",sql1];
  // NSLog(@"执行 gettfFactoryBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TfFactory *tfFactory=[[TfFactory alloc] init];
			char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                tfFactory.FACTORYCODE = nil;
            else
                tfFactory.FACTORYCODE = [NSString stringWithUTF8String: rowData0];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tfFactory.FACTORYNAME = nil;
            else
                tfFactory.FACTORYNAME = [NSString stringWithUTF8String: rowData1];
            
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tfFactory.CAPACITYSUM = nil;
            else
                tfFactory.CAPACITYSUM = [NSString stringWithUTF8String: rowData2];
            
            char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                tfFactory.DESCRIPTION = nil;
            else
                tfFactory.DESCRIPTION = [NSString stringWithUTF8String: rowData3];
            
            
            tfFactory.SORT = sqlite3_column_int(statement,4);
            tfFactory.BERTHNUM = sqlite3_column_int(statement,5);
            
            char * rowData6=(char *)sqlite3_column_text(statement,6);
            if (rowData6 == NULL)
                tfFactory.BERTHWET = nil;
            else
                tfFactory.BERTHWET = [NSString stringWithUTF8String: rowData6];
            
            char * rowData7=(char *)sqlite3_column_text(statement,7);
            if (rowData7 == NULL)
                tfFactory.CHANNELDEPTH = nil;
            else
                tfFactory.CHANNELDEPTH = [NSString stringWithUTF8String: rowData7];
            
            char * rowData8=(char *)sqlite3_column_text(statement,8);
            if (rowData8 == NULL)
                tfFactory.CATEGORY = nil;
            else
                tfFactory.CATEGORY = [NSString stringWithUTF8String: rowData8];
            
            
            tfFactory.MAXSTORAGE = sqlite3_column_int(statement,9);

            char * rowData10=(char *)sqlite3_column_text(statement,10);
            if (rowData10 == NULL)
                tfFactory.ORGANCODE = nil;
            else
                tfFactory.ORGANCODE = [NSString stringWithUTF8String: rowData10];
            
       
            
			[array addObject:tfFactory];
            [tfFactory release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
        sqlite3_finalize(statement);
        sqlite3_close(database);
	}
	sqlite3_finalize(statement);
    //sqlite3_close(database);
	[array autorelease];
	return array;
}

@end
