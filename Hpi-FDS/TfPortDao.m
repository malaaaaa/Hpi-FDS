//
//  TfPortDao.m
//  Hpi-FDS
//
//  Created by bin tang on 12-8-7.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TfPortDao.h"
#import "PubInfo.h"
@implementation TfPortDao

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
   NSLog(@"create TF_Port  。。。。"); 
    char *errorMsg;

    NSString *createSql=[NSString stringWithFormat:@"%@%@%@%@%@%@",
                         @"CREATE TABLE IF NOT EXISTS TF_Port( portcode TEXT  PRIMARY KEY  ",
                         @" , portname TEXT ",
                         @" , sort TEXT ",
                         @" , upload TEXT  ",
                         @" , download TEXT ",
                         @" , nationaltype TEXT ) "];
    
    
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        sqlite3_close(database);
        NSLog(@"create table TF_Port error");
        printf("%s",errorMsg);
        return;
        
        
    }else {
        NSLog(@"create table TF_Port seccess");
    }
  
}

+(void)insert:(TfPort *)tfprot
{
// NSLog(@"Insert begin TF_Port ");

   const char *insert="INSERT INTO TF_Port(portcode,portname,sort,upload,download,nationaltype )values(?,?,?,?,?,?)";

    sqlite3_stmt *statement;
    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
    
    if (re!=SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
    }
    sqlite3_bind_text(statement, 1, [tfprot.PORTCODE UTF8String], -1,SQLITE_TRANSIENT);
    
     sqlite3_bind_text(statement, 2, [tfprot.PORTNAME UTF8String], -1,SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 3, [tfprot.SORT UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,4, [tfprot.UPLOAD UTF8String], -1,SQLITE_TRANSIENT);
sqlite3_bind_text(statement,5, [tfprot.DOWNLOAD UTF8String], -1,SQLITE_TRANSIENT);
sqlite3_bind_text(statement,6, [tfprot.NATIONALTYPE UTF8String], -1,SQLITE_TRANSIENT);
    
 re=sqlite3_step(statement);
    if (re!=SQLITE_DONE) {
        NSLog( @"Error: insert TF_Port  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert); 
        
        sqlite3_finalize(statement);
        return;
        
    }else {
//        NSLog(@"insert  TF_Port  SUCCESS");
    }
    sqlite3_finalize(statement);
    return;
   
}


+(void)delete:(TfPort *)tfprot
{

   NSLog(@"删除实体........");

    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TF_Port where portcode ='%@' ", tfprot.PORTCODE ];
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        NSLog(@"Error: delete TB_Latefee error with message [%s]  sql[%@]", errorMsg,deletesql);
    }else {
        NSLog(@"delete success")  ;
    }
    return;


}
+(void)deleteAll
{
    
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TF_Port  " ];
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        NSLog(@"Error: delete TF_Port error with message [%s]  sql[%@]", errorMsg,deletesql);
    }else {
        NSLog(@"delete success")  ;
    }
    return;
    
    
}
+(NSString *)getPortName:(NSString *)portcode
{

  sqlite3_stmt *statement;
    NSString *sql=[NSString  stringWithFormat:@"select portname from TF_Port where portcode='%@' ",portcode];
    //NSLog(@"执行 getPortName [%@]",sql);
    NSString *portName;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            char *rowdata1=(char *)sqlite3_column_text(statement, 0);
            if (rowdata1==NULL)
                portName=@"";
            else
                portName=[NSString stringWithUTF8String:rowdata1];
            
            
            
            
        }
    
    }else {
        NSLog(@"getPortName--- Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
        sqlite3_finalize(statement);
    }
    sqlite3_finalize(statement);

    return portName;

}










@end
