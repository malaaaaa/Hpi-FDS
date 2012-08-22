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
//	NSLog(@"Insert begin NTFactoryFreightVolume");
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
    char *errorMsg;
    if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec begin error");
        return;
    }
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
    sqlite3_finalize(statement);
    if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec commit error");
        return;
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
    [array addObject:@"公司合计"];
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            NSString *factoryname =@"";
            
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                factoryname = nil;
            else
                factoryname = [NSString stringWithUTF8String: rowData0];
            [array addObject:factoryname];
            
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);

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
			
            NSString *tradetime = @"";
            
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                tradetime = nil;
            else
                tradetime = [NSString stringWithUTF8String: rowData0];
            [array addObject:tradetime];
           
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
	return array;
}
+(NSMutableArray *) getAllDataByTradeTime:(NSMutableArray *)tradetime Factory:(NSMutableArray *)factory
{
    NSInteger sumLW=0;
    NSInteger sumCOUNT=0;
    NSMutableArray *rowArray=[[[NSMutableArray alloc]init] autorelease];
    for (int i=0; i< [tradetime count]; i++) {
        
        NSMutableArray *coloumArray=[[NSMutableArray alloc]init] ;
        [coloumArray addObject:kBLACK];
        
        //第一列：时间
        [coloumArray addObject:[tradetime objectAtIndex:i] ];
        
        //第二列:公司合计
        //计算公司合计
        sqlite3_stmt *statement_facSum;
        NSString *sql= [NSString stringWithFormat:@"select sum(lw),sum(count) from tmp_ntfactoryfreightvolume where tradetime='%@' ",[tradetime objectAtIndex:i]];
        if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement_facSum,NULL)==SQLITE_OK){
            NTFactoryFreightVolume *factoryFreightVolume = [[NTFactoryFreightVolume alloc] init];
            if (sqlite3_step(statement_facSum)==SQLITE_ROW) {
                factoryFreightVolume.LW=sqlite3_column_int(statement_facSum, 0);
                factoryFreightVolume.COUNT=sqlite3_column_int(statement_facSum, 1);
            }
            else{
                factoryFreightVolume.LW=0;
                factoryFreightVolume.COUNT=0;
                
            }
            [coloumArray addObject:[NSString stringWithFormat:@"%0.2f",(float)factoryFreightVolume.LW/10000]];
            [coloumArray addObject:[NSString stringWithFormat:@"%d",factoryFreightVolume.COUNT]];
            
            [factoryFreightVolume release];
        }else {
            NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
        }
        sqlite3_finalize(statement_facSum);

        //第三列开始：各电厂名称
        //j从2开始，因为工厂数组中为填充标题第一项是"月份",第二项是“公司合计”
        for (int j=2; j<[factory count]; j++) {
            sqlite3_stmt *statement;
            sql= [NSString stringWithFormat:@"select lw,count from tmp_ntfactoryfreightvolume where tradetime='%@' and factoryname='%@'",[tradetime objectAtIndex:i],[factory objectAtIndex:j]];
            if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
                NTFactoryFreightVolume *factoryFreightVolume = [[NTFactoryFreightVolume alloc] init];
                if (sqlite3_step(statement)==SQLITE_ROW) {
                    
                    factoryFreightVolume.LW=sqlite3_column_int(statement, 0);
                    factoryFreightVolume.COUNT=sqlite3_column_int(statement, 1);
                 }
                else{
                    factoryFreightVolume.LW=0;
                    factoryFreightVolume.COUNT=0;
                    
                }
              [coloumArray addObject:[NSString stringWithFormat:@"%0.2f",(float)factoryFreightVolume.LW/10000]];
                [coloumArray addObject:[NSString stringWithFormat:@"%d",factoryFreightVolume.COUNT]];
                
                [factoryFreightVolume release];
            }else {
                NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
            }
            sqlite3_finalize(statement);

        }
        [rowArray addObject:coloumArray];
        [coloumArray release];
    }
    
    /**单独计算合计行,占比行开始**/
    //合计行
    NSMutableArray *sumColoumArray1=[[NSMutableArray alloc]init] ;
    //占比行
    NSMutableArray *sumColoumArray2=[[NSMutableArray alloc]init] ;
    
    [sumColoumArray1 addObject:kBLACK];
    [sumColoumArray2 addObject:kBLACK];
    
    //第一列：合计, 占比
    [sumColoumArray1 addObject:@"合计" ];
    [sumColoumArray2 addObject:@"占比" ];
    
    //第二列:公司合计,占比
    //计算总合计
    sqlite3_stmt *statement_Sum;
    NSString *sql= [NSString stringWithFormat:@"select sum(lw),sum(count) from tmp_ntfactoryfreightvolume  "];
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement_Sum,NULL)==SQLITE_OK){
        if (sqlite3_step(statement_Sum)==SQLITE_ROW) {
            sumLW=sqlite3_column_int(statement_Sum, 0);
            sumCOUNT=sqlite3_column_int(statement_Sum, 1);
        }
        else{
            sumLW=0;
            sumCOUNT=0;
            
        }
        
    }else {
        NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
    }
    [sumColoumArray1 addObject:[NSString stringWithFormat:@"%0.2f",(float)sumLW/10000]];
    [sumColoumArray1 addObject:[NSString stringWithFormat:@"%d",sumCOUNT]];
    [sumColoumArray2 addObject:@"100%" ];
    [sumColoumArray2 addObject:@"100%" ];
    sqlite3_finalize(statement_Sum);

    //第三列开始：各电厂合计,占比
    //j从2开始，因为工厂数组中为填充标题第一项是"月份",第二项是“公司合计”
    for (int j=2; j<[factory count]; j++) {
        sqlite3_stmt *statement;
        sql= [NSString stringWithFormat:@"select sum(lw),sum(count) from tmp_ntfactoryfreightvolume where factoryname='%@'",[factory objectAtIndex:j]];
        if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
            NTFactoryFreightVolume *factoryFreightVolume = [[NTFactoryFreightVolume alloc] init];
            if (sqlite3_step(statement)==SQLITE_ROW) {
                
                factoryFreightVolume.LW=sqlite3_column_int(statement, 0);
                factoryFreightVolume.COUNT=sqlite3_column_int(statement, 1);
                
            }
            else{
                factoryFreightVolume.LW=0;
                factoryFreightVolume.COUNT=0;
                
            }
            
            [sumColoumArray1 addObject:[NSString stringWithFormat:@"%0.2f",(float)factoryFreightVolume.LW/10000]];
            [sumColoumArray1 addObject:[NSString stringWithFormat:@"%d",factoryFreightVolume.COUNT]];
            
            [sumColoumArray2 addObject:[NSString stringWithFormat:@"%0.1f%%",(float)factoryFreightVolume.LW*100/sumLW]];
            [sumColoumArray2 addObject:[NSString stringWithFormat:@"%0.1f%%",(float)factoryFreightVolume.COUNT*100/sumCOUNT]];
            
            
            [factoryFreightVolume release];
        }else {
            NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
        }
        sqlite3_finalize(statement);

    }
    [rowArray addObject:sumColoumArray1];
    [rowArray addObject:sumColoumArray2];
    
    [sumColoumArray1 release];
    [sumColoumArray2 release];
    /**单独计算合计行,占比行结束**/
    
	return rowArray;
}
@end
