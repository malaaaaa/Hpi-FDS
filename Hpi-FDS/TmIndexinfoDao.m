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
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"database.db"];
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
						 @",infoValue TEXT )"];
	
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
    /*
	NSLog(@"infoId=%d", tmIndexinfo.infoId);
	NSLog(@"indexName=%@", tmIndexinfo.indexName);
	NSLog(@"recordTime=%@", tmIndexinfo.recordTime);
	NSLog(@"infoValue=%@", tmIndexinfo.infoValue);
    */
    sqlite3_bind_int(statement, 1, tmIndexinfo.infoId);
	sqlite3_bind_text(statement, 2, [tmIndexinfo.indexName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [tmIndexinfo.recordTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [tmIndexinfo.infoValue UTF8String], -1, SQLITE_TRANSIENT);
    
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
+(void) deleteAll
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TmIndexinfo "];
	
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
+(NSMutableArray *) getTmIndexinfo:(NSString *)indexName :(NSDate*)startDay :(NSDate *)endDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *end=[NSString stringWithFormat:@"%@%@",[dateFormatter stringFromDate:endDay],@"T00:00:00"];
    NSString *start=[NSString stringWithFormat:@"%@%@",[dateFormatter stringFromDate:startDay],@"T00:00:00"];
    
  
    
	NSString *query=[NSString stringWithFormat:@" indexName = '%@' AND recordTime >='%@' AND recordTime <='%@' order by recordTime desc ",indexName,start,end];
	NSMutableArray * array=[TmIndexinfoDao getTmIndexinfoBySql:query];
    
  //  NSLog(@"执行 getTmIndexinfo 数量[%d] ",[array count]);
    [dateFormatter release];
	return array;
}

+(TmIndexinfo *) getTmIndexinfoOne:(NSString *)indexName :(NSDate*)day
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *start=[dateFormatter stringFromDate:day];
    NSString *end=[dateFormatter stringFromDate:[[[NSDate alloc]  initWithTimeIntervalSinceReferenceDate:([day timeIntervalSinceReferenceDate] + 24*60*60)] autorelease]];
	NSString *query=[NSString stringWithFormat:@" indexName = '%@' AND recordTime >='%@' AND recordTime <='%@' Limit 1 ",indexName,start,end];
	NSMutableArray * array=[TmIndexinfoDao getTmIndexinfoBySql:query];
//   NSLog(@"执行 getTmIndexinfo 数量[%d] ",[array count]);
    [dateFormatter release];
    if ([array count]==0) {
        return nil;
    }
    else 
        return (TmIndexinfo *)[array objectAtIndex:0];
}
+(NSMutableArray *) getTmIndexinfoByName:(NSString *)indexName startDay:(NSDate*)startDay Days:(NSInteger)days
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *start=[dateFormatter stringFromDate:startDay];
    NSString *end=[dateFormatter stringFromDate:[[[NSDate alloc]  initWithTimeIntervalSinceReferenceDate:([startDay timeIntervalSinceReferenceDate] + days*24*60*60)] autorelease]];
	NSString *query=[NSString stringWithFormat:@" indexName = '%@' AND recordTime >='%@' AND recordTime <='%@' order by recordTime ",indexName,start,end];
	NSMutableArray * array=[TmIndexinfoDao getTmIndexinfoBySql:query];
    //   NSLog(@"执行 getTmIndexinfo 数量[%d] ",[array count]);
    [dateFormatter release];
  
    return array;
}
+(NSMutableArray *) getTmIndexinfoBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT infoId,indexName,recordTime,infoValue FROM  TmIndexinfo WHERE %@ ",sql1];
//   NSLog(@"执行 getTmIndexinfoBySql [%@] ",sql);
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
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
            
            char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                tmIndexinfo.infoValue = nil;
            else
                tmIndexinfo.infoValue = [NSString stringWithUTF8String: rowData3];
            
			[array addObject:tmIndexinfo];
            [tmIndexinfo release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);

	return array;
}

@end