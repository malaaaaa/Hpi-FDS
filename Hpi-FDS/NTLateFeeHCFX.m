//
//  NTLateFeeHCFX.m
//  Hpi-FDS
//  滞期费航次分析
//  Created by 馬文培 on 12-9-13.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NTLateFeeHCFX.h"

@implementation NTLateFeeHCFX

@end

@implementation NTLateFeeHCFXDao
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
		NSLog(@"open NTLateFeeHCFX error");
		return;
	}
	NSLog(@"open NTLateFeeHCFX database succes ....");
}

+(void) initDb
{
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS NTLateFeeHCFX  (FACTORY TEXT   ",
                          @",HC INTEGER ",
                         @",YL DOUBLE ",
						 @",LATEFEE DOUBLE )" ];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table NTLateFeeHCFX error");
		printf("%s",errorMsg);
		return;
		
	}
}
+(void) deleteAll
{
	char * errorMsg;
    
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  NTLateFeeHCFX "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete NTLateFeeHCFX error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(void)insert:(NTLateFeeHCFX *) ntLateFeeHCFX
{
	const char *insert="INSERT INTO NTLateFeeHCFX (FACTORY,HC,YL,LATEFEE) values(?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK)
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    sqlite3_bind_text(statement, 1, [ntLateFeeHCFX.factory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 2, ntLateFeeHCFX.hc);
    sqlite3_bind_double(statement, 3, ntLateFeeHCFX.yl);
    sqlite3_bind_double(statement, 4, ntLateFeeHCFX.latefee);
    
    
    re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert NTLateFeeHCFX error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}
	sqlite3_finalize(statement);
	return;
}
+(void) InsertByCompany:(NSMutableArray *)company
              StartDate:(NSString *)startDate
                EndDate:(NSString *)endDate{
    char *errorMsg;
    if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec begin error");
        return;
    }
    NSMutableString *shiptransSubSql = [[NSMutableString alloc] init ];
    
    //航运公司
    if (((TfShipCompany *)[company objectAtIndex:0]).didSelected==NO) {
        int count=0;
        for (int i=0; i<[company count]; i++) {
            if (((TfShipCompany *)[company objectAtIndex:i]).didSelected==YES) {
                count++;
                if (count==1) {
                    [shiptransSubSql appendString:@" AND shipcompanyid in ("];
                }
                //如果条件不是第一条
                if (count!=1) {
                    [shiptransSubSql appendString:@","];
                }
                [shiptransSubSql appendFormat:@"%d",((TfShipCompany *)[company objectAtIndex:i]).comid];
                
            }
            
        }
        if (count>0) {
            [shiptransSubSql appendString:@")"];
        }
    }
    
    [NTLateFeeHCFXDao deleteAll];
    sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"select TB_LATEFEE.FACTORYCODE,TFFACTORY.FACTORYNAME,count(TRIPNO) AS TRIPNO,round(SUM(LW/10000),2 ) as LW,round(sum(LATEFEE/1000000) ,2 ) as LATEFEE from TB_LATEFEE Inner Join TFFACTORY On TB_LATEFEE.FACTORYCODE = TFFACTORY.FACTORYCODE where strftime('%%Y-%%m-%%d',tradetime)>='%@' and strftime('%%Y-%%m-%%d',tradetime)<='%@' %@ group by TFFACTORY.fACTORYNAME,TB_LATEFEE.FACTORYCODE  ",startDate,endDate,shiptransSubSql];
    NSLog(@"执行 InsertByCompany Sql[%@] ",sql);
    
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            NTLateFeeHCFX *ntLateFeeHCFX=[[NTLateFeeHCFX alloc] init];
            
            char * rowData0=(char *)sqlite3_column_text(statement,1);
            if (rowData0 == NULL)
                ntLateFeeHCFX.factory = nil;
            else
                ntLateFeeHCFX.factory = [NSString stringWithUTF8String: rowData0];
            
             ntLateFeeHCFX.hc= sqlite3_column_int(statement,2);
            
             ntLateFeeHCFX.yl= sqlite3_column_double(statement,3);
            
            ntLateFeeHCFX.latefee= sqlite3_column_double(statement,4);
            NSLog(@"factory%@",ntLateFeeHCFX.factory);
            NSLog(@"latefee%f",ntLateFeeHCFX.latefee);
            
            [NTLateFeeHCFXDao insert:ntLateFeeHCFX];
            [ntLateFeeHCFX release];
            
        }
    }
    sqlite3_finalize(statement);
    [shiptransSubSql release];
    if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec commit error: %s",sqlite3_errmsg(database));
        return;
    }
    
}
+(NSMutableArray *) getNTLateFeeHCFX_LATEFEE
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  factory||'('||latefee||')',latefee from NTLateFeeHCFX order by latefee asc";
    //    NSString *sql=@"select  factory,efficiency from PortEfficiency order by efficiency asc";
    
    NSLog(@"执行 getNTLateFeeHCFXDao [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			NTLateFeeHCFX *ntLateFeeHCFX = [[NTLateFeeHCFX alloc] init];
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                ntLateFeeHCFX.factory = nil;
            else
                ntLateFeeHCFX.factory = [NSString stringWithUTF8String: rowData0];
            
            ntLateFeeHCFX.latefee=sqlite3_column_double(statement,1);
            
            [array addObject:ntLateFeeHCFX];
            [ntLateFeeHCFX release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
    
	return array;
}
+(NSMutableArray *) getNTLateFeeHCFX_HC
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  factory||'('||hc||')',hc from NTLateFeeHCFX order by hc asc";
    //    NSString *sql=@"select  factory,efficiency from PortEfficiency order by efficiency asc";
    
    NSLog(@"执行 getNTLateFeeHCFXDao [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			NTLateFeeHCFX *ntLateFeeHCFX = [[NTLateFeeHCFX alloc] init];
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                ntLateFeeHCFX.factory = nil;
            else
                ntLateFeeHCFX.factory = [NSString stringWithUTF8String: rowData0];
            
            ntLateFeeHCFX.hc=sqlite3_column_int(statement,1);
            
            [array addObject:ntLateFeeHCFX];
            [ntLateFeeHCFX release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
    
	return array;
}
+(NSMutableArray *) getNTLateFeeHCFX_YL
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  factory||'('||yl||')',yl from NTLateFeeHCFX order by yl asc";
    //    NSString *sql=@"select  factory,efficiency from PortEfficiency order by efficiency asc";
    
    NSLog(@"执行 getNTLateFeeHCFXDao [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			NTLateFeeHCFX *ntLateFeeHCFX = [[NTLateFeeHCFX alloc] init];
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                ntLateFeeHCFX.factory = nil;
            else
                ntLateFeeHCFX.factory = [NSString stringWithUTF8String: rowData0];
            
            ntLateFeeHCFX.yl=sqlite3_column_double(statement,1);
            
            [array addObject:ntLateFeeHCFX];
            [ntLateFeeHCFX release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
    
	return array;
}
+(BOOL) isNoData_LATEFEE
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  max(latefee) from NTLateFeeHCFX ";
    NSLog(@"执行 isNoData [%@] ",sql);
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
            double maxNumber=sqlite3_column_double(statement,0);
            if (0==maxNumber) {
                sqlite3_finalize(statement);
                return YES;
            }
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
	return NO;
}
+(NSInteger) getFactoryCount
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  count(*) from NTLateFeeHCFX ";
    //    NSLog(@"执行 getFactoryCount [%@] ",sql);
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
            NSInteger count=sqlite3_column_int(statement,0);
            sqlite3_finalize(statement);
            return count;
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
	return 0;
}

@end