//
//  TB_OFFLOADFACTORYDao.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TB_OFFLOADFACTORYDao.h"
#import "TB_OFFLOADSHIPDao.h"
@implementation TB_OFFLOADFACTORYDao

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
		NSLog(@"open TB_OFFLOADFACTORY error");
		return;
	}
	NSLog(@"open TB_OFFLOADFACTORY database succes ....");
}
+(void) initDb
{
    
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TB_OFFLOADFACTORY  (ID INTEGER PRIMARY KEY ",
                         @",FACTORYCODE TEXT ",
						 @",RECORDDATE TEXT ",
                         
                         @",CONSUM INTEGER ",
                         @",STORAGE INTEGER ",
                         @",HEATVALUE INTEGER ",
                         @",SULFUR DOUBLE ",
                         @",AVALIABLE INTEGER ",
                         @",MINDEPTH INTEGER ",
                         
                         @",NOTE TEXT )"];
    
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TB_OFFLOADFACTORY error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void) deleteAll
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TB_OFFLOADFACTORY "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TB_OFFLOADFACTORY error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
 
	return;
}

+(TB_OFFLOADFACTORY *)SelectFactoryByCode:(NSString *)factoryName :(NSString *)time
{


    TB_OFFLOADFACTORY * tbFactory=[[[TB_OFFLOADFACTORY alloc] init] autorelease];
    sqlite3_stmt *statement;
    NSString *sql=[NSString  stringWithFormat:@"select   ID,TB_OFFLOADFACTORY.FACTORYCODE,RECORDDATE,CONSUM,STORAGE,HEATVALUE,SULFUR,AVALIABLE,MINDEPTH,NOTE from TB_OFFLOADFACTORY  inner join  TFFACTORY on TFFACTORY.FACTORYCODE=TB_OFFLOADFACTORY.FACTORYCODE  where  (          CAST(strftime('%%Y',TB_OFFLOADFACTORY.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TB_OFFLOADFACTORY.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TB_OFFLOADFACTORY.RECORDDATE) AS VARCHAR(100))      )='%@'and  TFFACTORY.FACTORYNAME='%@'",time,factoryName];

   // NSLog(@"TB_OFFLOADFACTORYDao SelectFactoryByCode [%@]",sql);

    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
     
            tbFactory.ID=sqlite3_column_int(statement, 0);
 
            char *rowdata1=(char *)sqlite3_column_text(statement, 1);
            if (rowdata1==NULL)
                tbFactory.FACTORYCODE=nil;
            else
                tbFactory.FACTORYCODE=[NSString stringWithUTF8String:rowdata1];
            
            char *rowdata2=(char *)sqlite3_column_text(statement, 2);
            if (rowdata2==NULL)
                tbFactory.RECORDDATE=nil;
            else
                tbFactory.RECORDDATE=[NSString stringWithUTF8String:rowdata2];
            
            tbFactory.CONSUM=sqlite3_column_int(statement, 3);
            tbFactory.STORAGE=sqlite3_column_int(statement, 4);
            tbFactory.HEATVALUE=sqlite3_column_int(statement, 5);
            tbFactory.SULFUR=sqlite3_column_double(statement, 6);
            tbFactory.AVALIABLE=sqlite3_column_int(statement, 7);
            tbFactory.MINDEPTH=sqlite3_column_double(statement, 8);
            
            char *rowdata8=(char *)sqlite3_column_text(statement, 9);
            if (rowdata8==NULL)
                tbFactory.NOTE=nil;
            else
                tbFactory.NOTE=[NSString stringWithUTF8String:rowdata8];
            
        }
    
    }else {
        NSLog(@"TB_OFFLOADFACTORY--- Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
    }
    sqlite3_finalize(statement);


    tbFactory.tbShipList=[TB_OFFLOADSHIPDao SelectAllByFactoryCode:factoryName :time];
  // 

    

    return tbFactory;

}
@end
