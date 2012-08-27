//
//  TB_LatefeeDao.m
//  Hpi-FDS
//
//  Created by bin tang on 12-7-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TB_LatefeeDao.h"
#import "TB_Latefee.h"

#import "PubInfo.h"

@implementation TB_LatefeeDao
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
    
    NSLog(@"create TB_Latefee  。。。。");
    char *errorMsg;
    NSString *createSql=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                         @"CREATE TABLE IF NOT EXISTS TB_Latefee( dispatchno  TEXT  PRIMARY KEY " , 
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
        NSLog(@"create table TB_Latefee error");
        printf("%s",errorMsg);
        return;
        
    }else {
        NSLog(@"create table TB_Latefee seccess");
    }
}

+(void)deleteAll
{
    
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TB_Latefee  " ];
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        NSLog(@"Error: delete TB_Latefee error with message [%s]  sql[%@]", errorMsg,deletesql);
    }else {
        NSLog(@"delete success")  ;
    }
    return;
    
    
}


+(void)insert:(TB_Latefee *)tb_Latefee
{
 NSLog(@"Insert begin TB_Latefee ");


 const char *insert="INSERT INTO TB_Latefee(dispatchno,portcode ,portname,factorycode,factoryname,comid , company,shipid,shipname,feerate,allowperiod,supid,supplier,typeid,coaltype,trade,keyvalue,tripno,lw,tradetime ,p_anchoragetime,p_departtime,p_confirm,p_contime,p_conuser,f_anchoragetime,f_departtime,f_confirm,f_contime,f_conuser,latefee,p_correct,p_note,f_correct,f_note,iscal,currency,exchangrate)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

    sqlite3_stmt *statement;
    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
    
    if (re!=SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
    }
    //绑定数据

    sqlite3_bind_text(statement, 1, [tb_Latefee.DISPATCHNO UTF8String], -1,SQLITE_TRANSIENT);
                        
    sqlite3_bind_text(statement, 2, [tb_Latefee.PORTCODE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [tb_Latefee .PORTNAME   UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [tb_Latefee.FACTORYCODE UTF8String], -1, SQLITE_TRANSIENT);
     sqlite3_bind_text(statement, 5, [tb_Latefee.FACTORYNAME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 6, tb_Latefee.COMID);
     sqlite3_bind_text(statement, 7, [tb_Latefee.COMPANY UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 8, tb_Latefee.SHIPID);
     sqlite3_bind_text(statement, 9, [tb_Latefee.SHIPNAME   UTF8String], -1, SQLITE_TRANSIENT);
    
     sqlite3_bind_text(statement, 10, [tb_Latefee.FEERATE UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 11, [tb_Latefee.ALLOWPERIOD   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 12, tb_Latefee.SUPID);
     sqlite3_bind_text(statement,13, [tb_Latefee.SUPPLIER UTF8String], -1, SQLITE_TRANSIENT);
    
    
    sqlite3_bind_int(statement,14, tb_Latefee.TYPEID );
    sqlite3_bind_text(statement,15, [tb_Latefee.COALTYPE UTF8String], -1, SQLITE_TRANSIENT);
      sqlite3_bind_text(statement, 16, [tb_Latefee.TRADE   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 17, [tb_Latefee.KEYVALUE   UTF8String], -1, SQLITE_TRANSIENT);
    
     sqlite3_bind_text(statement,18, [tb_Latefee.TRIPNO   UTF8String], -1, SQLITE_TRANSIENT);

sqlite3_bind_int(statement,19, tb_Latefee.LW ); 
      sqlite3_bind_text(statement,20, [tb_Latefee.TRADETIME   UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement,21, [tb_Latefee.P_ANCHORAGETIME   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,22, [tb_Latefee.P_DEPARTTIME    UTF8String], -1, SQLITE_TRANSIENT);
       sqlite3_bind_text(statement,23, [tb_Latefee.P_CONFIRM    UTF8String], -1, SQLITE_TRANSIENT);
    
  sqlite3_bind_text(statement,24, [tb_Latefee.P_CONTIME    UTF8String], -1, SQLITE_TRANSIENT);
 sqlite3_bind_text(statement,25, [tb_Latefee.P_CONUSER    UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,26, [tb_Latefee.F_ANCHORAGETIME   UTF8String], -1, SQLITE_TRANSIENT);
    
     sqlite3_bind_text(statement,27, [tb_Latefee.F_DEPARTTIME   UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement,28, [tb_Latefee.F_CONFIRM   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,29, [tb_Latefee.F_CONTIME   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,30, [tb_Latefee.F_CONUSER   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,31, [tb_Latefee.LATEFEE   UTF8String], -1, SQLITE_TRANSIENT);
      sqlite3_bind_text(statement,32, [tb_Latefee.P_CORRECT   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,33, [tb_Latefee.P_NOTE  UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement,34, [tb_Latefee.F_CORRECT   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,35, [tb_Latefee.F_NOTE  UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,36, [tb_Latefee.ISCAL  UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,37, [tb_Latefee.CURRENCY  UTF8String], -1, SQLITE_TRANSIENT);
     sqlite3_bind_text(statement,38, [tb_Latefee.EXCHANGRATE  UTF8String], -1, SQLITE_TRANSIENT);
    
    
    
    re=sqlite3_step(statement);
    
    
    if (re!=SQLITE_DONE) {
        NSLog( @"Error: insert TB_Latefee  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert); 
        
        sqlite3_finalize(statement);
        return;
        
    }else {
        NSLog(@"insert TB_Latefee  SUCCESS");
    }
    sqlite3_finalize(statement);
    return;
 }

+(void)delete:(TB_Latefee *)tb_Latefee
{

    NSLog(@"删除实体........");
    
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TB_Latefee where dispatchno ='%@' ", tb_Latefee.DISPATCHNO ];
    
    
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        NSLog(@"Error: delete TB_Latefee error with message [%s]  sql[%@]", errorMsg,deletesql);
        
    }else {
        NSLog(@"delete success")  ;
    }
    return;
    
}
+(NSMutableArray *)getTB_LateFee:(NSString *)dispatchno
{


    NSString *query=[NSString stringWithFormat:@" dispatchno ='%@'  ",dispatchno ];
    
    NSMutableArray *array=[TB_LatefeeDao getTB_LateFeeBySql:query];
    return array;
}

+(NSMutableArray *)getTB_LateFee{

    NSString *query=@" 1=1 ";
    NSMutableArray *array=[TB_LatefeeDao getTB_LateFeeBySql:query];
    
    
    NSLog(@"执行 getTB_LateFee 数量【%d】",[array count]);
    
    return  array;





}
+(NSMutableArray *)getTB_LateFee:(NSString *)compoayId :(NSString *)shipId :(NSString *)factoryCode :(NSString *)Typeid :(NSString *)supid :(NSString *)startTime :(NSString *)endTime   
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

NSMutableArray *array=[self getTB_LateFeeBySql:query];
NSLog(@"执行 getTB_LateFee: 数量[%d]",[array count]);

return array;
}

+(NSMutableArray *)getTB_LateFeeBySql:(NSString *)sql1
{

    sqlite3_stmt *statement;
    
    //视图。。。。
    
    NSString *sql=[NSString  stringWithFormat:@"SELECT dispatchno,portcode,portname ,factorycode,factoryname,comid , company, shipid,shipname,feerate,allowperiod,supid,supplier,typeid,coaltype,trade,keyvalue,tripno,lw,tradetime ,p_anchoragetime,p_departtime,p_confirm,p_contime,p_conuser,f_anchoragetime,f_departtime,f_confirm,f_contime,f_conuser,latefee,p_correct,p_note,f_correct,f_note,iscal,currency,exchangrate  FROM  TB_Latefee  WHERE iscal=1  AND %@",sql1];
    
    
    
    
    
    

    NSLog(@"执行 getTB_LatefeeBySql [%@]",sql);
    NSMutableArray  *array=[[NSMutableArray alloc] init];

    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            TB_Latefee *tbLatefee=[[TB_Latefee alloc] init  ];
            
            
            char *rowdata1=(char *)sqlite3_column_text(statement, 0);
            if (rowdata1==NULL) 
                tbLatefee.DISPATCHNO=nil;
            else 
                tbLatefee.DISPATCHNO=[NSString stringWithUTF8String:rowdata1];
            
            char *rowdata2=(char *)sqlite3_column_text(statement, 1);
            if (rowdata2==NULL) 
                tbLatefee.PORTCODE=nil;
            else 
                tbLatefee.PORTCODE=[NSString stringWithUTF8String:rowdata2];
            
            char *rowdata_2=(char *)sqlite3_column_text(statement, 2);
            if (rowdata_2==NULL) 
                tbLatefee.PORTNAME=nil;
            else 
                tbLatefee.PORTNAME=[NSString stringWithUTF8String:rowdata_2];

            
            
            

            char *rowdata3=(char *)sqlite3_column_text(statement, 3);
            if (rowdata3==NULL) 
                tbLatefee.FACTORYCODE=nil;
            else 
                tbLatefee.FACTORYCODE=[NSString stringWithUTF8String:rowdata3];

            char *rowdata_3=(char *)sqlite3_column_text(statement, 4);
            if (rowdata_3==NULL) 
                tbLatefee.FACTORYNAME=nil;
            else 
                tbLatefee.FACTORYNAME=[NSString stringWithUTF8String:rowdata_3];   
            tbLatefee.COMID=sqlite3_column_int(statement, 5);
            char *rowdata_4=(char *)sqlite3_column_text(statement, 6);
            if (rowdata_4==NULL) 
                tbLatefee.COMPANY=nil;
            else 
                tbLatefee.COMPANY=[NSString stringWithUTF8String:rowdata_4];
            tbLatefee.SHIPID=sqlite3_column_int(statement, 7);
            char *rowdata_5=(char *)sqlite3_column_text(statement, 8);
            if (rowdata_5==NULL) 
                tbLatefee.SHIPNAME=nil;
            else 
                tbLatefee.SHIPNAME=[NSString stringWithUTF8String:rowdata_5];
            char *rowdata4=(char *)sqlite3_column_text(statement, 9);
            if (rowdata4==NULL) 
                tbLatefee.FEERATE=nil;
            else 
                tbLatefee.FEERATE=[NSString stringWithUTF8String:rowdata4];
            char *rowdata5=(char *)sqlite3_column_text(statement, 10);
            if (rowdata5==NULL) 
                tbLatefee.ALLOWPERIOD=nil;
            else 
                tbLatefee.ALLOWPERIOD=[NSString stringWithUTF8String:rowdata5];

            tbLatefee.SUPID=sqlite3_column_int(statement, 11);
            char *rowdata_6=(char *)sqlite3_column_text(statement,12);
            if (rowdata_6==NULL) 
                tbLatefee.SUPPLIER=nil;
            else 
                tbLatefee.SUPPLIER=[NSString stringWithUTF8String:rowdata_6];
            
            tbLatefee.TYPEID=sqlite3_column_int(statement, 13);
            char *rowdata_7=(char *)sqlite3_column_text(statement,14);
            if (rowdata_7==NULL) 
                tbLatefee.COALTYPE=nil;
            else 
                tbLatefee.COALTYPE=[NSString stringWithUTF8String:rowdata_7];
            char *rowdata6=(char *)sqlite3_column_text(statement,15);
            if (rowdata6==NULL) 
                tbLatefee.TRADE=nil;
            else 
                tbLatefee.TRADE=[NSString stringWithUTF8String:rowdata6];
            
            char *rowdata7=(char *)sqlite3_column_text(statement,16);
            if (rowdata7==NULL) 
                tbLatefee.KEYVALUE=nil;
            else 
                tbLatefee.KEYVALUE=[NSString stringWithUTF8String:rowdata7];

            char *rowdata8=(char *)sqlite3_column_text(statement,17);
            if (rowdata8==NULL) 
                tbLatefee.TRIPNO=nil;
            else 
                tbLatefee.TRIPNO=[NSString stringWithUTF8String:rowdata8];
            
            tbLatefee.LW=sqlite3_column_int(statement, 18);

            
            
            char *rowdata9=(char *)sqlite3_column_text(statement,19);
            if (rowdata9==NULL) 
                tbLatefee.TRADETIME =nil;
            else 
                tbLatefee.TRADETIME=[NSString stringWithUTF8String:rowdata9];
            
            char *rowdata10=(char *)sqlite3_column_text(statement,20);
            if (rowdata10==NULL) 
                tbLatefee.P_ANCHORAGETIME =nil;
            else 
                tbLatefee.P_ANCHORAGETIME=[NSString stringWithUTF8String:rowdata10];
            
            char *rowdata11=(char *)sqlite3_column_text(statement,21);
            if (rowdata11==NULL) 
                tbLatefee.P_DEPARTTIME =nil;
            else 
                tbLatefee.P_DEPARTTIME=[NSString stringWithUTF8String:rowdata11];
            
            char *rowdata12=(char *)sqlite3_column_text(statement,22);
            if (rowdata12==NULL) 
                tbLatefee.P_CONFIRM =nil;
            else 
                tbLatefee.P_CONFIRM=[NSString stringWithUTF8String:rowdata12];
            
            char *rowdata13=(char *)sqlite3_column_text(statement,23);
            if (rowdata13==NULL) 
                tbLatefee.P_CONTIME =nil;
            else 
                tbLatefee.P_CONTIME=[NSString stringWithUTF8String:rowdata13];
            
            char *rowdata14=(char *)sqlite3_column_text(statement,24);
            if (rowdata14==NULL) 
                tbLatefee.P_CONUSER =nil;
            else 
                tbLatefee.P_CONUSER=[NSString stringWithUTF8String:rowdata14];
            char *rowdata15=(char *)sqlite3_column_text(statement,25);
            if (rowdata15==NULL) 
                tbLatefee.F_ANCHORAGETIME =nil;
            else 
                tbLatefee.F_ANCHORAGETIME=[NSString stringWithUTF8String:rowdata15];
            
            char *rowdata16=(char *)sqlite3_column_text(statement,26);
            if (rowdata16==NULL) 
                tbLatefee.F_DEPARTTIME =nil;
            else 
                tbLatefee.F_DEPARTTIME  =[NSString stringWithUTF8String:rowdata16];
            
            char *rowdata17=(char *)sqlite3_column_text(statement,27);
            if (rowdata17==NULL) 
                tbLatefee.F_CONFIRM =nil;
            else 
                tbLatefee.F_CONFIRM  =[NSString stringWithUTF8String:rowdata17];
            
            char *rowdata18=(char *)sqlite3_column_text(statement,28);
            if (rowdata18==NULL) 
                tbLatefee.F_CONTIME =nil;
            else 
                tbLatefee.F_CONTIME  =[NSString stringWithUTF8String:rowdata18];
            
            char *rowdata19=(char *)sqlite3_column_text(statement,29);
            if (rowdata19==NULL) 
                tbLatefee.F_CONUSER =nil;
            else 
                tbLatefee.F_CONUSER  =[NSString stringWithUTF8String:rowdata19];
            char *rowdata20=(char *)sqlite3_column_text(statement,30);
            if (rowdata20==NULL) 
                tbLatefee.LATEFEE =nil;
            else 
                tbLatefee.LATEFEE  =[NSString stringWithUTF8String:rowdata20];
            char *rowdata21=(char *)sqlite3_column_text(statement,31);
            if (rowdata21==NULL) 
                tbLatefee.P_CORRECT =nil;
            else 
                tbLatefee.P_CORRECT   =[NSString stringWithUTF8String:rowdata21];
            
            char *rowdata22=(char *)sqlite3_column_text(statement,32);
            if (rowdata22==NULL) 
                tbLatefee.P_NOTE =nil;
            else 
                tbLatefee.P_NOTE  =[NSString stringWithUTF8String:rowdata22];
            
            
            char *rowdata23=(char *)sqlite3_column_text(statement,33);
            if (rowdata23==NULL) 
                tbLatefee.F_CORRECT     =nil;
            else 
                tbLatefee.F_CORRECT   =[NSString stringWithUTF8String:rowdata23];
            
            char *rowdata24=(char *)sqlite3_column_text(statement,34);
            if (rowdata24==NULL) 
                tbLatefee.F_NOTE     =nil;
            else 
                tbLatefee.F_NOTE   =[NSString stringWithUTF8String:rowdata24];
            
            char *rowdata25=(char *)sqlite3_column_text(statement,35);
            if (rowdata25==NULL) 
                tbLatefee.ISCAL     =nil;
            else 
                tbLatefee.ISCAL    =[NSString stringWithUTF8String:rowdata25];
            
            char *rowdata26=(char *)sqlite3_column_text(statement,36);
            if (rowdata26==NULL) 
                tbLatefee.CURRENCY     =nil;
            else 
                tbLatefee.CURRENCY =[NSString stringWithUTF8String:rowdata26];
            
            char *rowdata27=(char *)sqlite3_column_text(statement,37);
            if (rowdata27==NULL) 
                tbLatefee.EXCHANGRATE     =nil;
            else 
                tbLatefee.EXCHANGRATE =[NSString stringWithUTF8String:rowdata27];
            
            [array addObject:tbLatefee];
            [tbLatefee release];
      
        }
        
    }else {
       NSLog(@"gettbLatefee--- Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
    
    
    
    }
    [array autorelease];
    return array;
    
  
}

@end
