//
//  TH_SHIPTRANS_ORIDAO.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-10-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TH_SHIPTRANS_ORIDAO.h"
#import "TH_SHIPTRANS_ORI.h"
#import "PubInfo.h"

@implementation TH_SHIPTRANS_ORIDAO
static sqlite3  *database;


+(NSString *)dataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString  *documentsDirectory=[paths objectAtIndex:0];
    
    NSString *path=[documentsDirectory  stringByAppendingPathComponent: @"database.db"  ];
    
    
    NSLog(@"TH_SHIPTRANS_ORI=== %@",path);
    return  path;
}

+(void) openDataBase
{
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open  TH_SHIPTRANS_ORI error");
		return;
	}
	NSLog(@"open TH_SHIPTRANS_ORI database succes ....");
}
+(void)initDb
{
    
    NSLog(@"create TH_SHIPTRANS_ORI  。。。。");
    char *errorMsg;
    NSString *createSql=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                         @"CREATE TABLE IF NOT EXISTS TH_SHIPTRANS_ORI ( RECID  INTEGER  PRIMARY KEY " ,
                         @", RECORDDATE TEXT ",
                         @", DISPATCHNO TEXT ",
                         @", SHIPCOMPANYID INTEGER ",
                         @", SHIPCOMPANY TEXT ",
                         @", SHIPID INTEGER ",
                         @", SHIPNAME TEXT ",
                         @", TRIPNO TEXT ",
                         @", FACTORYCODE TEXT ",
                         @", FACTORYNAME TEXT ",
                         @", PORTCODE TEXT ",
                         @", PORTNAME TEXT ",
                         @", SUPID INTEGER ",
                         @", SUPPLIER TEXT ",
                         @", TYPEID INTEGER ",
                         @", COALTYPE TEXT ",
                         @", KEYVALUE TEXT ",
                         @", KEYNAME TEXT ",
                         @", TRADE TEXT ",
                         @", TRADENAME TEXT ",
                         @", STAGE TEXT ",
                         @", STAGENAME TEXT ",
                         @", STATECODE TEXT ",
                         @", STATENAME TEXT ",
                         @", LW INTEGER ",
                         @", HEATVALUE INTEGER ",
                         @", P_ANCHORAGETIME TEXT ",
                         @", P_HANDLE TEXT ",
                         @", P_ARRIVALTIME TEXT ",
                         @", P_DEPARTTIME TEXT ",
                         @", P_NOTE TEXT ",
                         @", T_NOTE TEXT ",
                         @", F_ANCHORAGETIME TEXT ",
                         @", F_ARRIVALTIME TEXT ",
                         @", F_DEPARTTIME TEXT ",
                         @", F_NOTE TEXT ",
                         @", LATEFEE TEXT ",
                         @", OFFEFFICIENCY INTEGER ",
                         @", SCHEDULE TEXT ",
                         @", PLANTYPE TEXT ",
                         @", PLANCODE TEXT ",
                         @", LAYCANSTART TEXT ",
                         @", LAYCANSTOP TEXT ",
                         @", RECIEPT TEXT ",
                         @", SHIPSHIFT TEXT ",
                         @", F_FINISH TEXT)"];
    
    
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        sqlite3_close(database);
        NSLog(@"create table Th_ShipTrans error");
        printf("%s",errorMsg);
        return;
        
    }else {
        NSLog(@"create table Th_ShipTrans seccess");
    }
}



+(void)delete:(TH_SHIPTRANS_ORI *)th_Shiptrans
{
    //    NSLog(@"删除实体........");
    
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TH_SHIPTRANS_ORI where recid  =%d ", th_Shiptrans.RECID ];
    
    
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        NSLog(@"Error: delete TH_SHIPTRANS_ORI error with message [%s]  sql[%@]", errorMsg,deletesql);
        
    }else {
        NSLog(@"delete success")  ;
    }
    return;
    
}
+(void)deleteAll
{
    // NSLog(@"删除实体........");
    
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TH_SHIPTRANS_ORI  "];
    
    
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        NSLog(@"Error: delete TH_SHIPTRANS_ORI error with message [%s]  sql[%@]", errorMsg,deletesql);
        
    }else {
        //NSLog(@"delete success")  ;
    }
    return;
    
}


+(NSMutableArray *)getTH_ShipTransBySql:(NSString *)sql1
{
    sqlite3_stmt *statement;
    NSString *sql=[NSString  stringWithFormat:@"SELECT RECID, RECORDDATE, DISPATCHNO, SHIPCOMPANYID, SHIPCOMPANY, SHIPID, SHIPNAME, TRIPNO, FACTORYCODE, FACTORYNAME, PORTCODE, PORTNAME, SUPID, SUPPLIER, TYPEID, COALTYPE, KEYVALUE, KEYNAME, TRADE, TRADENAME, STAGE, STAGENAME, STATECODE, STATENAME, LW, HEATVALUE, P_ANCHORAGETIME, P_HANDLE, P_ARRIVALTIME, P_DEPARTTIME, P_NOTE, T_NOTE, F_ANCHORAGETIME, F_ARRIVALTIME, F_DEPARTTIME, F_NOTE, LATEFEE, OFFEFFICIENCY, SCHEDULE, PLANTYPE, PLANCODE, LAYCANSTART, LAYCANSTOP,RECIEPT,SHIPSHIFT,F_FINISH  FROM  TH_SHIPTRANS_ORI WHERE %@",sql1];
    
    
    NSLog(@"执行 getTH_ShipTransBySql [%@]",sql);
    NSMutableArray  *array=[[[NSMutableArray alloc] init] autorelease];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
            TH_SHIPTRANS_ORI *thShiptrans=[[TH_SHIPTRANS_ORI alloc] init];
            
            thShiptrans .RECID= sqlite3_column_int(statement, 0);
            
            char *rowdata1=(char *)sqlite3_column_text(statement, 1);
            if (rowdata1==NULL)
                thShiptrans.RECORDDATE=nil;
            else
                thShiptrans.RECORDDATE=[NSString stringWithUTF8String:rowdata1];
            
            char *rowdata2=(char *)sqlite3_column_text(statement, 2);
            if (rowdata2==NULL)
                thShiptrans.DISPATCHNO=nil;
            else
                thShiptrans.DISPATCHNO=[NSString stringWithUTF8String:rowdata2];
            
            thShiptrans .SHIPCOMPANYID= sqlite3_column_int(statement, 3);
            
            char *rowdata4=(char *)sqlite3_column_text(statement, 4);
            if (rowdata4==NULL)
                thShiptrans.SHIPCOMPANY=nil;
            else
                thShiptrans.SHIPCOMPANY=[NSString stringWithUTF8String:rowdata4];
            
            thShiptrans .SHIPID= sqlite3_column_int(statement, 5);
            
            char *rowdata6=(char *)sqlite3_column_text(statement, 6);
            if (rowdata6==NULL)
                thShiptrans.SHIPNAME=nil;
            else
                thShiptrans.SHIPNAME=[NSString stringWithUTF8String:rowdata6];
            
            
            char *rowdata7=(char *)sqlite3_column_text(statement, 7);
            if (rowdata7==NULL)
                thShiptrans.TRIPNO=nil;
            else
                thShiptrans.TRIPNO=[NSString stringWithUTF8String:rowdata7];
            
            char *rowdata8=(char *)sqlite3_column_text(statement, 8);
            if (rowdata8==NULL)
                thShiptrans.FACTORYCODE=nil;
            else
                thShiptrans.FACTORYCODE=[NSString stringWithUTF8String:rowdata8];
            
            char *rowdata9=(char *)sqlite3_column_text(statement, 9);
            if (rowdata9==NULL)
                thShiptrans.FACTORYNAME=nil;
            else
                thShiptrans.FACTORYNAME=[NSString stringWithUTF8String:rowdata9];
            
            char *rowdata10=(char *)sqlite3_column_text(statement, 10);
            if (rowdata10==NULL)
                thShiptrans.PORTCODE=nil;
            else
                thShiptrans.PORTCODE=[NSString stringWithUTF8String:rowdata10];
            
            char *rowdata11=(char *)sqlite3_column_text(statement, 11);
            if (rowdata11==NULL)
                thShiptrans.PORTNAME=nil;
            else
                thShiptrans.PORTNAME=[NSString stringWithUTF8String:rowdata11];
            
            thShiptrans .SUPID= sqlite3_column_int(statement, 12);
            
            char *rowdata13=(char *)sqlite3_column_text(statement, 13);
            if (rowdata13==NULL)
                thShiptrans.SUPPLIER=nil;
            else
                thShiptrans.SUPPLIER=[NSString stringWithUTF8String:rowdata13];
            
            thShiptrans .TYPEID= sqlite3_column_int(statement, 14);
            
            char *rowdata15=(char *)sqlite3_column_text(statement, 15);
            if (rowdata15==NULL)
                thShiptrans.COALTYPE=nil;
            else
                thShiptrans.COALTYPE=[NSString stringWithUTF8String:rowdata15];
            
            char *rowdata16=(char *)sqlite3_column_text(statement, 16);
            if (rowdata16==NULL)
                thShiptrans.KEYVALUE=nil;
            else
                thShiptrans.KEYVALUE=[NSString stringWithUTF8String:rowdata16];
            
            char *rowdata17=(char *)sqlite3_column_text(statement, 17);
            if (rowdata17==NULL)
                thShiptrans.KEYNAME=nil;
            else
                thShiptrans.KEYNAME=[NSString stringWithUTF8String:rowdata17];
            
            char *rowdata18=(char *)sqlite3_column_text(statement, 18);
            if (rowdata6==NULL)
                thShiptrans.TRADE=nil;
            else
                thShiptrans.TRADE=[NSString stringWithUTF8String:rowdata18];
            
            char *rowdata19=(char *)sqlite3_column_text(statement, 19);
            if (rowdata19==NULL)
                thShiptrans.TRADENAME=nil;
            else
                thShiptrans.TRADENAME=[NSString stringWithUTF8String:rowdata19];
            
            char *rowdata20=(char *)sqlite3_column_text(statement, 20);
            if (rowdata20==NULL)
                thShiptrans.STAGE=nil;
            else
                thShiptrans.STAGE=[NSString stringWithUTF8String:rowdata20];
            
            char *rowdata21=(char *)sqlite3_column_text(statement, 21);
            if (rowdata21==NULL)
                thShiptrans.STAGENAME=nil;
            else
                thShiptrans.STAGENAME=[NSString stringWithUTF8String:rowdata21];
            
            char *rowdata22=(char *)sqlite3_column_text(statement, 22);
            if (rowdata22==NULL)
                thShiptrans.STATECODE=nil;
            else
                thShiptrans.STATECODE=[NSString stringWithUTF8String:rowdata22];
            
            char *rowdata23=(char *)sqlite3_column_text(statement, 23);
            if (rowdata23==NULL)
                thShiptrans.STATENAME=nil;
            else
                thShiptrans.STATENAME=[NSString stringWithUTF8String:rowdata23];
            
            thShiptrans .LW= sqlite3_column_int(statement, 24);
            thShiptrans .HEATVALUE= sqlite3_column_int(statement, 25);
            
            char *rowdata26=(char *)sqlite3_column_text(statement, 26);
            if (rowdata26==NULL)
                thShiptrans.P_ANCHORAGETIME=nil;
            else
                thShiptrans.P_ANCHORAGETIME=[NSString stringWithUTF8String:rowdata26];
            
            char *rowdata27=(char *)sqlite3_column_text(statement, 27);
            if (rowdata27==NULL)
                thShiptrans.P_HANDLE=nil;
            else
                thShiptrans.P_HANDLE=[NSString stringWithUTF8String:rowdata27];
            
            char *rowdata28=(char *)sqlite3_column_text(statement, 28);
            if (rowdata28==NULL)
                thShiptrans.P_ARRIVALTIME=nil;
            else
                thShiptrans.P_ARRIVALTIME=[NSString stringWithUTF8String:rowdata28];
            
            char *rowdata29=(char *)sqlite3_column_text(statement, 29);
            if (rowdata29==NULL)
                thShiptrans.P_DEPARTTIME=nil;
            else
                thShiptrans.P_DEPARTTIME=[NSString stringWithUTF8String:rowdata29];
            
            char *rowdata30=(char *)sqlite3_column_text(statement, 30);
            if (rowdata30==NULL)
                thShiptrans.P_NOTE=nil;
            else
                thShiptrans.P_NOTE=[NSString stringWithUTF8String:rowdata30];
            
            char *rowdata31=(char *)sqlite3_column_text(statement, 31);
            if (rowdata31==NULL)
                thShiptrans.T_NOTE=nil;
            else
                thShiptrans.T_NOTE=[NSString stringWithUTF8String:rowdata31];
            
            char *rowdata32=(char *)sqlite3_column_text(statement, 32);
            if (rowdata32==NULL)
                thShiptrans.F_ANCHORAGETIME=nil;
            else
                thShiptrans.F_ANCHORAGETIME=[NSString stringWithUTF8String:rowdata32];
            
            char *rowdata33=(char *)sqlite3_column_text(statement, 33);
            if (rowdata33==NULL)
                thShiptrans.F_ARRIVALTIME=nil;
            else
                thShiptrans.F_ARRIVALTIME=[NSString stringWithUTF8String:rowdata33];
            
            char *rowdata34=(char *)sqlite3_column_text(statement, 34);
            if (rowdata34==NULL)
                thShiptrans.F_DEPARTTIME=nil;
            else
                thShiptrans.F_DEPARTTIME=[NSString stringWithUTF8String:rowdata34];
            
            char *rowdata35=(char *)sqlite3_column_text(statement, 35);
            if (rowdata35==NULL)
                thShiptrans.F_NOTE=nil;
            else
                thShiptrans.F_NOTE=[NSString stringWithUTF8String:rowdata35];
            
            char *rowdata36=(char *)sqlite3_column_text(statement, 36);
            if (rowdata36==NULL)
                thShiptrans.LATEFEE=nil;
            else
                thShiptrans.LATEFEE=[NSString stringWithUTF8String:rowdata36];
            
            thShiptrans .OFFEFFICIENCY= sqlite3_column_int(statement, 37);
            
            char *rowdata38=(char *)sqlite3_column_text(statement, 38);
            if (rowdata38==NULL)
                thShiptrans.SCHEDULE=nil;
            else
                thShiptrans.SCHEDULE=[NSString stringWithUTF8String:rowdata38];
            
            char *rowdata39=(char *)sqlite3_column_text(statement, 39);
            if (rowdata39==NULL)
                thShiptrans.PLANTYPE=nil;
            else
                thShiptrans.PLANTYPE=[NSString stringWithUTF8String:rowdata39];
            
            char *rowdata40=(char *)sqlite3_column_text(statement, 40);
            if (rowdata40==NULL)
                thShiptrans.PLANCODE=nil;
            else
                thShiptrans.PLANCODE=[NSString stringWithUTF8String:rowdata40];
            
            char *rowdata41=(char *)sqlite3_column_text(statement, 41);
            if (rowdata41==NULL)
                thShiptrans.LAYCANSTART=nil;
            else
                thShiptrans.LAYCANSTART=[NSString stringWithUTF8String:rowdata41];
            
            char *rowdata42=(char *)sqlite3_column_text(statement, 42);
            if (rowdata42==NULL)
                thShiptrans.LAYCANSTOP=nil;
            else
                thShiptrans.LAYCANSTOP=[NSString stringWithUTF8String:rowdata42];
            
            char *rowdata43=(char *)sqlite3_column_text(statement, 43);
            if (rowdata43==NULL)
                thShiptrans.RECIEPT=nil;
            else
                thShiptrans.RECIEPT=[NSString stringWithUTF8String:rowdata43];
            
            char *rowdata44=(char *)sqlite3_column_text(statement, 44);
            if (rowdata44==NULL)
                thShiptrans.SHIPSHIFT=nil;
            else
                thShiptrans.SHIPSHIFT=[NSString stringWithUTF8String:rowdata44];
            
            char *rowdata45=(char *)sqlite3_column_text(statement, 45);
            if (rowdata45==NULL)
                thShiptrans.F_FINISH=nil;
            else
                thShiptrans.F_FINISH=[NSString stringWithUTF8String:rowdata45];
    
            
            [array addObject:thShiptrans    ];
            
            [thShiptrans release];
            
        }
        
    }else {
        NSLog(@"getTH_ShipTransBySql--- Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
    }
    sqlite3_finalize(statement);
    return array;
}

//added by mawp 2012.10.09
//船舶动态查询
+(NSMutableArray *) getThShiptrans:(NSString *)shipCompany :(NSString *)shipName :(NSString *)portName :(NSString *)factoryName :(NSString *)stageName :(NSDate *)date
{
    NSString *query=@" 1=1  ";
    
    if(![shipCompany isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND shipCompany ='%@' ",shipCompany];
    if(![shipName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND shipName ='%@' ",shipName];
    if(![portName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND portName ='%@' ",portName];
    if(![factoryName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND factoryName ='%@' ",factoryName];
    if(![stageName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND stageName ='%@' ",stageName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *start=[dateFormatter stringFromDate:date];
    query=[query stringByAppendingFormat:@" AND strftime('%%Y-%%m-%%d',RECORDDATE) >='%@' AND strftime('%%Y-%%m-%%d',RECORDDATE) <='%@' order by  RECORDDATE DESC ",start,start];
    [dateFormatter release];
    
	NSMutableArray * array=[TH_SHIPTRANS_ORIDAO getTH_ShipTransBySql:query] ;
    NSLog(@"--------执行 getTH_ShipTransBySql 数量[%d] ",[array count]);
	return array;
}

@end
