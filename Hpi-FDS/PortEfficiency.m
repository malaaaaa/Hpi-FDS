//
//  PortEfficiency.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-8.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "PortEfficiency.h"

@implementation PortEfficiency
@end

@implementation PortEfficiencyDao
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
		NSLog(@"open PortEfficiency error");
		return;
	}
	NSLog(@"open PortEfficiency database succes ....");
}

+(void) initDb
{
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@",
						 @"CREATE TABLE IF NOT EXISTS PortEfficiency  (FACTORY TEXT   ",
						 @",EFFICIENCY INTEGER )" ];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table PortEfficiency error");
		printf("%s",errorMsg);
		return;
		
	}
}
+(void) deleteAll
{
	char * errorMsg;
    
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  PortEfficiency "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete PortEfficiency error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(void)insert:(PortEfficiency *) portEfficiency
{
	const char *insert="INSERT INTO PortEfficiency (FACTORY,EFFICIENCY) values(?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK)
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    sqlite3_bind_text(statement, 1, [portEfficiency.factory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 2, portEfficiency.efficiency);
    
    
    re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert PortEfficiency error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
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
    NSMutableString *factorySubSql = [[NSMutableString alloc] init ];
    
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
        [factorySubSql appendFormat:@" AND tf.category='%@' ",category];
    }
    [PortEfficiencyDao deleteAll];
    sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"Select FACTORYCODE,FACTORYNAME, IfNULL(avgXG,0) as avgXG, IfNULL(FLw,0) as lw, case when IfNULL(avgXG,0) != 0 then     round(IfNULL(FLw,0)/IfNULL(avgXG,0),0)       else 0 end  as xiaolv from ( select FACTORYNAME,FACTORYCODE, (select sum((strftime('%%s',F_FINISHTIME)-strftime('%%s',F_ANCHORAGETIME))/3600.0) as avgXG from vbshiptrans where FACTORYCODE = tf.FACTORYCODE AND iscal = 1 and strftime('%%Y-%%m-%%d',f_anchoragetime)!='2000-01-01' and strftime('%%Y-%%m-%%d', F_FINISHTIME)!='2000-01-01' and strftime('%%Y-%%m-%%d',tradetime)>='%@' and  strftime('%%Y-%%m-%%d',tradetime)<='%@' %@) as avgXG, (Select SUM(LW) as FLw From vbshiptrans where FACTORYCODE = tf.FACTORYCODE and STAGE=4 and strftime('%%Y-%%m-%%d',f_anchoragetime)!='2000-01-01' and strftime('%%Y-%%m-%%d', F_FINISHTIME)!='2000-01-01'  and strftime('%%Y-%%m-%%d',tradetime)>='%@' and  strftime('%%Y-%%m-%%d',tradetime)<='%@' %@) as FLw from TFFACTORY tf where 1=1 %@) ",startDate,endDate,shiptransSubSql,startDate,endDate,shiptransSubSql,factorySubSql];
   // NSLog(@"执行 InsertByCompany Sql[%@] ",sql);
    
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            PortEfficiency *portEfficiency=[[PortEfficiency alloc] init];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                portEfficiency.factory = nil;
            else
                portEfficiency.factory = [NSString stringWithUTF8String: rowData1];
            
            portEfficiency.efficiency= sqlite3_column_int(statement,4);
            
            [PortEfficiencyDao insert:portEfficiency];
            [portEfficiency release];
            
        }
    }
    sqlite3_finalize(statement);
    [shiptransSubSql release];
    [factorySubSql release];
    if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec commit error: %s",sqlite3_errmsg(database));
        return;
    }

}
+(NSMutableArray *) getPortEfficiency
{
	sqlite3_stmt *statement;
    NSString *sql=@"select  factory||'('||efficiency||')',efficiency from PortEfficiency order by efficiency asc";
    //    NSString *sql=@"select  factory,efficiency from PortEfficiency order by efficiency asc";
    
    //NSLog(@"执行 getPortEfficiency [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			PortEfficiency *portEfficiency = [[PortEfficiency alloc] init];
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                portEfficiency.factory = nil;
            else
                portEfficiency.factory = [NSString stringWithUTF8String: rowData0];
            
            portEfficiency.efficiency=sqlite3_column_int(statement,1);
            
            [array addObject:portEfficiency];
            [portEfficiency release];
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
    NSString *sql=@"select  max(efficiency) from PortEfficiency ";
    NSLog(@"执行 isNoData [%@] ",sql);
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
            NSInteger maxNumber=sqlite3_column_int(statement,0);
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
@end
