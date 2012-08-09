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
 NSString *sql= [NSString   stringWithFormat:@"select vb_shiptrans.PORTNAME from vb_shiptrans inner join TF_PORT  on TF_PORT.PORTCODE=vb_shiptrans.PORTCODE where   ISCAL=1 and datepart(YYYY,P_ANCHORAGETIME)!=2000 and datepart(YYYY,P_DEPARTTIME)!=2000  and NATIONALTYPE=0 and  %@   group by    vb_shiptrans.PORTNAME order by vb_shiptrans.PORTNAME DESC",sql1];

  NSLog(@"执行 getPortName [%@]",sql);

  if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
    while ( sqlite3_step(statement)==SQLITE_ROW) {
        NSString *portName;
        char *date1=(char *)sqlite3_column_text(statement, 1);
        if (date1==NULL)
            portName=nil;
        else 
           portName=[NSString stringWithUTF8String:date1];
        
        [d addObject:portName];
        [portName release];
        
      }
    
   }


return d;

}

+(NSMutableArray *)getPortName:(NSString *)startTime :(NSString *)endTime
{
  
 NSString *query=[NSString stringWithFormat:@" 1=1 "];
if (![startTime isEqualToString:All_]) {
    query=[query stringByAppendingFormat:@"  AND vb_shiptrans.tradetime>='%@' ",startTime ];
}
if (![endTime isEqualToString:All_]) {
    query=[query stringByAppendingFormat:@"  AND vb_shiptrans.tradetime<='%@' ",endTime ];
}

 NSMutableArray *a=[self getPortName:query];
NSLog(@"根据时间start[%@]end[%@]查询到  港口名【%d】",startTime,endTime,[a count]);


return a;



}


+(NSMutableDictionary *)getTimeAndAvgTime:(NSString *)sql1
{

 NSMutableDictionary *a=[[NSMutableDictionary    alloc] init];
  sqlite3_stmt *statement;
  NSString *sql= [NSString stringWithFormat:@"select vb_shiptrans.PORTNAME, convert(varchar,DATEPART(YYYY,tradetime)) + '-' + CONVERT(varchar,DATEPART(MM,tradetime))  as TRADETIME ,cast(sum(CONVERT(numeric(18,2), DATEDIFF(minute,P_ANCHORAGETIME,P_DEPARTTIME))/1440*vb_shiptrans.LW/10000)/sum(vb_shiptrans.LW/10000) as decimal(20,2)) as avgTime from vb_shiptrans inner join TF_PORT  on TF_PORT.PORTCODE=vb_shiptrans.PORTCODE where 1=1  and ISCAL=1 and datepart(YYYY,P_ANCHORAGETIME)!=2000 and datepart(YYYY,P_DEPARTTIME)!=2000  and NATIONALTYPE=0 AND  %@  group by  convert(varchar,DATEPART(YYYY,tradetime)) + '-' + CONVERT(varchar,DATEPART(MM,tradetime)), vb_shiptrans.PORTNAME order by TRADETIME,avgTime ",sql1];

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
        
        
        
        NSLog(@"latefee:[%@]-----month:[%@]",tradeTime,avgTime);
        
        [a setObject: avgTime forKey:tradeTime ];
        
        
    }
  }

 return a;

}



+(NSMutableDictionary *)getTimeAndAvgTime:(NSString *)portName :(NSString *)startTime :(NSString *)endTime
{

    NSString *query=[NSString stringWithFormat:@" 1=1 "];
if (![portName isEqualToString:All_]) {
    query=[query stringByAppendingFormat:@" AND VB_SHIPTRANS.PORTNAME='%@'  ",portName];
}

if (![startTime isEqualToString:All_]) {
    query=[query stringByAppendingFormat:@"  AND vb_shiptrans.tradetime>='%@' ",startTime ];
}
if (![endTime isEqualToString:All_]) {
    query=[query stringByAppendingFormat:@"  AND vb_shiptrans.tradetime<='%@' ",endTime ];
}

 NSMutableDictionary *a=[self getTimeAndAvgTime:query];


 return a;

}














@end
