//
//  TgFactoryDao.m
//  Hfds
//
//  Created by zcx on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TgFactoryDao.h"
#import "TgFactory.h"

@implementation TgFactoryDao
static sqlite3	*database;

+(NSString  *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"TgFactory.db"];
	return	 path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open TgFactory error");
		return;
	}
	NSLog(@"open TgFactory database succes ....");
}
+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TgFactory  (factoryCode TEXT PRIMARY KEY ",
                         @",factoryName TEXT ",
						 @",capacitySum INTEGER ",
                         @",description TEXT ",
						 @",impOrt INTEGER ",
						 @",impMonth INTEGER ",
						 @",impYear INTEGER ",
                         @",storage INTEGER ",
                         @",conSum INTEGER ",
                         @",conMonth INTEGER ",
                         @",conYear INTEGER ",
                         @",lon TEXT ",
						 @",lat TEXT )"];

	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TgFactory error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TgFactory*) tgFactory
{
	NSLog(@"Insert begin TgFactory");
	const char *insert="INSERT INTO TgFactory (factoryCode,factoryName,capacitySum,description,impOrt,impMonth,impYear,storage,conSum,conMonth,conYear,lon,lat) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
	NSLog(@"factoryCode=%@", tgFactory.factoryCode);
    NSLog(@"factoryName=%@", tgFactory.factoryName);
	NSLog(@"capacitySum=%d", tgFactory.capacitySum);
	NSLog(@"description=%@", tgFactory.description);
	NSLog(@"impOrt=%d", tgFactory.impOrt);
	NSLog(@"impMonth=%d", tgFactory.impMonth);
	NSLog(@"impYear=%d", tgFactory.impYear);
	NSLog(@"storage=%d", tgFactory.storage);
    NSLog(@"conSum=%d", tgFactory.conSum);
    NSLog(@"conMonth=%d", tgFactory.conMonth);
    NSLog(@"conYear=%d", tgFactory.conYear);
    NSLog(@"lon=%@", tgFactory.lon);
    NSLog(@"lat=%@", tgFactory.lat);
    
	sqlite3_bind_text(statement, 1,[tgFactory.factoryCode UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 2, [tgFactory.factoryName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 3, tgFactory.capacitySum);
    sqlite3_bind_text(statement, 4,[tgFactory.description UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 5, tgFactory.impOrt);
    sqlite3_bind_int(statement, 6, tgFactory.impMonth);
    sqlite3_bind_int(statement, 7, tgFactory.impYear);
    sqlite3_bind_int(statement, 8, tgFactory.storage);
    sqlite3_bind_int(statement, 9, tgFactory.conSum);
    sqlite3_bind_int(statement, 10, tgFactory.conMonth);
    sqlite3_bind_int(statement, 11, tgFactory.conYear);
	sqlite3_bind_text(statement, 12,[tgFactory.lon UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 13,[tgFactory.lat UTF8String], -1, SQLITE_TRANSIENT);
    
	re = sqlite3_step(statement);
	if(re!=SQLITE_DONE)
    {
		NSLog( @"Error: insert tgFactory error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
    }
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TgFactory*) tgFactory
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TgFactory where factoryCode ='%@' ",tgFactory.factoryCode];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TgFactory error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}

+(NSMutableArray *) getTgFactory:(NSString *)factoryCode
{
	NSString *query=[NSString stringWithFormat:@" factoryCode = '%@' ",factoryCode];
	NSMutableArray * array=[TgFactoryDao getTgFactoryBySql:query];
	return array;
}
+(NSMutableArray *) getTgFactory
{
    
	NSString *query=[NSString stringWithString:@" lon<>0 "];
	NSMutableArray * array=[TgFactoryDao getTgFactoryBySql:query];
    NSLog(@"执行 getTgFactory 数量[%d] ",[array count]);
	return array;
}
+(NSMutableArray *) getTgFactoryBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT factoryCode,factoryName,capacitySum,description,impOrt,impMonth,impYear,storage,conSum,conMonth,conYear,lon,lat FROM  TgFactory WHERE %@ ",sql1];
    NSLog(@"执行 getTgFactoryBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TgFactory *tgFactory=[[TgFactory alloc] init];
			char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                tgFactory.factoryCode = nil;
            else
                tgFactory.factoryCode = [NSString stringWithUTF8String: rowData0];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tgFactory.factoryName = nil;
            else
                tgFactory.factoryName = [NSString stringWithUTF8String: rowData1];

            tgFactory.capacitySum = sqlite3_column_int(statement,2);
            
            char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                tgFactory.description = nil;
            else
                tgFactory.description = [NSString stringWithUTF8String: rowData3];
    
            tgFactory.impOrt = sqlite3_column_int(statement,4);
            tgFactory.impMonth = sqlite3_column_int(statement,5);
            tgFactory.impYear = sqlite3_column_int(statement,6);
            tgFactory.storage = sqlite3_column_int(statement,7);
            tgFactory.conSum = sqlite3_column_int(statement,8);
            tgFactory.conMonth = sqlite3_column_int(statement,9);
            tgFactory.conYear = sqlite3_column_int(statement,10);
            
            char * rowData11=(char *)sqlite3_column_text(statement,11);
            if (rowData11 == NULL)
                tgFactory.lon = nil;
            else
                tgFactory.lon = [NSString stringWithUTF8String: rowData11];
            
            char * rowData12=(char *)sqlite3_column_text(statement,12);
            if (rowData12 == NULL)
                tgFactory.lat = nil;
            else
                tgFactory.lat = [NSString stringWithUTF8String: rowData12];
            
			[array addObject:tgFactory];
            [tgFactory release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	//zhangcx add
	[array autorelease];
	return array;
}

@end
