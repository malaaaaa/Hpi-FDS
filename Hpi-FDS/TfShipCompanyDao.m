//
//  TfShipCompanyDao.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-17.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TfShipCompanyDao.h"

@implementation TfShipCompanyDao

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
		NSLog(@"open TfShipCompany error");
		return;
	}
	NSLog(@"open TfShipCompany database succes ....");
}
+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TfShipCompany  (comid INTEGER PRIMARY KEY ",
                         @",company TEXT ",
						 @",description TEXT ",
                         @",linkman TEXT ",
						 @",contact TEXT )"];
    
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TfShipCompany error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TfShipCompany*) tfShipCompany
{
//	NSLog(@"Insert begin TfShipCompany");
	const char *insert="INSERT INTO TfShipCompany (comid,company,description,linkman,contact) values(?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }

    sqlite3_bind_int(statement, 1, tfShipCompany.comid);    
	sqlite3_bind_text(statement, 2,[tfShipCompany.company UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3,[tfShipCompany.description UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 4,[tfShipCompany.linkman UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 5,[tfShipCompany.contact UTF8String], -1, SQLITE_TRANSIENT);

    
	re = sqlite3_step(statement);
	if(re!=SQLITE_DONE)
    {
		NSLog( @"Error: insert tfShipCompany error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
    }
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TfShipCompany*) tfShipCompany
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  tfShipCompany where comid ='%d' ",tfShipCompany.comid];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete tfShipCompany error with message [%s]  sql[%@]", errorMsg,deletesql);
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
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  tfShipCompany "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete tfShipCompany error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(NSMutableArray *) getTfShipCompany:(NSInteger)comid
{
	NSString *query=[NSString stringWithFormat:@" comid = '%d' ",comid];
	NSMutableArray * array=[TfShipCompanyDao getTfShipCompanyBySql:query];
	return array;
}
+(NSMutableArray *) getTfShipCompany
{
    
	NSString *query=@" 1=1 ";
	NSMutableArray * array=[TfShipCompanyDao getTfShipCompanyBySql:query];
    NSLog(@"执行 getTfShipCompany 数量[%d] ",[array count]);
	return array;
}
+(NSMutableArray *) getTfShipCompanyBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT comid,company,description,linkman,contact FROM  TfShipCompany WHERE %@ ",sql1];
    //NSLog(@"执行 getTfShipCompanyBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TfShipCompany *tfShipCompany=[[TfShipCompany alloc] init];
            
            tfShipCompany.comid = sqlite3_column_int(statement,0);

			char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tfShipCompany.company = nil;
            else
                tfShipCompany.company = [NSString stringWithUTF8String: rowData1];
            
            
			char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tfShipCompany.description = nil;
            else
                tfShipCompany.description = [NSString stringWithUTF8String: rowData2];
            
            
			char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                tfShipCompany.linkman = nil;
            else
                tfShipCompany.linkman = [NSString stringWithUTF8String: rowData3];
            
            
			char * rowData4=(char *)sqlite3_column_text(statement,4);
            if (rowData4 == NULL)
                tfShipCompany.contact = nil;
            else
                tfShipCompany.contact = [NSString stringWithUTF8String: rowData4];
            
                      
			[array addObject:tfShipCompany];
            [tfShipCompany release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);

	[array autorelease];
	return array;
}

@end
