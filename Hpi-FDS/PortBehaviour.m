//
//  PortBehaviour.m
//  Hpi-FDS
//
//  Created by 馬文培 on 13-2-27.
//  Copyright (c) 2013年 Landscape. All rights reserved.
//

#import "PortBehaviour.h"

@implementation PortBehaviour

@end
@implementation PortBehaviourDao
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
		NSLog(@"open PortEfficiency error");
		return;
	}
	NSLog(@"open PortEfficiency database succes ....");
}
+(NSMutableArray *) getPortBehaviour
{
	sqlite3_stmt *statement;
    NSString *sql=@"select strftime('%Y-%m-%d',c.recordDate),p.portname,sum(c.import)/10000.0,sum(c.Export)/10000.0,sum(c.storage)/10000.0,sum(s.waitShip) from TmCoalinfo c, TmShipinfo s, TF_Port p where c.portCode=p.portcode and s.portCode=p.portcode and p.nationaltype='0' and c.recordDate=(select max(recordDate) from TmCoalinfo) and s.recordDate=(select max(recordDate) from TmShipinfo) group by strftime('%Y-%m-%d',c.recordDate),p.portname";
    
    NSLog(@"执行 getPortBehaviour [%@] ",sql);
    
	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease];
    
	if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {
			PortBehaviour *portBehaviour = [[PortBehaviour alloc] init];
            char * rowData0=(char *)sqlite3_column_text(statement,0);
            if (rowData0 == NULL)
                portBehaviour.date = nil;
            else
                portBehaviour.date = [NSString stringWithUTF8String: rowData0];
            
            char * rowData1=(char *)sqlite3_column_text(statement,1);
            if (rowData1 == NULL)
                portBehaviour.portName = nil;
            else
                portBehaviour.portName = [NSString stringWithUTF8String: rowData1];
            
            portBehaviour.importWeight=sqlite3_column_double(statement,2);
            portBehaviour.exportWeight=sqlite3_column_double(statement,3);
            portBehaviour.storage=sqlite3_column_double(statement,4);
            portBehaviour.shipNum=sqlite3_column_int(statement,5);
            [array addObject:portBehaviour];
            [portBehaviour release];
		}
	}else {
		NSLog( @"Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql);
	}
    sqlite3_finalize(statement);
    
	return array;
}
@end
