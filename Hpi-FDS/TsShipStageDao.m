//
//  TsShipStageDao.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TsShipStageDao.h"

@implementation TsShipStageDao
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
		NSLog(@"open TsShipStage error");
		return;
	}
	NSLog(@"open TsShipStage database succes ....");
}
+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TsShipStage  (STAGE TEXT PRIMARY KEY ",
                         @",STAGENAME TEXT ",
						 @",SORT INTEGER )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TsShipStage error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TsShipStage*) tsShipStage
{ 
	NSLog(@"Insert begin TsShipStage");
	const char *insert="INSERT INTO TsShipStage (STAGE,STAGENAME,SORT) values(?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    sqlite3_bind_text(statement, 1,[tsShipStage.STAGE UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 2,[tsShipStage.STAGENAME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 3, tsShipStage.SORT); 
    
	re = sqlite3_step(statement);
	if(re!=SQLITE_DONE)
    {
		NSLog( @"Error: insert TsShipStage error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
    }
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TsShipStage*) tsShipStage
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TsShipStage where stage ='%@' ",tsShipStage.STAGE];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TsShipStage error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}

+(NSMutableArray *) getTsShipStage:(NSString *)stage
{
	NSString *query=[NSString stringWithFormat:@" stage = '%@' ",stage];
	NSMutableArray * array=[TsShipStageDao getTsShipStageBySql:query];
	return array;
}
+(NSMutableArray *) getTsShipStage
{
    
	NSString *query=[NSString stringWithString:@" 1=1 "];
	NSMutableArray * array=[TsShipStageDao getTsShipStageBySql:query];
    NSLog(@"执行 TsShipStage 数量[%d] ",[array count]);
	return array;
}
+(NSMutableArray *) getTsShipStageBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT STAGE,STAGENAME,SORT FROM  TsShipStage WHERE %@ ",sql1];
    NSLog(@"执行 getTsShipStageBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TsShipStage *tsShipStage=[[TsShipStage alloc] init];
            
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                tsShipStage.STAGE = nil;
            else
                tsShipStage.STAGE = [NSString stringWithUTF8String: rowData0];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tsShipStage.STAGENAME = nil;
            else
                tsShipStage.STAGENAME = [NSString stringWithUTF8String: rowData1];
            
            tsShipStage.SORT= sqlite3_column_int(statement,2);
                       
			[array addObject:tsShipStage];
            [tsShipStage release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	[array autorelease];
	return array;
}

@end
