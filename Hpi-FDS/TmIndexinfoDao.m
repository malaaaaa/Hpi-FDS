//
//  TmIndexinfoDao.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TmIndexinfoDao.h"
#import "TmIndexinfo.h"

@implementation TmIndexinfoDao
static sqlite3	*database;

+(NSString  *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"TmIndexinfo.db"];
	return	 path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open TmIndexinfo error");
		return;
	}
	NSLog(@"open TmIndexinfo database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TmIndexinfo  (infoId INTEGER PRIMARY KEY ",
						 @",indexName TEXT ",
						 @",recordTime TEXT ",
						 @",infoValue INTEGER )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TmIndexinfo error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TmIndexinfo*) tmIndexinfo
{
	NSLog(@"Insert begin TmIndexinfo");
	const char *insert="INSERT INTO TmIndexinfo (infoId,indexName,recordTime,infoValue) values(?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
	NSLog(@"infoId=%d", tmIndexinfo.infoId);
	NSLog(@"indexName=%@", tmIndexinfo.indexName);
	NSLog(@"recordTime=%@", tmIndexinfo.recordTime);
	NSLog(@"infoValue=%d", tmIndexinfo.infoValue);
    
    sqlite3_bind_int(statement, 1, tmIndexinfo.infoId);
	sqlite3_bind_text(statement, 2, [tmIndexinfo.indexName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [tmIndexinfo.recordTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 4, tmIndexinfo.infoValue);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert TmIndexinfo error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TmIndexinfo*) tmIndexinfo
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TmIndexinfo where infoId ='%d' ",tmIndexinfo.infoId];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TmIndexinfo error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}

+(NSMutableArray *) getTmIndexinfo:(NSInteger)infoId
{
	NSString *query=[NSString stringWithFormat:@" infoId = '%d' ",infoId];
	NSMutableArray * array=[TmIndexinfoDao getTmIndexinfoBySql:query];
	return array;
}
+(NSMutableArray *) getTmIndexinfo
{
    
	NSString *query=[NSString stringWithString:@" lon <> 0 "];
	NSMutableArray * array=[TmIndexinfoDao getTmIndexinfoBySql:query];
    NSLog(@"执行 getTmIndexinfo 数量[%d] ",[array count]);
	return array;
}
+(NSMutableArray *) getTmIndexinfoBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT infoId,indexName,recordTime,infoValue FROM  TmIndexinfo WHERE %@ ",sql1];
    NSLog(@"执行 getTmIndexinfoBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TmIndexinfo *tmIndexinfo=[[TmIndexinfo alloc] init];
            
            tmIndexinfo.infoId = sqlite3_column_int(statement,0);
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tmIndexinfo.indexName = nil;
            else
                tmIndexinfo.indexName = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tmIndexinfo.recordTime = nil;
            else
                tmIndexinfo.recordTime = [NSString stringWithUTF8String: rowData2];
            
            tmIndexinfo.infoValue = sqlite3_column_int(statement,3);
            
			[array addObject:tmIndexinfo];
            [tmIndexinfo release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return array;
}

@end