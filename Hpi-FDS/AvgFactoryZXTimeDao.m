//
//  AvgFactoryZXTimeDao.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-13.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "AvgFactoryZXTimeDao.h"
#import "PubInfo.h"
static sqlite3  *database;
@implementation AvgFactoryZXTimeDao

+(NSString *)dataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory=[paths objectAtIndex:0];
    NSString *path=[documentsDirectory  stringByAppendingPathComponent: @"database.db"  ];
   //NSLog(@"database:path=== %@",path);
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
+(NSMutableArray *)getTimeTitle:(NSString *)startTime :(NSString *)endTime :(NSString *)factoryCate
{

   NSString *query=[NSString stringWithFormat:@" 1=1 "];
 NSString *query1=[NSString stringWithFormat:@" 1=1 "];

    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))>='%@' ",@"%Y",@"%m",startTime ];
        
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth>='%@'  " ,startTime];
    }
    if (![endTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))<='%@' ",@"%Y",@"%m",endTime ];
         query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth<='%@'  " ,endTime];
        
    }

    if (![factoryCate isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TFFACTORY.CATEGORY='%@' ",factoryCate ];
    }
   // NSLog(@"--------------------------%@",query1);
    NSMutableArray *array=[AvgFactoryZXTimeDao getTimeTitleBySql:query:query1];
// NSLog(@"执行 getTimeTitleBySql: 数量[%d]",[array count]);
return array;
}

+(NSMutableArray *)getTimeTitleBySql:(NSString *)sql1:(NSString *)sql2
{   
    NSMutableArray *d=[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *sql= [NSString   stringWithFormat:@"SELECT   AvgT.TradeMonth  FROM ( select  ifnull(Pavg.avgZG,0) as avgZG,ifnull(Favg.avgXG,0)as avgXG,ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME from ( select '卸港' as UseType,FACTORYNAME,TradeMonth,round(sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG  from (sELECT  vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME, ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round( round(   round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay, vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where 1=1  and vbshiptrans.ISCAL=1  And  strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000' And   strftime('%%Y',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@ )  as  a    group by FACTORYNAME,TradeMonth    ) as Favg  LEFT OUTER  JOIN (  select '装港' as UseType,FACTORYNAME,TradeMonth, round( sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2 ) as avgZG  from ( sELECT   vbshiptrans.FACTORYNAME,(CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100))) as TradeMonth, round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1 And strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'  And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and  %@ )  as   a  group by FACTORYNAME,TradeMonth  )as Pavg  on Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth       union     select    ifnull(   Pavg.avgZG,0) as avgZG,ifnull(  Favg.avgXG    ,0)as avgXG,   ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,  ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME  from (   select '装港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgZG   from (   sELECT   vbshiptrans.FACTORYNAME, (CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth,   round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0 ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1  And    strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'	 And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and %@ )  as   a  group by FACTORYNAME,TradeMonth  )AS Pavg  LEFT OUTER  JOIN  (    select '卸港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG   from ( sELECT    vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME,   (  CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round(  round(  round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay,vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE  where 1=1  and     vbshiptrans.ISCAL=1   And   strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000'And   strftime('%%m',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@   )  as   a  group by FACTORYNAME,TradeMonth      )as Favg   on      Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth  order by  avgLT  )  AS AvgT   where  %@   group  by  AvgT.TradeMonth",sql1,sql1,sql1,sql1,sql2];

    //NSLog(@"执行 getTimeTitleBySql [%@]",sql);
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        [ d  addObject:@"电厂"];
        while ( sqlite3_step(statement)==SQLITE_ROW) { 
            NSString *time;
            char *date1=(char *)sqlite3_column_text(statement, 0);
            if (date1==NULL)
                time=nil;
            else
                time=[NSString stringWithUTF8String:date1];
            
            //NSLog(@"%@",time);
            
            [d addObject:time];
        }
    }
//NSLog(@"--------------查到时间标题：【%d】",[d count]);
return d;
}


+(NSMutableArray *)getFactoryName:(NSString *)startTime :(NSString *)endTime :(NSString *)factoryCate
{
    NSString *query=[NSString stringWithFormat:@" 1=1 "];
    NSString *query1=[NSString stringWithFormat:@" 1=1 "];
    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))>='%@' ",@"%Y",@"%m",startTime ];
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth>='%@'  " ,startTime];
    }
    if (![endTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))<='%@' ",@"%Y",@"%m",endTime ];
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth<='%@'  " ,endTime];
        
    }
    
    if (![factoryCate isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TFFACTORY.CATEGORY='%@' ",factoryCate ];
    }

 NSMutableArray *array=[AvgFactoryZXTimeDao getFactoryNameBySql:query:query1];
 //NSLog(@"执行 getFactoryNameBySql: 数量[%d]",[array count]);
return array;
}


+(NSMutableArray *)getFactoryNameBySql:(NSString *)sql1 :(NSString *)sql2
{
    NSMutableArray *d=[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *sql= [NSString   stringWithFormat:@"SELECT  AvgT.Factoryname  FROM (   select  ifnull(Pavg.avgZG,0) as avgZG,ifnull(Favg.avgXG,0)as avgXG,ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME from ( select '卸港' as UseType,FACTORYNAME,TradeMonth,round(sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG  from (sELECT  vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME, ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round( round(   round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay, vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where 1=1  and vbshiptrans.ISCAL=1  And  strftime('%@',vbshiptrans.F_FINISHTIME)!='2000' And   strftime('%@',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@ )  as  a    group by FACTORYNAME,TradeMonth    ) as Favg  LEFT OUTER  JOIN (  select '装港' as UseType,FACTORYNAME,TradeMonth, round( sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2 ) as avgZG  from ( sELECT   vbshiptrans.FACTORYNAME,(CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) as TradeMonth, round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1 And strftime('%@',vbshiptrans.P_DEPARTTIME) != '2000'  And strftime('%@',vbshiptrans.P_ANCHORAGETIME) != '2000'	and  %@ )  as   a  group by FACTORYNAME,TradeMonth  )as Pavg  on Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth       union     select    ifnull(   Pavg.avgZG,0) as avgZG,ifnull(  Favg.avgXG    ,0)as avgXG,   ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,  ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME  from (   select '装港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgZG   from (   sELECT   vbshiptrans.FACTORYNAME, (CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth,   round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0 ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1  And    strftime('%@',vbshiptrans.P_DEPARTTIME) != '2000'	 And strftime('%@',vbshiptrans.P_ANCHORAGETIME) != '2000'	and %@ )  as   a  group by FACTORYNAME,TradeMonth  )AS Pavg  LEFT OUTER  JOIN  (    select '卸港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG   from ( sELECT    vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME,   (  CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round(  round(  round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay,vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE  where 1=1  and     vbshiptrans.ISCAL=1   And   strftime('%@',vbshiptrans.F_FINISHTIME)!='2000'And   strftime('%@',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@   )  as   a  group by FACTORYNAME,TradeMonth      )as Favg   on      Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth  order by  avgLT  )  AS AvgT   where   %@  group  by  AvgT.Factoryname ",@"%Y",@"%m",@"%Y",@"%Y",sql1,@"%Y",@"%m",@"%Y",@"%Y",sql1,@"%Y",@"%m",@"%Y",@"%Y",sql1,@"%Y",@"%m",@"%Y",@"%Y",sql1,sql2];
  //NSLog(@"执行 getFactoryNameBySql [%@]",sql);
    if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        while ( sqlite3_step(statement)==SQLITE_ROW) {
            NSString *name;
            char *date1=(char *)sqlite3_column_text(statement, 0);
            if (date1==NULL)
                name=nil;
            else
                name=[NSString stringWithUTF8String:date1];
            [d addObject:name];
            [name release];

        }
    }
    
     sqlite3_finalize(statement);
   // NSLog(@"------查到电厂名：【%d】",[d count]);
    return d;
}


+(NSMutableDictionary *)getFactoryDate:(NSString *)startTime :(NSString *)endTime :(NSString *)factoryCate :(NSString *)factoryName
{
    NSString *query=[NSString stringWithFormat:@" 1=1 "];
    NSString *query1=[NSString stringWithFormat:@" 1=1 "];
    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))>='%@' ",@"%Y",@"%m",startTime ];
        
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth>='%@'  " ,startTime];
    }
    if (![endTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)))<='%@' ",@"%Y",@"%m",endTime ];
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth<='%@'  " ,endTime];
    }
    if (![factoryCate isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TFFACTORY.CATEGORY='%@' ",factoryCate ];
    }
    if(factoryName){
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.Factoryname='%@'  " ,factoryName];
    }
   NSMutableDictionary *array=[AvgFactoryZXTimeDao getFactoryDateBySql:query:query1];
//NSLog(@"执行 getFactoryDateBySql: 数量[%d]",[array count]);
return array;
}

+(NSMutableDictionary *)getFactoryDateBySql:(NSString *)sql1 :(NSString *)sql2
{
      NSMutableDictionary *b=[[NSMutableDictionary   alloc] init ];
    sqlite3_stmt *statement;
    NSString *sql= [NSString   stringWithFormat:@"SELECT  FACTORYNAME, avgXG,avgZG ,avgLT,TradeMonth   FROM(  select  ifnull(Pavg.avgZG,0) as avgZG,ifnull(Favg.avgXG,0)as avgXG,ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME from ( select '卸港' as UseType,FACTORYNAME,TradeMonth,round(sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG  from (sELECT  vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME, ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round( round(   round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay, vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where 1=1  and vbshiptrans.ISCAL=1  And  strftime('%@',vbshiptrans.F_FINISHTIME)!='2000' And   strftime('%@',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@ )  as  a    group by FACTORYNAME,TradeMonth    ) as Favg  LEFT OUTER  JOIN (  select '装港' as UseType,FACTORYNAME,TradeMonth, round( sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2 ) as avgZG  from ( sELECT   vbshiptrans.FACTORYNAME,(CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) as TradeMonth, round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1 And strftime('%@',vbshiptrans.P_DEPARTTIME) != '2000'  And strftime('%@',vbshiptrans.P_ANCHORAGETIME) != '2000'	and  %@ )  as   a  group by FACTORYNAME,TradeMonth  )as Pavg  on Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth       union     select    ifnull(   Pavg.avgZG,0) as avgZG,ifnull(  Favg.avgXG    ,0)as avgXG,   ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,  ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME  from (   select '装港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgZG   from (   sELECT   vbshiptrans.FACTORYNAME, (CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth,   round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0 ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1  And    strftime('%@',vbshiptrans.P_DEPARTTIME) != '2000'	 And strftime('%@',vbshiptrans.P_ANCHORAGETIME) != '2000'	and %@ )  as   a  group by FACTORYNAME,TradeMonth  )AS Pavg  LEFT OUTER  JOIN  (    select '卸港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG   from ( sELECT    vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME,   (  CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round(  round(  round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay,vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE  where 1=1  and     vbshiptrans.ISCAL=1   And   strftime('%@',vbshiptrans.F_FINISHTIME)!='2000'And   strftime('%@',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@   )  as   a  group by FACTORYNAME,TradeMonth      )as Favg   on      Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth  order by  avgLT  )  AS AvgT     where  %@  order by  AvgT.TradeMonth",@"%Y",@"%m",@"%Y",@"%Y",sql1,@"%Y",@"%m",@"%Y",@"%Y",sql1,@"%Y",@"%m",@"%Y",@"%Y",sql1,@"%Y",@"%m",@"%Y",@"%Y",sql1,sql2];
//NSLog(@"执行 getFactoryDateBySql [%@]",sql);
    if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        int XG=0;
        int ZG=0;
        int LT=0;
        float Txg=0.0;
        float Tzg=0.0;
        float Tlt=0.0;
      
        while ( sqlite3_step(statement)==SQLITE_ROW) {
            NSString *avgXG;
            NSString *avgZG;
            NSString *avgLT;
            NSString *time;
            
            NSMutableArray *d=[[NSMutableArray alloc] init];
             char *date1=(char *)sqlite3_column_text(statement, 1);
            if (date1==NULL)
            {
              avgXG=@"";
             [d addObject:avgXG];
            }
              
            else{
                avgXG=[NSString stringWithUTF8String:date1];
                XG++;
                Txg+=[avgXG floatValue  ];
               [d addObject:avgXG];
            }
            char *date2=(char *)sqlite3_column_text(statement, 2);
            if (date2==NULL)
            {
             avgZG=@"";
            [d addObject:avgZG];

            }
            else{
                avgZG=[NSString stringWithUTF8String:date2];
            
                ZG++;
                Tzg+=[avgZG floatValue];
                [d addObject:avgZG];
            }
            char *date3=(char *)sqlite3_column_text(statement, 3);
            if (date3==NULL)
            {
            avgLT=@"";
                 [d addObject:avgLT];
            }
                
            else{
                avgLT=[NSString stringWithUTF8String:date3];
                LT++;
                Tlt+=[avgLT  floatValue];
                 [d addObject:avgLT];
            }
            char *date4=(char *)sqlite3_column_text(statement, 4);
            if (date4==NULL)
            {
                time=nil;
            }else{
                time=[NSString stringWithUTF8String:date4];
            }
           [b  setObject:d forKey:time ];
            [avgXG release];
            [avgLT release];
            [avgZG release];
             [d release];
        }
          NSMutableArray *d=[[NSMutableArray alloc] init];
        [d addObject:[NSString stringWithFormat:@"%.2f",Txg/XG]  ];
        [d addObject:[NSString stringWithFormat:@"%.2f",Tzg/ZG]  ];
        [d addObject:[NSString stringWithFormat:@"%.2f",Tlt/LT]  ];
    [b setObject:d forKey:@"平均"];
    [d release];
    }
    return b;
}


@end
