//
//  VbShiptransDao.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VbShiptransDao.h"
#import "VbShiptrans.h"
#import "PubInfo.h"
@implementation VbShiptransDao
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
		NSLog(@"open database.db error");
		return;
	}
	NSLog(@"open database.db succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS VbShiptrans  (dispatchNo TEXT PRIMARY KEY ",
						 @",shipCompanyId INTEGER ",
                         @",shipCompany TEXT ",
						 @",shipId INTEGER ",
                         @",shipName TEXT ",
                         @",tripNo TEXT ",
                         @",factoryCode TEXT ",
                         @",factoryName TEXT ",
                         @",portCode TEXT ",
                         @",portName TEXT ",
						 @",supId INTEGER ",
                         @",supplier TEXT ",
						 @",typeId INTEGER ",
                         @",coalType TEXT ",
                         @",keyValue TEXT ",
                         @",keyName TEXT ",
                         @",trade TEXT ",
                         @",tradeName TEXT ",
						 @",heatValue INTEGER ",
                         @",stage TEXT ",
                         @",stageName TEXT ",
                         @",stateCode TEXT ",
                         @",stateName TEXT ",
                         @",lw INTEGER ",
                         @",p_AnchorageTime TEXT ",
                         @",p_Handle TEXT ",
                         @",p_ArrivalTime TEXT ",
                         @",p_DepartTime TEXT ",
                         @",p_Note TEXT ",
                         @",t_Note TEXT ",
                         @",f_AnchorageTime TEXT ",
                         @",f_ArrivalTime TEXT ",
                         @",f_DepartTime TEXT ",
                         @",f_Note TEXT ",
                         @",lateFee INTEGER ",
                         @",offEfficiency INTEGER ",
                         @",schedule TEXT ",
                         @",planType TEXT ",
                         @",planCode TEXT ",
                         @",laycanStart TEXT ",
                         @",laycanStop TEXT ",
                         @",reciept TEXT ",
                         @",shipShift TEXT ",
                         @",facSort INTEGER ",
                         @",tradeTime TEXT  ",
                         @",f_finishtime TEXT  ",
                         @",iscal TEXT )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table VbShiptrans error");
		printf("%s",errorMsg);
		return;
		
	}else{
    
        NSLog(@"[%@]",createSql);
        NSLog(@"create table VbShiptrans  seccess....................");
    }
}

+(void)insert:(VbShiptrans*) vbShiptrans
{
	NSLog(@"Insert begin VbShiptrans");
	const char *insert="INSERT INTO VbShiptrans (disPatchNo,shipCompanyId,shipCompany,shipId,shipName,tripNo,factoryCode,factoryName,portCode,portName,supId,supplier,typeId,coalType,keyValue,keyName,trade,tradeName,heatValue,stage,stageName,stateCode,stateName,lw,p_AnchorageTime,p_Handle,p_ArrivalTime,p_DepartTime,p_Note,t_Note,f_AnchorageTime,f_ArrivalTime,f_DepartTime,f_Note,lateFee,offEfficiency,schedule,planType,planCode,laycanStart,laycanStop,reciept,shipShift,facSort,tradeTime,f_finishtime,iscal) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    
    NSLog(@"disPatchNo=%@", vbShiptrans.disPatchNo);
    NSLog(@"shipCompanyId=%d", vbShiptrans.shipCompanyId);
    NSLog(@"shipCompany=%@", vbShiptrans.shipCompany);
    NSLog(@"shipId=%d", vbShiptrans.shipId);
    NSLog(@"shipName=%@", vbShiptrans.shipName);
    NSLog(@"tripNo=%@", vbShiptrans.tripNo);
    NSLog(@"factoryCode=%@", vbShiptrans.factoryCode);
    NSLog(@"factoryName=%@", vbShiptrans.factoryName);
    NSLog(@"portCode=%@", vbShiptrans.portCode);
    NSLog(@"portName=%@", vbShiptrans.portName);
    NSLog(@"supId=%d", vbShiptrans.supId);
    NSLog(@"supplier=%@", vbShiptrans.supplier);
    NSLog(@"typeId=%d", vbShiptrans.typeId);
    NSLog(@"coalType=%@", vbShiptrans.coalType);
    NSLog(@"keyValue=%@", vbShiptrans.keyValue);
    NSLog(@"keyName=%@", vbShiptrans.keyName);
    NSLog(@"trade=%@", vbShiptrans.trade);
    NSLog(@"tradeName=%@", vbShiptrans.tradeName);
    NSLog(@"heatValue=%d", vbShiptrans.heatValue);
    NSLog(@"stage=%@", vbShiptrans.stage);
    NSLog(@"stageName=%@", vbShiptrans.stageName);
    NSLog(@"stateCode=%@", vbShiptrans.stateCode);
    NSLog(@"stateName=%@", vbShiptrans.stateName);
    NSLog(@"lw=%d", vbShiptrans.lw);
    NSLog(@"p_AnchorageTime=%@", vbShiptrans.p_AnchorageTime);
    NSLog(@"p_Handle=%@", vbShiptrans.p_Handle);
    NSLog(@"p_ArrivalTime=%@", vbShiptrans.p_ArrivalTime);
    NSLog(@"p_DepartTime=%@", vbShiptrans.p_DepartTime);
    NSLog(@"p_Note=%@", vbShiptrans.p_Note);
    NSLog(@"t_Note=%@", vbShiptrans.t_Note);
    NSLog(@"f_AnchorageTime=%@", vbShiptrans.f_AnchorageTime);
    NSLog(@"f_ArrivalTime=%@", vbShiptrans.f_ArrivalTime);
    NSLog(@"f_DepartTime=%@", vbShiptrans.f_DepartTime);
    NSLog(@"f_Note=%@", vbShiptrans.f_Note);
    NSLog(@"lateFee=%d", vbShiptrans.lateFee);
    NSLog(@"offEfficiency=%d", vbShiptrans.offEfficiency);
    NSLog(@"schedule=%@", vbShiptrans.schedule);
    NSLog(@"planType=%@", vbShiptrans.planType);
    NSLog(@"planCode=%@", vbShiptrans.planCode);
    NSLog(@"laycanStart=%@", vbShiptrans.laycanStart);
    NSLog(@"laycanStop=%@", vbShiptrans.laycanStop);
    NSLog(@"reciept=%@", vbShiptrans.reciept);
    NSLog(@"shipShift=%@", vbShiptrans.shipShift);
    NSLog(@"facSort=%d", vbShiptrans.facSort);
    NSLog(@"tradeTime=%@", vbShiptrans.tradeTime);
     NSLog(@"-----------------------------------------新添字段F_FINISHTIME=%@",vbShiptrans.F_FINISHTIME);
    NSLog(@"-----------------------------------------新添字段iscal=%@",vbShiptrans.iscal);
    
	sqlite3_bind_text(statement, 1, [vbShiptrans.disPatchNo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 2, vbShiptrans.shipCompanyId);
    sqlite3_bind_text(statement, 3, [vbShiptrans.shipCompany UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 4, vbShiptrans.shipId);
    sqlite3_bind_text(statement, 5, [vbShiptrans.shipName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [vbShiptrans.tripNo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [vbShiptrans.factoryCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [vbShiptrans.factoryName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 9, [vbShiptrans.portCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 10, [vbShiptrans.portName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 11, vbShiptrans.supId);
    sqlite3_bind_text(statement, 12, [vbShiptrans.supplier UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 13, vbShiptrans.typeId);
    sqlite3_bind_text(statement, 14, [vbShiptrans.coalType UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 15, [vbShiptrans.keyValue UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 16, [vbShiptrans.keyName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 17, [vbShiptrans.trade UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 18, [vbShiptrans.tradeName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 19, vbShiptrans.heatValue);
    sqlite3_bind_text(statement, 20, [vbShiptrans.stage UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 21, [vbShiptrans.stageName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 22, [vbShiptrans.stateCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 23, [vbShiptrans.stateName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 24, vbShiptrans.lw);
    sqlite3_bind_text(statement, 25, [vbShiptrans.p_AnchorageTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 26, [vbShiptrans.p_Handle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 27, [vbShiptrans.p_ArrivalTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 28, [vbShiptrans.p_DepartTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 29, [vbShiptrans.p_Note UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 30, [vbShiptrans.t_Note UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 31, [vbShiptrans.f_AnchorageTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 32, [vbShiptrans.f_ArrivalTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 33, [vbShiptrans.f_DepartTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 34, [vbShiptrans.f_Note UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 35, vbShiptrans.lateFee);
    sqlite3_bind_int(statement, 36, vbShiptrans.offEfficiency);
    sqlite3_bind_text(statement, 37, [vbShiptrans.schedule UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 38, [vbShiptrans.planType UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 39, [vbShiptrans.planCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 40, [vbShiptrans.laycanStart UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 41, [vbShiptrans.laycanStop UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 42, [vbShiptrans.reciept UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 43, [vbShiptrans.shipShift UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 44, vbShiptrans.facSort);
    sqlite3_bind_text(statement, 45, [vbShiptrans.tradeTime UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 46, [vbShiptrans.F_FINISHTIME   UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 47, [vbShiptrans.iscal   UTF8String], -1, SQLITE_TRANSIENT);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert VbShiptrans error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}else{
    
        NSLog(@"insert seccess..................");
    
    }
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(VbShiptrans*) vbShiptrans
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  VbShiptrans where dispatchNo ='%@' ",vbShiptrans.disPatchNo];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete VbShiptrans error with message [%s]  sql[%@]", errorMsg,deletesql);
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
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  VbShiptrans "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete VbShiptrans error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}
+(NSMutableArray *) getVbShiptrans:(NSString *)dispatchNo
{
	NSString *query=[NSString stringWithFormat:@" dispatchNo = '%@' ",dispatchNo];
	NSMutableArray * array=[VbShiptransDao getVbShiptransBySql:query];
	return array;
}
+(NSMutableArray *) getVbShiptrans:(NSString *)shipCompany :(NSString *)shipName :(NSString *)portName :(NSString *)factoryName :(NSString *)stageName
{
    NSString *query=@" 1=1  ";
    
    if(![shipCompany isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND shipCompany ='%@' ",shipCompany];
    if(![shipName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND shipName ='%@' ",shipName];
    if(![portName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND portName ='%@' ",portName];
    if(![factoryName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND factoryName ='%@' ",factoryName];
    if(![stageName isEqualToString:All_])
        query=[query stringByAppendingFormat:@" AND stageName ='%@' ",stageName];
	NSMutableArray * array=[VbShiptransDao getVbShiptransBySql:query] ;
    NSLog(@"--------执行 getVbShiptransBySql 数量[%d] ",[array count]);
	return array;
}
+(NSMutableArray *) getVbShiptransBySql:(NSString *)sql1
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT disPatchNo,shipCompanyId,shipCompany,shipId,shipName,tripNo,factoryCode,factoryName,portCode,portName,supId,supplier,typeId,coalType,keyValue,keyName,trade,tradeName,heatValue,stage,stageName,stateCode,stateName,lw,p_AnchorageTime,p_Handle,p_ArrivalTime,p_DepartTime,p_Note,t_Note,f_AnchorageTime,f_ArrivalTime,f_DepartTime,f_Note,lateFee,offEfficiency,schedule,planType,planCode,laycanStart,laycanStop,reciept,shipShift,facSort,tradeTime,f_finishtime,iscal FROM  VbShiptrans WHERE %@ ",sql1];
    NSLog(@"执行 getVbShiptransBySql [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease] ;
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            VbShiptrans *vbShiptrans=[[VbShiptrans alloc] init];
			char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                vbShiptrans.disPatchNo = nil;
            else
                vbShiptrans.disPatchNo = [NSString stringWithUTF8String: rowData0];
            
            vbShiptrans.shipCompanyId = sqlite3_column_int(statement,1);
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                vbShiptrans.shipCompany = nil;
            else
                vbShiptrans.shipCompany = [NSString stringWithUTF8String: rowData2];
            
            vbShiptrans.shipId = sqlite3_column_int(statement,3);
            
            char * rowData4=(char *)sqlite3_column_text(statement,4);
            if (rowData4 == NULL)
                vbShiptrans.shipName = nil;
            else
                vbShiptrans.shipName = [NSString stringWithUTF8String: rowData4];
            
            char * rowData5=(char *)sqlite3_column_text(statement,5);
            if (rowData5 == NULL)
                vbShiptrans.tripNo = nil;
            else
                vbShiptrans.tripNo = [NSString stringWithUTF8String: rowData5];
            
            char * rowData6=(char *)sqlite3_column_text(statement,6);
            if (rowData6 == NULL)
                vbShiptrans.factoryCode = nil;
            else
                vbShiptrans.factoryCode = [NSString stringWithUTF8String: rowData6];
            
            char * rowData7=(char *)sqlite3_column_text(statement,7);
            if (rowData7 == NULL)
                vbShiptrans.factoryName = nil;
            else
                vbShiptrans.factoryName = [NSString stringWithUTF8String: rowData7];
            
            char * rowData8=(char *)sqlite3_column_text(statement,8);
            if (rowData8 == NULL)
                vbShiptrans.portCode = nil;
            else
                vbShiptrans.portCode = [NSString stringWithUTF8String: rowData8];
            
            char * rowData9=(char *)sqlite3_column_text(statement,9);
            if (rowData9 == NULL)
                vbShiptrans.portName = nil;
            else
                vbShiptrans.portName = [NSString stringWithUTF8String: rowData9];
            
            vbShiptrans.supId = sqlite3_column_int(statement,10);
            
            char * rowData11=(char *)sqlite3_column_text(statement,11);
            if (rowData11 == NULL)
                vbShiptrans.supplier = nil;
            else
                vbShiptrans.supplier = [NSString stringWithUTF8String: rowData11];
            
            vbShiptrans.typeId = sqlite3_column_int(statement,12);
            
            char * rowData13=(char *)sqlite3_column_text(statement,13);
            if (rowData13 == NULL)
                vbShiptrans.coalType = nil;
            else
                vbShiptrans.coalType = [NSString stringWithUTF8String: rowData13];
            
            char * rowData14=(char *)sqlite3_column_text(statement,14);
            if (rowData14 == NULL)
                vbShiptrans.keyValue = nil;
            else
                vbShiptrans.keyValue = [NSString stringWithUTF8String: rowData14];
            
            char * rowData15=(char *)sqlite3_column_text(statement,15);
            if (rowData15 == NULL)
                vbShiptrans.keyName = nil;
            else
                vbShiptrans.keyName = [NSString stringWithUTF8String: rowData15];
            
            char * rowData16=(char *)sqlite3_column_text(statement,16);
            if (rowData16 == NULL)
                vbShiptrans.trade = nil;
            else
                vbShiptrans.trade = [NSString stringWithUTF8String: rowData16];
            
            char * rowData17=(char *)sqlite3_column_text(statement,17);
            if (rowData17 == NULL)
                vbShiptrans.tradeName = nil;
            else
                vbShiptrans.tradeName = [NSString stringWithUTF8String: rowData17];
            
            vbShiptrans.heatValue = sqlite3_column_int(statement,18);
            
            char * rowData19=(char *)sqlite3_column_text(statement,19);
            if (rowData19 == NULL)
                vbShiptrans.stage = nil;
            else
                vbShiptrans.stage = [NSString stringWithUTF8String: rowData19];
            
            char * rowData20=(char *)sqlite3_column_text(statement,20);
            if (rowData20 == NULL)
                vbShiptrans.stageName = nil;
            else
                vbShiptrans.stageName = [NSString stringWithUTF8String: rowData20];
            
            char * rowData21=(char *)sqlite3_column_text(statement,21);
            if (rowData21 == NULL)
                vbShiptrans.stateCode = nil;
            else
                vbShiptrans.stateCode = [NSString stringWithUTF8String: rowData21];
            
            char * rowData22=(char *)sqlite3_column_text(statement,22);
            if (rowData22 == NULL)
                vbShiptrans.stateName = nil;
            else
                vbShiptrans.stateName = [NSString stringWithUTF8String: rowData22];
            
            vbShiptrans.lw = sqlite3_column_int(statement,23);
            
            char * rowData24=(char *)sqlite3_column_text(statement,24);
            if (rowData24 == NULL)
                vbShiptrans.p_AnchorageTime = nil;
            else
                vbShiptrans.p_AnchorageTime = [NSString stringWithUTF8String: rowData24];
            
            char * rowData25=(char *)sqlite3_column_text(statement,25);
            if (rowData25 == NULL)
                vbShiptrans.p_Handle = nil;
            else
                vbShiptrans.p_Handle = [NSString stringWithUTF8String: rowData25];
            
            char * rowData26=(char *)sqlite3_column_text(statement,26);
            if (rowData26 == NULL)
                vbShiptrans.p_ArrivalTime = nil;
            else
                vbShiptrans.p_ArrivalTime = [NSString stringWithUTF8String: rowData26];
            
            char * rowData27=(char *)sqlite3_column_text(statement,27);
            if (rowData27 == NULL)
                vbShiptrans.p_DepartTime = nil;
            else
                vbShiptrans.p_DepartTime = [NSString stringWithUTF8String: rowData27];
            
            char * rowData28=(char *)sqlite3_column_text(statement,28);
            if (rowData28 == NULL)
                vbShiptrans.p_Note = nil;
            else
                vbShiptrans.p_Note = [NSString stringWithUTF8String: rowData28];
            
            char * rowData29=(char *)sqlite3_column_text(statement,29);
            if (rowData29 == NULL)
                vbShiptrans.t_Note = nil;
            else
                vbShiptrans.t_Note = [NSString stringWithUTF8String: rowData29];
            
            char * rowData30=(char *)sqlite3_column_text(statement,30);
            if (rowData30 == NULL)
                vbShiptrans.f_AnchorageTime = nil;
            else
                vbShiptrans.f_AnchorageTime = [NSString stringWithUTF8String: rowData30];
            
            char * rowData31=(char *)sqlite3_column_text(statement,31);
            if (rowData31 == NULL)
                vbShiptrans.f_ArrivalTime = nil;
            else
                vbShiptrans.f_ArrivalTime = [NSString stringWithUTF8String: rowData31];
            
            char * rowData32=(char *)sqlite3_column_text(statement,32);
            if (rowData32 == NULL)
                vbShiptrans.f_DepartTime = nil;
            else
                vbShiptrans.f_DepartTime = [NSString stringWithUTF8String: rowData32];
            
            char * rowData33=(char *)sqlite3_column_text(statement,33);
            if (rowData33 == NULL)
                vbShiptrans.f_Note = nil;
            else
                vbShiptrans.f_Note = [NSString stringWithUTF8String: rowData33];
            
            vbShiptrans.lateFee = sqlite3_column_int(statement,34);
            
            vbShiptrans.offEfficiency = sqlite3_column_int(statement,35);
            
            char * rowData36=(char *)sqlite3_column_text(statement,36);
            if (rowData36 == NULL)
                vbShiptrans.schedule = nil;
            else
                vbShiptrans.schedule = [NSString stringWithUTF8String: rowData36];
            
            char * rowData37=(char *)sqlite3_column_text(statement,37);
            if (rowData37 == NULL)
                vbShiptrans.planType = nil;
            else
                vbShiptrans.planType = [NSString stringWithUTF8String: rowData37];
            
            char * rowData38=(char *)sqlite3_column_text(statement,38);
            if (rowData38 == NULL)
                vbShiptrans.planCode = nil;
            else
                vbShiptrans.planCode = [NSString stringWithUTF8String: rowData38];
            
            char * rowData39=(char *)sqlite3_column_text(statement,39);
            if (rowData39 == NULL)
                vbShiptrans.laycanStart = nil;
            else
                vbShiptrans.laycanStart = [NSString stringWithUTF8String: rowData39];
            
            char * rowData40=(char *)sqlite3_column_text(statement,40);
            if (rowData40 == NULL)
                vbShiptrans.laycanStop = nil;
            else
                vbShiptrans.laycanStop = [NSString stringWithUTF8String: rowData40];
            
            char * rowData41=(char *)sqlite3_column_text(statement,41);
            if (rowData41 == NULL)
                vbShiptrans.reciept = nil;
            else
                vbShiptrans.reciept = [NSString stringWithUTF8String: rowData41];
            
            char * rowData42=(char *)sqlite3_column_text(statement,42);
            if (rowData42 == NULL)
                vbShiptrans.shipShift = nil;
            else
                vbShiptrans.shipShift = [NSString stringWithUTF8String: rowData42];
            
            vbShiptrans.facSort = sqlite3_column_int(statement,43);
            
            char * rowData44=(char *)sqlite3_column_text(statement,44);
            if (rowData44 == NULL)
                vbShiptrans.tradeTime = nil;
            else
                vbShiptrans.tradeTime = [NSString stringWithUTF8String: rowData44];
            
            
            char * rowData45=(char *)sqlite3_column_text(statement,45);
            if (rowData45 == NULL)
                vbShiptrans.F_FINISHTIME = nil;
            else
                vbShiptrans.F_FINISHTIME = [NSString stringWithUTF8String: rowData45];

            
            
            char * rowData46=(char *)sqlite3_column_text(statement,46);
            if (rowData46 == NULL)
                vbShiptrans.iscal = nil;
            else
                vbShiptrans.iscal = [NSString stringWithUTF8String: rowData46];

            
			[array addObject:vbShiptrans];
            [vbShiptrans release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return array;
}

@end
