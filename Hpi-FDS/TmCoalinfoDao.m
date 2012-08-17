//
//  TmCoalinfoDao.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TmCoalinfoDao.h"
#import "TmCoalinfo.h"
@implementation TmCoalinfoDao
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
		NSLog(@"open TmCoalinfo error");
		return;
	}
	NSLog(@"open TmCoalinfo database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TmCoalinfo  (infoId INTEGER PRIMARY KEY ",
						 @",portCode TEXT ",
						 @",recordDate TEXT ",
                         @",import INTEGER ",
                         @",Export INTEGER ",
						 @",storage INTEGER )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TmCoalinfo error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TmCoalinfo*) tmCoalinfo
{
	NSLog(@"Insert begin TmCoalinfo");
	const char *insert="INSERT INTO TmCoalinfo (infoId,portCode,recordDate,import,Export,storage) values(?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
	NSLog(@"infoId=%d", tmCoalinfo.infoId);
	NSLog(@"portCode=%@", tmCoalinfo.portCode);
	NSLog(@"recordDate=%@", tmCoalinfo.recordDate);
	NSLog(@"import=%d", tmCoalinfo.import);
    NSLog(@"Export=%d", tmCoalinfo.Export);
    NSLog(@"storage=%d", tmCoalinfo.storage);
    
    sqlite3_bind_int(statement, 1, tmCoalinfo.infoId);
	sqlite3_bind_text(statement, 2, [tmCoalinfo.portCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [tmCoalinfo.recordDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 4, tmCoalinfo.import);
    sqlite3_bind_int(statement, 5, tmCoalinfo.Export);
    sqlite3_bind_int(statement, 6, tmCoalinfo.storage);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert TmCoalinfo error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TmCoalinfo*) tmCoalinfo
{
    sqlite3_stmt *statement;
    NSLog(@"delete %d",tmCoalinfo.infoId);
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TmCoalinfo where infoId='%d' ",
						 tmCoalinfo.infoId];
	NSInteger SqlOK=sqlite3_prepare_v2(database, [deletesql UTF8String], -1, &statement, NULL);
    if (SqlOK != SQLITE_OK) {
        NSLog( @"Error: delete TmCoalinfo error with message [%s]  sql[%@]", sqlite3_errmsg(database),deletesql);
        sqlite3_finalize(statement);
		return;
    }
    
    if(sqlite3_step(statement) == SQLITE_ERROR)
	{
		NSLog( @"Error: delete TmCoalinfo error with message [%s]  sql[%@]", sqlite3_errmsg(database),deletesql);
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

+(NSMutableArray *) getTmCoalinfo:(NSInteger)infoId
{
	NSString *query=[NSString stringWithFormat:@" infoId = '%d' ",infoId];
	NSMutableArray * array=[TmCoalinfoDao getTmCoalinfoBySql:query];
	return array;
}
+(NSMutableArray *) getTmCoalinfo:(NSString *)portCode :(NSDate*)startDay :(NSDate *)endDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *end=[dateFormatter stringFromDate:endDay];
    NSString *start=[dateFormatter stringFromDate:startDay];
	NSString *query=[NSString stringWithFormat:@" portCode = '%@' AND recordDate >='%@' AND recordDate <='%@' ",portCode,start,end];
	NSMutableArray * array=[TmCoalinfoDao getTmCoalinfoBySql:query];
    NSLog(@"执行 getTmCoalinfo 数量[%d] ",[array count]);
    [dateFormatter release];
	return array;
}

+(TmCoalinfo *) getTmCoalinfoOne:(NSString *)portCode :(NSDate*)day
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *start=[dateFormatter stringFromDate:day];
    NSString *end=[dateFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([day timeIntervalSinceReferenceDate] + 24*60*60)]];
	NSString *query=[NSString stringWithFormat:@" portCode = '%@' AND recordDate >='%@' AND recordDate <='%@' Limit 1 ",portCode,start,end];
	NSMutableArray * array=[TmCoalinfoDao getTmCoalinfoBySql:query];
    //NSLog(@"执行 getTmCoalinfo 数量[%d] ",[array count]);
    [dateFormatter release];
    if ([array count]==0) {
        return nil;
    }
    else 
        return (TmCoalinfo *)[array objectAtIndex:0];
}

+(NSMutableArray *) getTmCoalinfoBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT infoId,portCode,recordDate,import,Export,storage FROM  TmCoalinfo WHERE %@ ",sql1];
    //NSLog(@"执行 getTmCoalinfoBySql [%@] ",sql);
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TmCoalinfo *tmCoalinfo=[[TmCoalinfo alloc] init];
            
            tmCoalinfo.infoId = sqlite3_column_int(statement,0);
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tmCoalinfo.portCode = nil;
            else
                tmCoalinfo.portCode = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tmCoalinfo.recordDate = nil;
            else
                tmCoalinfo.recordDate = [NSString stringWithUTF8String: rowData2];
            
            tmCoalinfo.import = sqlite3_column_int(statement,3);
            
            tmCoalinfo.Export = sqlite3_column_int(statement,4);
            
            tmCoalinfo.storage = sqlite3_column_int(statement,5);
            
			[array addObject:tmCoalinfo];
            [tmCoalinfo release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return array;
}
@end
