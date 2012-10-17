//
//  TB_OFFLOADSHIPDao.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TB_OFFLOADSHIPDao.h"

@implementation TB_OFFLOADSHIPDao
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
		NSLog(@"open TB_OFFLOADSHIP error");
		return;
	}
	NSLog(@"open TB_OFFLOADSHIP database succes ....");
}
+(void) initDb
{
    
	char *errorMsg;
	NSString *createSql=[NSString  stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",
						 @"CREATE TABLE IF NOT EXISTS TB_OFFLOADSHIP  (ID INTEGER PRIMARY KEY ",
                        @",FACTORYCODE TEXT ",
                        @",RECORDDATE TEXT ",
                        @",TYPE TEXT ",
                        @",SHIPID INTEGER ",
                        @",EVENTTIME TEXT ",
                        @",LW INTEGER ",
                        @",HEATVALUE INTEGER ",
                        @",SULFUR INTEGER ",
                        @",DRAFT INTEGER ",
						@",SUPPLIER TEXT ",
                        @",TRADENAME TEXT ",
                        @",COALTYPE TEXT )"];
    
	
	if(sqlite3_exec(database,[createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"create table TB_OFFLOADSHIP error");
		printf("%s",errorMsg);
		return;
		
	}
}



+(void) deleteAll
{
	char * errorMsg;
	NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  TB_OFFLOADSHIP "];
	
	if(sqlite3_exec(database,[deletesql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSLog( @"Error: delete TB_OFFLOADSHIP error with message [%s]  sql[%@]", errorMsg,deletesql);
	}
	else
	{
		NSLog(@"delete success");
	}
	return;
}


+(NSMutableArray *)SelectAllByFactoryCode:(NSString *)factoryName :(NSString *)time
{

	NSMutableArray *array=[[[NSMutableArray alloc]init] autorelease]; 
    sqlite3_stmt *statement;

    NSString *sql= [NSString stringWithFormat:@"select   ID,TB_OFFLOADSHIP.FACTORYCODE,RECORDDATE,TYPE,SHIPID, strftime( '%%Y-%%m-%%d %%H:%%M:%%S', EVENTTIME)AS EVENTTIME ,LW,HEATVALUE,SULFUR,DRAFT,SUPPLIER,TRADENAME,COALTYPE  from TB_OFFLOADSHIP  inner join  TFFACTORY on TFFACTORY.FACTORYCODE=TB_OFFLOADSHIP.FACTORYCODE where  (          CAST(strftime('%%Y',TB_OFFLOADSHIP.RECORDDATE) AS  VARCHAR(100)) || '-' || CAST(strftime('%%m',TB_OFFLOADSHIP.RECORDDATE) AS VARCHAR(100)) || '-' || CAST(strftime('%%d',TB_OFFLOADSHIP.RECORDDATE) AS VARCHAR(100))      )='%@'  and  TFFACTORY.FACTORYNAME='%@'",time,factoryName];

    
    
   //  NSLog(@" B_OFFLOADSHIPDao     SelectAllByFactoryCode[%@]",sql );
    if(sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL)==SQLITE_OK){
		while (sqlite3_step(statement)==SQLITE_ROW) {

            TB_OFFLOADSHIP *tbShip=[[TB_OFFLOADSHIP alloc] init];
 
            tbShip.ID=sqlite3_column_int(statement, 0);
             
                        
            char *rowdata1=(char *)sqlite3_column_text(statement, 1);
            if (rowdata1==NULL)
                tbShip.FACTORYCODE=@"";
            else
                tbShip.FACTORYCODE=[NSString stringWithUTF8String:rowdata1];
            
            
            char *rowdata2=(char *)sqlite3_column_text(statement, 2);
            if (rowdata2==NULL)
                tbShip.RECORDDATE=@"";
            else
                tbShip.RECORDDATE=[NSString stringWithUTF8String:rowdata2];

            char *rowdata3=(char *)sqlite3_column_text(statement,3);
            if (rowdata3==NULL)
                tbShip.TYPE=@"";
            else
                tbShip.TYPE=[NSString stringWithUTF8String:rowdata3];
            
            tbShip.SHIPID=sqlite3_column_int(statement, 4);
            
            char *rowdata4=(char *)sqlite3_column_text(statement, 5);
            if (rowdata4==NULL)
                tbShip.EVENTTIME=@"";
            else
                tbShip.EVENTTIME=[NSString stringWithUTF8String:rowdata4];
            
              tbShip.LW=sqlite3_column_int(statement, 6);
             tbShip.HEATVALUE=sqlite3_column_int(statement, 7);
            tbShip.SULFUR=sqlite3_column_double(statement, 8);
              tbShip.DRAFT=sqlite3_column_double(statement, 9);
            
            char *rowdata5=(char *)sqlite3_column_text(statement,10);
            if (rowdata5==NULL)
                tbShip.SUPPLIER=@"";
            else
                tbShip.SUPPLIER=[NSString stringWithUTF8String:rowdata5];
            
            
            char *rowdata6=(char *)sqlite3_column_text(statement, 11);
            if (rowdata6==NULL)
                tbShip.TRADENAME=@"";
            else
                tbShip.TRADENAME=[NSString stringWithUTF8String:rowdata6];
            
            
            char *rowdata7=(char *)sqlite3_column_text(statement, 12);
            if (rowdata7==NULL)
                tbShip.COALTYPE=@"";
            else
                tbShip.COALTYPE=[NSString stringWithUTF8String:rowdata7];
            
            
            
            [array addObject:tbShip];
            [tbShip release];
        }
    }
    sqlite3_finalize(statement);
    
  //  NSLog(@"----================array[%d]",[array   count]);
    
  return array;

}



































@end
