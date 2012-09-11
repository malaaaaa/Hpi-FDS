//
//  TF_FACTORYCAPACITYDao.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TF_FACTORYCAPACITYDao.h"
static sqlite3  *database;
@implementation TF_FACTORYCAPACITYDao
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
		//NSLog(@"open  database error");
		return;
	}
	
}

+(void)initDb
{
    
    NSLog(@"create TF_FACTORYCAPACITY  。。。。");
    char *errorMsg;

    NSString *createSql=[NSString stringWithFormat:@"%@%@%@%@%@",
                         @"CREATE TABLE IF NOT EXISTS TF_FACTORYCAPACITY(CAPID  INTEGER PRIMARY KEY ",
                         @", FACTORYCODE   TEXT ",
                         @", CAPACITY   INTEGER ",
                         @", UNITS   INTEGER ",
                         @", DESCRIPTION TEXT )"];
    
    
    
    
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        sqlite3_close(database);
        NSLog(@"create table TF_FACTORYCAPACITY error");
        printf("%s",errorMsg);
        return;
        
    }else {
        NSLog(@"create table TF_FACTORYCAPACITY seccess");
    }




}

+(void)deleteAll
{

    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TF_FACTORYCAPACITY  "];
    
    
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        NSLog(@"Error: delete TF_FACTORYCAPACITY error with message [%s]  sql[%@]", errorMsg,deletesql);
        
    }else {
        NSLog(@"delete success")  ;
    }
    return;






}


//机组台数(台) 获取电厂机组运行信 GetUnits
+(NSString *)GetUnits:(NSString *)factoryName
{
    NSString *a;
    int b=0;
    sqlite3_stmt *statement;
    NSString *sql= [NSString stringWithFormat:@"SELECT   sum(  UNITS )        FROM TF_FACTORYCAPACITY          inner    join   TfFactory   ON TfFactory.FACTORYCODE= TF_FACTORYCAPACITY.FACTORYCODE     where   TfFactory.FACTORYNAME='%@'",factoryName]   ;
    
  //  NSLog(@"a 机组台数(台) GetUnits[%@] ",sql);
    
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
            
            b=  sqlite3_column_int(statement,0);
          //  NSLog(@"a 机组台数(台) [%d] ",b);
        }
    }
    sqlite3_finalize(statement);
   
    a=[NSString stringWithFormat:@"%d",b];
    return a;
    
    
}
//机组构成(台*容量)获取电厂机组运行信息 GetCapaCityByCode      TF_FACTORYCAPACITY
+(NSMutableArray *)GetCapaCityByName:(NSString *)factoryName
{
    
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    
    
    sqlite3_stmt *statement;
    NSString *sql= [NSString stringWithFormat:@"select CAPID,TFFACTORY.FACTORYCODE,    CAPACITY,UNITS,TF_FACTORYCAPACITY.DESCRIPTION   from TF_FACTORYCAPACITY  inner  join TFFACTORY on  TFFACTORY.FACTORYCODE=TF_FACTORYCAPACITY.FACTORYCODE    where TFFACTORY.FACTORYNAME='%@'",factoryName]   ;
    
   // NSLog(@"a 获取电厂机组运行信息 GetCapaCityByName[%@] ",sql);
    
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
            
            TF_FACTORYCAPACITY *tfCapacity=[[TF_FACTORYCAPACITY alloc] init ];
            
            tfCapacity.CAPID= sqlite3_column_int(statement,0);
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tfCapacity.FACTORYCODE  = nil;
            else
                tfCapacity.FACTORYCODE = [NSString stringWithUTF8String: rowData1];
            tfCapacity.CAPACITY= sqlite3_column_double(statement,2);
            
            
            tfCapacity.UNITS= sqlite3_column_int(statement,3);
            
            char * rowData2=(char *)sqlite3_column_text(statement,4);
            if (rowData2 == NULL)
                tfCapacity.DESCRIPTION  = nil;
            else
                tfCapacity.DESCRIPTION = [NSString stringWithUTF8String: rowData2];
            
            
            [array addObject:tfCapacity];
            
            [tfCapacity  release];
            
        }
    }
    sqlite3_finalize(statement);
    
    return array;
    
    
}








@end
