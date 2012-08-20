//
//  AvgFactoryZXTimeDao.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-13.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

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
	//NSLog(@"------------------------------------------open  database succes ....");
}


+(NSMutableArray *)getTimeTitle1:(NSString *)startTime :(NSString *)endTime :(NSString *)factoryCate
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
    NSMutableArray *array=[AvgFactoryZXTimeDao getTimeTitleBySql1:query:query1];
   // NSLog(@"执行 getTimeTitleBySql: 数量[%d]",[array count]);
    return array;
}

+(NSMutableArray *)getTimeTitleBySql1:(NSString *)sql1:(NSString *)sql2
{
    NSMutableArray *d=[[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *statement;
    NSString *sql= [NSString   stringWithFormat:@"SELECT   AvgT.TradeMonth  FROM ( select  ifnull(Pavg.avgZG,0) as avgZG,ifnull(Favg.avgXG,0)as avgXG,ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME from ( select '卸港' as UseType,FACTORYNAME,TradeMonth,round(sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG  from (sELECT  vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME, ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round( round(   round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay, vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where 1=1  and vbshiptrans.ISCAL=1  And  strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000' And   strftime('%%Y',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@ )  as  a    group by FACTORYNAME,TradeMonth    ) as Favg  LEFT OUTER  JOIN (  select '装港' as UseType,FACTORYNAME,TradeMonth, round( sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2 ) as avgZG  from ( sELECT   vbshiptrans.FACTORYNAME,(CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100))) as TradeMonth, round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1 And strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'  And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and  %@ )  as   a  group by FACTORYNAME,TradeMonth  )as Pavg  on Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth       union     select    ifnull(   Pavg.avgZG,0) as avgZG,ifnull(  Favg.avgXG    ,0)as avgXG,   ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,  ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME  from (   select '装港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgZG   from (   sELECT   vbshiptrans.FACTORYNAME, (CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth,   round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0 ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1  And    strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'	 And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and %@ )  as   a  group by FACTORYNAME,TradeMonth  )AS Pavg  LEFT OUTER  JOIN  (    select '卸港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG   from ( sELECT    vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME,   (  CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round(  round(  round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay,vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE  where 1=1  and     vbshiptrans.ISCAL=1   And   strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000'And   strftime('%%m',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@   )  as   a  group by FACTORYNAME,TradeMonth      )as Favg   on      Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth  order by  avgLT  )  AS AvgT   where  %@   group  by  AvgT.TradeMonth",sql1,sql1,sql1,sql1,sql2];
    
   // NSLog(@"执行 getTimeTitleBySql [%@]",sql);
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
    
     [ d  addObject:@"平均"];


    return d;
 
}

+(NSMutableArray *)getAvgFactoryDate:(NSString *)startTime :(NSString *)endTime :(NSString *)factoryCate :(NSMutableArray *)titleTime
{
    NSString *query=[NSString stringWithFormat:@" 1=1 "];
    
     NSString *sql2=@"";
    
    if(titleTime&&[titleTime count]!=0){
        for (int i=1; i<[titleTime count]-1; i++) {
            NSString *title=[titleTime objectAtIndex:i];
            
            sql2=[sql2 stringByAppendingFormat:@"SUM(case TradeMonth when '%@' then avgXG  else NULL end )as '%@-avgXG', SUM(case TradeMonth when '%@' then avgZG  else NULL end )as '%@-avgZG',  SUM(case TradeMonth when '%@' then avgLT  else NULL end )as '%@-avgLT',  ",title,title,title,title,title,title];
        }
    }
//NSLog(@"---------sql2[%@]",sql2);

    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)))>='%@' ",startTime];
    }
    if (![endTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@" AND ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)))<='%@' ",endTime];
    }
    if (![factoryCate isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TFFACTORY.CATEGORY='%@' ",factoryCate ];
    }

    NSMutableArray *date=[AvgFactoryZXTimeDao getAvgFactoryDateBySql:query :sql2   titleTimeCount:[titleTime count]];

//NSLog(@"getAvgFactoryDate[%d]",[date     count]);

return date;



}

+(NSMutableArray *)getAvgFactoryDateBySql:(NSString *)sql1:(NSString *)sql2 titleTimeCount:(NSInteger)count
{
    sqlite3_stmt *statement;
    NSString *sql=[NSString  stringWithFormat:@"select LT.FACTORYNAME,  %@   Round( AVG( LT.avgXG  ),2   )as AVGTimeavgXG,  Round(  AVG( LT.avgZG  ) ,2  )AS AVGTimeavgZG, round( Round(  AVG( LT.avgLT  ) ,6   ),2)AS AVGTimeavgLT  from  ( select     ifnull(Pavg.avgZG,0) as avgZG,ifnull(Favg.avgXG,0)as avgXG,ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME from  ( select '卸港' as UseType,FACTORYNAME,TradeMonth,round(sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG  from (sELECT  vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME, ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round( round(   round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay, vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where 1=1  and vbshiptrans.ISCAL=1  And  strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000' And   strftime('%%Y',vbshiptrans.F_ANCHORAGETIME)!='2000'  and       %@  )  as  a    group by FACTORYNAME,TradeMonth    ) as Favg  LEFT OUTER  JOIN (                                                                                                                                        select '装港' as UseType,FACTORYNAME,TradeMonth, round( sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2 ) as avgZG  from ( sELECT   vbshiptrans.FACTORYNAME,(CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100))) as TradeMonth, round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1 And strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'  And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and   %@   )  as   a  group by FACTORYNAME,TradeMonth  )as Pavg  on Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth       union     select    ifnull(   Pavg.avgZG,0) as avgZG,ifnull(  Favg.avgXG    ,0)as avgXG,   ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,  ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME  from (   select '装港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgZG   from (   sELECT   vbshiptrans.FACTORYNAME, (CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth,   round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0 ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1  And    strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'	 And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and  %@                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           )  as   a  group by FACTORYNAME,TradeMonth  )AS Pavg  LEFT OUTER  JOIN  (    select '卸港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG   from ( sELECT    vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME,   (  CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round(  round(  round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay,vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE  where 1=1  and     vbshiptrans.ISCAL=1   And   strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000'And   strftime('%%Y',vbshiptrans.F_ANCHORAGETIME)!='2000'  and   %@                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              )  as   a  group by FACTORYNAME,TradeMonth      )as Favg   on  Favg.Factoryname=Pavg.Factoryname   AND  Favg.TradeMonth=Pavg.TradeMonth  order by  TradeMonth ) as LT     GROUP BY LT.FACTORYNAME ",sql2,sql1,sql1,sql1,sql1];
    
   // NSLog(@"执行 getAvgFactoryDateBySql [%@]",sql);


 NSMutableArray  *date=[[[NSMutableArray alloc] init]
    autorelease ];


if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            NSMutableArray  *arr=[[NSMutableArray alloc] init];
            [arr addObject:@"3"];
        
            char *date1=(char *)sqlite3_column_text(statement, 0);
            if(date1==NULL)
                [arr    addObject:@""];
            else
                [arr addObject:[NSString stringWithUTF8String:date1]];
           
            for (int i=1; i<=(count-1)*3; i++) {
                char *dated=(char *)sqlite3_column_text(statement,i);
                if(dated==NULL)
                    [arr    addObject:@""];
                else
              [arr addObject:[NSString stringWithUTF8String:dated]];  
            }        
            [date addObject:arr];
            [arr     release];
        }
   }
    return  date;
}


           
    return d;
 
}

+(NSMutableArray *)getAvgFactoryDate:(NSString *)startTime :(NSString *)endTime :(NSString *)factoryCate :(NSMutableArray *)titleTime
{
    NSString *query=[NSString stringWithFormat:@" 1=1 "];
    
     NSString *sql2=@"";
    
    if(titleTime&&[titleTime count]!=0){
        for (int i=1; i<[titleTime count]-1; i++) {
            NSString *title=[titleTime objectAtIndex:i];
            
            sql2=[sql2 stringByAppendingFormat:@"SUM(case TradeMonth when '%@' then avgXG  else NULL end )as '%@-avgXG', SUM(case TradeMonth when '%@' then avgZG  else NULL end )as '%@-avgZG',  SUM(case TradeMonth when '%@' then avgLT  else NULL end )as '%@-avgLT',  ",title,title,title,title,title,title];
        }
    }
//NSLog(@"---------sql2[%@]",sql2);

    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)))>='%@' ",startTime];
    }
    if (![endTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@" AND ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)))<='%@' ",endTime];
    }
    if (![factoryCate isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TFFACTORY.CATEGORY='%@' ",factoryCate ];
    }

    NSMutableArray *date=[AvgFactoryZXTimeDao getAvgFactoryDateBySql:query :sql2   titleTimeCount:[titleTime count]];

//NSLog(@"getAvgFactoryDate[%d]",[date     count]);

return date;



}

+(NSMutableArray *)getAvgFactoryDateBySql:(NSString *)sql1:(NSString *)sql2 titleTimeCount:(NSInteger)count
{
    sqlite3_stmt *statement;
    NSString *sql=[NSString  stringWithFormat:@"select LT.FACTORYNAME,  %@   Round( AVG( LT.avgXG  ),2   )as AVGTimeavgXG,  Round(  AVG( LT.avgZG  ) ,2  )AS AVGTimeavgZG, round( Round(  AVG( LT.avgLT  ) ,6   ),2)AS AVGTimeavgLT  from  ( select     ifnull(Pavg.avgZG,0) as avgZG,ifnull(Favg.avgXG,0)as avgXG,ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME from  ( select '卸港' as UseType,FACTORYNAME,TradeMonth,round(sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG  from (sELECT  vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME, ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round( round(   round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay, vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where 1=1  and vbshiptrans.ISCAL=1  And  strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000' And   strftime('%%Y',vbshiptrans.F_ANCHORAGETIME)!='2000'  and       %@  )  as  a    group by FACTORYNAME,TradeMonth    ) as Favg  LEFT OUTER  JOIN (                                                                                                                                        select '装港' as UseType,FACTORYNAME,TradeMonth, round( sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2 ) as avgZG  from ( sELECT   vbshiptrans.FACTORYNAME,(CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100))) as TradeMonth, round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1 And strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'  And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and   %@   )  as   a  group by FACTORYNAME,TradeMonth  )as Pavg  on Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth       union     select    ifnull(   Pavg.avgZG,0) as avgZG,ifnull(  Favg.avgXG    ,0)as avgXG,   ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,  ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME  from (   select '装港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgZG   from (   sELECT   vbshiptrans.FACTORYNAME, (CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth,   round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0 ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1  And    strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'	 And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and  %@                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           )  as   a  group by FACTORYNAME,TradeMonth  )AS Pavg  LEFT OUTER  JOIN  (    select '卸港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG   from ( sELECT    vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME,   (  CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round(  round(  round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay,vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE  where 1=1  and     vbshiptrans.ISCAL=1   And   strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000'And   strftime('%%Y',vbshiptrans.F_ANCHORAGETIME)!='2000'  and   %@                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              )  as   a  group by FACTORYNAME,TradeMonth      )as Favg   on  Favg.Factoryname=Pavg.Factoryname   AND  Favg.TradeMonth=Pavg.TradeMonth  order by  TradeMonth ) as LT     GROUP BY LT.FACTORYNAME ",sql2,sql1,sql1,sql1,sql1];
    
   // NSLog(@"执行 getAvgFactoryDateBySql [%@]",sql);

 NSMutableArray  *date=[[[NSMutableArray alloc] init]
    autorelease ];

if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            NSMutableArray  *arr=[[NSMutableArray alloc] init];
            [arr addObject:@"3"];
        
            char *date1=(char *)sqlite3_column_text(statement, 0);
            if(date1==NULL)
                [arr    addObject:@""];
            else
                [arr addObject:[NSString stringWithUTF8String:date1]];
           
            for (int i=1; i<=(count-1)*3; i++) {
                char *dated=(char *)sqlite3_column_text(statement,i);
                if(dated==NULL)
                    [arr    addObject:@""];
                else
              [arr addObject:[NSString stringWithUTF8String:dated]];  
            }        
            [date addObject:arr];
            [arr     release];
        }
   }
    return  date;
}










@end
