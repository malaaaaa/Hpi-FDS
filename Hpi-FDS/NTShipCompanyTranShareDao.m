//
//  NTShipCompanyTranShareDao.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-23.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NTShipCompanyTranShareDao.h"

@implementation NTShipCompanyTranShareDao
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
		NSLog(@"open NTShipCompanyTranShare error");
		return;
	}
	NSLog(@"open NTShipCompanyTranShare database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS NTShipCompanyTranShare  (COMID INTEGER   ",
						 @",COMPANY TEXT ",
                         @",PORTCODE TEXT ",
                         @",PORTNAME TEXT ",
                         @",TRADEYEAR TEXT ",
                         @",TRADEMONTH TEXT ",
						 @",LW INTEGER )" ];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table NTShipCompanyTranShare error");
		printf("%s",errorMsg);
		return;
		
	}
}
+(void) initDb_tmpTable
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TMP_NTShipCompanyTranShare  (COMID INTEGER   ",
						 @",COMPANY TEXT ",
                         @",TRADEYEAR TEXT ",
                         @",TRADEMONTH TEXT ",
						 @",LW INTEGER ",
                         @",PERCENT TEXT )" ];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TMP_NTShipCompanyTranShare error");
		printf("%s",errorMsg);
		return;
		
	}
}
+(void) initDb_ColorConfig
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS NTColorConfig  (TYPE TEXT   ",
						 @",ID TEXT ",
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
    NSString *insertSql=[NSString  stringWithFormat:@"insert into NTColorConfig (TYPE,ID,RED,GREEN,BLUE) values ('%@','%@','%@','%@','%@');",@"COMID",@"4",@"220.0",@"11.0",@"11.0"];
    if(sqlite3_exec(database,[insertSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"insert into table NTColorConfig error");
		printf("%s",errorMsg);
		return;
	}
    insertSql=[NSString  stringWithFormat:@"insert into NTColorConfig (TYPE,ID,RED,GREEN,BLUE) values ('%@','%@','%@','%@','%@');",@"COMID",@"5",@"11.0",@"220.0",@"11.0"];
    if(sqlite3_exec(database,[insertSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"insert into table NTColorConfig error");
		printf("%s",errorMsg);
		return;
	}
			
}


+(void)insert:(NTShipCompanyTranShare*) NTShipCompanyTranShare
{
	NSLog(@"Insert begin NTShipCompanyTranShare");
	const char *insert="INSERT INTO NTShipCompanyTranShare (COMID,COMPANY,PORTCODE,PORTNAME,TRADEYEAR,TRADEMONTH,LW) values(?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }

    sqlite3_bind_int(statement, 1, NTShipCompanyTranShare.COMID);    
	sqlite3_bind_text(statement, 2, [NTShipCompanyTranShare.COMPANY UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [NTShipCompanyTranShare.PORTCODE UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 4, [NTShipCompanyTranShare.PORTNAME UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 5, [NTShipCompanyTranShare.TRADEYEAR UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 6, [NTShipCompanyTranShare.TRADEMONTH UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 7, NTShipCompanyTranShare.LW);    

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
+(void)insert_tmpTable:(NTShipCompanyTranShare*) NTShipCompanyTranShare
{
	NSLog(@"Insert begin TMP_NTShipCompanyTranShare");
	const char *insert="INSERT INTO TMP_NTShipCompanyTranShare (COMID,COMPANY,TRADEYEAR,TRADEMONTH,LW,PERCENT) values(?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    
    sqlite3_bind_int(statement, 1, NTShipCompanyTranShare.COMID);    
	sqlite3_bind_text(statement, 2, [NTShipCompanyTranShare.COMPANY UTF8String], -1, SQLITE_TRANSIENT);

	sqlite3_bind_text(statement, 3, [NTShipCompanyTranShare.TRADEYEAR UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 4, [NTShipCompanyTranShare.TRADEMONTH UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 5, NTShipCompanyTranShare.LW);  
    sqlite3_bind_text(statement, 6, [NTShipCompanyTranShare.PERCENT UTF8String], -1, SQLITE_TRANSIENT);
    
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

+(void) deleteAll
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  NTShipCompanyTranShare "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete NTShipCompanyTranShare error with message [%s]  sql[%@]", errorMsg,deletesql);
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
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TMP_NTShipCompanyTranShare "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TMP_NTShipCompanyTranShare error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}



+(void) InsertByPortCode:(NSMutableArray *)portCode :(NSString *)startDate :(NSString *)endDate{
    [NTShipCompanyTranShareDao deleteAll_tmpTable];
    NSMutableString *tmpString = [[NSMutableString alloc] init ];
    NSInteger   sumLW=0;
    if ([portCode count]>0) {
        int count=0;
        for (int i=0; i<[portCode count]; i++) {
            if (((TgPort *)[portCode objectAtIndex:i]).didSelected) {
                count++;
                if (count==1) {
                    [tmpString appendString:@" AND PORTCODE in ("];
                }
                //如果条件不是第一条
                if (count!=1) {
                    [tmpString appendString:@","];
                }
                [tmpString appendFormat:@"'%@'",((TgPort *)[portCode objectAtIndex:i]).portCode];
            }
        }
        if (count>0) {
            [tmpString appendString:@")"];
        }
    }
    
    NSInteger monthNum= [PubInfo getMonthDifference:startDate :endDate];
    NSString *year= [startDate substringToIndex:4];
    NSString *month=[startDate substringFromIndex:4];
    
    for (int i=0; i<monthNum; i++) {
        sqlite3_stmt *statement;
        NSString *sql=[NSString stringWithFormat:@"SELECT sum(lw) from NTShipCompanyTranShare where tradeyear='%@' and trademonth='%@' %@ ",year,month,tmpString];
        NSLog(@"执行 InsertByPortCode Sql[%@] ",sql);
        
        if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                sumLW= sqlite3_column_int(statement,0);
                
            }
        }
        if (sumLW>0) {
            
            sql=[NSString stringWithFormat:@"select comid,company,tradeyear,trademonth,sum(lw) from NTShipCompanyTranShare where tradeyear='%@' and trademonth='%@' %@ group by comid,company,tradeyear,trademonth",year,month,tmpString];
            NSLog(@"执行 InsertByPortCode Sql[%@] ",sql);
            if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    
                    
                    NTShipCompanyTranShare *ntShipCompanyTranShare=[[NTShipCompanyTranShare alloc] init];
                    
                    ntShipCompanyTranShare.COMID= sqlite3_column_int(statement,0);
                    
                    
                    char * rowData1=(char *)sqlite3_column_text(statement,1);
                    if (rowData1 == NULL)
                        ntShipCompanyTranShare.COMPANY = nil;
                    else
                        ntShipCompanyTranShare.COMPANY = [NSString stringWithUTF8String: rowData1];
                    
                    char * rowData2=(char *)sqlite3_column_text(statement,2);
                    if (rowData2 == NULL)
                        ntShipCompanyTranShare.TRADEYEAR = nil;
                    else
                        ntShipCompanyTranShare.TRADEYEAR = [NSString stringWithUTF8String: rowData2];
                    
                    char * rowData3=(char *)sqlite3_column_text(statement,3);
                    if (rowData3 == NULL)
                        ntShipCompanyTranShare.TRADEMONTH = nil;
                    else
                        ntShipCompanyTranShare.TRADEMONTH = [NSString stringWithUTF8String: rowData3];
                    
                    ntShipCompanyTranShare.LW   =  sqlite3_column_int(statement,4);
                    
                    float percent=(float)ntShipCompanyTranShare.LW/sumLW;
                    //保留三位小数
                    NSLog(@"%0.3f",percent);
                    ntShipCompanyTranShare.PERCENT =[NSString stringWithFormat:@"%0.1f", percent*100];

                    [NTShipCompanyTranShareDao insert_tmpTable:ntShipCompanyTranShare];
                    [ntShipCompanyTranShare release];
                    
                }
            }
            
        }
        
        NSLog(@"--%@%@",year,month);
        if ([month isEqualToString:@"12"]) {
            month=@"01";
            year =  [NSString stringWithFormat:@"%d",[year integerValue]+1];
        }
        else {
            if ([month integerValue]>=9) {
                month = [NSString stringWithFormat:@"%d", [month integerValue]+1];
            }
            else {
                month = [NSString stringWithFormat:@"0%d", [month integerValue]+1];
            }
        }
        NSLog(@"++%@%@",year,month);
        
    }    
    
    [tmpString release];
}
+(NTShipCompanyTranShare *) getTransShareByComid:(NSInteger)comid Year:(NSString *)year Month:(NSString *)month
{
	sqlite3_stmt *statement;
    NTShipCompanyTranShare *transShare=[[[NTShipCompanyTranShare alloc] init] autorelease];
    
    NSString *sql=[NSString stringWithFormat:@"SELECT company,percent FROM  TMP_NTShipCompanyTranShare WHERE comid=%d and tradeyear='%@' and trademonth='%@' ",comid,year,month];
    //NSLog(@"执行 getTmCoalinfoBySql [%@] ",sql);
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                transShare.COMPANY = nil;
            else
                transShare.COMPANY = [NSString stringWithUTF8String: rowData0];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                transShare.PERCENT = nil;
            else
                transShare.PERCENT = [NSString stringWithUTF8String: rowData1];
            
        }
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return transShare;
}
@end