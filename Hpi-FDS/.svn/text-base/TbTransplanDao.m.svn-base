//
//  TbTransplanDao.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-25.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TbTransplanDao.h"
#import "TbTransplan.h"

@implementation TbTransplanDao
static sqlite3	*database;

+(NSString  *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"TbTransplan.db"];
	return	 path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open TbTransplan error");
		return;
	}
	NSLog(@"open TbTransplan database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TbTransplan  (planCode TEXT PRIMARY KEY ",
                         @",planMonth TEXT ",
						 @",shipID INTEGER ",
                         @",factoryCode TEXT ",
                         @",portCode TEXT ",
                         @",tripNo TEXT ",
                         @",eTap TEXT ",
                         @",eTaf TEXT ",
						 @",eLw INTEGER ",
						 @",supID INTEGER ",
						 @",typeID INTEGER ",
                         @",keyValue TEXT ",
                         @",schedule TEXT ",
                         @",description TEXT ",
                         @",serialNo TEXT )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TbTransplan error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TbTransplan*) tbTransplan
{
	NSLog(@"Insert begin TbTransplan");
	const char *insert="INSERT INTO TbTransplan (planCode,planMonth,shipID,factoryCode,portCode,tripNo,eTap,eTaf,eLw,supID,typeID,keyValue,schedule,description,serialNo) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
	NSLog(@"planCode=%@", tbTransplan.planCode);
    NSLog(@"planMonth=%@", tbTransplan.planMonth);
	NSLog(@"shipID=%d", tbTransplan.shipID);
    NSLog(@"factoryCode=%@", tbTransplan.factoryCode);
    NSLog(@"portCode=%@", tbTransplan.portCode);
    NSLog(@"tripNo=%@", tbTransplan.tripNo);
    NSLog(@"eTap=%@", tbTransplan.eTap);
    NSLog(@"eTaf=%@", tbTransplan.eTaf);
	NSLog(@"eLw=%d", tbTransplan.eLw);
	NSLog(@"supID=%d", tbTransplan.supID);
	NSLog(@"typeID=%d", tbTransplan.typeID);
    NSLog(@"keyValue=%@", tbTransplan.keyValue);
    NSLog(@"schedule=%@", tbTransplan.schedule);
    NSLog(@"description=%@", tbTransplan.description);
    NSLog(@"serialNo=%@", tbTransplan.serialNo);
    
	sqlite3_bind_text(statement, 1, [tbTransplan.planCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [tbTransplan.planMonth UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(statement, 3, tbTransplan.shipID);
    sqlite3_bind_text(statement, 4, [tbTransplan.factoryCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [tbTransplan.portCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [tbTransplan.tripNo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [tbTransplan.eTap UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [tbTransplan.eTaf UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 9, tbTransplan.eLw);
    sqlite3_bind_int(statement, 10, tbTransplan.supID);
    sqlite3_bind_int(statement, 11, tbTransplan.typeID);
    sqlite3_bind_text(statement, 12, [tbTransplan.keyValue UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 13, [tbTransplan.schedule UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 14, [tbTransplan.description UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 15, [tbTransplan.serialNo UTF8String], -1, SQLITE_TRANSIENT);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert TbTransplan error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TbTransplan*) tbTransplan
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TbTransplan where planCode ='%@' ",tbTransplan.planCode];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TbTransplan error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}

+(NSMutableArray *) getTbTransplan:(NSString *)planCode
{
	NSString *query=[NSString stringWithFormat:@" TbTransplan = '%@' ",planCode];
	NSMutableArray * array=[TbTransplanDao getTbTransplanBySql:query];
	return array;
}
+(NSMutableArray *) getTbTransplan
{
    
	NSString *query=[NSString stringWithString:@" lon <> 0 "];
	NSMutableArray * array=[TbTransplanDao getTbTransplanBySql:query];
    NSLog(@"执行 getTgPort 数量[%d] ",[array count]);
	return array;
}
+(NSMutableArray *) getTbTransplanBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT planCode,planMonth,shipID,factoryCode,portCode,tripNo,eTap,eTaf,eLw,supID,typeID,keyValue,schedule,description,serialNo FROM  TbTransplan WHERE %@ ",sql1];
    NSLog(@"执行 getTbTransplanBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TbTransplan *tbTransplan=[[TbTransplan alloc] init];
			char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                tbTransplan.planCode = nil;
            else
                tbTransplan.planCode = [NSString stringWithUTF8String: rowData0];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tbTransplan.planMonth = nil;
            else
                tbTransplan.planMonth = [NSString stringWithUTF8String: rowData1];
            
            tbTransplan.shipID = sqlite3_column_int(statement,2);
            
            char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                tbTransplan.factoryCode = nil;
            else
                tbTransplan.factoryCode = [NSString stringWithUTF8String: rowData3];
            
            char * rowData4=(char *)sqlite3_column_text(statement,4);
            if (rowData4 == NULL)
                tbTransplan.portCode = nil;
            else
                tbTransplan.portCode = [NSString stringWithUTF8String: rowData4];
            
            char * rowData5=(char *)sqlite3_column_text(statement,5);
            if (rowData5 == NULL)
                tbTransplan.tripNo = nil;
            else
                tbTransplan.tripNo = [NSString stringWithUTF8String: rowData5];
            
            char * rowData6=(char *)sqlite3_column_text(statement,6);
            if (rowData6 == NULL)
                tbTransplan.eTap = nil;
            else
                tbTransplan.eTap = [NSString stringWithUTF8String: rowData6];
            
            char * rowData7=(char *)sqlite3_column_text(statement,7);
            if (rowData7 == NULL)
                tbTransplan.eTaf = nil;
            else
                tbTransplan.eTaf = [NSString stringWithUTF8String: rowData7];
            
            tbTransplan.eLw = sqlite3_column_int(statement,8);
            
            tbTransplan.supID = sqlite3_column_int(statement,9);
            
            tbTransplan.typeID = sqlite3_column_int(statement,10);
            
            
            char * rowData11=(char *)sqlite3_column_text(statement,11);
            if (rowData11 == NULL)
                tbTransplan.keyValue = nil;
            else
                tbTransplan.keyValue = [NSString stringWithUTF8String: rowData11];
            
            char * rowData12=(char *)sqlite3_column_text(statement,12);
            if (rowData12 == NULL)
                tbTransplan.schedule = nil;
            else
                tbTransplan.schedule = [NSString stringWithUTF8String: rowData12];
            
            char * rowData13=(char *)sqlite3_column_text(statement,13);
            if (rowData13 == NULL)
                tbTransplan.description = nil;
            else
                tbTransplan.description = [NSString stringWithUTF8String: rowData13];
            
            char * rowData14=(char *)sqlite3_column_text(statement,14);
            if (rowData14 == NULL)
                tbTransplan.serialNo = nil;
            else
                tbTransplan.serialNo = [NSString stringWithUTF8String: rowData14];
            
			[array addObject:tbTransplan];
            [tbTransplan release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	//zhangcx add
	[array autorelease];
	return array;
}

@end
