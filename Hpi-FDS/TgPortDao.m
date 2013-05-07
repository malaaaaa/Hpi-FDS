//
//  TgPortDao.m
//  Hfds
//
//  Created by zcx on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TgPortDao.h"
#import "TgPort.h"
@implementation TgPortDao
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
		NSLog(@"open TgPort error");
		return;
	}
	NSLog(@"open TgPort database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TgPort  (portCode TEXT PRIMARY KEY ",
						 @",shipNum INTEGER ",
						 @",handleShip INTEGER ",
						 @",waitShip INTEGER ",
						 @",transactShip INTEGER ",
						 @",loadShip INTEGER ",
                         @",portName TEXT ",
                         @",lon TEXT ",
                         @",lat TEXT )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TgPort error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TgPort*) tgPort
{
//	NSLog(@"Insert begin TgPort");
	const char *insert="INSERT INTO TgPort (portCode,shipNum,handleShip,loadShip,transactShip,waitShip,portName,lon,lat) values(?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
//	NSLog(@"portCode=%@", tgPort.portCode);
//	NSLog(@"shipNum=%d", tgPort.shipNum);
//	NSLog(@"handleShip=%d", tgPort.handleShip);
//	NSLog(@"loadShip=%d", tgPort.loadShip);
//	NSLog(@"transactShip=%d", tgPort.transactShip);
//	NSLog(@"waitShip=%d", tgPort.waitShip);
//	NSLog(@"portName=%@", tgPort.portName);
//    NSLog(@"lon=%@", tgPort.lon);
//    NSLog(@"lat=%@", tgPort.lat);
//    
	sqlite3_bind_text(statement, 1, [tgPort.portCode UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(statement, 2, tgPort.shipNum);
    sqlite3_bind_int(statement, 3, tgPort.handleShip);
    sqlite3_bind_int(statement, 4, tgPort.loadShip);
    sqlite3_bind_int(statement, 5, tgPort.transactShip);
    sqlite3_bind_int(statement, 6, tgPort.waitShip);
	sqlite3_bind_text(statement, 7, [tgPort.portName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [tgPort.lon UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 9, [tgPort.lat UTF8String], -1, SQLITE_TRANSIENT);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert TgPort error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TgPort*) tgPort
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TgPort where portCode ='%@' ",tgPort.portCode];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TgPort error with message [%s]  sql[%@]", errorMsg,deletesql);
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
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TgPort "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TgPort error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
//		NSLog(@"delete success");
	}
	return;
}

+(NSMutableArray *) getTgPort:(NSString *)portCode
{
	NSString *query=[NSString stringWithFormat:@" portCode = '%@' ",portCode];
	NSMutableArray * array=[TgPortDao getTgPortBySql:query];
	return array;
}
+(NSMutableArray *) getTgPortByPortName:(NSString *)portName
{
	NSString *query=[NSString stringWithFormat:@" portName = '%@' ",portName];
	NSMutableArray * array=[TgPortDao getTgPortBySql:query];
	return array;
}

+(NSMutableArray *) getTgPort
{
    
	NSString *query=@" lon <> 0 ";
	NSMutableArray * array=[TgPortDao getTgPortBySql:query];
  //  NSLog(@"执行 getTgPort 数量[%d] ",[array count]);
	return array;
}

+(NSMutableArray *) getTgPortSort
{
    
	NSString *query=@" lon <> 0 ";
	NSMutableArray * array=[TgPortDao getTgPortSortBySql:query];
    //  NSLog(@"执行 getTgPortSortBySql 数量[%d] ",[array count]);
	return array;
}

#pragma mark---getTgPortSortBySql添加---
#pragma mark getTgPortSortBySql  tgport和tfport关联,以tgport数据为准.以tfport离的sort排序。

+(NSMutableArray *) getTgPortSortBySql:(NSString *)sql1
{

    sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"select  a.portCode,a.shipNum,a.handleShip,a.loadShip,a.transactShip,a.waitShip,a.portName,a.lon,a.lat    from   TgPort   as a   left  join TF_Port    as  b  on  a.portCode=b.portcode  WHERE %@   order by   cast( b.sort  as INTEGER )  asc",sql1];
    //NSLog(@"执行 getTgPortSortBySql [%@] ",sql);
    
    /*select  a.portCode,a.shipNum,a.handleShip,a.loadShip,a.transactShip,a.waitShip,a.portName,a.lon,a.lat    from   TgPort   as a   left  join TF_Port    as  b  on  a.portCode=b.portcode  WHERE %@   order by   cast( b.sort  as INTEGER )  desc*/
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TgPort *tgPort=[[TgPort alloc] init];
			char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                tgPort.portCode = nil;
            else
                tgPort.portCode = [NSString stringWithUTF8String: rowData0];
            
            tgPort.shipNum = sqlite3_column_int(statement,1);
            tgPort.handleShip = sqlite3_column_int(statement,2);
            tgPort.loadShip = sqlite3_column_int(statement,3);
            tgPort.transactShip = sqlite3_column_int(statement,4);
            tgPort.waitShip = sqlite3_column_int(statement,5);
            
            char * rowData6=(char *)sqlite3_column_text(statement,6);
            if (rowData6 == NULL)
                tgPort.portName = nil;
            else
                tgPort.portName = [NSString stringWithUTF8String: rowData6];
            
            char * rowData7=(char *)sqlite3_column_text(statement,7);
            if (rowData7 == NULL)
                tgPort.lon = nil;
            else
                tgPort.lon = [NSString stringWithUTF8String: rowData7];
            
            char * rowData8=(char *)sqlite3_column_text(statement,8);
            if (rowData8 == NULL)
                tgPort.lat = nil;
            else
                tgPort.lat = [NSString stringWithUTF8String: rowData8];
            
			[array addObject:tgPort];
            [tgPort release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	//zhangcx add
	[array autorelease];
	return array;



}




+(NSMutableArray *) getTgPortBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"select  portCode,shipNum,handleShip,loadShip,transactShip,waitShip,portName,lon,lat    from   TgPort     WHERE %@   ",sql1];
    //NSLog(@"执行 getTgPortBySql [%@] ",sql);
    
    /*select  a.portCode,a.shipNum,a.handleShip,a.loadShip,a.transactShip,a.waitShip,a.portName,a.lon,a.lat    from   TgPort   as a   left  join TF_Port    as  b  on  a.portCode=b.portcode  WHERE %@   order by   cast( b.sort  as INTEGER )  desc*/
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TgPort *tgPort=[[TgPort alloc] init];
			char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                tgPort.portCode = nil;
            else
                tgPort.portCode = [NSString stringWithUTF8String: rowData0];
            
            tgPort.shipNum = sqlite3_column_int(statement,1);
            tgPort.handleShip = sqlite3_column_int(statement,2);
            tgPort.loadShip = sqlite3_column_int(statement,3);
            tgPort.transactShip = sqlite3_column_int(statement,4);
            tgPort.waitShip = sqlite3_column_int(statement,5);
            
            char * rowData6=(char *)sqlite3_column_text(statement,6);
            if (rowData6 == NULL)
                tgPort.portName = nil;
            else
                tgPort.portName = [NSString stringWithUTF8String: rowData6];
            
            char * rowData7=(char *)sqlite3_column_text(statement,7);
            if (rowData7 == NULL)
                tgPort.lon = nil;
            else
                tgPort.lon = [NSString stringWithUTF8String: rowData7];

            char * rowData8=(char *)sqlite3_column_text(statement,8);
            if (rowData8 == NULL)
                tgPort.lat = nil;
            else
                tgPort.lat = [NSString stringWithUTF8String: rowData8];
            
			[array addObject:tgPort];
            [tgPort release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	//zhangcx add
	[array autorelease];
	return array;
}

@end
