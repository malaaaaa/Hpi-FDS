//
//  NTColorConfigDao.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NTColorConfigDao.h"


@implementation NTColorConfigDao
static sqlite3 *database;

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
		NSLog(@"open NTColorConfig error");
		return;
	}
	NSLog(@"open NTColorConfig database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS NTColorConfig  (TYPE TEXT   ",
						 @",ID TEXT ",
                         @",DESCRIPTION TEXT ",
                         @",RED TEXT ",
                         @",GREEN TEXT ",
                         @",BLUE TEXT )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table NTColorConfig error");
		printf("%s",errorMsg);
		return;
	}
    NSString *deleteSql=[NSString  stringWithFormat:@"delete from NTColorConfig"];
    if(sqlite3_exec(database,[deleteSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"delete NTColorConfig error");
		printf("%s",errorMsg);
		return;
	}
    NSString *insertSql=[NSString  stringWithFormat:@"insert into NTColorConfig (TYPE,ID,DESCRIPTION,RED,GREEN,BLUE) values ('%@','%@','%@','%@','%@','%@');",@"COMID",@"4",@"时代",@"220.0",@"11.0",@"11.0"];
    if(sqlite3_exec(database,[insertSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"insert into table NTColorConfig error");
		printf("%s",errorMsg);
		return;
	}
    insertSql=[NSString  stringWithFormat:@"insert into NTColorConfig (TYPE,ID,DESCRIPTION,RED,GREEN,BLUE) values ('%@','%@','%@','%@','%@','%@');",@"COMID",@"5",@"瑞宁",@"11.0",@"220.0",@"11.0"];
    if(sqlite3_exec(database,[insertSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"insert into table NTColorConfig error");
		printf("%s",errorMsg);
		return;
	}
    insertSql=[NSString  stringWithFormat:@"insert into NTColorConfig (TYPE,ID,DESCRIPTION,RED,GREEN,BLUE) values ('%@','%@','%@','%@','%@','%@');",@"COMID",@"6",@"华鲁",@"195.0",@"73.0",@"156.0"];
    if(sqlite3_exec(database,[insertSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"insert into table NTColorConfig error");
		printf("%s",errorMsg);
		return;
	}
    insertSql=[NSString  stringWithFormat:@"insert into NTColorConfig (TYPE,ID,DESCRIPTION,RED,GREEN,BLUE) values ('%@','%@','%@','%@','%@','%@');",@"COMID",@"7",@"其它",@"58.0",@"82.0",@"62.0"];
    if(sqlite3_exec(database,[insertSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"insert into table NTColorConfig error");
		printf("%s",errorMsg);
		return;
	}
    insertSql=[NSString  stringWithFormat:@"insert into NTColorConfig (TYPE,ID,DESCRIPTION,RED,GREEN,BLUE) values ('%@','%@','%@','%@','%@','%@');",@"COMID",@"9",@"福轮总",@"112.0",@"166.0",@"184.0"];
    if(sqlite3_exec(database,[insertSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"insert into table NTColorConfig error");
		printf("%s",errorMsg);
		return;
	}
    insertSql=[NSString  stringWithFormat:@"insert into NTColorConfig (TYPE,ID,DESCRIPTION,RED,GREEN,BLUE) values ('%@','%@','%@','%@','%@','%@');",@"COMID",@"12",@"中海",@"192.0",@"111.0",@"54.0"];
    if(sqlite3_exec(database,[insertSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"insert into table NTColorConfig error");
		printf("%s",errorMsg);
		return;
	}


    
}

+(NSMutableArray *) getNTColorConfigByType:(NSString *)typeid
{
    
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT ID,RED,GREEN,BLUE,DESCRIPTION FROM  NTColorConfig WHERE TYPE='%@' ",typeid];
    
    NSLog(@"执行 getNTColorConfigByType [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            NTColorConfig *ntColorConfig=[[NTColorConfig alloc] init];
        
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                ntColorConfig.ID = nil;
            else
                ntColorConfig.ID = [NSString stringWithUTF8String: rowData0];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                ntColorConfig.RED = nil;
            else
                ntColorConfig.RED = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                ntColorConfig.GREEN = nil;
            else
                ntColorConfig.GREEN = [NSString stringWithUTF8String: rowData2];
            
            char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                ntColorConfig.BLUE = nil;
            else
                ntColorConfig.BLUE = [NSString stringWithUTF8String: rowData3];
            
            char * rowData4=(char *)sqlite3_column_text(statement,4);
            if (rowData4 == NULL)
                ntColorConfig.DESCRIPTION = nil;
            else
                ntColorConfig.DESCRIPTION = [NSString stringWithUTF8String: rowData4];
            

            
			[array addObject:ntColorConfig];
            [ntColorConfig release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);

	[array autorelease];
	return array;
}

@end
