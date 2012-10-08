//
//  NTZxgsjtj.m
//  Hpi-FDS
//  装卸港时间统计
//  Created by 馬文培 on 12-9-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NTZxgsjtj.h"

@implementation NTZxgsjtj

@end


@implementation NTZxgsjtjDao
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
		NSLog(@"open NTZxgsjtj error");
		return;
	}
	NSLog(@"open NTZxgsjtj database succes ....");
}

+(void) initDb
{
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS NTZxgsjtj  (FACTORY TEXT   ",
                         @",ZG DOUBLE ",
                         @",XG DOUBLE ",
                         @",LT DOUBLE ",
						 @",LW DOUBLE )" ];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table NTZxgsjtj error");
		printf("%s",errorMsg);
		return;
		
	}
}
+(void) deleteAll
{
	char * errorMsg;
    
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  NTZxgsjtj "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete NTZxgsjtj error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(void)insert:(NTZxgsjtj *) ntZxgsjtj
{
	const char *insert="INSERT INTO NTZxgsjtj (FACTORY,ZG,XG,LT,LW) values(?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK)
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    sqlite3_bind_text(statement, 1, [ntZxgsjtj.factory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_double(statement, 2, ntZxgsjtj.zg);
    sqlite3_bind_double(statement, 3, ntZxgsjtj.xg);
    sqlite3_bind_double(statement, 4, ntZxgsjtj.lt);
    sqlite3_bind_double(statement, 5, ntZxgsjtj.lw);
    
    
    re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert NTZxgsjtj error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}
	sqlite3_finalize(statement);
	return;
}
+(void) InsertByCompany:(NSMutableArray *)company
               Schedule:(NSString *)schedule
               Category:(NSString *)category
              StartDate:(NSString *)startDate
                EndDate:(NSString *)endDate{
    char *errorMsg;
    if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec begin error");
        return;
    }
    NSMutableString *shiptransSubSql = [[NSMutableString alloc] init ];
    NSMutableString *categorySubSql = [[NSMutableString alloc] init ];

    
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
    //是否班轮
    if ([schedule isEqualToString:@"否"]) {
        [shiptransSubSql appendString:@" AND SCHEDULE='0' "];
        
    }
    else if ([schedule isEqualToString:@"是"]) {
        [shiptransSubSql appendString:@" AND SCHEDULE='1' "];
    }
    //电厂类型
    if (![category isEqualToString:All_]) {
        [categorySubSql appendFormat:@" Where category='%@' ",category];
    }
    [shiptransSubSql appendFormat:@" AND strftime('%%Y-%%m-%%d',tradetime)>='%@' and strftime('%%Y-%%m-%%d',tradetime)<='%@' ",startDate,endDate];
    [NTZxgsjtjDao deleteAll];
    sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"Select FACTORYCODE,FACTORYNAME, IfNULL(avgZG,0) as avgZG, IfNULL(avgXG,0) as avgXG, IfNULL(avgZG,0) + IfNULL(avgXG,0) as avgLT, (IfNULL(PLw,0) + IfNULL(FLw,0)) as LW From ( select FACTORYNAME,FACTORYCODE, (select round(sum(((strftime('%%s',P_DEPARTTIME )-strftime('%%s',P_ANCHORAGETIME)))/86400.0*vbshiptrans.LW/10000.0)/sum(vbshiptrans.LW/10000.0),2) as avgZG from vbshiptrans  where vbshiptrans.FACTORYCODE = tf.FACTORYCODE  and ISCAL=1 and P_ANCHORAGETIME!='2000-01-01T00:00:00' and P_DEPARTTIME!='2000-01-01T00:00:00' %@) as avgZG,  (select round(sum(((strftime('%%s',F_FINISHTIME)-strftime('%%s',F_ANCHORAGETIME)))/86400.0*vbshiptrans.LW/10000.0)/sum(vbshiptrans.LW/10000.0),2) as avgXG from vbshiptrans  where vbshiptrans.FACTORYCODE = tf.FACTORYCODE  and ISCAL=1 and F_FINISHTIME!='2000-01-01T00:00:00' and F_ANCHORAGETIME!='2000-01-01T00:00:00' %@) as avgXG, (Select SUM(LW/10000.0) as PLw From vbshiptrans where FACTORYCODE = tf.FACTORYCODE and ISCAL=1 and TRADE='D' %@) as PLw, (Select SUM(LW/10000.0) as FLw From vbshiptrans where FACTORYCODE = tf.FACTORYCODE and ISCAL=1 and TRADE='F' %@) as FLw from TFFACTORY tf %@) a  ",shiptransSubSql,shiptransSubSql,shiptransSubSql,shiptransSubSql,categorySubSql];
    NSLog(@"执行 InsertByCompany Sql[%@] ",sql);
    
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            NTZxgsjtj *ntZxgsjtj=[[NTZxgsjtj alloc] init];
            
            char * rowData0=(char *)sqlite3_column_text(statement,1);
            if (rowData0 == NULL)
                ntZxgsjtj.factory = nil;
            else
                ntZxgsjtj.factory = [NSString stringWithUTF8String: rowData0];
            
            ntZxgsjtj.zg= sqlite3_column_double(statement,2);
            ntZxgsjtj.xg= sqlite3_column_double(statement,3);
            ntZxgsjtj.lt= sqlite3_column_double(statement,4);
            ntZxgsjtj.lw= sqlite3_column_double(statement,5);

            NSLog(@"factory%@",ntZxgsjtj.factory);
            
            [NTZxgsjtjDao insert:ntZxgsjtj];
            [ntZxgsjtj release];
            
        }
    }
    sqlite3_finalize(statement);
    [shiptransSubSql release];
    [categorySubSql release];
    if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec commit error: %s",sqlite3_errmsg(database));
        return;
    }
    
}
+(NSMutableArray *) getNTZxgsjtj_ZG
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  factory||'('||zg||')',zg from NTZxgsjtj order by zg asc";
    //    NSString *sql=@"select  factory,efficiency from PortEfficiency order by efficiency asc";
    
    NSLog(@"执行 getNTZxgsjtjDao [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			NTZxgsjtj *ntZxgsjtj = [[NTZxgsjtj alloc] init];
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                ntZxgsjtj.factory = nil;
            else
                ntZxgsjtj.factory = [NSString stringWithUTF8String: rowData0];
            
            ntZxgsjtj.zg=sqlite3_column_double(statement,1);
            
            [array addObject:ntZxgsjtj];
            [ntZxgsjtj release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
    
	return array;
}
+(NSMutableArray *) getNTZxgsjtj_XG
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  factory||'('||xg||')',xg from NTZxgsjtj order by xg asc";
    //    NSString *sql=@"select  factory,efficiency from PortEfficiency order by efficiency asc";
    
    NSLog(@"执行 getNTZxgsjtjDao [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			NTZxgsjtj *ntZxgsjtj = [[NTZxgsjtj alloc] init];
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                ntZxgsjtj.factory = nil;
            else
                ntZxgsjtj.factory = [NSString stringWithUTF8String: rowData0];
            
            ntZxgsjtj.xg=sqlite3_column_double(statement,1);
            
            [array addObject:ntZxgsjtj];
            [ntZxgsjtj release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
    
	return array;
}
+(NSMutableArray *) getNTZxgsjtj_LT
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  factory||'('||lt||')',lt from NTZxgsjtj order by lt asc";
    //    NSString *sql=@"select  factory,efficiency from PortEfficiency order by efficiency asc";
    
    NSLog(@"执行 getNTZxgsjtjDao [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			NTZxgsjtj *ntZxgsjtj = [[NTZxgsjtj alloc] init];
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                ntZxgsjtj.factory = nil;
            else
                ntZxgsjtj.factory = [NSString stringWithUTF8String: rowData0];
            
            ntZxgsjtj.lt=sqlite3_column_double(statement,1);
            
            [array addObject:ntZxgsjtj];
            [ntZxgsjtj release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
    
	return array;
}
+(BOOL) isNoData_ZG
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  max(zg) from NTZxgsjtj ";
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
+(BOOL) isNoData_LT
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  max(lt) from NTZxgsjtj ";
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
+(BOOL) isNoData_XG
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  max(xg) from NTZxgsjtj ";
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
    NSString *sql=@"select  count(*) from NTZxgsjtj ";
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