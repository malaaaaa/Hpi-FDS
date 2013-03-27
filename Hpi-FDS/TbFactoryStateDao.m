//
//  TbFactoryStateDao.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TbFactoryStateDao.h"
#import "TbFactoryState.h"

@implementation TbFactoryStateDao
static sqlite3	*database;

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
		NSLog(@"open TbFactoryState error");
		return;
	}
	NSLog(@"open TbFactoryState database succes ....");
}
+(void) initDb
{	
 
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TbFactoryState  (STID INTEGER PRIMARY KEY ",
                         @",FACTORYCODE TEXT ",
						 @",RECORDDATE DATE ",
                         @",IMPORT INTEGER ",
						 @",EXPORT INTEGER ",
						 @",STORAGE INTEGER ",
						 @",CONSUM INTEGER ",
                         @",AVALIABLE INTEGER ",
                         @",MONTHIMP INTEGER ",
                         @",YEARIMP INTEGER ",
                         @",ELECGENER INTEGER ",
                         @",STORAGE7 INTEGER ",
                         @",TRANSNOTE TEXT ",
                         @",NOTE TEXT ",
                         
                         @",MONTHCONSUM INTEGER ",
                        
						 @",YEARCONSUM INTEGER )"];
    
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TbFactoryState error");
		printf("%s",errorMsg);
		return;
		
	}
    NSString *createIndexSql=@"create INDEX IF NOT EXISTS TbFactoryState_inx1 on TbFactoryState (factorycode asc)  ";
    
	if(sqlite3_exec(database,[createIndexSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create index TbFactoryState_inx1 error");
		printf("%s",errorMsg);
		return;
		
	}

}
/******************电厂靠泊动态 ******************/
//处理时间  //前一天所在月份的第二天  5/2   5/10
+(NSString  *)getTime:(NSDate *)time :(NSString *)s
{
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    //处理时间  //前一天所在月份的第二天  5/2   5/10
    NSDate *time1=[[NSDate alloc] initWithTimeInterval:-(24*60*60) sinceDate:time];
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    
//    if (s==@"M") {
    if ([s isEqualToString:@"M"]){
        [f setDateFormat:@"MM"];
        [comp setMonth:[[f stringFromDate:time1] integerValue]];
        [comp setDay:1];
        [f setDateFormat:@"yyyy"];
        [comp setYear:[[f stringFromDate:time1] integerValue]];
        
    }
//    if (s==@"Y") {
    if ([s isEqualToString:@"Y"]){

        [f setDateFormat:@"yyyy"];
        [comp setYear:[[f stringFromDate:time1] integerValue]];
        [comp setMonth:1];
        [comp setDay:1];
    }
    
    //  时间 会少 8小时
    NSCalendar *myCal = [[NSCalendar alloc ]    initWithCalendarIdentifier:NSGregorianCalendar] ;
    
    
    
    NSDate *myDate1 =     [[NSDate alloc] initWithTimeInterval:(24*60*60+8*60*60) sinceDate:  [myCal dateFromComponents:comp] ]       ;
    
    NSString *d1=[f stringFromDate: myDate1];
    
    
    [f release];
    [comp release];
    [myCal release];
    return  d1;
    
    
}


//电厂月调进量

//GetMonthPort
+(float)GetMonthPort:(NSDate *)time :(NSString *)facN
{
    float a=0;
    
    sqlite3_stmt *statement;
    
    NSString *time1=[self getTime:time:@"M"];
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    NSString *sql=[NSString stringWithFormat: @"SELECT Monthimp  FROM TBFACTORYSTATE  inner join TFFACTORY on TFFACTORY.FACTORYCODE=TBFACTORYSTATE.FACTORYCODE  where recorddate=     (  select max(recorddate)  from TBFACTORYSTATE    inner join TFFACTORY on TFFACTORY.FACTORYCODE=TBFACTORYSTATE.FACTORYCODE   where     (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )>='%@'  and  (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )<='%@'   and TFFACTORY.FACTORYNAME='%@' )  and TFFACTORY.FACTORYNAME='%@'",time1,[ f stringFromDate: time ],facN,facN];
    
    
  //  NSLog(@"GetMonthPort电厂月调进量[%@]",sql );
    
    
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
            
           char *rowDate=(char *)sqlite3_column_text(statement,0);
            if (rowDate==NULL) 
                a=0.0;
            else
            a=  [[NSString stringWithUTF8String: rowDate] doubleValue];
           // NSLog(@"a电厂月调进量[%f] ",a);
        }
        
        
    }
    sqlite3_finalize(statement);

    [f release  ];
    return a;
}


//获取电厂年调进量  GetYearPort
+(float)GetYearPort:(NSDate *)time :(NSString *)facN{
    float a=0;
    
    sqlite3_stmt *statement;
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    NSString *time1=[self getTime:time:@"Y"];
    
    
    
    NSString *sql=[NSString stringWithFormat: @"SELECT YEARIMP  FROM TBFACTORYSTATE  inner join TFFACTORY on TFFACTORY.FACTORYCODE=TBFACTORYSTATE.FACTORYCODE  where recorddate=     (  select max(recorddate)  from TBFACTORYSTATE    inner join TFFACTORY on TFFACTORY.FACTORYCODE=TBFACTORYSTATE.FACTORYCODE   where     (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )>='%@'  and  (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )<='%@'   and TFFACTORY.FACTORYNAME='%@' )  and TFFACTORY.FACTORYNAME='%@'",time1,[ f stringFromDate: time ],facN,facN];
    
    //NSLog(@"-------GetYearPort获取电厂年调进量[%@]",sql);
    
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
            
            char *rowDate=(char *)sqlite3_column_text(statement,0);
            if (rowDate==NULL)
                a=0.0;
            else
                a=  [[NSString stringWithUTF8String: rowDate] doubleValue];

           // NSLog(@"a电厂年调进量[%f] ",a);
        }
    }
    sqlite3_finalize(statement);

    [f release  ];
    return a;
    
}


// 获取当月最近日期的月累计耗煤量,包含今日  GetMonthConsum
+(float)GetMonthConsum:(NSDate *)time :(NSString *)facN
{
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    float a=0;
    NSString  *time1=[self getTime:time:@"M"];

    
    sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat: @"SELECT MonthConsum  FROM TBFACTORYSTATE  inner join TFFACTORY on TFFACTORY.FACTORYCODE=TBFACTORYSTATE.FACTORYCODE  where recorddate=     (  select max(recorddate)  from TBFACTORYSTATE    inner join TFFACTORY on TFFACTORY.FACTORYCODE=TBFACTORYSTATE.FACTORYCODE   where     (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )>='%@'  and  (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )<='%@'   and TFFACTORY.FACTORYNAME='%@' )  and TFFACTORY.FACTORYNAME='%@'",time1,[ f stringFromDate: time ],facN,facN];
    
    
   // NSLog(@"获取当月最近日期的月累计耗煤量,包含今日 GetMonthConsum [%@]", sql );
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
            
            char *rowDate=(char *)sqlite3_column_text(statement,0);
            if (rowDate==NULL)
                a=0.0;
            else
                a=  [[NSString stringWithUTF8String: rowDate] doubleValue];

          //  NSLog(@"a获取当月最近日期的月累计耗煤量,包含今日[%f] ",a);
        }
    }
    sqlite3_finalize(statement);
     
    [f release];
    return a;
    
    
    
    
}

//  年累计耗用量  GetYearConsum
+(float)GetYearConsum:(NSDate *)time :(NSString *)facN
{
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    float a=0;
    NSString  *time1=[self getTime:time:@"Y"];
  
    sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat: @"SELECT YearConsum  FROM TBFACTORYSTATE  inner join TFFACTORY on TFFACTORY.FACTORYCODE=TBFACTORYSTATE.FACTORYCODE  where recorddate=     (  select max(recorddate)  from TBFACTORYSTATE    inner join TFFACTORY on TFFACTORY.FACTORYCODE=TBFACTORYSTATE.FACTORYCODE   where     (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )>='%@'  and  (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )<='%@'   and TFFACTORY.FACTORYNAME='%@' )  and TFFACTORY.FACTORYNAME='%@'",time1,[ f stringFromDate: time ],facN,facN];
   // NSLog(@"年累计耗用量  GetYearConsum [%@]", sql );
    
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
            
            char *rowDate=(char *)sqlite3_column_text(statement,0);
            if (rowDate==NULL)
                a=0.0;
            else
                a=  [[NSString stringWithUTF8String: rowDate] doubleValue];

           // NSLog(@"年累计耗用量  GetYearConsum [%f] ",a);
        }
    }
    sqlite3_finalize(statement);
  
    [f release];
    return a;
}

// 获得  factoryState 实体  根据电厂名 和时间
+(TbFactoryState *)getStateBySql:(NSString *)facN :(NSDate *)time
{
    TbFactoryState * tbFactoryState=[[[TbFactoryState   alloc] init] autorelease];
    
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    
    
    sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"select   STID,TBFACTORYSTATE.FACTORYCODE,RECORDDATE,IMPORT,EXPORT,STORAGE,CONSUM,AVALIABLE,  monthimp,YEARIMP,ELECGENER,STORAGE7,TRANSNOTE,NOTE, MONTHCONSUM,YEARCONSUM from TBFACTORYSTATE  inner join  TFFACTORY on TFFACTORY.FACTORYCODE=TBFACTORYSTATE.FACTORYCODE  where TFFACTORY. FACTORYNAME='%@'  AND    (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )>='%@'   AND    (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )<='%@'   ",facN,[  f stringFromDate:  time ],[  f stringFromDate:  time ]];
    
    
   // NSLog(@"执行 getStateBySql [%@] ",sql);
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        while (sqlite3_step(statement)==SQLITE_ROW) {

            tbFactoryState.STID = sqlite3_column_int(statement,0);
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tbFactoryState.FACTORYCODE = @"";
            else
                tbFactoryState.FACTORYCODE = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tbFactoryState.RECORDDATE = @"";
            else
                tbFactoryState.RECORDDATE = [NSString stringWithUTF8String: rowData2];
            
            tbFactoryState.IMPORT = sqlite3_column_int(statement,3);
            tbFactoryState.EXPORT = sqlite3_column_int(statement,4);
            tbFactoryState.STORAGE = sqlite3_column_int(statement,5);
            tbFactoryState.CONSUM = sqlite3_column_int(statement,6);
            tbFactoryState.AVALIABLE = sqlite3_column_int(statement,7);
            tbFactoryState.MONTHIMP = sqlite3_column_int(statement,8);
            tbFactoryState.YEARIMP = sqlite3_column_int(statement,9);
            
            tbFactoryState.ELECGENER = sqlite3_column_int(statement,10);
            
            
            tbFactoryState.STORAGE7 = sqlite3_column_int(statement,11);
            
            
            char * rowData11=(char *)sqlite3_column_text(statement,12);
            if (rowData11 == NULL)
                tbFactoryState.TRANSNOTE = @"";
            else
                tbFactoryState.TRANSNOTE = [NSString stringWithUTF8String: rowData11];
            
            char * rowData12=(char *)sqlite3_column_text(statement,13);
            if (rowData12 == NULL)
                tbFactoryState.NOTE = @"";
            else
                tbFactoryState.NOTE = [NSString stringWithUTF8String: rowData12];
            
            tbFactoryState.MONTHCONSUM  = sqlite3_column_int(statement,14);
            tbFactoryState.YEARCONSUM = sqlite3_column_int(statement,15);
            
        }

    }else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        
	}
    sqlite3_finalize(statement);

    
    
    [f release];
    return tbFactoryState;
    
}
+(TbFactoryState *)getStateMode:(NSString *)factoryName :(NSString *)time
{
    
    TbFactoryState *tbFactoryState=[[[TbFactoryState alloc] init] autorelease]; 
     sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"select   STID,TBFACTORYSTATE.FACTORYCODE,RECORDDATE,IMPORT,EXPORT,STORAGE,CONSUM,AVALIABLE,  monthimp,YEARIMP,ELECGENER,STORAGE7,TRANSNOTE,NOTE, MONTHCONSUM,YEARCONSUM from TBFACTORYSTATE  inner join  TFFACTORY on TFFACTORY.FACTORYCODE=TBFACTORYSTATE.FACTORYCODE  where TFFACTORY. FACTORYNAME='%@'  AND    (          CAST(strftime('%%Y',TBFACTORYSTATE.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TBFACTORYSTATE.RECORDDATE) AS VARCHAR(100))      )='%@'",factoryName,time];
    
    
    // NSLog(@"执行 getStateMode [%@] ",sql);
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
            tbFactoryState.STID = sqlite3_column_int(statement,0);
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tbFactoryState.FACTORYCODE = nil;
            else
                tbFactoryState.FACTORYCODE = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tbFactoryState.RECORDDATE = nil;
            else
                tbFactoryState.RECORDDATE = [NSString stringWithUTF8String: rowData2];
            
            tbFactoryState.IMPORT = sqlite3_column_int(statement,3);
            tbFactoryState.EXPORT = sqlite3_column_int(statement,4);
            tbFactoryState.STORAGE = sqlite3_column_int(statement,5);
            tbFactoryState.CONSUM = sqlite3_column_int(statement,6);
            tbFactoryState.AVALIABLE = sqlite3_column_int(statement,7);
            tbFactoryState.MONTHIMP = sqlite3_column_int(statement,8);
            tbFactoryState.YEARIMP = sqlite3_column_int(statement,9);
            tbFactoryState.ELECGENER = sqlite3_column_int(statement,10);
            tbFactoryState.STORAGE7 = sqlite3_column_int(statement,11);
            char * rowData11=(char *)sqlite3_column_text(statement,12);
            if (rowData11 == NULL)
                tbFactoryState.TRANSNOTE = nil;
            else
                tbFactoryState.TRANSNOTE = [NSString stringWithUTF8String: rowData11];
            
            char * rowData12=(char *)sqlite3_column_text(statement,13);
            if (rowData12 == NULL)
                tbFactoryState.NOTE = @"";
            else
                tbFactoryState.NOTE = [NSString stringWithUTF8String: rowData12];
            
            tbFactoryState.MONTHCONSUM  = sqlite3_column_int(statement,14);
            tbFactoryState.YEARCONSUM = sqlite3_column_int(statement,15);
            
        }
        sqlite3_finalize(statement);
    }else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        
	}

    return   tbFactoryState ;
}



/******************电厂靠泊动态 ******************/
+(void)insert:(TbFactoryState*) tbFactoryState
{
//	NSLog(@"Insert begin TbFactoryState");
	const char *insert="INSERT INTO TbFactoryState (STID, FACTORYCODE, RECORDDATE, IMPORT, EXPORT, STORAGE, CONSUM, AVALIABLE, MONTHIMP, YEARIMP, ELECGENER, STORAGE7, TRANSNOTE, NOTE,MONTHCONSUM,YEARCONSUM) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }

    
    sqlite3_bind_int(statement, 1, tbFactoryState.STID);
	sqlite3_bind_text(statement, 2,[tbFactoryState.FACTORYCODE UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 3, [tbFactoryState.RECORDDATE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 4, tbFactoryState.IMPORT);
    sqlite3_bind_int(statement, 5, tbFactoryState.EXPORT);
    sqlite3_bind_int(statement, 6, tbFactoryState.STORAGE);
    sqlite3_bind_int(statement, 7, tbFactoryState.CONSUM);
    sqlite3_bind_int(statement, 8, tbFactoryState.AVALIABLE);
    sqlite3_bind_int(statement, 9, tbFactoryState.MONTHIMP);
    sqlite3_bind_int(statement, 10, tbFactoryState.YEARIMP);
    sqlite3_bind_int(statement, 11, tbFactoryState.ELECGENER);
    sqlite3_bind_int(statement, 12, tbFactoryState.STORAGE7);
    sqlite3_bind_text(statement, 13,[tbFactoryState.TRANSNOTE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 14,[tbFactoryState.NOTE UTF8String], -1, SQLITE_TRANSIENT);
    
    
    sqlite3_bind_int(statement, 15, tbFactoryState.MONTHCONSUM);
    sqlite3_bind_int(statement, 16, tbFactoryState.YEARCONSUM);

  	re = sqlite3_step(statement);
	if(re!=SQLITE_DONE)
    {
		NSLog( @"Error: insert tbFactoryState error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
    }
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TbFactoryState*) tbFactoryState
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  tbFactoryState where STID =%d ",tbFactoryState.STID];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete tbFactoryState error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}
+(void) deleteAll
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  tbFactoryState "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete tbFactoryState error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}

+(NSMutableArray *) getTbFactoryState:(NSString *)factoryCode
{
	NSString *query=[NSString stringWithFormat:@" factoryCode = '%@' ",factoryCode];
	NSMutableArray * array=[TbFactoryStateDao getTbFactoryStateBySql:query];
	return array;
}


+(NSMutableArray *) getTbFactoryStateBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT STID, FACTORYCODE, RECORDDATE, IMPORT, EXPORT, STORAGE, CONSUM, AVALIABLE, MONTHIMP, YEARIMP, ELECGENER, STORAGE7, TRANSNOTE, NOTE, MONTHCONSUM,YEARCONSUM  FROM  tbFactoryState WHERE %@ ",sql1];
  // NSLog(@"执行 getTbFactoryStateBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TbFactoryState *tbFactoryState=[[TbFactoryState alloc] init];
            
            tbFactoryState.STID = sqlite3_column_int(statement,0);

			char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tbFactoryState.FACTORYCODE = nil;
            else
                tbFactoryState.FACTORYCODE = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tbFactoryState.RECORDDATE = nil;
            else
                tbFactoryState.RECORDDATE = [NSString stringWithUTF8String: rowData2];
            
            tbFactoryState.IMPORT = sqlite3_column_int(statement,3);
            tbFactoryState.EXPORT = sqlite3_column_int(statement,4);
            tbFactoryState.STORAGE = sqlite3_column_int(statement,5);
            tbFactoryState.CONSUM = sqlite3_column_int(statement,6);
            tbFactoryState.AVALIABLE = sqlite3_column_int(statement,7);
            tbFactoryState.MONTHIMP = sqlite3_column_int(statement,8);
            tbFactoryState.YEARIMP = sqlite3_column_int(statement,9);
            
            tbFactoryState.ELECGENER = sqlite3_column_int(statement,10);

            
            tbFactoryState.STORAGE7 = sqlite3_column_int(statement,11);

            
            char * rowData11=(char *)sqlite3_column_text(statement,12);
            if (rowData11 == NULL)
                tbFactoryState.TRANSNOTE = nil;
            else
                tbFactoryState.TRANSNOTE = [NSString stringWithUTF8String: rowData11];
            
            char * rowData12=(char *)sqlite3_column_text(statement,13);
            if (rowData12 == NULL)
                tbFactoryState.NOTE = @"";
            else
                tbFactoryState.NOTE = [NSString stringWithUTF8String: rowData12];
            
            
            tbFactoryState.MONTHCONSUM  = sqlite3_column_int(statement,14);
            tbFactoryState.YEARCONSUM = sqlite3_column_int(statement,15);
            
			[array addObject:tbFactoryState];
            [tbFactoryState release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        
	}
    sqlite3_finalize(statement);
    sqlite3_close(database);
	//zhangcx add
	[array autorelease];
	return array;
}
@end
