//
//  TH_ShipTransDao.m
//  Hpi-FDS
//
//  Created by bin tang on 12-7-19.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TH_ShipTransDao.h"
#import "TH_ShipTrans.h"
#import "PubInfo.h"

@implementation TH_ShipTransDao
static sqlite3  *database;


+(NSString *)dataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString  *documentsDirectory=[paths objectAtIndex:0];
    
    NSString *path=[documentsDirectory  stringByAppendingPathComponent: @"database.db"  ];
    
    
    NSLog(@"VBThShipTrans:path=== %@",path);
    return  path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open  Th_ShipTrans error");
		return;
	}
	NSLog(@"open Th_ShipTrans database succes ....");
}
+(void)initDb
{
    
    NSLog(@"create thshipTrans  。。。。");
    char *errorMsg;
    NSString *createSql=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                         @"CREATE TABLE IF NOT EXISTS Th_ShipTrans( recid  INTEGER  PRIMARY KEY " , 
                         @", statecode   INTEGER ",
                         @",recorddate TEXT ",                 
                         @", statename   TEXT ",
                         @", portcode TEXT  ",
                         @", portname TEXT ",
                         @", shipname TEXT ",
                         @", tripno  TEXT ",
                         @", factoryname  TEXT ",
                         @", supplier TEXT  ",
                         @", coaltype TEXT ",
                         @", lw  INTEGER ",
                         @", p_anchoragetime TEXT ",
                         @", p_handle TEXT ",
                         @", p_arrivaltime   TEXT ",
                         @", p_departtime TEXT ",
                         @", note TEXT )"];

     
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
       
        sqlite3_close(database);
        NSLog(@"create table Th_ShipTrans error");
        printf("%s",errorMsg);
        return;
    
    }else {
        NSLog(@"create table Th_ShipTrans seccess");
    }
   }


+(void)insert:(TH_ShipTrans *)th_Shiptrans
{

//    NSLog(@"Insert begin Th_ShipTrans ");
    
    
    const char *insert="INSERT INTO Th_ShipTrans(recid,statecode,recorddate,statename,portcode,portname,shipname,tripno,factoryname,supplier,coaltype,lw,p_anchoragetime,p_handle ,p_arrivaltime,p_departtime,note)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *statement;
    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
    
    if (re!=SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
    }

//    NSLog(@"recid=%d", th_Shiptrans.RECID);
//   
//	NSLog(@"recorddate=%@", th_Shiptrans.RECORDDATE );
// 
//    NSLog(@"插入实体中   有值");

//绑定数据
    
    sqlite3_bind_int(statement,1 ,th_Shiptrans.RECID);
    
    sqlite3_bind_int(statement,2,th_Shiptrans.STATECODE );
    sqlite3_bind_text(statement, 3, [th_Shiptrans.RECORDDATE UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 4, [th_Shiptrans.STATENAME  UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 5, [th_Shiptrans.PORTCODE      UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 6, [th_Shiptrans.PORTNAME     UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 7, [th_Shiptrans.SHIPNAME      UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [th_Shiptrans.TRIPNO     UTF8String], -1, SQLITE_TRANSIENT);
    
    
    

     sqlite3_bind_text(statement, 9, [th_Shiptrans.FACTORYNAME      UTF8String], -1, SQLITE_TRANSIENT);
     sqlite3_bind_text(statement, 10, [th_Shiptrans.SUPPLIER       UTF8String], -1, SQLITE_TRANSIENT);  
    

    
 sqlite3_bind_text(statement, 11, [th_Shiptrans.COALTYPE       UTF8String], -1, SQLITE_TRANSIENT);
    

    
     sqlite3_bind_int(statement,12,th_Shiptrans.LW );
  
    
    
    
    sqlite3_bind_text(statement, 13, [th_Shiptrans.P_ANCHORAGETIME      UTF8String], -1, SQLITE_TRANSIENT);
     
    sqlite3_bind_text(statement, 14, [th_Shiptrans.P_HANDLE    UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 15, [th_Shiptrans.P_ARRIVALTIME      UTF8String], -1, SQLITE_TRANSIENT);
     sqlite3_bind_text(statement, 16, [th_Shiptrans.P_DEPARTTIME    UTF8String], -1, SQLITE_TRANSIENT);
     
    
    
    
      sqlite3_bind_text(statement, 17, [th_Shiptrans.NOTE    UTF8String], -1, SQLITE_TRANSIENT);
    
       
    re=sqlite3_step(statement);
    
    
    if (re!=SQLITE_DONE) {
       NSLog( @"Error: insert Th_ShipTrans  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert); 
        
        sqlite3_finalize(statement);
        return;

    }else {
        NSLog(@"insert Th_ShipTrans  SUCCESS");
    }
    sqlite3_finalize(statement);
    return;
   
}

+(void)delete:(TH_ShipTrans *)th_Shiptrans
{
//    NSLog(@"删除实体........");
    
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  Th_ShipTrans where recid  =%d ", th_Shiptrans.RECID ];
    
    
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        NSLog(@"Error: delete Th_ShipTrans error with message [%s]  sql[%@]", errorMsg,deletesql);
        
    }else {
        NSLog(@"delete success")  ;
    }
return;





}
+(void)deleteAll
{
    NSLog(@"删除实体........");
    
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  Th_ShipTrans  "];
    
    
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        NSLog(@"Error: delete Th_ShipTrans error with message [%s]  sql[%@]", errorMsg,deletesql);
        
    }else {
        NSLog(@"delete success")  ;
    }
    return;
   
}
+(NSMutableArray *)getTH_ShipTrans:(NSInteger)recid
{

    NSString *query=[NSString stringWithFormat:@" recid =%d  ",recid ];

    NSMutableArray *array=[TH_ShipTransDao getTH_ShipTransBySql:query];
    return array;
    
    



}
+(NSMutableArray *)getTH_ShipTrans
{
 
 NSString *query=@" 1=1 ";
    NSMutableArray *array=[TH_ShipTransDao getTH_ShipTransBySql:query];
    
    
    NSLog(@"执行 getTH_ShipTrans 数量【%d】",[array count]);
    
    return  array;



}

+(NSMutableArray *)getTH_ShipTrans:(NSString *)portName :(NSString *)dateTime :(NSString *)state
{

    NSString *query=[NSString stringWithFormat:@" 1=1 "];
    if (![portName isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND portname='%@' ",portName];
    }
    if (![dateTime isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@" AND  recorddate='%@' ",dateTime];
    }
  if(![state isEqualToString:All_] ){
      query=[query stringByAppendingFormat:@" AND statename='%@'  ",state];
   }
    NSMutableArray *array=[TH_ShipTransDao getTH_ShipTransBySql:query];
    NSLog(@"执行  getTH_ShipTrans 数量[%d]",[array count]);
 
    return array;
    
    
    

}


+(NSMutableArray *)getTH_ShipTransBySql:(NSString *)sql1
{

    sqlite3_stmt *statement;
    NSString *sql=[NSString  stringWithFormat:@"SELECT recid,statecode,recorddate,statename,portcode,portname,shipname,tripno,factoryname,supplier,coaltype,lw,p_anchoragetime,p_handle ,p_arrivaltime,p_departtime,note  FROM  Th_ShipTrans WHERE %@",sql1];
    
    
    NSLog(@"执行 getTH_ShipTransBySql [%@]",sql);
    NSMutableArray  *array=[[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
            TH_ShipTrans *thShiptrans=[[TH_ShipTrans alloc] init];
             
            thShiptrans .RECID= sqlite3_column_int(statement, 0);
            thShiptrans.STATECODE=sqlite3_column_int(statement, 1);

            
            
            char *rowdata1=(char *)sqlite3_column_text(statement, 2);
            if (rowdata1==NULL) 
                thShiptrans.RECORDDATE=nil;
            else 
                thShiptrans.RECORDDATE=[NSString stringWithUTF8String:rowdata1];
            
            
            
            char *rowdata2=(char *)sqlite3_column_text(statement, 3);
            if (rowdata2==NULL) 
                thShiptrans.STATENAME=nil;
            else 
                thShiptrans.STATENAME=[NSString stringWithUTF8String:rowdata2];
        
            
   
            
            char *rowdata3=(char *)sqlite3_column_text(statement, 4);
            if (rowdata3==NULL) 
                thShiptrans.PORTCODE=nil;
            else 
                thShiptrans.PORTCODE=[NSString stringWithUTF8String:rowdata3];
            
            char *rowdata4=(char *)sqlite3_column_text(statement, 5);
            if (rowdata4==NULL) 
                thShiptrans.PORTNAME=nil;
            else 
                thShiptrans.PORTNAME=[NSString stringWithUTF8String:rowdata4];
            
            char *rowdata5=(char *)sqlite3_column_text(statement, 6);
            if (rowdata5==NULL) 
                thShiptrans.SHIPNAME=nil;
            else 
                thShiptrans.SHIPNAME=[NSString stringWithUTF8String:rowdata5];
            
            char *rowdata6=(char *)sqlite3_column_text(statement, 7);
            if (rowdata6==NULL) 
                thShiptrans.TRIPNO=nil;
            else 
                thShiptrans.TRIPNO=[NSString stringWithUTF8String:rowdata6];
            
            
            char *rowdata7=(char *)sqlite3_column_text(statement, 8);
            if (rowdata7==NULL) 
                thShiptrans.FACTORYNAME=nil;
            else 
                thShiptrans.FACTORYNAME=[NSString stringWithUTF8String:rowdata7];
            
            
            char *rowdata8=(char *)sqlite3_column_text(statement, 9);
            if (rowdata8==NULL) 
                thShiptrans.SUPPLIER=nil;
            else 
                thShiptrans.SUPPLIER=[NSString stringWithUTF8String:rowdata8];
            
            char *rowdata9=(char *)sqlite3_column_text(statement, 10);
            if (rowdata9==NULL) 
                thShiptrans.COALTYPE=nil;
            else 
                thShiptrans.COALTYPE=[NSString stringWithUTF8String:rowdata9];            
            
            
              thShiptrans .LW = sqlite3_column_int(statement, 11);
            
            char *rowdata10=(char *)sqlite3_column_text(statement, 12);
            if (rowdata10==NULL) 
                thShiptrans.P_ANCHORAGETIME=nil;
            else 
                thShiptrans.P_ANCHORAGETIME=[NSString stringWithUTF8String:rowdata10];
            
            char *rowdata18=(char *)sqlite3_column_text(statement, 13);
            if (rowdata18==NULL) 
                thShiptrans.P_HANDLE=nil;
            else 
                thShiptrans.P_HANDLE=[NSString stringWithUTF8String:rowdata18];
            
            
          
            
            char *rowdata16=(char *)sqlite3_column_text(statement, 14);
            if (rowdata16==NULL) 
                thShiptrans.P_ARRIVALTIME=nil;
            else 
                thShiptrans.P_ARRIVALTIME=[NSString stringWithUTF8String:rowdata16];
            
            char *rowdata17=(char *)sqlite3_column_text(statement, 15);
            if (rowdata17==NULL) 
                thShiptrans.P_DEPARTTIME=nil;
            else 
                thShiptrans.P_DEPARTTIME=[NSString stringWithUTF8String:rowdata17];
            
            
            char *rowdata19=(char *)sqlite3_column_text(statement, 16);
            if (rowdata19==NULL) 
                thShiptrans.NOTE=nil;
            else 
                thShiptrans.NOTE=[NSString stringWithUTF8String:rowdata19];
            
            
                        
            [array addObject:thShiptrans    ];
            
            [thShiptrans release];
           
        }
      
    }else {
        NSLog(@"getTH_ShipTrans--- Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
    }
    [array  autorelease ];
    return array;
}


@end
