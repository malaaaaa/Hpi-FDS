//
//  NTLateFeeDMFX.m
//  Hpi-FDS
//  滞期费吨煤分析
//  Created by 馬文培 on 12-9-6.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NTLateFeeDMFX.h"

@implementation NTLateFeeDMFX

@end

@implementation NTLateFeeDMFXDao
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
		NSLog(@"open NTLateFeeDMFX error");
		return;
	}
	NSLog(@"open NTLateFeeDMFX database succes ....");
}

+(void) initDb
{
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@",
						 @"CREATE TABLE IF NOT EXISTS NTLateFeeDMFX  (FACTORY TEXT   ",
						 @",LATEFEE DOUBLE )" ];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table NTLateFeeDMFX error");
		printf("%s",errorMsg);
		return;
		
	}
}
+(void) deleteAll
{
	char * errorMsg;
    
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  NTLateFeeDMFX "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete NTLateFeeDMFX error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(void)insert:(NTLateFeeDMFX *) ntLateFeeDMFX
{
	const char *insert="INSERT INTO NTLateFeeDMFX (FACTORY,LATEFEE) values(?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK)
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    sqlite3_bind_text(statement, 1, [ntLateFeeDMFX.factory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_double(statement, 2, ntLateFeeDMFX.latefee);
    
    
    re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert NTLateFeeDMFX error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
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
                    [shiptransSubSql appendString:@" AND comid in ("];
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

    [NTLateFeeDMFXDao deleteAll];
    sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"select TFFACTORY.FACTORYNAME,round(SUM(LATEFEE)/sum(LW),2) as tt from TB_LATEFEE Inner Join TFFACTORY On TB_LATEFEE.FACTORYCODE = TFFACTORY.FACTORYCODE where TB_LATEFEE.iscal=1 and strftime('%%Y-%%m-%%d',tradetime)>='%@' and strftime('%%Y-%%m-%%d',tradetime)<='%@' %@ group by TFFACTORY.FACTORYNAME  ",startDate,endDate,shiptransSubSql];
   // NSLog(@"执行 InsertByCompany Sql[%@] ",sql);
    
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            NTLateFeeDMFX *ntLateFeeDMFX=[[NTLateFeeDMFX alloc] init];
            
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                ntLateFeeDMFX.factory = nil;
            else
                ntLateFeeDMFX.factory = [NSString stringWithUTF8String: rowData0];
            
            ntLateFeeDMFX.latefee= sqlite3_column_double(statement,1);
            NSLog(@"factory%@",ntLateFeeDMFX.factory);
            NSLog(@"latefee%f",ntLateFeeDMFX.latefee);

            [NTLateFeeDMFXDao insert:ntLateFeeDMFX];
            [ntLateFeeDMFX release];
            
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
+(NSMutableArray *) getNTLateFeeDMFX
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  factory||'('||latefee||')',latefee from NTLateFeeDMFX order by latefee asc";
    //    NSString *sql=@"select  factory,efficiency from PortEfficiency order by efficiency asc";
    
    NSLog(@"执行 getNTLateFeeDMFXDao [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			NTLateFeeDMFX *ntLateFeeDMFX = [[NTLateFeeDMFX alloc] init];
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                ntLateFeeDMFX.factory = nil;
            else
                ntLateFeeDMFX.factory = [NSString stringWithUTF8String: rowData0];
            
            ntLateFeeDMFX.latefee=sqlite3_column_double(statement,1);
            
            [array addObject:ntLateFeeDMFX];
            [ntLateFeeDMFX release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
    
	return array;
}
+(BOOL) isNoData
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  max(abs(latefee)) from NTLateFeeDMFX ";
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
    NSString *sql=@"select  count(*) from NTLateFeeDMFX ";
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