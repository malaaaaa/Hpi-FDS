//
//  NT_LatefeeTongjDao.m
//  Hpi-FDS
//
//  Created by bin tang on 12-8-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NT_LatefeeTongjDao.h"
#import "NT_LatefeeTongj.h"
#import "PubInfo.h"

@implementation NT_LatefeeTongjDao
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







//的到电厂

+(NSMutableArray *)getFactoryName:(NSString *)sql1
{
    
    NSMutableArray *d=[[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *statement;
    NSString *sql=  [NSString   stringWithFormat:@"select TfFactory.CATEGORY ,  TB_Latefee.factoryname from  TB_Latefee   left  join TfFactory  on  TB_Latefee.factorycode=TfFactory.factorycode      where TB_Latefee .iscal=1 AND %@ group by  TB_Latefee.factoryname",sql1];
    
    
    
    //  @"select TfFactory.CATEGORY ,      TB_Latefee.factoryname ,cast(SUM(latefee)/10000 as decimal(20,2)) as MONTHLATEFEE,strftime('%m',tradetime)  as MonthM from TB_Latefee     left  join TfFactory  on  TB_Latefee.factorycode=TfFactory.factorycode               where TB_Latefee.iscal=1 group   by TB_Latefee.factoryname, strftime('%m',tradetime) ,TfFactory.CATEGORY     order by  MonthM ASC";
 
    
    
    
    
    NSLog(@"执行 getFactoryName [%@]",sql);
    if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        while ( sqlite3_step(statement)==SQLITE_ROW) {
            NSString *factoryName;
            char *date1=(char *)sqlite3_column_text(statement, 1);
            if (date1==NULL)
                factoryName=nil;
           else 
               factoryName=[NSString stringWithUTF8String:date1];
            
            [d addObject:factoryName];
            
        }
       
    }
        return d;
}
+(NSMutableArray *)getFactoryName:(NSString *)cate:(NSString *)startTime:(NSString *)endTime{
  
 NSString *query=[NSString stringWithFormat:@" 1=1 "];

    if (![cate isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TfFactory.CATEGORY='%@' ",cate ];
    }
    
    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TB_Latefee.TRADETIME>='%@' ",startTime ];
    }
    if (![endTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TB_Latefee.TRADETIME<='%@' ",endTime ];
    }

    NSMutableArray *a=[self getFactoryName:query];
    NSLog(@"根据电厂类别时间等条件  得到电厂【%d】",[a count]);
    return a;

}






	




//根据 电厂名  获得 滞期费和月份

+(NSMutableDictionary *)getMonthAndLatefee:(NSString *)sql1
{

 NSMutableDictionary *a=[[[NSMutableDictionary    alloc] init] autorelease];
    sqlite3_stmt *statement;
    NSString *sql= [NSString stringWithFormat:@"select TfFactory.CATEGORY , round(SUM(latefee)/10000 ,2) as MONTHLATEFEE,cast(strftime('%@',tradetime)  as int)  as MonthM from TB_Latefee  left  join TfFactory  on  TB_Latefee.factorycode=TfFactory.factorycode   where TB_Latefee.iscal=1 AND %@  group by  TB_Latefee.factoryname,cast(strftime('%@',tradetime)  as int)  order by MonthM ASC",@"%m",sql1,@"%m"] ;
    
    
      NSLog(@"getMonthAndLatefee[%@]",sql );
       

    if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW ) {
            NSString *Latefee;
            NSString *month;
            char *date1=(char *)sqlite3_column_text(statement, 1);
            if (date1==NULL)
                Latefee=nil;
            else 
                Latefee=[NSString stringWithUTF8String:date1];
            
            char *date2=(char *)sqlite3_column_text(statement, 2);
            if (date2==NULL)
                month=nil;
            else 
                month=[NSString stringWithUTF8String:date2];
        
            
            
            NSLog(@"latefee:[%@]-----month:[%@]",Latefee,month);
            
            [a setObject:Latefee forKey:month];
           
            
        }
    }
    return a;
}
//根据 电厂名  获得 滞期费和月份
+(NSMutableDictionary *)getMonthAndLatefee:(NSString *)cate:(NSString *)factoryName :(NSString *)startTime:(NSString *)endTime 
{
     NSString *query=[NSString stringWithFormat:@" 1=1 "]; 
    if ([cate isEqualToString:@"cate"]&&![factoryName isEqualToString:All_]) {
         query=[query stringByAppendingFormat:@" AND TfFactory.CATEGORY='%@'  ",factoryName];
    }
    
    
    if ( [cate isEqualToString:@"factory"]&&![factoryName isEqualToString:All_]) {
      query=[query stringByAppendingFormat:@"  AND TB_Latefee.FACTORYNAME='%@' ",factoryName];
    }
    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TB_Latefee.TRADETIME>='%@' ",startTime ];
    }
    if (![endTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TB_Latefee.TRADETIME<='%@' ",endTime ];
    }
    NSMutableDictionary *a=[self getMonthAndLatefee:query];
   
  
    
    return a;
}

+(NSMutableArray *)getNT_LatefeeTongj:(NSString *)factoryCate :(NSString *)startTime :(NSString *)endTime{
    
    
    NSString *query=[NSString stringWithFormat:@" 1=1 "];
    
    
    if (![factoryCate isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TfFactory.CATEGORY='%@' ",factoryCate ];
    }
    
    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TB_Latefee.TRADETIME>='%@'  ",startTime ];
    }
    if (![endTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND TB_Latefee.TRADETIME<='%@' ",endTime ];
    }
    
    
    
    NSMutableArray *array=[self getNT_LatefeeTongjBySql:query];
    NSLog(@"执行 getNT_LatefeeTongj: 数量[%d]",[array count]);
    
    return array;
}
+(NSMutableArray *)getNT_LatefeeTongj{
    NSString *query=@" 1=1 ";
    NSMutableArray *array=[NT_LatefeeTongjDao getNT_LatefeeTongjBySql:query];
    return  array;
    
    
    
}
+(NSMutableArray *)getNT_LatefeeTongjBySql:(NSString *)sql1
{
    
    NSMutableArray  *array=[[NSMutableArray alloc] init];
 
    /*select    factoryname ,
     sum( CASE  WHEN   MonthM=3  THEN  MONTHLATEFEE    ELSE   0  END  )AS '3',
     sum( CASE  WHEN   MonthM=5  THEN  MONTHLATEFEE    ELSE   0   END  )AS '5',
     sum( CASE  WHEN   MonthM=7  THEN  MONTHLATEFEE    ELSE   0   END  )AS '7',
     total(  MONTHLATEFEE ) AS 'Total'
     from(
     select TfFactory.CATEGORY ,TB_Latefee.factoryname ,round(SUM(latefee)/10000 ,2)  as MONTHLATEFEE,cast(strftime('%m',tradetime)  as int)  as MonthM from TB_Latefee left  join TfFactory on TB_Latefee.factorycode=TfFactory.factorycode  where TB_Latefee.iscal=1 and  1=1   AND TB_Latefee.TRADETIME>='2012-01-01'    AND TB_Latefee.TRADETIME<='2012-08-20'    group   by TB_Latefee.factoryname, cast(strftime('%m',tradetime)  as int) ,TfFactory.CATEGORY  order by  MonthM ASC
     )as LT */
    
    
    
    
    
    
    
    
sqlite3_stmt *statement;
    NSString *sql=[NSString  stringWithFormat:@"select TfFactory.CATEGORY ,TB_Latefee.factoryname ,round(SUM(latefee)/10000 ,2)  as MONTHLATEFEE,cast(strftime('%@',tradetime)  as int)  as MonthM from TB_Latefee left  join TfFactory on TB_Latefee.factorycode=TfFactory.factorycode  where TB_Latefee.iscal=1 and %@   group   by TB_Latefee.factoryname, cast(strftime('%@',tradetime)  as int) ,TfFactory.CATEGORY  order by  MonthM ASC",@"%m",sql1,@"%m"];
    
    

NSLog(@"执行 getNT_LatefeeTongjBySql-----------%@",sql);
    
    NSLog(@"SQLITE_OK[%d]",SQLITE_OK);
    NSLog(@"sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)[%d]",sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL));
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            NT_LatefeeTongj *latefeetj=[[NT_LatefeeTongj alloc] init];
            
            char *rowdata1=(char *)sqlite3_column_text(statement, 0);
            if (rowdata1==NULL) 
                latefeetj.CATEGORY=nil;
            else 
                latefeetj.CATEGORY=[NSString stringWithUTF8String:rowdata1];
            
            char *rowdata2=(char *)sqlite3_column_text(statement, 1);
            if (rowdata2==NULL) 
                latefeetj.FACTORYNAME=nil;
            else 
                latefeetj.FACTORYNAME=[NSString stringWithUTF8String:rowdata2];
        
            char *rowdata3=(char *)sqlite3_column_text(statement, 2);
            if (rowdata3==NULL) 
                latefeetj.MONTHLATEFEE=nil;
            else 
                latefeetj.MONTHLATEFEE=[NSString stringWithUTF8String:rowdata3];
            
            
            
            NSLog(@"-------%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]);
            
            
            latefeetj.MonthM=sqlite3_column_int(statement, 3);

            [array addObject:latefeetj];
            
            [latefeetj release];
            
        
        
        }
    }else {
        NSLog(@"编译错误");
        NSLog(@"getNT_LatefeeTongjBySql --- Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
        
        
        
    }
    [array autorelease];
return array;
    
 }



@end
