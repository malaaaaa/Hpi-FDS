//
//  AvgPortPTimeDao.m
//  Hpi-FDS
//
//  Created by bin tang on 12-8-8.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "AvgPortPTimeDao.h"
#import "PubInfo.h"
@implementation AvgPortPTimeDao
static sqlite3  *database;
+(NSString *)dataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString  *documentsDirectory=[paths objectAtIndex:0];
    
    NSString *path=[documentsDirectory  stringByAppendingPathComponent: @"database.db"  ];
    
    
    NSLog(@"database:path=== %@",path);
    return  path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open  database error");
		return;
	}
	NSLog(@"open  database succes ....");
}


+(NSMutableArray *)getPortName:(NSString *)sql1
{
  NSMutableArray *d=[[NSMutableArray alloc] init];
 sqlite3_stmt *statement;
    NSString *sql= [NSString   stringWithFormat:@"select VbShiptrans.PORTNAME from VbShiptrans inner join TF_PORT  on TF_PORT.PORTCODE=VbShiptrans.PORTCODE where   ISCAL=1  and strftime('%@',VbShiptrans.P_ANCHORAGETIME)!='2000' and strftime('%@',VbShiptrans.P_DEPARTTIME)!='2000'  and NATIONALTYPE=0  AND %@  group by    VbShiptrans.PORTNAME order by  ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))   ",@"%Y",@"%Y",sql1,@"%Y",@"%m"];

  NSLog(@"执行 getPortName [%@]",sql);

  if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
    while ( sqlite3_step(statement)==SQLITE_ROW) {
        NSString *portName;
        char *date1=(char *)sqlite3_column_text(statement, 0);
        if (date1==NULL)
            portName=nil;
        else 
           portName=[NSString stringWithUTF8String:date1];
        
        [d addObject:portName];
        [portName release];
        
      }
    
   }

NSLog(@"------查到港口名：【%d】",[d count]);
return d;

}
+(NSMutableArray *)getTime:(NSString *)startTime:(NSString *)endTime
{


  NSMutableArray *d=[[NSMutableArray alloc] init];
 sqlite3_stmt *statement;
    NSString *sql= [NSString   stringWithFormat:@"select ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) AS TRADETIME     from VbShiptrans inner join TF_PORT  on TF_PORT.PORTCODE=VbShiptrans.PORTCODE  where   ISCAL=1  and strftime('%@',VbShiptrans.P_ANCHORAGETIME)!='2000' and strftime('%@',VbShiptrans.P_DEPARTTIME)!='2000'  and NATIONALTYPE=0  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) >='%@' AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) <='%@'  group by   TRADETIME order by     TRADETIME  ",@"%Y",@"%m",    @"%Y",@"%Y",    @"%Y",@"%m",  startTime,@"%Y",@"%m",endTime];



 NSLog(@"执行 getTime [%@]",sql);
    if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        while ( sqlite3_step(statement)==SQLITE_ROW) {
            NSString *time;
            char *date1=(char *)sqlite3_column_text(statement, 0);
            if (date1==NULL)
                time=nil;
            else
                time=[NSString stringWithUTF8String:date1];
            
            [d addObject:time];
            
            //[time release];
            
        }
        
    }
    NSLog(@"------查到时间：【%d】",[d count]);
return  d;




}









+(NSMutableArray *)getPortName:(NSString *)startTime :(NSString *)endTime
{
  
 NSString *query=[NSString stringWithFormat:@" 1=1 "];
if (![startTime isEqualToString:All_]) {
    query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))>='%@' ",@"%Y",@"%m",startTime ];
}
if (![endTime isEqualToString:All_]) {
    query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))<='%@' ",@"%Y",@"%m",endTime ];
}

 NSMutableArray *a=[self getPortName:query];
NSLog(@"根据时间start[%@]end[%@]查询到  港口名【%d】",startTime,endTime,[a count]);


return a;



}


+(NSMutableDictionary *)getTimeAndAvgTime:(NSString *)sql1
{

 NSMutableDictionary *a=[[NSMutableDictionary    alloc] init];
  sqlite3_stmt *statement;
    NSString *sql= [NSString stringWithFormat:@"select VbShiptrans.PORTNAME , ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))AS  TRADETIME, round( round( total(round(( julianday(VbShiptrans.P_DEPARTTIME)  - julianday(VbShiptrans.P_ANCHORAGETIME)) *24*60 ,13)/1440*VbShiptrans.LW/10000.0) ,13)/total( round( VbShiptrans.LW/10000.0,6)),2)as  avgTime  from VbShiptrans inner join TF_PORT  on TF_PORT.PORTCODE=VbShiptrans.PORTCODE   where   ISCAL=1  and strftime('%@',VbShiptrans.P_ANCHORAGETIME)!='2000'  and strftime('%@',VbShiptrans.P_DEPARTTIME)!='2000'   and TF_PORT.NATIONALTYPE=0  AND %@   group by      VbShiptrans.PORTNAME ,( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))   order by TRADETIME,avgTime",@"%Y",@"%m", @"%Y",@"%Y",sql1,@"%Y",@"%m"];

 NSLog(@"getTimeAndAvgTime[%@]",sql );

if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK){
    while (sqlite3_step(statement)==SQLITE_ROW ) {
        NSString *tradeTime;
        NSString *avgTime;
        char *date1=(char *)sqlite3_column_text(statement, 1);
        if (date1==NULL)
            tradeTime=nil;
        else 
           tradeTime=[NSString stringWithUTF8String:date1];
        
        char *date2=(char *)sqlite3_column_text(statement, 2);
        if (date2==NULL)
            avgTime=nil;
        else 
           avgTime=[NSString stringWithUTF8String:date2];
        
        
        
        NSLog(@"tradeTime:[%@]-----avgTime:[%@]",tradeTime,avgTime);
        
        [a setObject: avgTime forKey:tradeTime ];
        
        
    }
  }

 return a;

}



+(NSMutableDictionary *)getTimeAndAvgTime:(NSString *)portName :(NSString *)startTime :(NSString *)endTime
{

    NSString *query=[NSString stringWithFormat:@" 1=1 "];
if (![portName isEqualToString:All_]) {
    query=[query stringByAppendingFormat:@" AND vbshiptrans.PORTNAME='%@'  ",portName];
}

if (![startTime isEqualToString:All_]) {
    query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) >='%@' ",@"%Y",@"%m",startTime ];
}
if (![endTime isEqualToString:All_]) {
    query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) <='%@' ",@"%Y",@"%m",endTime ];
}

 NSMutableDictionary *a=[self getTimeAndAvgTime:query];


 return a;

}














@end
