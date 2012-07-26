//
//  TfCoalTypeDao.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TfCoalTypeDao.h"

@implementation TfCoalTypeDao
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
		NSLog(@"open TfCoalType error");
		return;
	}
	NSLog(@"open TfCoalType database succes ....");
}
+(void) initDb
{	

	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TfCoalType  (TYPEID INTEGER PRIMARY KEY ",
                         @",COALTYPE TEXT ",
						 @",SORT INTEGER ",
                         @",HEATVALUE INTEGER ",
                         @",SULFUR INTEGER )"];
    
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TfCoalType error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TfCoalType*) tfCoalType
{ 
	NSLog(@"Insert begin TfCoalType");
	const char *insert="INSERT INTO TfCoalType (TYPEID,COALTYPE,SORT,HEATVALUE,SULFUR) values(?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    
    sqlite3_bind_int(statement, 1, tfCoalType.TYPEID); 
    sqlite3_bind_text(statement, 2,[tfCoalType.COALTYPE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 3, tfCoalType.SORT); 
    sqlite3_bind_int(statement, 4, tfCoalType.HEATVALUE); 
    sqlite3_bind_int(statement, 5, tfCoalType.SULFUR); 

	re = sqlite3_step(statement);
	if(re!=SQLITE_DONE)
    {
		NSLog( @"Error: insert TfCoalType error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
    }
	sqlite3_finalize(statement);
    NSLog(@"%@",tfCoalType.COALTYPE);
    NSLog(@"%@",tfCoalType.SULFUR);
    NSLog(@"%@",@"插入成功！！！！！！");
    
    
    
    
	return;
}

+(void) delete:(TfCoalType*) tfCoalType
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TfCoalType where typeid =%d ",tfCoalType.TYPEID];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TfCoalType error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}

+(NSMutableArray *) getTfCoalType:(NSInteger)typeid
{
	NSString *query=[NSString stringWithFormat:@" typeid = %d ",typeid];
	NSMutableArray * array=[TfCoalTypeDao getTfCoalTypeBySql:query];
	return array;
}
+(NSMutableArray *) getTfCoalType
{
    
	NSString *query=[NSString stringWithString:@" 1=1 "];
	NSMutableArray * array=[TfCoalTypeDao getTfCoalTypeBySql:query];
    
    
    NSLog(@"执行 TfCoalType 数量[%d] ",[array count]);
	return array;
}
+(NSMutableArray *) getTfCoalTypeBySql:(NSString *)sql1
{
    
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT TYPEID,COALTYPE,SORT,HEATVALUE,SULFUR FROM  TfCoalType WHERE %@ ",sql1];
    
    NSLog(@"执行 getTfCoalTypeBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TfCoalType *tfCoalType=[[TfCoalType alloc] init];
            
            tfCoalType.TYPEID = sqlite3_column_int(statement,0);
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tfCoalType.COALTYPE = nil;
            else
                tfCoalType.COALTYPE = [NSString stringWithUTF8String: rowData1];
            
            tfCoalType.SORT = sqlite3_column_int(statement,2);
            tfCoalType.HEATVALUE = sqlite3_column_int(statement,2);

            tfCoalType.SULFUR = sqlite3_column_int(statement,2);
            
			[array addObject:tfCoalType];
            [tfCoalType release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	[array autorelease];
	return array;
}

@end
