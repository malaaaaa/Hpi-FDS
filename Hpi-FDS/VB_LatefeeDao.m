//
//  VB_LatefeeDao.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-9-27.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VB_LatefeeDao.h"
#import "VB_Latefee.h"
#import "PubInfo.h"
@implementation VB_LatefeeDao
static sqlite3  *database;
+(NSString *)dataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString  *documentsDirectory=[paths objectAtIndex:0];
    
    NSString *path=[documentsDirectory  stringByAppendingPathComponent: @"database.db"  ];
    
    
    NSLog(@"database.db:path=== %@",path);
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

+(void)initDb
{
    
    NSLog(@"create VB_Latefee  。。。。");
    char *errorMsg;
    NSString *createSql=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                         @"CREATE TABLE IF NOT EXISTS VB_Latefee( dispatchno  TEXT  PRIMARY KEY " ,
                         @", portcode   TEXT ",
                         @", portname   TEXT ",
                         @",factorycode TEXT ",
                         @",factoryname TEXT ",
                         @", comid   INTEGER ",
                         @", company   TEXT ",
                         @", shipid INTEGER  ",
                         @", shipname TEXT  ",
                         @", feerate TEXT ",
                         @", allowperiod TEXT ",
                         @", supid  INTEGER ",
                         @", supplier  TEXT ",
                         
                         @", typeid  INTEGER ",
                         
                         @", coaltype  TEXT ",
                         
                         @", trade TEXT  ",
                         @", keyvalue TEXT ",
                         @", tripno TEXT ",
                         @", lw  INTEGER ",
                         @", tradetime TEXT ",
                         @", p_anchoragetime TEXT ",
                         @", p_departtime TEXT ",
                         @", p_confirm TEXT ",
                         @", p_contime TEXT ",
                         @", p_conuser TEXT ",
                         @", f_anchoragetime TEXT ",
                         @", f_departtime TEXT ",
                         @", f_confirm TEXT ",
                         @", f_contime TEXT ",
                         @", f_conuser TEXT ",
                         @", latefee TEXT ",
                         @", p_correct TEXT ",
                         @", p_note TEXT " ,
                         @", f_correct TEXT " ,
                         @", f_note TEXT " ,
                         @", iscal TEXT " ,
                         @", currency TEXT " ,
                         @", exchangrate TEXT) "];
    
    
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        sqlite3_close(database);
        NSLog(@"create table VB_Latefee error");
        printf("%s",errorMsg);
        return;
        
    }else {
        NSLog(@"create table VB_Latefee seccess");
    }
}

+(void)deleteAll
{
    
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  VB_Latefee  " ];
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        NSLog(@"Error: delete VB_Latefee error with message [%s]  sql[%@]", errorMsg,deletesql);
    }else {
        NSLog(@"delete success")  ;
    }
    return;
    
    
}


+(void)insert:(VB_Latefee *)vb_Latefee
{
    NSLog(@"Insert begin VB_Latefee ");
    
    
    const char *insert="INSERT INTO VB_Latefee(dispatchno,portcode ,portname,factorycode,factoryname,comid , company,shipid,shipname,feerate,allowperiod,supid,supplier,typeid,coaltype,trade,keyvalue,tripno,lw,tradetime ,p_anchoragetime,p_departtime,p_confirm,p_contime,p_conuser,f_anchoragetime,f_departtime,f_confirm,f_contime,f_conuser,latefee,p_correct,p_note,f_correct,f_note,iscal,currency,exchangrate)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *statement;
    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
    
    if (re!=SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
    }
    //绑定数据
    
    sqlite3_bind_text(statement, 1, [vb_Latefee.DISPATCHNO UTF8String], -1,SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 2, [vb_Latefee.PORTCODE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [vb_Latefee .PORTNAME   UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [vb_Latefee.FACTORYCODE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [vb_Latefee.FACTORYNAME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 6, vb_Latefee.COMID);
    sqlite3_bind_text(statement, 7, [vb_Latefee.COMPANY UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 8, vb_Latefee.SHIPID);
    sqlite3_bind_text(statement, 9, [vb_Latefee.SHIPNAME   UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 10, [vb_Latefee.FEERATE UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 11, [vb_Latefee.ALLOWPERIOD   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 12, vb_Latefee.SUPID);
    sqlite3_bind_text(statement,13, [vb_Latefee.SUPPLIER UTF8String], -1, SQLITE_TRANSIENT);
    
    
    sqlite3_bind_int(statement,14, vb_Latefee.TYPEID );
    sqlite3_bind_text(statement,15, [vb_Latefee.COALTYPE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 16, [vb_Latefee.TRADE   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 17, [vb_Latefee.KEYVALUE   UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement,18, [vb_Latefee.TRIPNO   UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(statement,19, vb_Latefee.LW );
    sqlite3_bind_text(statement,20, [vb_Latefee.TRADETIME   UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement,21, [vb_Latefee.P_ANCHORAGETIME   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,22, [vb_Latefee.P_DEPARTTIME    UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,23, [vb_Latefee.P_CONFIRM    UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement,24, [vb_Latefee.P_CONTIME    UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,25, [vb_Latefee.P_CONUSER    UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,26, [vb_Latefee.F_ANCHORAGETIME   UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement,27, [vb_Latefee.F_DEPARTTIME   UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement,28, [vb_Latefee.F_CONFIRM   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,29, [vb_Latefee.F_CONTIME   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,30, [vb_Latefee.F_CONUSER   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,31, [vb_Latefee.LATEFEE   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,32, [vb_Latefee.P_CORRECT   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,33, [vb_Latefee.P_NOTE  UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement,34, [vb_Latefee.F_CORRECT   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,35, [vb_Latefee.F_NOTE  UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,36, [vb_Latefee.ISCAL  UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,37, [vb_Latefee.CURRENCY  UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,38, [vb_Latefee.EXCHANGRATE  UTF8String], -1, SQLITE_TRANSIENT);
    
    
    
    re=sqlite3_step(statement);
    
    
    if (re!=SQLITE_DONE) {
        NSLog( @"Error: insert vb_Latefee  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
        
        sqlite3_finalize(statement);
        return;
        
    }else {
        NSLog(@"insert vb_Latefee  SUCCESS");
    }
    sqlite3_finalize(statement);
    return;
}

+(void)delete:(VB_Latefee *)vb_Latefee
{
    
    NSLog(@"删除实体........");
    
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  VB_Latefee where dispatchno ='%@' ", vb_Latefee.DISPATCHNO ];
    
    
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        NSLog(@"Error: delete VB_Latefee error with message [%s]  sql[%@]", errorMsg,deletesql);
        
    }else {
        NSLog(@"delete success")  ;
    }
    return;
    
}
+(NSMutableArray *)getVB_LateFee:(NSString *)dispatchno
{
    
    
    NSString *query=[NSString stringWithFormat:@" dispatchno ='%@'  ",dispatchno ];

    NSMutableArray *array=[VB_LatefeeDao getVB_LateFeeBySql:query];
    return array;
}

+(NSMutableArray *)getVB_LateFee{
    
    NSString *query=@" 1=1 ";
    NSMutableArray *array=[VB_LatefeeDao getVB_LateFeeBySql:query];
    
    
    NSLog(@"执行 getvb_Latefee 数量【%d】",[array count]);
    
    return  array;
    
    
    
    
    
}
+(NSMutableArray *)getVB_LateFee:(NSString *)compoayId :(NSString *)shipId :(NSString *)factoryCode :(NSString *)Typeid :(NSString *)supid :(NSString *)startTime :(NSString *)endTime
{
    
    NSString *query=[NSString stringWithFormat:@" 1=1 "];
    
    
    if (![compoayId isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND company='%@' ",compoayId ];
        
        
    }
    if (![shipId isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND shipname='%@' ",shipId ];
    }
    
    if (![factoryCode isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND factoryname='%@' ",factoryCode];
    }
    
    
    
    
    if (![Typeid isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND coaltype='%@' ",Typeid];
    }
    
    
    
    
    if (![supid isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND supplier='%@' ",supid ];
    }
    
    
    if (![startTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND tradetime>='%@' ",startTime];
    }
    
    if (![endTime   isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND tradetime<='%@' ",endTime  ];
    }
    
    NSMutableArray *array=[self getVB_LateFeeBySql:query];
    NSLog(@"执行 getVB_LateFee: 数量[%d]",[array count]);
    
    return array;
}

+(NSMutableArray *)getVB_LateFeeBySql:(NSString *)sql1
{
    
    sqlite3_stmt *statement;
    
    //视图。。。。
    
    NSString *sql=[NSString  stringWithFormat:@"SELECT dispatchno,portcode,portname ,factorycode,factoryname,comid , company, shipid,shipname,feerate,allowperiod,supid,supplier,typeid,coaltype,trade,keyvalue,tripno,lw,tradetime ,p_anchoragetime,p_departtime,p_confirm,p_contime,p_conuser,f_anchoragetime,f_departtime,f_confirm,f_contime,f_conuser,latefee,p_correct,p_note,f_correct,f_note,iscal,currency,exchangrate  FROM  VB_Latefee  WHERE iscal=1  AND %@",sql1];
    
    
    
    
    
    
    
    NSLog(@"执行 getVB_LatefeeBySql [%@]",sql);
    NSMutableArray  *array=[[NSMutableArray alloc] init];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            VB_Latefee *vbLatefee=[[VB_Latefee alloc] init  ];
            
            
            char *rowdata1=(char *)sqlite3_column_text(statement, 0);
            if (rowdata1==NULL)
                vbLatefee.DISPATCHNO=nil;
            else
                vbLatefee.DISPATCHNO=[NSString stringWithUTF8String:rowdata1];
            
            char *rowdata2=(char *)sqlite3_column_text(statement, 1);
            if (rowdata2==NULL)
                vbLatefee.PORTCODE=nil;
            else
                vbLatefee.PORTCODE=[NSString stringWithUTF8String:rowdata2];
            
            char *rowdata_2=(char *)sqlite3_column_text(statement, 2);
            if (rowdata_2==NULL)
                vbLatefee.PORTNAME=nil;
            else
                vbLatefee.PORTNAME=[NSString stringWithUTF8String:rowdata_2];
            
            
            
            
            
            char *rowdata3=(char *)sqlite3_column_text(statement, 3);
            if (rowdata3==NULL)
                vbLatefee.FACTORYCODE=nil;
            else
                vbLatefee.FACTORYCODE=[NSString stringWithUTF8String:rowdata3];
            
            char *rowdata_3=(char *)sqlite3_column_text(statement, 4);
            if (rowdata_3==NULL)
                vbLatefee.FACTORYNAME=nil;
            else
                vbLatefee.FACTORYNAME=[NSString stringWithUTF8String:rowdata_3];
            vbLatefee.COMID=sqlite3_column_int(statement, 5);
            char *rowdata_4=(char *)sqlite3_column_text(statement, 6);
            if (rowdata_4==NULL)
                vbLatefee.COMPANY=nil;
            else
                vbLatefee.COMPANY=[NSString stringWithUTF8String:rowdata_4];
            vbLatefee.SHIPID=sqlite3_column_int(statement, 7);
            char *rowdata_5=(char *)sqlite3_column_text(statement, 8);
            if (rowdata_5==NULL)
                vbLatefee.SHIPNAME=nil;
            else
                vbLatefee.SHIPNAME=[NSString stringWithUTF8String:rowdata_5];
            char *rowdata4=(char *)sqlite3_column_text(statement, 9);
            if (rowdata4==NULL)
                vbLatefee.FEERATE=nil;
            else
                vbLatefee.FEERATE=[NSString stringWithUTF8String:rowdata4];
            char *rowdata5=(char *)sqlite3_column_text(statement, 10);
            if (rowdata5==NULL)
                vbLatefee.ALLOWPERIOD=nil;
            else
                vbLatefee.ALLOWPERIOD=[NSString stringWithUTF8String:rowdata5];
            
            vbLatefee.SUPID=sqlite3_column_int(statement, 11);
            char *rowdata_6=(char *)sqlite3_column_text(statement,12);
            if (rowdata_6==NULL)
                vbLatefee.SUPPLIER=nil;
            else
                vbLatefee.SUPPLIER=[NSString stringWithUTF8String:rowdata_6];
            
            vbLatefee.TYPEID=sqlite3_column_int(statement, 13);
            char *rowdata_7=(char *)sqlite3_column_text(statement,14);
            if (rowdata_7==NULL)
                vbLatefee.COALTYPE=nil;
            else
                vbLatefee.COALTYPE=[NSString stringWithUTF8String:rowdata_7];
            char *rowdata6=(char *)sqlite3_column_text(statement,15);
            if (rowdata6==NULL)
                vbLatefee.TRADE=nil;
            else
                vbLatefee.TRADE=[NSString stringWithUTF8String:rowdata6];
            
            char *rowdata7=(char *)sqlite3_column_text(statement,16);
            if (rowdata7==NULL)
                vbLatefee.KEYVALUE=nil;
            else
                vbLatefee.KEYVALUE=[NSString stringWithUTF8String:rowdata7];
            
            char *rowdata8=(char *)sqlite3_column_text(statement,17);
            if (rowdata8==NULL)
                vbLatefee.TRIPNO=nil;
            else
                vbLatefee.TRIPNO=[NSString stringWithUTF8String:rowdata8];
            
            vbLatefee.LW=sqlite3_column_int(statement, 18);
            
            
            
            char *rowdata9=(char *)sqlite3_column_text(statement,19);
            if (rowdata9==NULL)
                vbLatefee.TRADETIME =nil;
            else
                vbLatefee.TRADETIME=[NSString stringWithUTF8String:rowdata9];
            
            char *rowdata10=(char *)sqlite3_column_text(statement,20);
            if (rowdata10==NULL)
                vbLatefee.P_ANCHORAGETIME =nil;
            else
                vbLatefee.P_ANCHORAGETIME=[NSString stringWithUTF8String:rowdata10];
            
            char *rowdata11=(char *)sqlite3_column_text(statement,21);
            if (rowdata11==NULL)
                vbLatefee.P_DEPARTTIME =nil;
            else
                vbLatefee.P_DEPARTTIME=[NSString stringWithUTF8String:rowdata11];
            
            char *rowdata12=(char *)sqlite3_column_text(statement,22);
            if (rowdata12==NULL)
                vbLatefee.P_CONFIRM =nil;
            else
                vbLatefee.P_CONFIRM=[NSString stringWithUTF8String:rowdata12];
            
            char *rowdata13=(char *)sqlite3_column_text(statement,23);
            if (rowdata13==NULL)
                vbLatefee.P_CONTIME =nil;
            else
                vbLatefee.P_CONTIME=[NSString stringWithUTF8String:rowdata13];
            
            char *rowdata14=(char *)sqlite3_column_text(statement,24);
            if (rowdata14==NULL)
                vbLatefee.P_CONUSER =nil;
            else
                vbLatefee.P_CONUSER=[NSString stringWithUTF8String:rowdata14];
            char *rowdata15=(char *)sqlite3_column_text(statement,25);
            if (rowdata15==NULL)
                vbLatefee.F_ANCHORAGETIME =nil;
            else
                vbLatefee.F_ANCHORAGETIME=[NSString stringWithUTF8String:rowdata15];
            
            char *rowdata16=(char *)sqlite3_column_text(statement,26);
            if (rowdata16==NULL)
                vbLatefee.F_DEPARTTIME =nil;
            else
                vbLatefee.F_DEPARTTIME  =[NSString stringWithUTF8String:rowdata16];
            
            char *rowdata17=(char *)sqlite3_column_text(statement,27);
            if (rowdata17==NULL)
                vbLatefee.F_CONFIRM =nil;
            else
                vbLatefee.F_CONFIRM  =[NSString stringWithUTF8String:rowdata17];
            
            char *rowdata18=(char *)sqlite3_column_text(statement,28);
            if (rowdata18==NULL)
                vbLatefee.F_CONTIME =nil;
            else
                vbLatefee.F_CONTIME  =[NSString stringWithUTF8String:rowdata18];
            
            char *rowdata19=(char *)sqlite3_column_text(statement,29);
            if (rowdata19==NULL)
                vbLatefee.F_CONUSER =nil;
            else
                vbLatefee.F_CONUSER  =[NSString stringWithUTF8String:rowdata19];
            char *rowdata20=(char *)sqlite3_column_text(statement,30);
            if (rowdata20==NULL)
                vbLatefee.LATEFEE =nil;
            else
                vbLatefee.LATEFEE  =[NSString stringWithUTF8String:rowdata20];
            char *rowdata21=(char *)sqlite3_column_text(statement,31);
            if (rowdata21==NULL)
                vbLatefee.P_CORRECT =nil;
            else
                vbLatefee.P_CORRECT   =[NSString stringWithUTF8String:rowdata21];
            
            char *rowdata22=(char *)sqlite3_column_text(statement,32);
            if (rowdata22==NULL)
                vbLatefee.P_NOTE =nil;
            else
                vbLatefee.P_NOTE  =[NSString stringWithUTF8String:rowdata22];
            
            
            char *rowdata23=(char *)sqlite3_column_text(statement,33);
            if (rowdata23==NULL)
                vbLatefee.F_CORRECT     =nil;
            else
                vbLatefee.F_CORRECT   =[NSString stringWithUTF8String:rowdata23];
            
            char *rowdata24=(char *)sqlite3_column_text(statement,34);
            if (rowdata24==NULL)
                vbLatefee.F_NOTE     =nil;
            else
                vbLatefee.F_NOTE   =[NSString stringWithUTF8String:rowdata24];
            
            char *rowdata25=(char *)sqlite3_column_text(statement,35);
            if (rowdata25==NULL)
                vbLatefee.ISCAL     =nil;
            else
                vbLatefee.ISCAL    =[NSString stringWithUTF8String:rowdata25];
            
            char *rowdata26=(char *)sqlite3_column_text(statement,36);
            if (rowdata26==NULL)
                vbLatefee.CURRENCY     =nil;
            else
                vbLatefee.CURRENCY =[NSString stringWithUTF8String:rowdata26];
            
            char *rowdata27=(char *)sqlite3_column_text(statement,37);
            if (rowdata27==NULL)
                vbLatefee.EXCHANGRATE     =nil;
            else
                vbLatefee.EXCHANGRATE =[NSString stringWithUTF8String:rowdata27];
            
            [array addObject:vbLatefee];
            [vbLatefee release];
            
        }
        
    }else {
        NSLog(@"gettbLatefee--- Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
        
        
        
    }
    sqlite3_finalize(statement);
    
    [array autorelease];
    return array;
    
    
}

@end
