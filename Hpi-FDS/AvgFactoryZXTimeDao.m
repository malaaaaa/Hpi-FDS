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
	NSLog(@"------------------------------------------open  database succes ....");
}



//临时表
+(void)initDb
{
    NSLog(@"create NT_AvgFactoryZXTime  。。。。");
    char *errorMsg;
    
    NSString *createSql=[NSString stringWithFormat:@"%@%@%@%@%@",
                         
                         @" CREATE TABLE IF NOT  EXISTS   NT_AvgFactoryZXTime ( avgZG  TEXT   ",
                         @", avgXG  TEXT  ",
                         @", avgLT  TEXT  ",
                         @", TradeMonth  TEXT  ",
                         @",FactoryName  TEXT )"];
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        sqlite3_close(database);
        NSLog(@"create table NT_AvgFactoryZXTime error");
        printf("%s",errorMsg);
        return;
        
    }else {
        NSLog(@"---------------create table NT_AvgFactoryZXTime seccess");
    }
    
}


+(void)insert:(AvgFactoryZXTime *)AvgF
{
    
    NSLog(@"Insert begin NT_AvgFactoryZXTime ");
    const char *insert="INSERT INTO NT_AvgFactoryZXTime(avgZG,avgXG,avgLT, TradeMonth,FactoryName)values(?,?,?,?,?)";
    
    sqlite3_stmt *statement;
    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
    
    if (re!=SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
    }
    
    
    NSLog(@"avgZG[%@]",AvgF.avgZG   )    ;
    NSLog(@"FactoryName[%@]",AvgF.FactoryName   )    ;
    NSLog(@"插入实体中   有值");
    
    sqlite3_bind_text(statement, 1, [AvgF.avgZG UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [AvgF.avgXG  UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [AvgF.avgLT  UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [AvgF.TradeMonth  UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [AvgF.FactoryName  UTF8String], -1, SQLITE_TRANSIENT);
    NSLog(@"re[%d]",re);
    NSLog(@"SQLITE_DONE[%d]",SQLITE_DONE);
    
    
    
    re=sqlite3_step(statement);

    if (re!=SQLITE_DONE) {
        NSLog( @"Error: insert NT_AvgFactoryZXTime  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
        
        sqlite3_finalize(statement);
        return;
        
    }else {
        NSLog(@"------------insert NT_AvgFactoryZXTime  SUCCESS");
    }
    sqlite3_finalize(statement);
    return;
    
}


+(void)delete
{
    
    NSLog(@"删除实体........");
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  NT_AvgFactoryZXTime  " ];
    
    
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        
        NSLog(@"可能为空；Error: delete NT_AvgFactoryZXTime error with message [%s]  sql[%@]", errorMsg,deletesql);
        
    }else {
        NSLog(@"--------delete NT_AvgFactoryZXTime    success...................")  ;
    }
    return;
    
    
    
    
}
+(NSMutableArray *)getNT_AvgFactoryZXTime:(NSString *)startTime :(NSString *)endTime:(NSString *)FactoryCate
{
    
    
    /*1=1   AND ( CAST(strftime('%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%m',VbShiptrans.tradetime) AS VARCHAR(100)))>='2012-01'   AND ( CAST(strftime('%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%m',VbShiptrans.tradetime) AS VARCHAR(100)))<='2012-08'  */
    
    NSString *query=[NSString stringWithFormat:@" 1=1 "];
    
    
    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)))>='%@' ",startTime];
    }
    if (![endTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@" AND ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)))<='%@' ",endTime];
    }
    if (![FactoryCate isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TFFACTORY.CATEGORY='%@' ",FactoryCate ];
    }
    
    
    NSMutableArray *array=[AvgFactoryZXTimeDao getNT_AvgFactoryZXTimeBySql:query];
    NSLog(@"执行  getNT_AvgFactoryZXTime 数量[%d]",[array count]);
    
    return array;
}


+(NSMutableArray *)getNT_AvgFactoryZXTimeBySql:(NSString *)sql1
{
    
    
    sqlite3_stmt *statement;
    NSString *sql=[NSString  stringWithFormat:@" select     ifnull(Pavg.avgZG,0) as avgZG,ifnull(Favg.avgXG,0)as avgXG,ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME from  ( select '卸港' as UseType,FACTORYNAME,TradeMonth,round(sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG  from (sELECT  vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME, ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round( round(   round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay, vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where 1=1  and vbshiptrans.ISCAL=1  And  strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000' And   strftime('%%Y',vbshiptrans.F_ANCHORAGETIME)!='2000'  and       %@  )  as  a    group by FACTORYNAME,TradeMonth    ) as Favg  LEFT OUTER  JOIN (                                                                                                                                        select '装港' as UseType,FACTORYNAME,TradeMonth, round( sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2 ) as avgZG  from ( sELECT   vbshiptrans.FACTORYNAME,(CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100))) as TradeMonth, round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1 And strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'  And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and   %@   )  as   a  group by FACTORYNAME,TradeMonth  )as Pavg  on Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth       union     select    ifnull(   Pavg.avgZG,0) as avgZG,ifnull(  Favg.avgXG    ,0)as avgXG,   ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,  ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME  from (   select '装港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgZG   from (   sELECT   vbshiptrans.FACTORYNAME, (CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth,   round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0 ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1  And    strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'	 And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and  %@                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           )  as   a  group by FACTORYNAME,TradeMonth  )AS Pavg  LEFT OUTER  JOIN  (    select '卸港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG   from ( sELECT    vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME,   (  CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round(  round(  round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay,vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE  where 1=1  and     vbshiptrans.ISCAL=1   And   strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000'And   strftime('%%Y',vbshiptrans.F_ANCHORAGETIME)!='2000'  and   %@                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              )  as   a  group by FACTORYNAME,TradeMonth      )as Favg   on  Favg.Factoryname=Pavg.Factoryname   AND  Favg.TradeMonth=Pavg.TradeMonth  order by  TradeMonth",sql1,sql1,sql1,sql1];
    
    
    
    NSLog(@"执行 NT_AvgFactoryZXTime [%@]",sql);
    
    NSMutableArray  *array=[[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            AvgFactoryZXTime *AVGf=[[AvgFactoryZXTime alloc] init];
            
            char *rowdata1=(char *)sqlite3_column_text(statement, 0);
            if (rowdata1==NULL)
                AVGf.avgZG=nil;
            else
                AVGf.avgZG=[NSString stringWithUTF8String:rowdata1];
            
            char *rowdata2=(char *)sqlite3_column_text(statement,1);
            if (rowdata2==NULL)
                AVGf.avgXG=nil;
            else
                AVGf.avgXG=[NSString stringWithUTF8String:rowdata2];
            
            char *rowdata3=(char *)sqlite3_column_text(statement,2);
            if (rowdata3==NULL)
                AVGf.avgLT=nil;
            else
                AVGf.avgLT=[NSString stringWithUTF8String:rowdata3];
            
            
            
            char *rowdata4=(char *)sqlite3_column_text(statement,3);
            if (rowdata4==NULL)
                AVGf.TradeMonth=nil;
            else
                AVGf.TradeMonth=[NSString stringWithUTF8String:rowdata4];
            
            
            char *rowdata5=(char *)sqlite3_column_text(statement,4);
            if (rowdata5==NULL)
                AVGf.FactoryName=nil;
            else
                AVGf.FactoryName=[NSString stringWithUTF8String:rowdata5];
            
            [array addObject:AVGf];
            [AVGf release];
            
        }
    }else {
        NSLog(@"getNT_AvgFactoryZXTime--- Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
    }
    [array  autorelease ];
    return array;
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








































+(NSMutableArray *)getTimeTitle:(NSString *)startTime :(NSString *)endTime {
    
    
    NSString *query1=[NSString stringWithFormat:@" 1=1 "];
    
    if (![startTime isEqualToString:All_]) {
        
        
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth>='%@'  " ,startTime];
    }
    if (![endTime isEqualToString:All_]) {
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth<='%@'  " ,endTime];
        
    }
    NSMutableArray *array=[AvgFactoryZXTimeDao getTimeTitleBySql:query1];
    NSLog(@"执行 getTimeTitleBySql: 数量[%d]",[array count]);
    return array;
}

+(NSMutableArray *)getTimeTitleBySql:(NSString *)sql1{
    NSMutableArray *d=[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    /* select  ifnull(Pavg.avgZG,0) as avgZG,ifnull(Favg.avgXG,0)as avgXG,ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME from ( select '卸港' as UseType,FACTORYNAME,TradeMonth,round(sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG  from (sELECT  vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME, ( CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round( round(   round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay, vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where 1=1  and vbshiptrans.ISCAL=1  And  strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000' And   strftime('%%Y',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@ )  as  a    group by FACTORYNAME,TradeMonth    ) as Favg  LEFT OUTER  JOIN (  select '装港' as UseType,FACTORYNAME,TradeMonth, round( sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2 ) as avgZG  from ( sELECT   vbshiptrans.FACTORYNAME,(CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100))) as TradeMonth, round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1 And strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'  And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and  %@ )  as   a  group by FACTORYNAME,TradeMonth  )as Pavg  on Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth       union     select    ifnull(   Pavg.avgZG,0) as avgZG,ifnull(  Favg.avgXG    ,0)as avgXG,   ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,  ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME  from (   select '装港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgZG   from (   sELECT   vbshiptrans.FACTORYNAME, (CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth,   round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0 ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1  And    strftime('%%Y',vbshiptrans.P_DEPARTTIME) != '2000'	 And strftime('%%Y',vbshiptrans.P_ANCHORAGETIME) != '2000'	and %@ )  as   a  group by FACTORYNAME,TradeMonth  )AS Pavg  LEFT OUTER  JOIN  (    select '卸港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG   from ( sELECT    vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME,   (  CAST(strftime('%%Y',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round(  round(  round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay,vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE  where 1=1  and     vbshiptrans.ISCAL=1   And   strftime('%%Y',vbshiptrans.F_FINISHTIME)!='2000'And   strftime('%%m',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@   )  as   a  group by FACTORYNAME,TradeMonth      )as Favg   on      Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth  order by  avgLT */
    
    NSString *sql= [NSString   stringWithFormat:@"SELECT   AvgT.TradeMonth  FROM (NT_AvgFactoryZXTime )  AS AvgT   where  %@   group  by  AvgT.TradeMonth",sql1];
    
    NSLog(@"执行 getTimeTitleBySql [%@]",sql);
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
    NSLog(@"--------------查到时间标题：【%d】",[d count]);
    return d;
}


+(NSMutableArray *)getFactoryName:(NSString *)startTime :(NSString *)endTime {
    
    NSString *query1=[NSString stringWithFormat:@" 1=1 "];
    if (![startTime isEqualToString:All_]) {
        
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth>='%@'  " ,startTime];
    }
    if (![endTime isEqualToString:All_]) {
        
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth<='%@'  " ,endTime];
        
    }  
    NSMutableArray *array=[AvgFactoryZXTimeDao getFactoryNameBySql:query1];
    NSLog(@"执行 getFactoryNameBySql: 数量[%d]",[array count]);
    return array;
}


+(NSMutableArray *)getFactoryNameBySql:(NSString *)sql1
{
    NSMutableArray *d=[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    /* select  ifnull(Pavg.avgZG,0) as avgZG,ifnull(Favg.avgXG,0)as avgXG,ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME from ( select '卸港' as UseType,FACTORYNAME,TradeMonth,round(sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG  from (sELECT  vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME, ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round( round(   round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay, vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where 1=1  and vbshiptrans.ISCAL=1  And  strftime('%@',vbshiptrans.F_FINISHTIME)!='2000' And   strftime('%@',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@ )  as  a    group by FACTORYNAME,TradeMonth    ) as Favg  LEFT OUTER  JOIN (  select '装港' as UseType,FACTORYNAME,TradeMonth, round( sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2 ) as avgZG  from ( sELECT   vbshiptrans.FACTORYNAME,(CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) as TradeMonth, round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1 And strftime('%@',vbshiptrans.P_DEPARTTIME) != '2000'  And strftime('%@',vbshiptrans.P_ANCHORAGETIME) != '2000'	and  %@ )  as   a  group by FACTORYNAME,TradeMonth  )as Pavg  on Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth       union     select    ifnull(   Pavg.avgZG,0) as avgZG,ifnull(  Favg.avgXG    ,0)as avgXG,   ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,  ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME  from (   select '装港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgZG   from (   sELECT   vbshiptrans.FACTORYNAME, (CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth,   round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0 ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1  And    strftime('%@',vbshiptrans.P_DEPARTTIME) != '2000'	 And strftime('%@',vbshiptrans.P_ANCHORAGETIME) != '2000'	and %@ )  as   a  group by FACTORYNAME,TradeMonth  )AS Pavg  LEFT OUTER  JOIN  (    select '卸港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG   from ( sELECT    vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME,   (  CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round(  round(  round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay,vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE  where 1=1  and     vbshiptrans.ISCAL=1   And   strftime('%@',vbshiptrans.F_FINISHTIME)!='2000'And   strftime('%@',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@   )  as   a  group by FACTORYNAME,TradeMonth      )as Favg   on      Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth  order by  avgLT */
    
    NSString *sql= [NSString   stringWithFormat:@"SELECT  AvgT.Factoryname  FROM ( NT_AvgFactoryZXTime  )  AS AvgT   where   %@  group  by  AvgT.Factoryname ",sql1];
    
    
    NSLog(@"执行 getFactoryNameBySql [%@]",sql);
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
    NSLog(@"------查到电厂名：【%d】",[d count]);
    return d;
}


+(NSMutableDictionary *)getFactoryDate:(NSString *)startTime :(NSString *)endTime :(NSString *)factoryName
{
    NSString *query1=[NSString stringWithFormat:@" 1=1 "];
    if (![startTime isEqualToString:All_]) {
        
        
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth>='%@'  " ,startTime];
    }
    if (![endTime isEqualToString:All_]) {
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.TradeMonth<='%@'  " ,endTime];
    }
    
    if(factoryName){
        query1=[query1 stringByAppendingFormat:@"  AND  AvgT.Factoryname='%@'  " ,factoryName];
    }
    NSMutableDictionary *array=[AvgFactoryZXTimeDao getFactoryDateBySql:query1];
  NSLog(@"执行 getFactoryDateBySql: 数量[%d]",[array count]);
    return array;
}

+(NSMutableDictionary *)getFactoryDateBySql:(NSString *)sql1
{
    NSMutableDictionary *b=[[NSMutableDictionary   alloc] init ];
    sqlite3_stmt *statement;
    /* select  ifnull(Pavg.avgZG,0) as avgZG,ifnull(Favg.avgXG,0)as avgXG,ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME from ( select '卸港' as UseType,FACTORYNAME,TradeMonth,round(sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG  from (sELECT  vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME, ( CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round( round(   round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay, vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where 1=1  and vbshiptrans.ISCAL=1  And  strftime('%@',vbshiptrans.F_FINISHTIME)!='2000' And   strftime('%@',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@ )  as  a    group by FACTORYNAME,TradeMonth    ) as Favg  LEFT OUTER  JOIN (  select '装港' as UseType,FACTORYNAME,TradeMonth, round( sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2 ) as avgZG  from ( sELECT   vbshiptrans.FACTORYNAME,(CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100))) as TradeMonth, round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1 And strftime('%@',vbshiptrans.P_DEPARTTIME) != '2000'  And strftime('%@',vbshiptrans.P_ANCHORAGETIME) != '2000'	and  %@ )  as   a  group by FACTORYNAME,TradeMonth  )as Pavg  on Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth       union     select    ifnull(   Pavg.avgZG,0) as avgZG,ifnull(  Favg.avgXG    ,0)as avgXG,   ifnull(Pavg.avgZG,0) + ifnull(Favg.avgXG,0) as avgLT,ifnull(Pavg.TradeMonth,Favg.TradeMonth) as TradeMonth,  ifnull(Pavg.FACTORYNAME,Favg.FACTORYNAME) as FACTORYNAME  from (   select '装港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgZG   from (   sELECT   vbshiptrans.FACTORYNAME, (CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth,   round(  round(   round(  (julianday(P_DEPARTTIME)  -  julianday(P_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0 ,2  )  as  UseDay,	vbshiptrans.lw as lw  FROM vbshiptrans  Inner  Join   TFFACTORY   On   vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE   where ISCAL=1  And    strftime('%@',vbshiptrans.P_DEPARTTIME) != '2000'	 And strftime('%@',vbshiptrans.P_ANCHORAGETIME) != '2000'	and %@ )  as   a  group by FACTORYNAME,TradeMonth  )AS Pavg  LEFT OUTER  JOIN  (    select '卸港' as UseType,FACTORYNAME,TradeMonth, round(    sum(useday*lw/10000.0)/SUM(lw/10000.0) ,2     ) as avgXG   from ( sELECT    vbshiptrans.FACTORYCODE,    vbshiptrans.FACTORYNAME,   (  CAST(strftime('%@',VbShiptrans.tradetime) AS  VARCHAR(100)) || '-' || CAST(strftime('%@',VbShiptrans.tradetime) AS VARCHAR(100)) ) as TradeMonth, round(  round(  round(  (julianday(F_FINISHTIME)  -  julianday(F_ANCHORAGETIME)  ),2)*24*60 ,2  )/1440.0  ,2  ) as  UseDay,vbshiptrans.lw  as  lw  FROM  vbshiptrans   inner  Join  TFFACTORY    On    vbshiptrans.FACTORYCODE  = TFFACTORY.FACTORYCODE  where 1=1  and     vbshiptrans.ISCAL=1   And   strftime('%@',vbshiptrans.F_FINISHTIME)!='2000'And   strftime('%@',vbshiptrans.F_ANCHORAGETIME)!='2000'  and %@   )  as   a  group by FACTORYNAME,TradeMonth      )as Favg   on      Favg.Factoryname=Pavg.Factoryname    AND  Favg.TradeMonth=Pavg.TradeMonth  order by  avgLT*/
    
    NSString *sql= [NSString   stringWithFormat:@"SELECT  FACTORYNAME, avgXG,avgZG ,avgLT,TradeMonth   FROM( NT_AvgFactoryZXTime  )  AS AvgT     where  %@  order by  AvgT.TradeMonth",sql1];
    NSLog(@"执行 getFactoryDateBySql [%@]",sql);
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
