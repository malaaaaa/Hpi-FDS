//
//  TmShipinfoDao.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TmShipinfoDao.h"
#import "TmShipinfo.h"
@implementation TmShipinfoDao
static sqlite3	*database;

+(NSString  *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"TmShipinfo.db"];
	return	 path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open TmShipinfo error");
		return;
	}
	NSLog(@"open TmShipinfo database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TmShipinfo  (infoId INTEGER PRIMARY KEY ",
						 @",portCode TEXT ",
						 @",recordDate TEXT ",
                         @",waitShip INTEGER ",
                         @",transactShip INTEGER ",
						 @",loadShip INTEGER )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TmShipinfo error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TmShipinfo*) tmShipinfo
{
	NSLog(@"Insert begin TmShipinfo");
	const char *insert="INSERT INTO TmShipinfo (infoId,portCode,recordDate,waitShip,transactShip,loadShip) values(?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
	NSLog(@"infoId=%d", tmShipinfo.infoId);
	NSLog(@"portCode=%@", tmShipinfo.portCode);
	NSLog(@"recordDate=%@", tmShipinfo.recordDate);
	NSLog(@"waitShip=%d", tmShipinfo.waitShip);
    NSLog(@"transactShip=%d", tmShipinfo.transactShip);
    NSLog(@"loadShip=%d", tmShipinfo.loadShip);
    
    sqlite3_bind_int(statement, 1, tmShipinfo.infoId);
	sqlite3_bind_text(statement, 2, [tmShipinfo.portCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [tmShipinfo.recordDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 4, tmShipinfo.waitShip);
    sqlite3_bind_int(statement, 5, tmShipinfo.transactShip);
    sqlite3_bind_int(statement, 6, tmShipinfo.loadShip);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert TmShipinfo error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TmShipinfo*) tmShipinfo
{ 
    sqlite3_stmt *statement;
    NSLog(@"delete %d",tmShipinfo.infoId);
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TmShipinfo where infoId='%d' ",
						 tmShipinfo.infoId];
	NSInteger SqlOK=sqlite3_prepare_v2(database, [deletesql UTF8String], -1, &statement, NULL);
    if (SqlOK != SQLITE_OK) {
        NSLog( @"Error: delete TmShipinfo error with message [%s]  sql[%@]", sqlite3_errmsg(database),deletesql);
        sqlite3_finalize(statement);
		return;
    }
    
    if(sqlite3_step(statement) == SQLITE_ERROR)
	{
		NSLog( @"Error: delete TmShipinfo error with message [%s]  sql[%@]", sqlite3_errmsg(database),deletesql);
        sqlite3_finalize(statement);
		return;
	}
	else
	{
        NSLog(@"delete success");	
        sqlite3_finalize(statement);
		return;
    }
}

+(NSMutableArray *) getTmShipinfo:(NSInteger)infoId
{
	NSString *query=[NSString stringWithFormat:@" infoId = '%d' ",infoId];
	NSMutableArray * array=[TmShipinfoDao getTmShipinfoBySql:query];
	return array;
}
+(NSMutableArray *) getTmShipinfo:(NSString *)portCode :(NSDate*)startDay :(NSDate *)endDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *end=[dateFormatter stringFromDate:endDay];
    NSString *start=[dateFormatter stringFromDate:startDay];
	NSString *query=[NSString stringWithFormat:@" portCode = '%@' AND recordDate >='%@' AND recordDate <='%@' ",portCode,start,end];
	NSMutableArray * array=[TmShipinfoDao getTmShipinfoBySql:query];
    NSLog(@"执行 getTmShipinfo 数量[%d] ",[array count]);
    [dateFormatter release];
	return array;
}

+(TmShipinfo *) getTmShipinfoOne:(NSString *)portCode :(NSDate*)day
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *start=[dateFormatter stringFromDate:day] ;
    NSString *end=[dateFormatter stringFromDate:[[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([day timeIntervalSinceReferenceDate] + 24*60*60)] autorelease]] ;
   
	NSString *query=[NSString stringWithFormat:@" portCode = '%@' AND recordDate >='%@' AND recordDate <='%@' Limit 1 ",portCode,start,end];
  
	NSMutableArray * array=[TmShipinfoDao getTmShipinfoBySql:query] ;
    //NSLog(@"执行 getTmShipinfo 数量[%d] ",[array count]);
   
    [dateFormatter release];
    
    if ([array count]==0) {
        return nil;
    }
    else 
        return (TmShipinfo *)[array objectAtIndex:0];
}

+(NSMutableArray *) getTmShipinfoBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT infoId,portCode,recordDate,waitShip,transactShip,loadShip FROM  TmShipinfo WHERE %@ ",sql1];
    //NSLog(@"执行 getTmShipinfoBySql [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TmShipinfo *tmShipinfo=[[TmShipinfo alloc] init];
            
            tmShipinfo.infoId = sqlite3_column_int(statement,0);
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tmShipinfo.portCode = nil;
            else
                tmShipinfo.portCode = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tmShipinfo.recordDate = nil;
            else
                tmShipinfo.recordDate = [NSString stringWithUTF8String: rowData2];
            
            tmShipinfo.waitShip = sqlite3_column_int(statement,3);
            
            tmShipinfo.transactShip = sqlite3_column_int(statement,4);
            
            tmShipinfo.loadShip = sqlite3_column_int(statement,5);
            
			[array addObject:tmShipinfo];
            [tmShipinfo release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return array;
}
@end
