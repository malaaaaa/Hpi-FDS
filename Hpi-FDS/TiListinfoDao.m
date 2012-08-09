//
//  TiListinfoDao.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-17.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TiListinfoDao.h"
#import "TiListinfo.h"

@implementation TiListinfoDao
static sqlite3	*database;

+(NSString  *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"TiListinfo.db"];
	return	 path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open TiListinfo error");
		return;
	}
	NSLog(@"open TiListinfo database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TiListinfo  (infoId INTEGER PRIMARY KEY ",
						 @",columns INTEGER ",
						 @",rows INTEGER ",
                         @",title TEXT ",
						 @",dataValue TEXT ",
						 @",decLength INTEGER ",
                         @",url TEXT )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TiListinfo error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TiListinfo*) tiListinfo
{
	NSLog(@"Insert begin TiListinfo");
	const char *insert="INSERT INTO TiListinfo (infoId,columns,rows,title,dataValue,decLength,url) values(?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
	NSLog(@"infoId=%d", tiListinfo.infoId);
	NSLog(@"columns=%d", tiListinfo.columns);
	NSLog(@"rows=%d", tiListinfo.rows);
    NSLog(@"title=%@", tiListinfo.title);
	NSLog(@"dataValue=%@", tiListinfo.dataValue);
	NSLog(@"decLength=%d", tiListinfo.decLength);
	NSLog(@"url=%@", tiListinfo.url);
    
	sqlite3_bind_int(statement, 1, tiListinfo.infoId);
    sqlite3_bind_int(statement, 2, tiListinfo.columns);
    sqlite3_bind_int(statement, 3, tiListinfo.rows);
    sqlite3_bind_text(statement, 4, [tiListinfo.title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [tiListinfo.dataValue UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 6, tiListinfo.decLength);
	sqlite3_bind_text(statement, 7, [tiListinfo.url UTF8String], -1, SQLITE_TRANSIENT);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert TiListinfo error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TiListinfo*) tiListinfo
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TiListinfo where infoId ='%d' ",tiListinfo.infoId];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TiListinfo error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}

+(NSMutableArray *) getTiListinfo:(NSInteger)infoId
{
	NSString *query=[NSString stringWithFormat:@" infoId = '%d' ",infoId];
	NSMutableArray * array=[TiListinfoDao getTiListinfoBySql:query];
	return array;
}
+(NSMutableArray *) getTiListinfo :(NSInteger)columns :(NSInteger)rows
{
    NSString *query=[NSString stringWithFormat:@" columns = '%d' AND rows = '%d'",columns,rows];
	NSMutableArray * array=[TiListinfoDao getTiListinfoBySql:query];
	return array;
}
+(NSMutableArray *) getTiListinfoBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT infoId,columns,rows,title,dataValue,decLength,url FROM  TiListinfo WHERE %@ ",sql1];
    NSLog(@"执行 getTiListinfoBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TiListinfo *tiListinfo=[[TiListinfo alloc] init];
            
            tiListinfo.infoId = sqlite3_column_int(statement,0);
            
            tiListinfo.columns = sqlite3_column_int(statement,1);
            
            tiListinfo.rows = sqlite3_column_int(statement,2);
            
            char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                tiListinfo.title = nil;
            else
                tiListinfo.title = [NSString stringWithUTF8String: rowData3];
            
            char * rowData4=(char *)sqlite3_column_text(statement,4);
            if (rowData4 == NULL)
                tiListinfo.dataValue = nil;
            else
                tiListinfo.dataValue = [NSString stringWithUTF8String: rowData4];
            
            tiListinfo.decLength = sqlite3_column_int(statement,5);
            
            char * rowData6=(char *)sqlite3_column_text(statement,6);
            if (rowData6 == NULL)
                tiListinfo.url = nil;
            else
                tiListinfo.url = [NSString stringWithUTF8String: rowData6];
            
			[array addObject:tiListinfo];
            [tiListinfo release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	[array autorelease];
	return array;
}

@end
