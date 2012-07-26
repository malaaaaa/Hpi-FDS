//
//  VbFactoryTransDao.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-6.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VbFactoryTransDao.h"
#import "VbFactoryTrans.h"
#import "PubInfo.h"

@implementation VbFactoryTransDao
static sqlite3 *database;

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
		NSLog(@"open VbFactoryTrans error");
		return;
	}
	NSLog(@"open VbFactoryTrans database succes ....");
}

+(void) initDb
{	
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS VbFactoryTrans  (FACTORYCODE TEXT   ",
						 @",DISPATCHNO TEXt ",
                         @",SHIPID INTEGER ",
						 @",SHIPNAME TEXT ",
                         @",TYPEID INTEGER ",
                         @",TRADE TEXT ",
                         @",KEYVALUE TEXT ",
                         @",SUPID INTEGER ",
                         @",STATECODE TEXT ",
                         @",STATENAME TEXT ",
                         @",STAGECODE TEXT ",
                         @",STAGENAME TEXT ",
                         @",elw INTEGER ",
                         @",COMID INTEGER ",
						 @",T_NOTE TEXT ",
                         @",F_NOTE TEXT )"];
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table VbFactoryTrans error");
		printf("%s",errorMsg);
		return;
		
	}
}

+(void)insert:(VbFactoryTrans*) vbFactoryTrans
{
	NSLog(@"Insert begin VbFactoryTrans");
	const char *insert="INSERT INTO VbFactoryTrans (FACTORYCODE,DISPATCHNO,SHIPID,SHIPNAME,TYPEID, TRADE,KEYVALUE,SUPID,STATECODE,STATENAME,STAGECODE,STAGENAME,elw,COMID,T_NOTE,F_NOTE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *statement;
	
	int re=sqlite3_prepare_v2(database, insert, -1, &statement, NULL);
    if (re != SQLITE_OK) 
    {
        NSLog( @"Error: failed to prepare statement with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
    }
    
    NSLog(@"FACTORYCODE=%@", vbFactoryTrans.FACTORYCODE);
    NSLog(@"DISPATCHNO=%@", vbFactoryTrans.DISPATCHNO);
    NSLog(@"SHIPID=%d", vbFactoryTrans.SHIPID);
    NSLog(@"SHIPNAME=%@", vbFactoryTrans.SHIPNAME);
    NSLog(@"TYPEID=%d", vbFactoryTrans.TYPEID);
    NSLog(@"TRADE=%@", vbFactoryTrans.TRADE);
    NSLog(@"KEYVALUE=%@", vbFactoryTrans.KEYVALUE);
    NSLog(@"SUPID=%d", vbFactoryTrans.SUPID);
    NSLog(@"STATECODE=%@", vbFactoryTrans.STATECODE);
    NSLog(@"elw=%d", vbFactoryTrans.elw);
    NSLog(@"T_NOTE=%@", vbFactoryTrans.T_NOTE);
    NSLog(@"F_NOTE=%@", vbFactoryTrans.F_NOTE);
    
	sqlite3_bind_text(statement, 1, [vbFactoryTrans.FACTORYCODE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [vbFactoryTrans.DISPATCHNO UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 3, vbFactoryTrans.SHIPID);
    sqlite3_bind_text(statement, 4, [vbFactoryTrans.SHIPNAME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 5, vbFactoryTrans.TYPEID);
    sqlite3_bind_text(statement, 6, [vbFactoryTrans.TRADE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [vbFactoryTrans.KEYVALUE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 8, vbFactoryTrans.SUPID);
    sqlite3_bind_text(statement, 9, [vbFactoryTrans.STATECODE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 10, [vbFactoryTrans.STATENAME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 11, [vbFactoryTrans.STAGECODE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 12, [vbFactoryTrans.STAGENAME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 13, vbFactoryTrans.elw);
    sqlite3_bind_int(statement, 14, vbFactoryTrans.COMID);
    sqlite3_bind_text(statement, 15, [vbFactoryTrans.T_NOTE UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 16, [vbFactoryTrans.F_NOTE UTF8String], -1, SQLITE_TRANSIENT);
    
	re=sqlite3_step(statement);
	if(re!=SQLITE_DONE)
	{
		NSLog( @"Error: insert VbFactoryTrans error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
	}	
	sqlite3_finalize(statement);
	return;
}

+(void) delete:(VbFactoryTrans*) vbFactoryTrans
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  VbFactoryTrans where dispatchNo ='%@' ",vbFactoryTrans.FACTORYCODE];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete VbFactoryTrans error with message [%s]  sql[%@]", errorMsg,deletesql);
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
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  VbFactoryTrans "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete VbFactoryTrans error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");		
	}
	return;
}



//查询第一层电厂运行情况

+(NSMutableArray *) getVbFactoryTransState:(NSMutableArray *)factory 
                                          :(NSDate *)date 
                                          :(NSMutableArray *)shipCompany 
                                          :(NSMutableArray *)ship 
                                          :(NSMutableArray *)supplier 
                                          :(NSMutableArray *)coalType 
                                          :(NSString *)keyValue 
                                          :(NSString *)trade 
                                          :(NSMutableArray *)shipStage
{
    NSMutableString *tmpString = [[NSMutableString alloc] init ];
    
    //全部选中的情况下不代入查询条件
    //电厂
    if (((TgFactory *)[factory objectAtIndex:0]).didSelected==NO) {
        int count=0;
        for (int i=0; i<[factory count]; i++) {
            if (((TgFactory *)[factory objectAtIndex:i]).didSelected==YES) {
                count++;
                if (count==1) {
                    [tmpString appendString:@" AND F.FactoryCode in ("];
                }
                //如果条件不是第一条
                if (count!=1) {
                    [tmpString appendString:@","];
                }
                [tmpString appendFormat:@"'%@'",((TgFactory *)[factory objectAtIndex:i]).factoryCode];
            }
            
        }
        if (count>0) {
            [tmpString appendString:@")"];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *start=[dateFormatter stringFromDate:date];
    [tmpString appendFormat:@" AND strftime('%%Y-%%m-%%d',s.RECORDDATE) ='%@'",start];
    
    
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"SELECT f.FACTORYCODE,f.FACTORYNAME,F.CAPACITYSUM, S.CONSUM,S.AVALIABLE,S.MONTHIMP,S.YEARIMP,f.description FROM  TfFactory f,TbFactoryState s WHERE f.factorycode=s.factorycode  %@ ",tmpString];
    NSLog(@"执行 getVbFactoryTransState OuterSql[%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            VbFactoryTrans *vbFactoryTrans=[[VbFactoryTrans alloc] init];
            
			char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                vbFactoryTrans.FACTORYCODE = nil;
            else
                vbFactoryTrans.FACTORYCODE = [NSString stringWithUTF8String: rowData0];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                vbFactoryTrans.DISPATCHNO = nil;
            else
                vbFactoryTrans.FACTORYNAME = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                vbFactoryTrans.CAPACITYSUM = nil;
            else
                vbFactoryTrans.CAPACITYSUM = [NSString stringWithUTF8String: rowData2];
            
            vbFactoryTrans.CONSUM = sqlite3_column_int(statement,3);
            vbFactoryTrans.AVALIABLE = sqlite3_column_int(statement,4);
            vbFactoryTrans.MONTHIMP = sqlite3_column_int(statement,5);
            vbFactoryTrans.YEARIMP = sqlite3_column_int(statement,6);
            
            char * rowData7=(char *)sqlite3_column_text(statement,7);
            if (rowData7 == NULL)
                vbFactoryTrans.DESCRIPTION = nil;
            else
                vbFactoryTrans.DESCRIPTION = [NSString stringWithUTF8String: rowData7];
            
            
            //查询第二层数据
            {
                NSMutableString *innerTmpString = [[NSMutableString alloc] init ];
                
                //全部选中的情况下不代入查询条件
                
                //电厂
                if (((TfShipCompany *)[shipCompany objectAtIndex:0]).didSelected==NO) {
                    int count=0;
                    for (int i=0; i<[shipCompany count]; i++) {
                        if (((TfShipCompany *)[shipCompany objectAtIndex:i]).didSelected==YES) {
                            count++;
                            if (count==1) {
                                [innerTmpString appendString:@" AND comid in ("];
                            }
                            //如果条件不是第一条
                            if (count!=1) {
                                [innerTmpString appendString:@","];
                            }
                            [innerTmpString appendFormat:@"%d",((TfShipCompany *)[shipCompany objectAtIndex:i]).comid];
                        }
                    }
                    if (count>0) {
                        [innerTmpString appendString:@")"];
                    }
                }
                
                //船舶
                if (((TgShip *)[ship objectAtIndex:0]).didSelected==NO) {
                    int count=0;
                    for (int i=0; i<[ship count]; i++) {
                        if (((TgShip *)[ship objectAtIndex:i]).didSelected==YES) {
                            count++;
                            if (count==1) {
                                [innerTmpString appendString:@" AND shipid in ("];
                            }
                            //如果条件不是第一条
                            if (count!=1) {
                                [innerTmpString appendString:@","];
                            }
                            [innerTmpString appendFormat:@"%d",((TgShip *)[ship objectAtIndex:i]).shipID];
                        }
                    }
                    if (count>0) {
                        [innerTmpString appendString:@")"];
                    }
                }
                
                //供货商
                if (((TfSupplier *)[supplier objectAtIndex:0]).didSelected==NO) {
                    int count=0;
                    for (int i=0; i<[supplier count]; i++) {
                        if (((TfSupplier *)[supplier objectAtIndex:i]).didSelected==YES) {
                            count++;
                            if (count==1) {
                                [innerTmpString appendString:@" AND supid in ("];
                            }
                            //如果条件不是第一条
                            if (count!=1) {
                                [innerTmpString appendString:@","];
                            }
                            [innerTmpString appendFormat:@"%d",((TfSupplier *)[supplier objectAtIndex:i]).SUPID];
                        }
                    }
                    if (count>0) {
                        [innerTmpString appendString:@")"];
                    }
                }
                
                //煤种
                if (((TfCoalType *)[coalType objectAtIndex:0]).didSelected==NO) {
                    int count=0;
                    for (int i=0; i<[coalType count]; i++) {
                        if (((TfCoalType *)[coalType objectAtIndex:i]).didSelected==YES) {
                            count++;
                            if (count==1) {
                                [innerTmpString appendString:@" AND typeid in ("];
                            }
                            //如果条件不是第一条
                            if (count!=1) {
                                [innerTmpString appendString:@","];
                            }
                            [innerTmpString appendFormat:@"%d",((TfCoalType *)[coalType objectAtIndex:i]).TYPEID];
                        }
                    }
                    if (count>0) {
                        [innerTmpString appendString:@")"];
                    }
                }
                
                //性质
                if ([keyValue isEqualToString:@"重点"]) {
                    [innerTmpString appendString:@" AND keyvalue='1' "];
                    
                }
                else if ([keyValue isEqualToString:@"非重点"]) {
                    [innerTmpString appendString:@" AND keyvalue='0' "];
                }
                
                //贸易性质
                if ([trade isEqualToString:@"内贸"]) {
                    [innerTmpString appendString:@" AND trade='D' "];
                    
                }
                else if ([trade isEqualToString:@"进口"]) {
                    [innerTmpString appendString:@" AND trade='F' "];
                }
                //状态
                if (((TsShipStage *)[shipStage objectAtIndex:0]).didSelected==NO) {
                    int count=0;
                    for (int i=0; i<[shipStage count]; i++) {
                        if (((TsShipStage *)[shipStage objectAtIndex:i]).didSelected==YES) {
                            count++;
                            if (count==1) {
                                [innerTmpString appendString:@" AND stagecode in ("];
                            }
                            //如果条件不是第一条
                            if (count!=1) {
                                [innerTmpString appendString:@","];
                            }
                            [innerTmpString appendFormat:@"'%@'",((TsShipStage *)[shipStage objectAtIndex:i]).STAGE];
                        }
                    }
                    if (count>0) {
                        [innerTmpString appendString:@")"];
                    }
                }
                
                sqlite3_stmt *innerStatement;
                NSString *innerSql=[NSString stringWithFormat:@"select count(*) from VBFACTORYTRANS where  trim(STATECODE)<>'b' and  FACTORYCODE ='%@' %@",vbFactoryTrans.FACTORYCODE,innerTmpString];
                NSLog(@"执行 getVbFactoryTransState InnerSql[%@] ",innerSql);
                
                if(sqlite3_prepare_v2(database,[innerSql UTF8String],-1,&innerStatement,NULL)==SQLITE_OK){
                    while (sqlite3_step(innerStatement)==SQLITE_ROW) {
                        vbFactoryTrans.SHIPNUM = sqlite3_column_int(innerStatement,0);
                    }
                }
                else {
                    NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),innerSql);
                }
                [innerTmpString release];
            }
                        
			[array addObject:vbFactoryTrans];
            [vbFactoryTrans release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    [tmpString release];
	return array;
}

//查询第二层船舶运行情况
+(NSMutableArray *) getVbFactoryTransBySql:(NSString *)querySql
{
	sqlite3_stmt *statement;
    NSString *sql=[NSString stringWithFormat:@"select dispatchno,statename,shipname,elw,t_note from VbFactoryTrans where  %@ ",querySql];
    NSLog(@"执行 getVbFactoryTransBySql [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			
            VbFactoryTrans *vbFactoryTrans=[[VbFactoryTrans alloc] init];
            
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                vbFactoryTrans.DISPATCHNO = nil;
            else
                vbFactoryTrans.DISPATCHNO = [NSString stringWithUTF8String: rowData0];
            
			char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                vbFactoryTrans.STATENAME = nil;
            else
                vbFactoryTrans.STATENAME = [NSString stringWithUTF8String: rowData1];
            
            char * rowData2=(char *)sqlite3_column_text(statement,2);
            if (rowData2 == NULL)
                vbFactoryTrans.SHIPNAME = nil;
            else
                vbFactoryTrans.SHIPNAME = [NSString stringWithUTF8String: rowData2];
            
            vbFactoryTrans.elw = sqlite3_column_int(statement,3);
            
            char * rowData4=(char *)sqlite3_column_text(statement,4);
            if (rowData4 == NULL)
                vbFactoryTrans.T_NOTE = nil;
            else
                vbFactoryTrans.T_NOTE = [NSString stringWithUTF8String: rowData4];
            
			[array addObject:vbFactoryTrans];
            [vbFactoryTrans release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
	return array;
}
+(NSMutableArray *) getVbFactoryTransDetail:(NSString *)FactoryCode 
                                           :(NSMutableArray *)shipCompany 
                                           :(NSMutableArray *)ship 
                                           :(NSMutableArray *)supplier 
                                           :(NSMutableArray *)coalType 
                                           :(NSString *)keyValue 
                                           :(NSString *)trade
                                           :(NSMutableArray *)shipStage 
{
    
    //查询所有没有结束的船只

    NSMutableString *query =[[NSMutableString alloc] init];
    [query appendFormat:@" trim(statecode)<>'b'  AND FACTORYCODE ='%@' ",FactoryCode];
  
    //船厂
    if (((TfShipCompany *)[shipCompany objectAtIndex:0]).didSelected==NO) {
        int count=0;
        for (int i=0; i<[shipCompany count]; i++) {
            if (((TfShipCompany *)[shipCompany objectAtIndex:i]).didSelected==YES) {
                count++;
                if (count==1) {
                    [query appendString:@" AND comid in ("];
                }
                //如果条件不是第一条
                if (count!=1) {
                    [query appendString:@","];
                }
                [query appendFormat:@"%d",((TfShipCompany *)[shipCompany objectAtIndex:i]).comid];
                
            }
            
        }
        if (count>0) {
            [query appendString:@")"];
        }
    }
    //船舶
    if (((TgShip *)[ship objectAtIndex:0]).didSelected==NO) {
        int count=0;
        for (int i=0; i<[ship count]; i++) {
            if (((TgShip *)[ship objectAtIndex:i]).didSelected==YES) {
                count++;
                if (count==1) {                    
                    [query appendString:@" AND shipid in ("];
                }
                //如果条件不是第一条
                if (count!=1) {
                    [query appendString:@","];
                }
                [query appendFormat:@"%d",((TgShip *)[ship objectAtIndex:i]).shipID];
                
            }
            
        }
        if (count>0) {
            [query appendString:@")"];
        }
    }
    //供货商
    if (((TfSupplier *)[supplier objectAtIndex:0]).didSelected==NO) {
        int count=0;
        for (int i=0; i<[supplier count]; i++) {
            if (((TfSupplier *)[supplier objectAtIndex:i]).didSelected==YES) {
                count++;
                if (count==1) {                    
                    [query appendString:@" AND supid in ("];
                }
                //如果条件不是第一条
                if (count!=1) {
                    [query appendString:@","];
                }
                [query appendFormat:@"%d",((TfSupplier *)[supplier objectAtIndex:i]).SUPID];
                
            }
            
        }
        if (count>0) {
            [query appendString:@")"];
        }
    }
    
    //煤种
    if (((TfCoalType *)[coalType objectAtIndex:0]).didSelected==NO) {
        int count=0;
        for (int i=0; i<[coalType count]; i++) {
            if (((TfCoalType *)[coalType objectAtIndex:i]).didSelected==YES) {
                count++;
                if (count==1) {                    
                    [query appendString:@" AND typeid in ("];
                }
                //如果条件不是第一条
                if (count!=1) {
                    [query appendString:@","];
                }
                [query appendFormat:@"%d",((TfCoalType *)[coalType objectAtIndex:i]).TYPEID];
                
            }
            
        }
        if (count>0) {
            [query appendString:@")"];
        }
    }

    //性质
    if ([keyValue isEqualToString:@"重点"]) {
        [query appendString:@" AND keyvalue='1' "];
        
    }
    else if ([keyValue isEqualToString:@"非重点"]) {
        [query appendString:@" AND keyvalue='0' "];
    }
    
    //贸易性质
    if ([trade isEqualToString:@"内贸"]) {
        [query appendString:@" AND trade='D' "];
        
    }
    else if ([trade isEqualToString:@"进口"]) {
        [query appendString:@" AND trade='F' "];
    }
    
    //状态
    if (((TsShipStage *)[shipStage objectAtIndex:0]).didSelected==NO) {
        int count=0;
        for (int i=0; i<[shipStage count]; i++) {
            if (((TsShipStage *)[shipStage objectAtIndex:i]).didSelected==YES) {
                count++;
                if (count==1) {                    
                    [query appendString:@" AND stagecode in ("];
                }
                //如果条件不是第一条
                if (count!=1) {
                    [query appendString:@","];
                }
                [query appendFormat:@"'%@'",((TsShipStage *)[shipStage objectAtIndex:i]).STAGE];
                
            }
            
        }
        if (count>0) {
            [query appendString:@")"];
        }
    }
    
	NSMutableArray * array=[VbFactoryTransDao getVbFactoryTransBySql:query];
    NSLog(@"执行 getVbFactoryTransDetail 数量[%d] ",[array count]);
    [query release];
	return array;
}

@end
