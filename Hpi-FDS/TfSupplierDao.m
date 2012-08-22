//
//  TfSupplierDao.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TfSupplierDao.h"

@implementation TfSupplierDao
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
		NSLog(@"open TfSupplier error");
		return;
	}
	NSLog(@"open TfSupplier database succes ....");
}
+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TfSupplier  (SUPID INTEGER PRIMARY KEY ",
                         @",PID INTEGER ",
						 @",SUPPLIER TEXT ",
                         @",DESCRIPTION TEXT ",
                         @",LINKMAN TEXT ",
                         @",CONTACT TEXT ",
						 @",SORT INTEGER )"];
    
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TfSupplier error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TfSupplier*) tfSupplier
{ 
//	NSLog(@"Insert begin TfSupplier");
	const char *insert="INSERT INTO TfSupplier (SUPID,PID,SUPPLIER,DESCRIPTION,LINKMAN,CONTACT,SORT) values(?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    
    sqlite3_bind_int(statement, 1, tfSupplier.SUPID); 
    sqlite3_bind_int(statement, 2, tfSupplier.PID);   
	sqlite3_bind_text(statement, 3,[tfSupplier.SUPPLIER UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4,[tfSupplier.DESCRIPTION UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 5,[tfSupplier.LINKMAN UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 6,[tfSupplier.CONTACT UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 7, tfSupplier.SORT); 

    
	re = sqlite3_step(statement);
	if(re!=SQLITE_DONE)
    {
		NSLog( @"Error: insert TfSupplier error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
    }
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TfSupplier*) tfSupplier
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TfSupplier where supid =%d ",tfSupplier.SUPID];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TfSupplier error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}
+(void) deleteAll
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TfSupplier "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TfSupplier error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(NSMutableArray *) getTfSupplier:(NSInteger)supid
{
	NSString *query=[NSString stringWithFormat:@" supid = %d ",supid];
	NSMutableArray * array=[TfSupplierDao getTfSupplierBySql:query];
	return array;
}
+(NSMutableArray *) getTfSupplier
{
    
	NSString *query=@" 1=1 ";
	NSMutableArray * array=[TfSupplierDao getTfSupplierBySql:query];
    NSLog(@"执行 TfSupplier 数量[%d] ",[array count]);
	return array;
}
+(NSMutableArray *) getTfSupplierBySql:(NSString *)sql1
{

	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT SUPID,PID,SUPPLIER,DESCRIPTION,LINKMAN,CONTACT,SORT FROM  TfSupplier WHERE %@ ",sql1];
    NSLog(@"执行 getTfSupplierBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TfSupplier *tfSupplier=[[TfSupplier alloc] init];
            
            tfSupplier.SUPID = sqlite3_column_int(statement,0);
            tfSupplier.PID = sqlite3_column_int(statement,1);

			char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tfSupplier.SUPPLIER = nil;
            else
                 tfSupplier.SUPPLIER = [NSString stringWithUTF8String: rowData2];
            
            char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                tfSupplier.DESCRIPTION = nil;
            else
                tfSupplier.DESCRIPTION = [NSString stringWithUTF8String: rowData3];
            
            char * rowData4=(char *)sqlite3_column_text(statement,4);
            if (rowData4 == NULL)
                tfSupplier.LINKMAN = nil;
            else
                tfSupplier.LINKMAN = [NSString stringWithUTF8String: rowData4];
            
            char * rowData5=(char *)sqlite3_column_text(statement,5);
            if (rowData5 == NULL)
                tfSupplier.CONTACT = nil;
            else
                tfSupplier.CONTACT = [NSString stringWithUTF8String: rowData5];
            
            tfSupplier.SORT = sqlite3_column_int(statement,6);
            
			[array addObject:tfSupplier];
            [tfSupplier release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	[array autorelease];
	return array;
}

@end
