//
//  TsFileinfoDao.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TsFileinfoDao.h"
#import "TsFileinfo.h"
@implementation TsFileinfoDao
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
		NSLog(@"open TsFileinfo error");
		return;
	}
	NSLog(@"open TsFileinfo database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TsFileinfo  (fileId INTEGER PRIMARY KEY ",
						 @",fileType TEXT ",
						 @",title TEXT ",
						 @",filePath TEXT ",
						 @",fileName TEXT ",
						 @",userName TEXT ",
                         @",recordTime TEXT ",
                         @",xzbz TEXT )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TsFileinfo error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TsFileinfo*) tsFileinfo
{
	NSLog(@"Insert begin TsFileinfo");
	const char *insert="INSERT INTO TsFileinfo (fileId,fileType,title,filePath,fileName,userName,recordTime,xzbz) values(?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
	NSLog(@"fileId=%d", tsFileinfo.fileId);
	NSLog(@"fileType=%@", tsFileinfo.fileType);
	NSLog(@"title=%@", tsFileinfo.title);
	NSLog(@"filePath=%@", tsFileinfo.filePath);
	NSLog(@"fileName=%@", tsFileinfo.fileName);
	NSLog(@"userName=%@", tsFileinfo.userName);
	NSLog(@"recordTime=%@", tsFileinfo.recordTime);
    NSLog(@"xzbz=%@", tsFileinfo.xzbz);
	sqlite3_bind_int(statement, 1, tsFileinfo.fileId);
    sqlite3_bind_text(statement, 2, [tsFileinfo.fileType UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [tsFileinfo.title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [tsFileinfo.filePath UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [tsFileinfo.fileName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 6, [tsFileinfo.userName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [tsFileinfo.recordTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [tsFileinfo.xzbz UTF8String], -1, SQLITE_TRANSIENT);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert TsFileinfo error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TsFileinfo*) tsFileinfo
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TsFileinfo where fileId ='%d' ",tsFileinfo.fileId];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TsFileinfo error with message [%s]  sql[%@]", errorMsg,deletesql);
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
	NSString *deletesql=@"DELETE FROM  TsFileinfo";
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TsFileinfo error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}

+(NSMutableArray *) getTsFileinfo:(NSInteger)fileId
{
	NSString *query=[NSString stringWithFormat:@" fileId = '%d' ",fileId];
	NSMutableArray * array=[TsFileinfoDao getTsFileinfoBySql:query];
	return array;
}

+(NSMutableArray *) getTsFileinfoByType:(NSString *)type
{
	NSString *query=[NSString stringWithFormat:@" fileType = '%@' ",type];
	NSMutableArray * array=[TsFileinfoDao getTsFileinfoBySql:query];
	return array;
}

+(NSMutableArray *) getTsFileinfo
{
    [self updatezbz];
	NSString *query=@" 1 = 1 ORDER BY fileId DESC;  ";
	NSMutableArray * array=[TsFileinfoDao getTsFileinfoBySql:query];
    NSLog(@"执行 getTsFileinfo 数量[%d] ",[array count]);
	return array;
}

+(NSMutableArray *) getTsFileNeedDown:(NSInteger)fileId
{
	NSString *query=[NSString stringWithFormat:@" fileId = '%d' ",fileId];
	NSMutableArray * array=[TsFileinfoDao getTsFileinfoBySql:query];
	return array;
}

+(void) deleteNotDownload
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TsFileinfo where xzbz ='0'"];
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TsFileinfo error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}

+(BOOL)tsFileHasDownload
{
    NSString *query=@"SELECT  count(fileId)  FROM  TsFileinfo WHERE xzbz='2' ";
	NSLog(@"isExist [%@]",query);
	sqlite3_stmt	*statement;
	if(sqlite3_prepare_v2(database,[query UTF8String],-1,&statement,nil)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			char * rowData0=(char *)sqlite3_column_text(statement,0);
			int num=[[[NSString alloc] initWithUTF8String:rowData0]intValue] ;
			if(num>0)
				return YES;
			else
				return  NO;
		}
	}else {
		return NO;
	}
    return NO;
}

+(BOOL)tsFileIsDownload:(NSInteger)fileId
{
    NSString *query=[NSString stringWithFormat:@"SELECT  count(fileId)  FROM  TsFileinfo WHERE fileId = '%d' AND xzbz='1' ",fileId];
	NSLog(@"isExist [%@]",query);
	sqlite3_stmt	*statement;
	if(sqlite3_prepare_v2(database,[query UTF8String],-1,&statement,nil)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			char * rowData0=(char *)sqlite3_column_text(statement,0);
			int num=[[[NSString alloc] initWithUTF8String:rowData0]intValue] ;
			if(num>0)
				return YES;
			else
				return  NO;
		}
	}else {
		return NO;
	}
    return NO;
}


+(NSMutableArray *) getTsFileinfoBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT fileId,fileType,title,filePath,fileName,userName,recordTime,xzbz FROM  TsFileinfo WHERE %@ ORDER BY recordTime DESC",sql1];
    NSLog(@"执行 getTsFileinfoBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TsFileinfo *tsFileinfo=[[TsFileinfo alloc] init];
            tsFileinfo.fileId = sqlite3_column_int(statement,0);            
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tsFileinfo.fileType = nil;
            else
                tsFileinfo.fileType = [NSString stringWithUTF8String: rowData1];    
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                tsFileinfo.title = nil;
            else
                tsFileinfo.title = [NSString stringWithUTF8String: rowData2];   
            
            char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                tsFileinfo.filePath = nil;
            else
                tsFileinfo.filePath = [NSString stringWithUTF8String: rowData3];   
            
            char * rowData4=(char *)sqlite3_column_text(statement,4);
            if (rowData4 == NULL)
                tsFileinfo.fileName = nil;
            else
                tsFileinfo.fileName = [NSString stringWithUTF8String: rowData4];            
            
            char * rowData5=(char *)sqlite3_column_text(statement,5);
            if (rowData5 == NULL)
                tsFileinfo.userName = nil;
            else
                tsFileinfo.userName = [NSString stringWithUTF8String: rowData5];  
            
			char * rowData6=(char *)sqlite3_column_text(statement,6);
            if (rowData6 == NULL)
                tsFileinfo.recordTime = nil;
            else
                tsFileinfo.recordTime = [NSString stringWithUTF8String: rowData6];
            
            char * rowData7=(char *)sqlite3_column_text(statement,7);
            if (rowData7 == NULL)
                tsFileinfo.xzbz = nil;
            else
                tsFileinfo.xzbz = [NSString stringWithUTF8String: rowData7];
            
            
			[array addObject:tsFileinfo];
            [tsFileinfo release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return array;
}

//zhangcx add
+(void) updateTsFileXzbz:(NSInteger) fileId :(NSString *)xzbz
{
	NSString *updateSql=[NSString stringWithFormat:@"update  TsFileinfo  set xzbz='%@' where FILEID='%d' ",xzbz,fileId];
	if(sqlite3_exec(database,[updateSql UTF8String],NULL,NULL,NULL)!=SQLITE_OK)
	{
		NSLog( @"Error: update data error with message [%s]  sql[%@]", sqlite3_errmsg(database),updateSql);		
	}
	else
	{
		NSLog(@"update success");
		
	}
	return;	
}

//zhangcx add
+(void) updatezbz
{
	NSString *updateSql=@"update TsFileinfo  set xzbz='0' where xzbz='2' ";
	if(sqlite3_exec(database,[updateSql UTF8String],NULL,NULL,NULL)!=SQLITE_OK)
	{
		NSLog( @"Error: update data error with message [%s]  sql[%@]", sqlite3_errmsg(database),updateSql);		
	}
	else
	{
		NSLog(@"update success");
		
	}
	return;	
}
+(void) updateDown
{
	NSString *updateSql=@"update TsFileinfo  set xzbz='0' where xzbz='1' ";
	if(sqlite3_exec(database,[updateSql UTF8String],NULL,NULL,NULL)!=SQLITE_OK)
	{
		NSLog( @"Error: update data error with message [%s]  sql[%@]", sqlite3_errmsg(database),updateSql);		
	}
	else
	{
		NSLog(@"update success");
		
	}
	return;	
}
@end
