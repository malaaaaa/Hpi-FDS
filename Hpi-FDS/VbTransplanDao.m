//
//  VbTransplanDao.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-3.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VbTransplanDao.h"
#import "VbTransplan.h"
#import "PubInfo.h"
@implementation VbTransplanDao
static sqlite3	*database;

+(NSString  *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"database.db"];
    
    //NSLog(@"VbTransplan:path========%@",path);
	return	 path;
}

+(void) openDataBase
{	
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		//NSLog(@"open VbTransplan error");
		return;
	}
	//NSLog(@"open VbTransplan database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS VbTransplan  (planCode TEXT PRIMARY KEY ",
                         @",planMonth TEXT ",
						 @",shipID INTEGER ",
                         @",shipName TEXT ",
                         @",factoryCode TEXT ",
                         @",factoryName TEXT ",
                         @",portCode TEXT ",
                         @",portName TEXT ",
                         @",tripNo TEXT ",
                         @",eTap TEXT ",
                         @",eTaf TEXT ",
						 @",eLw INTEGER ",
						 @",supID INTEGER ",
                         @",supplier TEXT ",
						 @",typeID INTEGER ",
                         @",coalType TEXT ",
                         @",keyValue TEXT ",
                         @",keyName TEXT ",
                         @",schedule TEXT ",
                         @",description TEXT ",
                         @",serialNo INTEGER ",
                         @",facSort TEXT ",
                         @",heatvalue double ",
                         
                         @",sulfur double )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table VbTransplan error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(VbTransplan*) vbTransplan
{
	//NSLog(@"Insert begin VbTransplan");
	const char *insert="INSERT INTO VbTransplan (planCode,planMonth,shipID,shipName,factoryCode,factoryName,portCode,portName,tripNo,eTap,eTaf,eLw,supID,supplier,typeID,coalType,keyValue,keyName,schedule,description,serialNo,facSort,heatvalue,sulfur) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    
	sqlite3_bind_text(statement, 1, [vbTransplan.planCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [vbTransplan.planMonth UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(statement, 3, vbTransplan.shipID);
    sqlite3_bind_text(statement, 4, [vbTransplan.shipName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [vbTransplan.factoryCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [vbTransplan.factoryName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [vbTransplan.portCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [vbTransplan.portName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 9, [vbTransplan.tripNo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 10, [vbTransplan.eTap UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 11, [vbTransplan.eTaf UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 12, vbTransplan.eLw);
    sqlite3_bind_int(statement, 13, vbTransplan.supID);
    sqlite3_bind_text(statement, 14, [vbTransplan.supplier UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 15, vbTransplan.typeID);
    sqlite3_bind_text(statement, 16, [vbTransplan.coalType UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 17, [vbTransplan.keyValue UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 18, [vbTransplan.keyName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 19, [vbTransplan.schedule UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 20, [vbTransplan.description UTF8String], -1, SQLITE_TRANSIENT);
    
    
    sqlite3_bind_int(statement, 21, vbTransplan.serialNo);
    
    
    
    sqlite3_bind_text(statement, 22, [vbTransplan.facSort UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_double(statement, 23, vbTransplan.heatvalue);
    sqlite3_bind_double(statement, 24, vbTransplan.sulfur);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert VbTransplan error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(VbTransplan*) vbTransplan
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  VbTransplan where planCode ='%@' ",vbTransplan.planCode];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete VbTransplan error with message [%s]  sql[%@]", errorMsg,deletesql);
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
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  VbTransplan "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete VbTransplan error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(NSMutableArray *) getVbTransplan:(NSString *)planCode
{
	NSString *query=[NSString stringWithFormat:@" VbTransplan = '%@' ",planCode];
	NSMutableArray * array=[VbTransplanDao getVbTransplanBySql:query];
	return array;
}
+(NSMutableArray *) getVbTransplan
{
    
	NSString *query=@" lon <> 0 ";
	NSMutableArray * array=[VbTransplanDao getVbTransplanBySql:query];
   // NSLog(@"执行 getVbTransplan 数量[%d] ",[array count]);
	return array;
}
//:(NSString *)coalType    :(NSString *)planCode   去掉没种 和  计划单号 查询条件

+(NSMutableArray *) getVbTransplan:(NSString *)shipCompany :(NSString *)shipName :(NSString *)portName :(NSString *)factoryName :(NSString *)dateTime
{
    NSString *query=@" 1=1  ";
    
    if(![shipCompany isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND shipCompany ='%@' ",shipCompany];
    if(![shipName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND shipName ='%@' ",shipName];
    if(![portName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND portName ='%@' ",portName];
    
    
    
    /*
    if (![coalType isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"AND coalType='%@' ",coalType];
    }*/
    
    if(![factoryName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND factoryName ='%@' ",factoryName];
    
    
    //201207
    if (![dateTime isEqualToString:All_])        
        //计划月份
        query=[query stringByAppendingFormat:@"AND planMonth='%@' ",dateTime];
    
    
     /*
    if ([planCode length]!=0||planCode==nil) {
        query=[query stringByAppendingFormat:@"AND planCode='%@' ",planCode];
        
    }*/

	NSMutableArray * array=[VbTransplanDao getVbTransplanBySql:query];
   // NSLog(@"执行  getVbTransplanBySql 数量[%d] ",[array count]);
	return array;
}

+(NSMutableArray *) getVbTransplanBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT planCode,planMonth,shipID,shipName,factoryCode,factoryName,portCode,portName,tripNo,eTap,eTaf, round(  eLw/10000.0,2) as eLw,supID,supplier,typeID,coalType,keyValue,keyName,schedule,description,serialNo,facSort ,heatvalue,sulfur  FROM  VbTransplan WHERE %@  order by   planMonth  desc  ,factoryName  asc,  serialNo  desc",sql1];
//    NSLog(@"执行 getVbTransplanBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            VbTransplan *vbTransplan=[[VbTransplan alloc] init];
			char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                vbTransplan.planCode = nil;
            else
                vbTransplan.planCode = [NSString stringWithUTF8String: rowData0];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                vbTransplan.planMonth = nil;
            else
                vbTransplan.planMonth = [NSString stringWithUTF8String: rowData1];
            
            vbTransplan.shipID = sqlite3_column_int(statement,2);
            
            char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                vbTransplan.shipName = nil;
            else
                vbTransplan.shipName = [NSString stringWithUTF8String: rowData3];
            
            char * rowData4=(char *)sqlite3_column_text(statement,4);
            if (rowData4 == NULL)
                vbTransplan.factoryCode = nil;
            else
                vbTransplan.factoryCode = [NSString stringWithUTF8String: rowData4];
            
            char * rowData5=(char *)sqlite3_column_text(statement,5);
            if (rowData5 == NULL)
                vbTransplan.factoryName = nil;
            else
                vbTransplan.factoryName = [NSString stringWithUTF8String: rowData5];
            
            char * rowData6=(char *)sqlite3_column_text(statement,6);
            if (rowData6 == NULL)
                vbTransplan.portCode = nil;
            else
                vbTransplan.portCode = [NSString stringWithUTF8String: rowData6];
            
            char * rowData7=(char *)sqlite3_column_text(statement,7);
            if (rowData7 == NULL)
                vbTransplan.portName = nil;
            else
                vbTransplan.portName = [NSString stringWithUTF8String: rowData7];
            
            char * rowData8=(char *)sqlite3_column_text(statement,8);
            if (rowData8 == NULL)
                vbTransplan.tripNo = nil;
            else
                vbTransplan.tripNo = [NSString stringWithUTF8String: rowData8];
            
            
            //处理显示时间
            char * rowData9=(char *)sqlite3_column_text(statement,9);
            if (rowData9 == NULL)
                vbTransplan.eTap = nil;
            else
                vbTransplan.eTap = [NSString stringWithUTF8String: rowData9];
            
          //  NSLog(@"--------读取时间为%@",vbTransplan.eTap);
            
            char * rowData10=(char *)sqlite3_column_text(statement,10);
            if (rowData10 == NULL)
                vbTransplan.eTaf = nil;
            else
                vbTransplan.eTaf = [NSString stringWithUTF8String: rowData10];
                   
            vbTransplan.eLw = sqlite3_column_double(statement,11);
            
            vbTransplan.supID = sqlite3_column_int(statement,12);
            
            char * rowData13=(char *)sqlite3_column_text(statement,13);
            if (rowData13 == NULL)
                vbTransplan.supplier = nil;
            else
                vbTransplan.supplier = [NSString stringWithUTF8String: rowData13];
            
            vbTransplan.typeID = sqlite3_column_int(statement,14);
            
            char * rowData15=(char *)sqlite3_column_text(statement,15);
            if (rowData15 == NULL)
                vbTransplan.coalType = nil;
            else
                vbTransplan.coalType = [NSString stringWithUTF8String: rowData15];
            
            
            char * rowData16=(char *)sqlite3_column_text(statement,16);
            if (rowData16 == NULL)
                vbTransplan.keyValue = nil;
            else
                vbTransplan.keyValue = [NSString stringWithUTF8String: rowData16];
            
            char * rowData17=(char *)sqlite3_column_text(statement,17);
            if (rowData17 == NULL)
                vbTransplan.keyName = nil;
            else
                vbTransplan.keyName = [NSString stringWithUTF8String: rowData17];
            
            char * rowData18=(char *)sqlite3_column_text(statement,18);
            if (rowData18 == NULL)
                vbTransplan.schedule = nil;
            else
                vbTransplan.schedule = [NSString stringWithUTF8String: rowData18];
            
            char * rowData19=(char *)sqlite3_column_text(statement,19);
            if (rowData19 == NULL)
                vbTransplan.description = nil;
            else
                vbTransplan.description = [NSString stringWithUTF8String: rowData19];
            
            vbTransplan.serialNo=sqlite3_column_int (statement,20);
                      
            char * rowData21=(char *)sqlite3_column_text(statement,21);
            if (rowData21 == NULL)
                vbTransplan.facSort = nil;
            else
                vbTransplan.facSort = [NSString stringWithUTF8String: rowData21];
            
            vbTransplan.heatvalue = sqlite3_column_double (statement,22);

             vbTransplan.sulfur = sqlite3_column_double(statement,23);
            
			[array addObject:vbTransplan];
            [vbTransplan release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	[array autorelease];
	return array;
}

//为地图中船舶相信信息界面中剩余航运计划使用
+(NSMutableArray *) getVbTransplanByTripNO:(NSString *)tripNO ShipID:(NSInteger)shipID
{
	NSString *query=[NSString stringWithFormat:@" shipID = %d and round(tripNO)>%@",shipID,tripNO];
	NSMutableArray * array=[VbTransplanDao getVbTransplanBySql:query];
	return array;
}
@end
