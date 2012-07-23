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



+(void) InsertByPortCode:(NSMutableArray *)portCode :(NSString *)startDate :(NSString *)endDate{
    NSMutableString *tmpString = [[NSMutableString alloc] init ];

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
    NSLog(@"monthNum=%d",monthNum);
 
    sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT sum(lw) from NTShipCompanyTranShare where tradeyear='%@', and trademonth='%@' %@ ",tmpString];
    NSLog(@"执行 InsertByPortCode Sql[%@] ",sql);
     
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
        }
    }

    [tmpString release];
}
@end
