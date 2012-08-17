//
//  TmIndexdefineDao.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TmIndexdefineDao.h"
#import "TmIndexdefine.h"

@implementation TmIndexdefineDao
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
		NSLog(@"open TmIndexdefine error");
		return;
	}
	NSLog(@"open TmIndexdefine database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TmIndexdefine  (indexId INTEGER PRIMARY KEY ",
						 @",indexName TEXT ",
						 @",indexType TEXT ",
						 @",maxiMum INTEGER ",
                         @",miniMum INTEGER ",
                         @",displayName TEXT )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TmIndexdefine error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TmIndexdefine*) tmIndexdefine
{
//	NSLog(@"Insert begin TmIndexdefine");
	const char *insert="INSERT INTO TmIndexdefine (indexId,indexName,indexType,maxiMum,miniMum,displayName) values(?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
//	NSLog(@"indexId=%d", tmIndexdefine.indexId);
//	NSLog(@"indexName=%@", tmIndexdefine.indexName);
//	NSLog(@"indexType=%@", tmIndexdefine.indexType);
//	NSLog(@"maxiMum=%d", tmIndexdefine.maxiMum);
//    NSLog(@"miniMum=%d", tmIndexdefine.miniMum);
//    NSLog(@"displayName=%@", tmIndexdefine.displayName);
//    
    sqlite3_bind_int(statement, 1, tmIndexdefine.indexId);
	sqlite3_bind_text(statement, 2, [tmIndexdefine.indexName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [tmIndexdefine.indexType UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 4, tmIndexdefine.maxiMum);
    sqlite3_bind_int(statement, 5, tmIndexdefine.miniMum);
    sqlite3_bind_text(statement, 6, [tmIndexdefine.displayName UTF8String], -1, SQLITE_TRANSIENT);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert TmIndexdefine error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TmIndexdefine*) tmIndexdefine
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TmIndexdefine where indexId ='%d' ",tmIndexdefine.indexId];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TmIndexdefine error with message [%s]  sql[%@]", errorMsg,deletesql);
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
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TmIndexdefine "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TmIndexdefine error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(NSMutableArray *) getTmIndexdefine:(NSInteger)indexId
{
	NSString *query=[NSString stringWithFormat:@" indexId = %d ",indexId];
	NSMutableArray * array=[TmIndexdefineDao getTmIndexdefineBySql:query];
	return array;
}

+(NSMutableArray *) getTmIndexdefineByName:(NSString *)indexName
{
	NSString *query=[NSString stringWithFormat:@" indexName = '%@' ",indexName];
	NSMutableArray * array=[TmIndexdefineDao getTmIndexdefineBySql:query];
	return array;
}

+(NSMutableArray *) getTmIndexdefine
{
    
	NSString *query=@" lon <> 0 ";
	NSMutableArray * array=[TmIndexdefineDao getTmIndexdefineBySql:query];
    NSLog(@"执行 getTmIndexdefine 数量[%d] ",[array count]);
	return array;
}
+(NSMutableArray *) getTmIndexdefineBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT indexId,indexName,indexType,maxiMum,miniMum,displayName FROM  TmIndexdefine WHERE %@ ",sql1];
    NSLog(@"执行 getTmIndexdefineBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TmIndexdefine *tmIndexdefine=[[TmIndexdefine alloc] init];
            
            tmIndexdefine.indexId = sqlite3_column_int(statement,0);
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tmIndexdefine.indexName = nil;
            else
                tmIndexdefine.indexName = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tmIndexdefine.indexType = nil;
            else
                tmIndexdefine.indexType = [NSString stringWithUTF8String: rowData2];
            
            tmIndexdefine.maxiMum = sqlite3_column_int(statement,3);
            
            tmIndexdefine.miniMum = sqlite3_column_int(statement,4);
            
            char * rowData5=(char *)sqlite3_column_text(statement,5);
            if (rowData5 == NULL)
                tmIndexdefine.displayName = nil;
            else
                tmIndexdefine.displayName = [NSString stringWithUTF8String: rowData5];
            
			[array addObject:tmIndexdefine];
            [tmIndexdefine release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return array;
}

@end