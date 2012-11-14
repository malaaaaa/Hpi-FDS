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
                         @",TRADEWEEK TEXT ",
						 @",LWSUM INTEGER )" ];
	
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
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TMP_NTShipCompanyTranShare  (TAG INTEGER PRIMARY KEY  ",
						 @",COMID INTEGER ",
                         @",COMPANY TEXT ",
                         @",TRADEYEAR TEXT ",
                         @",TRADEWEEK TEXT ",
						 @",LWSUM INTEGER ",
                         @",X INTEGER ",
                         @",Y INTEGER ",
                         @",PERCENT TEXT )" ];
    
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TMP_NTShipCompanyTranShare error");
		printf("%s",errorMsg);
		return;
		
	}
}


+(void)insert:(NTShipCompanyTranShare*) NTShipCompanyTranShare
{
//	NSLog(@"Insert begin NTShipCompanyTranShare");
	const char *insert="INSERT INTO NTShipCompanyTranShare (COMID,COMPANY,PORTCODE,PORTNAME,TRADEYEAR,TRADEWEEK,LWSUM) values(?,?,?,?,?,?,?)";
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
	sqlite3_bind_text(statement, 6, [NTShipCompanyTranShare.TRADEWEEK UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 7, NTShipCompanyTranShare.LWSUM);

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
//	NSLog(@"Insert begin TMP_NTShipCompanyTranShare");
	const char *insert="INSERT INTO TMP_NTShipCompanyTranShare (COMID,COMPANY,TRADEYEAR,TRADEWEEK,LWSUM,PERCENT) values(?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK)
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    
    sqlite3_bind_int(statement, 1, NTShipCompanyTranShare.COMID);
	sqlite3_bind_text(statement, 2, [NTShipCompanyTranShare.COMPANY UTF8String], -1, SQLITE_TRANSIENT);
    
	sqlite3_bind_text(statement, 3, [NTShipCompanyTranShare.TRADEYEAR UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 4, [NTShipCompanyTranShare.TRADEWEEK UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 5, NTShipCompanyTranShare.LWSUM);
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
    
    char *errorMsg;
    if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec begin error");
        return;
    }
    [NTShipCompanyTranShareDao deleteAll_tmpTable];
    NSMutableString *tmpString = [[NSMutableString alloc] init ];
    NSInteger   sumLW=0;

    if ([portCode count]>0) {
        int count=0;
        for (int i=0; i<[portCode count]; i++) {
            if (((TfPort *)[portCode objectAtIndex:i]).didSelected) {
                count++;
                if (count==1) {
                    [tmpString appendString:@" AND PORTCODE in ("];
                }
                //如果条件不是第一条
                if (count!=1) {
                    [tmpString appendString:@","];
                }
                [tmpString appendFormat:@"'%@'",((TfPort *)[portCode objectAtIndex:i]).PORTCODE];
            }
        }
        if (count>0) {
            [tmpString appendString:@")"];
        }
    }
    
    NSInteger monthNum= [PubInfo getMonthDifference:startDate :endDate];
    NSString *year= [startDate substringToIndex:4];
    NSString *month=[startDate substringFromIndex:4];
    //.................
    NSInteger  shiDai=0;
    NSInteger riNing=0;
    NSInteger huaLU=0;
    NSInteger qiTa=0;
    NSInteger flZhong=0;
    NSInteger zHai=0;
    
    NSInteger total=0;
    
    for (int i=0; i<monthNum; i++) {
        sqlite3_stmt *statement;
        NSString *sql=[NSString stringWithFormat:@"SELECT sum(lwsum) from NTShipCompanyTranShare where tradeyear='%@' and tradeweek='%@' %@ ",year,month,tmpString];
   //   NSLog(@"执行 InsertByPortCode Sql[%@] ",sql);
        
        if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                sumLW+= sqlite3_column_int(statement,0);
                
            }
        }
        if (sumLW>0) {
           
            NSString *TRADEYEAR;
            NSString *TRADEWEEK;
            NSMutableArray *cmParyArr=[[NSMutableArray alloc] initWithObjects:@"时代",@"瑞宁",@"华鲁", @"其它",@"福轮总",@"中海",nil];
            
            NSMutableArray *arr=[[NSMutableArray alloc] init];
            sql=[NSString stringWithFormat:@"select comid,company,tradeyear,tradeweek,sum(lwsum) from NTShipCompanyTranShare where tradeyear='%@' and tradeweek='%@' %@ group by comid,company,tradeyear,tradeweek",year,month,tmpString];
            //NSLog(@"执行 InsertByPortCode Sql[%@] ",sql);
            if(sqlite3_prepare_v2(database,[sql     UTF8String],-1,&statement,NULL)==SQLITE_OK){
                while (sqlite3_step(statement)==SQLITE_ROW) {
                   
                    
                    NTShipCompanyTranShare *ntShipCompanyTranShare=[[NTShipCompanyTranShare alloc] init];
                    
                    ntShipCompanyTranShare.COMID= sqlite3_column_int(statement,0);
                    
                    
                    char * rowData1=(char *)sqlite3_column_text(statement,1);
                    if (rowData1 == NULL)
                        ntShipCompanyTranShare.COMPANY = nil;
                    else
                        ntShipCompanyTranShare.COMPANY = [NSString stringWithUTF8String: rowData1];
                    
                    if (ntShipCompanyTranShare.COMPANY!=nil )
                        [arr    addObject: ntShipCompanyTranShare.COMPANY];
                    
                    
                    char * rowData2=(char *)sqlite3_column_text(statement,2);
                    if (rowData2 == NULL)
                        ntShipCompanyTranShare.TRADEYEAR = nil;
                    else
                        ntShipCompanyTranShare.TRADEYEAR = [NSString stringWithUTF8String: rowData2];
                    
                    TRADEYEAR=ntShipCompanyTranShare.TRADEYEAR;
                    
                    
                    char * rowData3=(char *)sqlite3_column_text(statement,3);
                    if (rowData3 == NULL)
                        ntShipCompanyTranShare.TRADEWEEK = nil;
                    else
                        ntShipCompanyTranShare.TRADEWEEK = [NSString stringWithUTF8String: rowData3];
                    TRADEWEEK=ntShipCompanyTranShare.TRADEWEEK;

                    ntShipCompanyTranShare.LWSUM   =  sqlite3_column_int(statement,4);
                    
                    if (ntShipCompanyTranShare.COMPANY!=nil &&[ntShipCompanyTranShare.COMPANY isEqualToString:@"时代"]) {
                        shiDai+=ntShipCompanyTranShare.LWSUM ;
                        total=shiDai;  
                    }else if (ntShipCompanyTranShare.COMPANY!=nil &&[ntShipCompanyTranShare.COMPANY isEqualToString:@"瑞宁"])
                    {
                        riNing+=ntShipCompanyTranShare.LWSUM ;
                        total=riNing;  
                    }else if (ntShipCompanyTranShare.COMPANY!=nil &&[ntShipCompanyTranShare.COMPANY isEqualToString:@"华鲁"])
                    {
                        huaLU+=ntShipCompanyTranShare.LWSUM ;
                        total=huaLU;
                        
                    }else if (ntShipCompanyTranShare.COMPANY!=nil &&[ntShipCompanyTranShare.COMPANY isEqualToString:@"其它"])
                    {
                        qiTa+=ntShipCompanyTranShare.LWSUM ;
                        total=qiTa; 
                    }else if (ntShipCompanyTranShare.COMPANY!=nil &&[ntShipCompanyTranShare.COMPANY isEqualToString:@"福轮总"])
                    {
                        flZhong+=ntShipCompanyTranShare.LWSUM ;
                        total=flZhong; 
                    }else if (ntShipCompanyTranShare.COMPANY!=nil &&[ntShipCompanyTranShare.COMPANY isEqualToString:@"中海"])
                    {  
                        zHai+=ntShipCompanyTranShare.LWSUM ;
                        total=zHai;
                    }
                    //数据矫正............  
                    //当前月加前几个月
                    float percent=(float)total/sumLW;
                    
                    //保留三位小数
                    //                    NSLog(@"%0.3f",percent);
                    ntShipCompanyTranShare.PERCENT =[NSString stringWithFormat:@"%0.1f", percent*100];
                    
                    [NTShipCompanyTranShareDao insert_tmpTable:ntShipCompanyTranShare];
                    [ntShipCompanyTranShare release];
                    
                }
            }
            if ([arr count]>0) {
                for (int i=0; i<[cmParyArr count]; i++) {
                    
                    if (![arr containsObject:[cmParyArr objectAtIndex:i]]) {
                        //插入数据
                        //定死     要从数据库查......
                        NTShipCompanyTranShare *ntShipCompanyTranShare=[[NTShipCompanyTranShare alloc] init];
                        float percent=0.0;
                        if ([[cmParyArr objectAtIndex:i] isEqualToString:@"时代"]) {
                            ntShipCompanyTranShare.COMID=4;
                            ntShipCompanyTranShare.COMPANY=@"时代";
                            
                            percent=(float)shiDai/sumLW;
                            
                        }else if ([[cmParyArr objectAtIndex:i] isEqualToString:@"瑞宁"])
                        {
                            ntShipCompanyTranShare.COMID=5;
                            ntShipCompanyTranShare.COMPANY=@"瑞宁";
                            percent=(float)riNing/sumLW;
                        }else if ([[cmParyArr objectAtIndex:i] isEqualToString:@"华鲁"])
                        {
                            ntShipCompanyTranShare.COMID=6;
                            ntShipCompanyTranShare.COMPANY=@"华鲁";
                            percent=(float)huaLU/sumLW;
                            
                        }else if ([[cmParyArr objectAtIndex:i] isEqualToString:@"其它"])
                        {
                            ntShipCompanyTranShare.COMID=7;
                            ntShipCompanyTranShare.COMPANY=@"其它";
                            percent=(float)qiTa/sumLW;
                        }else if ([[cmParyArr objectAtIndex:i] isEqualToString:@"福轮总"])
                        {
                            ntShipCompanyTranShare.COMID=9;
                            ntShipCompanyTranShare.COMPANY=@"福轮总";
                            percent=(float)flZhong/sumLW;
                        }else if ([[cmParyArr objectAtIndex:i] isEqualToString:@"中海"])
                        {
                            ntShipCompanyTranShare.COMID=12;
                            ntShipCompanyTranShare.COMPANY=@"中海";
                            percent=(float)zHai/sumLW;
                        }
                        ntShipCompanyTranShare.TRADEYEAR=TRADEYEAR;
                        ntShipCompanyTranShare.TRADEWEEK = TRADEWEEK;
                        ntShipCompanyTranShare.LWSUM =0;
                        ntShipCompanyTranShare.PERCENT =[NSString stringWithFormat:@"%0.1f", percent*100];
                        [NTShipCompanyTranShareDao insert_tmpTable:ntShipCompanyTranShare];
                        [ntShipCompanyTranShare release]; 
                    }
                }
            }
            [cmParyArr release];
            [arr release];
            
        }
        
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
        sqlite3_finalize(statement);
        
    }
    [tmpString release];
    if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec commit error");
        return;
    }
   // NSLog(@"insert over");
}
+(NTShipCompanyTranShare *) getTransShareByComid:(NSInteger)comid Year:(NSString *)year Month:(NSString *)month
{
	sqlite3_stmt *statement;
    NTShipCompanyTranShare *transShare=[[[NTShipCompanyTranShare alloc] init] autorelease];
    
    NSString *sql=[NSString stringWithFormat:@"SELECT company,percent,tag FROM  TMP_NTShipCompanyTranShare WHERE comid=%d and tradeyear='%@' and tradeweek='%@' ",comid,year,month];
   // NSLog(@"执行 getTmCoalinfoBySql [%@] ",sql);
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
            
            transShare.TAG=sqlite3_column_int(statement, 2);
        }
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
	return transShare;
}
+(NTShipCompanyTranShare *) getTransShareByTag:(NSInteger)tag {
	sqlite3_stmt *statement;
    NTShipCompanyTranShare *transShare=[[[NTShipCompanyTranShare alloc] init] autorelease];
    
    NSString *sql=[NSString stringWithFormat:@"SELECT company,percent,lwsum,x,y FROM  TMP_NTShipCompanyTranShare WHERE tag=%d  ",tag];
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
            
            transShare.LWSUM=sqlite3_column_int(statement, 2);
            transShare.X=sqlite3_column_int(statement, 3);
            transShare.Y=sqlite3_column_int(statement, 4);
            
            
        }
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
	return transShare;
}
+(void) updateTransShareCoordinate:(NSInteger) tag setX:(NSInteger)x setY:(NSInteger)y
{
	NSString *updateSql=[NSString stringWithFormat:@"update  TMP_NTShipCompanyTranShare  set x=%d, y=%d where TAG=%d ",x,y,tag];
	if(sqlite3_exec(database,[updateSql UTF8String],NULL,NULL,NULL)!=SQLITE_OK)
	{
		NSLog( @"Error: update data error with message [%s]  sql[%@]", sqlite3_errmsg(database),updateSql);
	}
	else
	{
        //		NSLog(@"update success");
    }
	return;
}
@end
