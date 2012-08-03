//
//  NTFactoryFreightVolumeDao.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NTFactoryFreightVolumeDao.h"

@implementation NTFactoryFreightVolumeDao
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
		NSLog(@"open NTFactoryFreightVolume error");
		return;
	}
	NSLog(@"open NTFactoryFreightVolume database succes ....");
}

+(void) initDb
{
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS NTFactoryFreightVolume  (TRADETIME TEXT   ",
						 @",TRADE TEXT ",
                         @",TRADENAME TEXT ",
                         @",CATEGORY TEXT ",
                         @",FACTORYNAME TEXT ",
						 @",LW INTEGER )" ];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table NTFactoryFreightVolume error");
		printf("%s",errorMsg);
		return;
		
	}
}
+(void) initDb_tmpTable
{
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TMP_NTFactoryFreightVolume  (TRADETIME TEXT   ",
                         @",FACTORYNAME TEXT ",
						 @",LW INTEGER ",
                         @",COUNT INTEGER )" ];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TMP_NTFactoryFreightVolume error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(NTFactoryFreightVolume *) factoryFreightVolume
{
	NSLog(@"Insert begin NTFactoryFreightVolume");
	const char *insert="INSERT INTO NTFactoryFreightVolume (TRADETIME,TRADE,TRADENAME,CATEGORY,FACTORYNAME,LW) values(?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK)
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    sqlite3_bind_text(statement, 1, [factoryFreightVolume.TRACETIME UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 2, [factoryFreightVolume.TRADE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [factoryFreightVolume.TRADENAME UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 4, [factoryFreightVolume.CATEGORY UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 5, [factoryFreightVolume.FACTORYNAME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 6, factoryFreightVolume.LW);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert NTShipCompanyTranShare error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}
	sqlite3_finalize(statement);
	return;
}
+(void) InsertByTrade:(NSString *)trade Type:(NSString *)type StartDate:(NSString *)startDate EndDate:(NSString *)endDate{
    [NTFactoryFreightVolumeDao deleteAll_tmpTable];
    NSMutableString *tmpString = [[NSMutableString alloc] init ];
    
    //贸易性质
    if ([trade isEqualToString:@"内贸"]) {
        [tmpString appendString:@" AND trade='D' "];
        
    }
    else if ([trade isEqualToString:@"进口"]) {
        [tmpString appendString:@" AND trade='F' "];
    }
    
    //电厂类型
    if (![type isEqualToString:All_]) {
        [tmpString appendFormat:@" AND category='%@' ",type];
    }
    
    
    sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"select tradetime,factoryname,count(*),sum(lw) from NTFactoryFreightVolume where tradetime>='%@' and  tradetime<='%@' %@ group by tradetime,factoryname ",startDate,endDate,tmpString];
    NSLog(@"执行 InsertByPortCode Sql[%@] ",sql);
    
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            NTFactoryFreightVolume *factoryFreightVolume=[[NTFactoryFreightVolume alloc] init];
            
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                factoryFreightVolume.TRACETIME = nil;
            else
                factoryFreightVolume.TRACETIME = [NSString stringWithUTF8String: rowData0];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                factoryFreightVolume.FACTORYNAME = nil;
            else
                factoryFreightVolume.FACTORYNAME = [NSString stringWithUTF8String: rowData1];
            
            factoryFreightVolume.COUNT= sqlite3_column_int(statement,2);
            factoryFreightVolume.LW= sqlite3_column_int(statement,3);
            
            [NTFactoryFreightVolumeDao insert_tmpTable:factoryFreightVolume];
            [factoryFreightVolume release];
            
        }
    }
    [tmpString release];
}
+(void)insert_tmpTable:(NTFactoryFreightVolume *) factoryFreightVolume
{
	const char *insert="INSERT INTO TMP_NTFactoryFreightVolume (TRADETIME,FACTORYNAME,COUNT,LW) values(?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK)
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    sqlite3_bind_text(statement, 1, [factoryFreightVolume.TRACETIME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [factoryFreightVolume.FACTORYNAME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 3, factoryFreightVolume.COUNT);
    sqlite3_bind_int(statement, 4, factoryFreightVolume.LW);
    
    re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert TMP_NTFactoryFreightVolume error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}
	sqlite3_finalize(statement);
	return;
}

+(void) deleteAll
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  NTFactoryFreightVolume "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete NTFactoryFreightVolume error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(void) deleteAll_tmpTable
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TMP_NTFactoryFreightVolume "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TMP_NTFactoryFreightVolume error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(NSMutableArray *) getFactoryFromTmpNTFactoryFreightVolume
{
	sqlite3_stmt *statement;
    NSString *sql=@"select distinct factoryname from tmp_ntfactoryfreightvolume";
    NSLog(@"执行 getFactoryFromTmpNTFactoryFreightVolume [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    //填充标题
    [array addObject:@"月份"];

	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            NSString *factoryname = [[NSString alloc]init];
            
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                factoryname = nil;
            else
                factoryname = [NSString stringWithUTF8String: rowData0];
            [array addObject:factoryname];
            [factoryname release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return array;
}
+(NSMutableArray *) getTradeTimeFromTmpNTFactoryFreightVolume
{
	sqlite3_stmt *statement;
    NSString *sql=@"select distinct tradetime from tmp_ntfactoryfreightvolume";
    NSLog(@"执行 getTradeTimeFromTmpNTFactoryFreightVolume [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            NSString *tradetime = [[NSString alloc]init];
            
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                tradetime = nil;
            else
                tradetime = [NSString stringWithUTF8String: rowData0];
            [array addObject:tradetime];
            [tradetime release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return array;
}
+(NSMutableArray *) getAllDataByTradeTime:(NSMutableArray *)tradetime Factory:(NSMutableArray *)factory
{
    NSMutableArray *rowArray=[[[NSMutableArray alloc]init] autorelease];
    for (int i=0; i< [tradetime count]; i++) {
        
        NSMutableArray *coloumArray=[[[NSMutableArray alloc]init] autorelease];
        [coloumArray addObject:kBLACK];
        [coloumArray addObject:[tradetime objectAtIndex:i] ];
        //j从1开始，因为工厂数组中为填充标题第一项是"月份"
        for (int j=1; j<[factory count]; j++) {
            sqlite3_stmt *statement;
            NSString *sql= [NSString stringWithFormat:@"select lw,count from tmp_ntfactoryfreightvolume where tradetime='%@' and factoryname='%@'",[tradetime objectAtIndex:i],[factory objectAtIndex:j]];
            if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
//                while (sqlite3_step(statement)==SQLITE_ROW) {
                         NTFactoryFreightVolume *factoryFreightVolume = [[NTFactoryFreightVolume alloc] init];
                if (sqlite3_step(statement)==SQLITE_ROW) {
       
                    factoryFreightVolume.LW=sqlite3_column_int(statement, 0);
                    factoryFreightVolume.COUNT=sqlite3_column_int(statement, 1);
                   // [coloumArray addObject:factoryFreightVolume.LW];
                    NSLog(@"lw======%d===",factoryFreightVolume.LW);
                   
                }
                else{
                    factoryFreightVolume.LW=0;
                    factoryFreightVolume.COUNT=0;

                }
                
                NSLog(@"lw======%d===",factoryFreightVolume.LW);

                [coloumArray addObject:[NSString stringWithFormat:@"%d",factoryFreightVolume.LW]];
                 [coloumArray addObject:[NSString stringWithFormat:@"%d",factoryFreightVolume.COUNT]];

                 [factoryFreightVolume release];
            }else {
                NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
            }
//                    NSLog(@"lw======%d===",1122);
//
//                    [coloumArray addObject:[NSString stringWithFormat:@"%d",1122]];
        }
        [rowArray addObject:coloumArray];
    }
    
	return rowArray;
}
@end
