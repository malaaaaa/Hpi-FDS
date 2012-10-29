//
//  TgShipDao.m
//  Hfds
//
//  Created by zcx on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TgShipDao.h"
#import "TgShip.h"
#import "PubInfo.h"
@implementation TgShipDao
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
		NSLog(@"open TgShip error");
		return;
	}
	NSLog(@"open TgShip database succes ....");
}
+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TgShip  (shipID INTEGER PRIMARY KEY ",
                         @",shipName TEXT ",
						 @",comID INTEGER ",
                         @",company TEXT ",
						 @",portCode TEXT ",
                         @",portName TEXT ",
                         @",factoryCode TEXT ",
                         @",factoryName TEXT ",
                         @",tripNo TEXT ",
                         @",supID INTEGER ",
                         @",supplier TEXT ",
                         @",heatValue INTEGER ",
                         @",lw INTEGER ",
                         @",length TEXT ",
                         @",width TEXT ",
                         @",draft TEXT ",
                         @",eta TEXT ",
                         @",lat TEXT ",
                         @",lon TEXT ",
                         @",sog TEXT ",
                         @",destination TEXT ",
                         @",infoTime TEXT ",
                         @",naviStat TEXT ",
                         @",online TEXT ",
                         @",stage TEXT ",
                         @",stageName TEXT ",
                         @",statCode TEXT ",
						 @",statName TEXT )"];
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TgShip error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(TgShip*) tgShip
{
//	NSLog(@"Insert begin tgShip");
	const char *insert="INSERT INTO TgShip (shipID,shipName,comID,company,portCode,portName,factoryCode,factoryName,tripNo,supID,supplier,heatValue,lw,length,width,draft,eta,lat,lon,sog,destination,infoTime,naviStat,online,stage,stageName,statCode,statName) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
//	NSLog(@"shipID=%d", tgShip.shipID);
//    NSLog(@"shipName=%@", tgShip.shipName);
//	NSLog(@"comID=%d", tgShip.comID);
//	NSLog(@"company=%@", tgShip.company);
//	NSLog(@"portCode=%@", tgShip.portCode);
//	NSLog(@"portName=%@", tgShip.portName);
//	NSLog(@"factoryCode=%@", tgShip.factoryCode);
//	NSLog(@"factoryName=%@", tgShip.factoryName);
//    NSLog(@"tripNo=%@", tgShip.tripNo);
//    NSLog(@"supID=%d", tgShip.supID);
//    NSLog(@"supplier=%@", tgShip.supplier);
//    NSLog(@"heatValue=%d", tgShip.heatValue);
//    NSLog(@"lw=%d", tgShip.lw);
//    NSLog(@"length=%@", tgShip.length);
//    NSLog(@"width=%@", tgShip.width);
//    NSLog(@"draft=%@", tgShip.draft);
//    NSLog(@"eta=%@", tgShip.eta);
//    NSLog(@"lat=%@", tgShip.lat);
//    NSLog(@"lon=%@", tgShip.lon);
//    NSLog(@"sog=%@", tgShip.sog);
//    NSLog(@"destination=%@", tgShip.destination);
//    NSLog(@"infoTime=%@", tgShip.infoTime);
//    NSLog(@"naviStat=%@", tgShip.naviStat);
//    NSLog(@"online=%@", tgShip.online);
//    NSLog(@"stage=%@", tgShip.stage);
//    NSLog(@"stageName=%@", tgShip.stageName);
//    NSLog(@"statCode=%@", tgShip.statCode);
//    NSLog(@"statName=%@", tgShip.statName);
    
	sqlite3_bind_int(statement, 1,tgShip.shipID);
	sqlite3_bind_text(statement, 2, [tgShip.shipName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 3, tgShip.comID);
    sqlite3_bind_text(statement, 4,[tgShip.company UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [tgShip.portCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [tgShip.portName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [tgShip.factoryCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [tgShip.factoryName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 9, [tgShip.tripNo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 10, tgShip.supID);
    sqlite3_bind_text(statement, 11, [tgShip.supplier UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 12, tgShip.heatValue);
    sqlite3_bind_int(statement, 13, tgShip.lw);
    sqlite3_bind_text(statement, 14,[tgShip.length UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 15,[tgShip.width UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 16,[tgShip.draft UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 17,[tgShip.eta UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 18,[tgShip.lat UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 19,[tgShip.lon UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 20,[tgShip.sog UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 21,[tgShip.destination UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 22,[tgShip.infoTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 23,[tgShip.naviStat UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 24,[tgShip.online UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 25,[tgShip.stage UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 26,[tgShip.stageName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 27,[tgShip.statCode UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 28,[tgShip.statName UTF8String], -1, SQLITE_TRANSIENT);
    
	re = sqlite3_step(statement);
	if(re!=SQLITE_DONE)
    {
		NSLog( @"Error: insert tgShip error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
    }
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(TgShip*) tgShip
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TgShip where shipID ='%d' ",tgShip.shipID];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TgShip error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
//		NSLog(@"delete success");		
	}
	return;
}
+(void) deleteAll
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TgShip "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TgShip error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
//		NSLog(@"delete success");
	}
	return;
}
+(NSMutableArray *) getTgShip:(NSInteger)shipID
{
	NSString *query=[NSString stringWithFormat:@" shipID = '%d' ",shipID];
	NSMutableArray * array=[TgShipDao getTgShipBySql:query];
	return array;
}
+(NSMutableArray *) getTgShip
{
    
	NSString *query=@" online = '1' ";
	NSMutableArray * array=[TgShipDao getTgShipBySql:query];
    NSLog(@"执行 getTgShip 数量[%d] ",[array count]);
	return array;
}

+(NSMutableArray *) getTgShipSZZTPort:(NSString *)portName
{
	NSString *query=[NSString stringWithFormat:@" portName ='%@' AND online='1' AND stage='0' ",portName];
	NSMutableArray * array=[TgShipDao getTgShipBySql:query];
    NSLog(@"执行 getTgShip 数量[%d] ",[array count]);
	return array;
}

+(NSMutableArray *) getTgShipZGPort:(NSString *)portName
{
	NSString *query=[NSString stringWithFormat:@" portName ='%@' AND online='1' AND stage='1' ",portName];
	NSMutableArray * array=[TgShipDao getTgShipBySql:query];
    NSLog(@"执行 getTgShip 数量[%d] ",[array count]);
	return array;
}

+(NSMutableArray *) getTgShipZCPort:(NSString *)factoryName
{
	NSString *query=[NSString stringWithFormat:@" online='1' AND factoryName ='%@'",factoryName];
	NSMutableArray * array=[TgShipDao getTgShipBySql:query];
    NSLog(@"执行 getTgShip 数量[%d] ",[array count]);
	return array;
}

+(NSMutableArray *) getTgShipByName:(NSString *)shipName
{
	NSString *query=[NSString stringWithFormat:@" shipName ='%@'",shipName];
	NSMutableArray * array=[TgShipDao getTgShipBySql:query];
    NSLog(@"执行 getTgShip 数量[%d] ",[array count]);
	return array;
}

+(NSMutableArray *) getTgShipZTPort:(NSString *)chooseShip :(NSString *)chooseFactory :(NSString *)choosePort
{
    NSLog(@"ship %@  factory %@ port %@",chooseShip,chooseFactory,choosePort);
    NSString *query=@" stage in ('0','2') ";
    if(![chooseShip isEqualToString:All_SHIP])
        query=[query stringByAppendingFormat:@" AND shipName ='%@' ",chooseShip];
    if(![choosePort isEqualToString:All_PORT])
        query=[query stringByAppendingFormat:@" AND portName ='%@' ",choosePort];
    if(![chooseFactory isEqualToString:All_FCTRY])
        query=[query stringByAppendingFormat:@" AND factoryName ='%@' ",chooseFactory];
	NSMutableArray * array=[TgShipDao getTgShipBySql:query];
    NSLog(@"执行 getTgShip 数量[%d] ",[array count]);
	return array;
}

+(NSMutableArray *) getTgShipBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT shipID,shipName,comID,company,portCode,portName,factoryCode,factoryName,tripNo,supID,supplier,heatValue,lw,length,width,draft,eta,lat,lon,sog,destination,infoTime,naviStat,online,stage,stageName,statCode,statName FROM  TgShip WHERE %@ ",sql1];
    NSLog(@"执行 getTgShipBySql [%@] ",sql);
    
	NSMutableArray *array=[[NSMutableArray alloc]init];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            TgShip *tgShip=[[TgShip alloc] init];
            tgShip.shipID = sqlite3_column_int(statement,0);
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                tgShip.shipName = nil;
            else
                tgShip.shipName = [NSString stringWithUTF8String: rowData1];
            
            tgShip.comID = sqlite3_column_int(statement,2);
            
            char * rowData3=(char *)sqlite3_column_text(statement,3);
            if (rowData3 == NULL)
                tgShip.company = nil;
            else
                tgShip.company = [NSString stringWithUTF8String: rowData3];
            
            char * rowData4=(char *)sqlite3_column_text(statement,4);
            if (rowData4 == NULL)
                tgShip.portCode = nil;
            else
                tgShip.portCode = [NSString stringWithUTF8String: rowData4];
            
            char * rowData5=(char *)sqlite3_column_text(statement,5);
            if (rowData5 == NULL)
                tgShip.portName = nil;
            else
                tgShip.portName = [NSString stringWithUTF8String: rowData5];
            
            char * rowData6=(char *)sqlite3_column_text(statement,6);
            if (rowData6 == NULL)
                tgShip.factoryCode = nil;
            else
                tgShip.factoryCode = [NSString stringWithUTF8String: rowData6];
            
            char * rowData7=(char *)sqlite3_column_text(statement,7);
            if (rowData7 == NULL)
                tgShip.factoryName = nil;
            else
                tgShip.factoryName = [NSString stringWithUTF8String: rowData7];
            
            char * rowData8=(char *)sqlite3_column_text(statement,8);
            if (rowData8 == NULL)
                tgShip.tripNo = nil;
            else
                tgShip.tripNo = [NSString stringWithUTF8String: rowData8];
            
            tgShip.supID = sqlite3_column_int(statement,9);
            
            char * rowData10=(char *)sqlite3_column_text(statement,10);
            if (rowData10 == NULL)
                tgShip.supplier = nil;
            else
                tgShip.supplier = [NSString stringWithUTF8String: rowData10];
            
            tgShip.heatValue = sqlite3_column_int(statement,11);
            tgShip.lw = sqlite3_column_int(statement,12);
            
			char * rowData13=(char *)sqlite3_column_text(statement,13);
            if (rowData13 == NULL)
                tgShip.length = nil;
            else
                tgShip.length = [NSString stringWithUTF8String: rowData13];
            
            char * rowData14=(char *)sqlite3_column_text(statement,14);
            if (rowData14 == NULL)
                tgShip.width = nil;
            else
                tgShip.width = [NSString stringWithUTF8String: rowData14];
            
            char * rowData15=(char *)sqlite3_column_text(statement,15);
            if (rowData15 == NULL)
                tgShip.draft = nil;
            else
                tgShip.draft = [NSString stringWithUTF8String: rowData15];
            
            char * rowData16=(char *)sqlite3_column_text(statement,16);
            if (rowData16 == NULL)
                tgShip.eta = nil;
            else
                tgShip.eta = [NSString stringWithUTF8String: rowData16];
            
            char * rowData17=(char *)sqlite3_column_text(statement,17);
            if (rowData17 == NULL)
                tgShip.lat = nil;
            else
                tgShip.lat = [NSString stringWithUTF8String: rowData17];
            
            char * rowData18=(char *)sqlite3_column_text(statement,18);
            if (rowData18 == NULL)
                tgShip.lon = nil;
            else
                tgShip.lon = [NSString stringWithUTF8String: rowData18];
            
            char * rowData19=(char *)sqlite3_column_text(statement,19);
            if (rowData19 == NULL)
                tgShip.sog = nil;
            else
                tgShip.sog = [NSString stringWithUTF8String: rowData19];
            
            char * rowData20=(char *)sqlite3_column_text(statement,20);
            if (rowData20 == NULL)
                tgShip.destination = nil;
            else
                tgShip.destination = [NSString stringWithUTF8String: rowData20];
            
            char * rowData21=(char *)sqlite3_column_text(statement,21);
            if (rowData21 == NULL)
                tgShip.infoTime = nil;
            else
                tgShip.infoTime = [NSString stringWithUTF8String: rowData21];
            
            char * rowData22=(char *)sqlite3_column_text(statement,22);
            if (rowData22 == NULL)
                tgShip.naviStat = nil;
            else
                tgShip.naviStat = [NSString stringWithUTF8String: rowData22];
            
            char * rowData23=(char *)sqlite3_column_text(statement,23);
            if (rowData23 == NULL)
                tgShip.online = nil;
            else
                tgShip.online = [NSString stringWithUTF8String: rowData23];
            
            char * rowData24=(char *)sqlite3_column_text(statement,24);
            if (rowData24 == NULL)
                tgShip.stage = nil;
            else
                tgShip.stage = [NSString stringWithUTF8String: rowData24];
            
            char * rowData25=(char *)sqlite3_column_text(statement,25);
            if (rowData25 == NULL)
                tgShip.stageName = nil;
            else
                tgShip.stageName = [NSString stringWithUTF8String: rowData25];
            
            char * rowData26=(char *)sqlite3_column_text(statement,26);
            if (rowData26 == NULL)
                tgShip.statCode = nil;
            else
                tgShip.statCode = [NSString stringWithUTF8String: rowData26];
            
            char * rowData27=(char *)sqlite3_column_text(statement,27);
            if (rowData27 == NULL)
                tgShip.statName = nil;
            else
                tgShip.statName = [NSString stringWithUTF8String: rowData27];
            
			[array addObject:tgShip];
            [tgShip release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	//zhangcx add
	[array autorelease];
	return array;
}

@end
