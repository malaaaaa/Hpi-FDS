//
//  TmIndextypeDao.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TmIndextypeDao.h"
#import "TmIndextype.h"

@implementation TmIndextypeDao
static sqlite3	*database;

+(NSString  *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"TmIndextype.db"];
	return	 path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open TmIndextype error");
		return;
	}
	NSLog(@"open TmIndextype database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TmIndextype  (typeId INTEGER PRIMARY KEY ",
						 @",indexType TEXT ",
						 @",typeName TEXT )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TmIndextype error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TmIndextype*) tmIndextype
{
	NSLog(@"Insert begin TmIndextype");
	const char *insert="INSERT INTO TmIndextype (typeId,indexType,typeName) values(?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
	NSLog(@"typeId=%d", tmIndextype.typeId);
	NSLog(@"indexType=%@", tmIndextype.indexType);
	NSLog(@"typeName=%@", tmIndextype.typeName);
    
    sqlite3_bind_int(statement, 1, tmIndextype.typeId);
	sqlite3_bind_text(statement, 2, [tmIndextype.indexType UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [tmIndextype.typeName UTF8String], -1, SQLITE_TRANSIENT);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert TmIndextype error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TmIndextype*) tmIndextype
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TmIndextype where typeId ='%d' ",tmIndextype.typeId];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TmIndextype error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}

+(NSMutableArray *) getTmIndextype:(NSInteger)typeId
{
	NSString *query=[NSString stringWithFormat:@" typeId = '%d' ",typeId];
	NSMutableArray * array=[TmIndextypeDao getTmIndextypeBySql:query];
	return array;
}
+(NSMutableArray *) getTmIndextype
{
    
	NSString *query=@" 1=1 ";
	NSMutableArray * array=[TmIndextypeDao getTmIndextypeBySql:query];
    NSLog(@"执行 getTmIndextype 数量[%d] ",[array count]);
	return array;
}
+(NSMutableArray *) getTmIndextypeBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT typeId,indexType,typeName FROM  TmIndextype WHERE %@ ",sql1];
    NSLog(@"执行 getTmIndextypeBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TmIndextype *tmIndextype=[[TmIndextype alloc] init];
            
            tmIndextype.typeId = sqlite3_column_int(statement,0);
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tmIndextype.indexType = nil;
            else
                tmIndextype.indexType = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tmIndextype.typeName = nil;
            else
                tmIndextype.typeName = [NSString stringWithUTF8String: rowData2];
            
			[array addObject:tmIndextype];
            [tmIndextype release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return array;
}

@end
