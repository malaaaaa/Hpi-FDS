//
//  TfShipDao.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-5.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TfShipDao.h"

@implementation TfShipDao
static sqlite3  *database;
+(NSString *)dataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString  *documentsDirectory=[paths objectAtIndex:0];
    
    NSString *path=[documentsDirectory  stringByAppendingPathComponent: @"database.db"  ];
    
   
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
    
    NSLog(@"create TfShip  。。。。");
    char *errorMsg;
    
    NSString *createSql=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                         @"CREATE TABLE IF NOT EXISTS TfShip( SHIPID INTEGER  PRIMARY KEY  ",
                         @" , COMID INTEGER ",
                         @" , SHIPNAME TEXT ",
                         @" , SHIPCODE TEXT  ",
                         @" , MMSI TEXT ",
                         @" , LENGTH INTEGER ",
                         @" , WIDTH INTEGER ",
                         @" , MAXSPEED INTEGER ",
                         @" , LOADWEIGHT INTEGER ",
                         @" , DRAFT INTEGER ",
                         @" , VOLUME INTEGER ",
                         @" , CABINNUM INTEGER ",
                         @" , GATENUM INTEGER ", 
                         @" , TELEPHONE TEXT  ",
                         @" , FEERATE INTEGER ",
                         @" , ALLOWPERIOD INTEGER ",
                         
                         @" , DESPATCHRATE INTEGER ) "];
    
    
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        sqlite3_close(database);
        NSLog(@"create table TfShip error");
        printf("%s",errorMsg);
        return;
        
        
    }else {
        NSLog(@"create table TfShip seccess");
    }
    
}

+(void)deleteAll
{
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TfShip  " ];
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        NSLog(@"Error: delete TfShip error with message [%s]  sql[%@]", errorMsg,deletesql);
    }else {
        NSLog(@"delete success")  ;
    }
    return;
}
+(NSString *)getShipName:(NSInteger)shipID
{
    NSString *shipName=@"";
   sqlite3_stmt *statement;

    NSString *sql=[NSString  stringWithFormat:@"select shipname from TfShip where shipid='%@'",[NSString stringWithFormat:@"%d" ,shipID]];

        NSLog(@"执行 getShipName [%@]",sql);
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {

            char *rowdata1=(char *)sqlite3_column_text(statement, 0);
            if (rowdata1==NULL)
                shipName=@"";
            else
                shipName=[NSString stringWithUTF8String:rowdata1];
        }
    }
    sqlite3_finalize(statement);

    return shipName;
}







@end
