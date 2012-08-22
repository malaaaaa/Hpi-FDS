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
    
    
   // NSLog(@"database:path=== %@",path);
    return  path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		//NSLog(@"open  database error");
		return;
	}
	//NSLog(@"open  database succes ....");
}
+(NSMutableArray *)getTime:(NSString *)startTime:(NSString *)endTime
{
    NSMutableArray *d=[[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *statement;
    NSString *sql= [NSString   stringWithFormat:@"select ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) AS TRADETIME     from VbShiptrans inner join TF_PORT  on TF_PORT.PORTCODE=VbShiptrans.PORTCODE  where   ISCAL=1  and strftime('%@',VbShiptrans.P_ANCHORAGETIME)!='2000' and strftime('%@',VbShiptrans.P_DEPARTTIME)!='2000'  and NATIONALTYPE=0  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) >='%@' AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) <='%@'  group by   TRADETIME order by     TRADETIME  ",@"%Y",@"%m",    @"%Y",@"%Y",    @"%Y",@"%m",  startTime,@"%Y",@"%m",endTime];
    
    
    
   //  NSLog(@"执行 getTime [%@]",sql);
    if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        [d addObject:@"港口"];
        
        while ( sqlite3_step(statement)==SQLITE_ROW) {
            NSString *time;
            char *date1=(char *)sqlite3_column_text(statement, 0);
            if (date1==NULL)
                time=nil;
            else
                time=[NSString stringWithUTF8String:date1];  
            [d addObject:time];
        }
        
        [d addObject:@"平均时间"];
        
    }
    
    
   // NSLog(@"------查到时间：【%d】",[d count]);
    return  d;
}


+(NSMutableArray *)getAvgPortDate:(NSString *)startTime :(NSString *)endTime     :(NSMutableArray *)titleTime
{
    NSString *query=[NSString stringWithFormat:@" 1=1 "];
    
    NSString *sql2=@"";


    if(titleTime&&[titleTime count]!=0){
        for (int i=1; i<[titleTime count]-1; i++) {
            NSString *title=[titleTime objectAtIndex:i];
            
            sql2=[sql2 stringByAppendingFormat:@"SUM(case TRADETIME  when '%@'  then avgTime  else NULL end) as '%@',",title,title];
            
        }
    }

    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) >='%@' ",@"%Y",@"%m",startTime ];
    }
    if (![endTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) <='%@' ",@"%Y",@"%m",endTime ];
    }


    NSMutableArray *d=[AvgPortPTimeDao getAvgPortDateBySql:sql2 :query :[titleTime count]];
    //NSLog(@"d[%d]",[d count]);
    
    return  d;

}


+(NSMutableArray *)getAvgPortDateBySql:(NSString *)sql1 :(NSString *)sql2 :(NSInteger)count
{

sqlite3_stmt *statement;
    NSString *sql=[NSString  stringWithFormat:@"select LT.PORTNAME ,  %@   round( Round(  AVG( avgTime  ) ,6   ),2)AS   AVGTimeLT FROM (   select VbShiptrans.PORTNAME , ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))AS  TRADETIME, round( round( total(round(( julianday(VbShiptrans.P_DEPARTTIME)  - julianday(VbShiptrans.P_ANCHORAGETIME)) *24*60 ,13)/1440*VbShiptrans.LW/10000.0) ,13)/total( round( VbShiptrans.LW/10000.0,6)),2)as  avgTime  from VbShiptrans inner join TF_PORT  on TF_PORT.PORTCODE=VbShiptrans.PORTCODE   where   ISCAL=1  and strftime('%@',VbShiptrans.P_ANCHORAGETIME)!='2000'  and strftime('%@',VbShiptrans.P_DEPARTTIME)!='2000'   and TF_PORT.NATIONALTYPE=0  AND %@   group by      VbShiptrans.PORTNAME ,( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))   order by TRADETIME,avgTime     )  as  LT  GROUP  BY     LT.PORTNAME",sql1,@"%Y",@"%m", @"%Y",@"%Y",sql2,@"%Y",@"%m"];

  //  NSLog(@"执行 getAvgFactoryDateBySql [%@]",sql);
    
    NSMutableArray  *date=[[[NSMutableArray alloc] init] autorelease];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            NSMutableArray  *arr=[[NSMutableArray alloc] init];
            [arr addObject:@"3"];
                       
            for (int i=0; i<count; i++) {
                char *dated=(char *)sqlite3_column_text(statement,i);
                if(dated==NULL)
                    [arr    addObject:@""];
                else
                    [arr addObject:[NSString stringWithUTF8String:dated]];
            }
            
            NSLog(@"arr[%d]",[arr count]);
            
            
            [date addObject:arr];
            [arr     release];
            
        }
     }
    return  date;
}


@end
