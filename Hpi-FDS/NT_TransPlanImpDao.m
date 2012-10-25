
//
//  NT_TransPlanImpDao.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-14.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NT_TransPlanImpDao.h"
#import "PubInfo.h"
#import "TransPlanImpDao.h"
static sqlite3  *database;
@implementation NT_TransPlanImpDao

+(NSString *)dataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString  *documentsDirectory=[paths objectAtIndex:0];
    
    NSString *path=[documentsDirectory  stringByAppendingPathComponent: @"database.db"  ];
    
    
    return  path;
}
+(void) openDataBase
{
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open  database error");
		return;
	}
//	NSLog(@"open  database succes ....");
}

+(void)IntTb
{
    
    //PRIMARY KEY 
    NSLog(@"create NT_TransPlanImp  。。。。");
    char *errorMsg;
    NSString *createSql=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                         @"CREATE TABLE IF NOT EXISTS NT_TransPlanImp( ST_PLANMONTH TEXT   ",
                         @" , ST_IntPlanMonth  NSInteger ",
                         @" , ST_SHIPID NSInteger ",
                         @" , ST_SHIPNAME TEXT ",
                         @" , ST_FACTORYCODE TEXT ",
                         @" , ST_FACTORYNAME TEXT ",
                         @" , ST_TRIPNO TEXT ",
                         @" , ST_PORTCODE TEXT ",
                         @" , ST_PORTNAME TEXT ",
                         @" , ST_ARRIVETIME TEXT ",
                         @" , ST_LEAVETIME TEXT ",
                         @" , ST_COALTYPE TEXT ",
                         @" , ST_SUPPLIER TEXT ",
                         @" , ST_KEYNAME  TEXT ",
                         @" , ST_ELW double ",
                         @" , ST_SORT  NSInteger ",
                         @" , ST_SUPID  NSInteger ",
                         @" , ST_TYPEID NSInteger ",
                         @" , ST_KEYVALUE  NSInteger ",
                         @" , S_SHIPID NSInteger ",
                         @" , S_SHIPNAME TEXT ",
                         @" , S_FACTORYCODE TEXT ",
                         @" , S_PORTCODE TEXT ",
                         @" , S_PORTNAME TEXT ",
                         @" , S_ARRIVETIME TEXT ",
                         @" , S_LEAVETIME TEXT ",
                         @" , S_LW double   ",
                         @" , S_PLANTYPE TEXT ",
                         @" , T_SHIPID NSInteger ",
                         @" , T_SHIPNAME TEXT ",
                         @" , T_FACTORYCODE TEXT ",
                         @" , T_PORTCODE TEXT ",
                         @" , T_PORTNAME TEXT ",
                         @" , T_ARRIVETIME TEXT ",
                         @" , T_LEAVETIME TEXT ",
                         @" , T_ELW  double ",
                         @" , T_DESCRIPTION TEXT ",
                         @" , S_STAGE TEXT ",
                         @" , S_HEATVALUE NSInteger ",
                         @" , S_SULFUR  double ",
                         @" , T_HEATVALUE NSInteger ",
                         @" , T_SULFUR double ) "];
    
    
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        
        sqlite3_close(database);
        NSLog(@"create table NT_TransPlanImp error");
        printf("%s",errorMsg);
        return;
    }else {
      //  NSLog(@"create table NT_TransPlanImp seccess");
    }
}


+(void)deleteAll
{
    
    
    char *errorMsg;
    NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM  NT_TransPlanImp  " ];
    if (sqlite3_exec(database, [deletesql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
        NSLog(@"Error: delete NT_TransPlanImp error with message [%s]  sql[%@]", errorMsg,deletesql);
    }else {
       // NSLog(@"delete success")  ;
    }
    return;
    
    
}

+(void)insert:(TransPlanImpModel *)model
{
    
    
    const char *insert="INSERT INTO NT_TransPlanImp( ST_PLANMONTH ,ST_IntPlanMonth  , ST_SHIPID   ,ST_SHIPNAME , ST_FACTORYCODE  , ST_FACTORYNAME ,  ST_TRIPNO , ST_PORTCODE , ST_PORTNAME , ST_ARRIVETIME  , ST_LEAVETIME  , ST_COALTYPE ,   ST_SUPPLIER , ST_KEYNAME , ST_ELW  , ST_SORT  , ST_SUPID  , ST_TYPEID  , ST_KEYVALUE ,  S_SHIPID , S_SHIPNAME  , S_FACTORYCODE  ,  S_PORTCODE , S_PORTNAME , S_ARRIVETIME  , S_LEAVETIME ,S_LW  , S_PLANTYPE  ,  T_SHIPID   , T_SHIPNAME , T_FACTORYCODE , T_PORTCODE  , T_PORTNAME ,T_ARRIVETIME , T_LEAVETIME  ,  T_ELW   , T_DESCRIPTION ,S_STAGE , S_HEATVALUE  , S_SULFUR   ,     T_HEATVALUE  ,T_SULFUR )values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *statement;
    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
    
    if (re!=SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
    }

    sqlite3_bind_text(statement, 1, [model.ST_PLANMONTH UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 2, model.ST_IntPlanMonth);
    sqlite3_bind_int(statement, 3, model.ST_SHIPID );
    sqlite3_bind_text(statement, 4, [model.ST_SHIPNAME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [model.ST_FACTORYCODE UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [model.ST_FACTORYNAME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,7, [model.ST_TRIPNO UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [model.ST_PORTCODE UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 9, [model.ST_PORTNAME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 10, [model.ST_ARRIVETIME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 11, [model.ST_LEAVETIME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 12, [model.ST_COALTYPE UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 13, [model.ST_SUPPLIER UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 14, [ model.ST_KEYNAME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_double(statement, 15, model.ST_ELW );
    sqlite3_bind_int(statement, 16, model.ST_SORT );
    sqlite3_bind_int(statement, 17, model.ST_SUPID);
    sqlite3_bind_int(statement, 18,model.ST_TYPEID);
    sqlite3_bind_int(statement, 19, model.ST_KEYVALUE);
    sqlite3_bind_int(statement, 20, model.S_SHIPID);
    sqlite3_bind_text(statement, 21, [model.S_SHIPNAME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 22, [model.S_FACTORYCODE UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 23, [model.S_PORTCODE UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 24, [model.S_PORTNAME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 25, [model.S_ARRIVETIME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,26, [model.S_LEAVETIME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_double (statement, 27, model.S_LW);
    sqlite3_bind_text(statement, 28, [model.S_PLANTYPE UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 29, model.T_SHIPID );
    sqlite3_bind_text(statement, 30, [model.T_SHIPNAME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 31, [model.T_FACTORYCODE UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 32, [model.T_PORTCODE UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 33, [model.T_PORTNAME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 34, [model.T_ARRIVETIME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 35, [model.T_LEAVETIME UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_double(statement,36, model.T_ELW);
    sqlite3_bind_text(statement, 37, [model.T_DESCRIPTION UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 38, [model.S_STAGE UTF8String], -1,SQLITE_TRANSIENT);
    
    
       sqlite3_bind_text(statement, 39, [model.S_HEATVALUE UTF8String], -1,SQLITE_TRANSIENT);
    
       sqlite3_bind_text(statement, 40, [model.S_SULFUR UTF8String], -1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 41, [model.T_HEATVALUE UTF8String], -1,SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 42, [model.T_SULFUR UTF8String], -1,SQLITE_TRANSIENT);
    

    
    
    re = sqlite3_step(statement);
	if(re!=SQLITE_DONE)
    {
		//NSLog( @"Error: insert NT_TransPlanImp error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
		sqlite3_finalize(statement);
		return;
    }
	sqlite3_finalize(statement);
    
}








+(NSMutableArray *)GetNT_TransPlanImpData:(SearchModel *)model
{
    /*

     ST_PORTCODE   ST_SHIPID   ST_FACTORYCODE   ST_TYPEID每种  ST_SUPID   ST_KEYVALUE  ST_IntPlanMonth  PlanMonthE
     */
    NSString *query=[NSString   stringWithFormat:@"  1=1  "];
    
    if (![ model.ShipId  isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ST_SHIPID=%d ",[model.ShipId integerValue]];
    }
    if (![model.portName isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ST_PORTNAME='%@' ",model.portName];
    }
    if (![model.FactoryName isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ST_FACTORYNAME='%@' ",model.FactoryName];
    }
    if (![model.KeyV isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ST_KEYNAME='%@' ",model.KeyV];
    }
    if (![model.CoalType isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ST_COALTYPE='%@' ",model.CoalType];
    }
    
    if (![model.Supplier isEqualToString:All_]) {
        query=[query stringByAppendingFormat:@"  AND ST_SUPPLIER='%@' ",model.Supplier];
    }
    if (model.PlanMonthS !=0) {
        query=[query stringByAppendingFormat:@"  AND ST_IntPlanMonth >=%d ",model.PlanMonthS];
    }
    if (model.PlanMonthE !=0) {
        query=[query stringByAppendingFormat:@"  AND ST_IntPlanMonth <=%d ",model.PlanMonthE];
    }
    
  //  NSLog(@"执行 query=========[%@]",query);
    
    NSMutableArray *array=[NT_TransPlanImpDao GetNT_TransPlanImpDataBySql:query];
   // NSLog(@"执行  GetTransPlanImpData 数量[%d]",[array count]);
    
    return array;
}
+(void)getNT_TransPlanImp
{
    NSMutableArray *list =[TransPlanImpDao GetTransPlanImpDataBySql];
    
   // NSLog(@"getNT_TransPlanImp  list [%d]",[list count]);
    
  [NT_TransPlanImpDao deleteAll];
     char *errorMsg;
     //为提高数据库写入性能，加入事务控制，批量提交
     if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
     sqlite3_close(database);
    // NSLog(@"exec begin error");
     return;
     }
    for (int i=0; i<[list count]; i++) {
        TransPlanImpModel *model=[list objectAtIndex:i];
        [NT_TransPlanImpDao insert:model];
    }
     if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
       //sqlite3_close(database);
    //NSLog(@"exec commit error");
     return;
     }else
     {
      NSLog(@"NT_TransPlanImp   数据填充完毕。。。。");
     }
   //sqlite3_close(database);
    
}










//过滤数据...
+(NSMutableArray *)GetNT_TransPlanImpDataBySql:(NSString *)sql
{

  
   
    NSMutableArray *d=[[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *statement;

    NSString *sql1=  [NSString   stringWithFormat: @"select   substr(ST_PLANMONTH ,0,7)as ST_PLANMONTH ,ST_IntPlanMonth  , ST_SHIPID   ,ST_SHIPNAME , ST_FACTORYCODE  , ST_FACTORYNAME ,  ST_TRIPNO , ST_PORTCODE , ST_PORTNAME , ST_ARRIVETIME  , ST_LEAVETIME  , ST_COALTYPE ,   ST_SUPPLIER , ST_KEYNAME , ST_ELW  , ST_SORT  , ST_SUPID  , ST_TYPEID  , ST_KEYVALUE ,  S_SHIPID , S_SHIPNAME  , S_FACTORYCODE  ,  S_PORTCODE , S_PORTNAME , S_ARRIVETIME  , S_LEAVETIME ,S_LW  , S_PLANTYPE  ,  T_SHIPID   , T_SHIPNAME , T_FACTORYCODE , T_PORTCODE  , T_PORTNAME ,T_ARRIVETIME , T_LEAVETIME  ,  T_ELW   , T_DESCRIPTION ,S_STAGE , S_HEATVALUE  , S_SULFUR   ,     T_HEATVALUE  ,T_SULFUR   FROM  NT_TransPlanImp  where  %@   order  by  ST_PLANMONTH  desc, ST_SORT  asc    ", sql ];
    
    
   //   NSLog(@"执行 GetTransPlanImpDataBySql [%@]",sql1);
 
   
    if (sqlite3_prepare(database, [sql1 UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        while ( sqlite3_step(statement)==SQLITE_ROW) {
            
            TransPlanImpModel *mModel=[[TransPlanImpModel alloc] init];
    
            char *date01=(char *)sqlite3_column_text(statement, 0);
            if(date01==NULL)
                mModel.ST_PLANMONTH=@"";
            else
                mModel.ST_PLANMONTH=[NSString stringWithUTF8String:date01];
            
            mModel.ST_IntPlanMonth =sqlite3_column_int(statement, 1);
            
            mModel.ST_SHIPID=sqlite3_column_int(statement, 2);
            
            char *date02=(char *)sqlite3_column_text(statement,3);
            if(date02==NULL)
                mModel.ST_SHIPNAME=@"";
            else
                mModel.ST_SHIPNAME=[NSString stringWithUTF8String:date02];
            char *date03=(char *)sqlite3_column_text(statement,4);
            if(date03==NULL)
                mModel.ST_FACTORYCODE=@"";
            else
                mModel.ST_FACTORYCODE=[NSString stringWithUTF8String:date03];
            
            char *date04=(char *)sqlite3_column_text(statement,5);
            if(date04==NULL)
                mModel.ST_FACTORYNAME=@"";
            else
                mModel.ST_FACTORYNAME=[NSString stringWithUTF8String:date04];
            
            
            char *date05=(char *)sqlite3_column_text(statement, 6);
            if(date05==NULL)
                mModel.ST_TRIPNO=@"";
            else
                mModel.ST_TRIPNO=[NSString stringWithUTF8String:date05];
            
            
            char *date06=(char *)sqlite3_column_text(statement, 7);
            if(date06==NULL)
                mModel.ST_PORTCODE=@"";
            else
                mModel.ST_PORTCODE=[NSString stringWithUTF8String:date06];
            
            
            char *date07=(char *)sqlite3_column_text(statement, 8);
            if(date07==NULL)
                mModel.ST_PORTNAME=@"";
            else
                mModel.ST_PORTNAME=[NSString stringWithUTF8String:date07];
            
            char *date08=(char *)sqlite3_column_text(statement, 9);
            if(date08==NULL)
                mModel.ST_ARRIVETIME=@"";
            else
                mModel.ST_ARRIVETIME=[NSString stringWithUTF8String:date08];
            
            
            
            char *date09=(char *)sqlite3_column_text(statement,10);
            if(date09==NULL)
                mModel.ST_LEAVETIME=@"";
            else
                mModel.ST_LEAVETIME=[NSString stringWithUTF8String:date09];
            
            
            
            char *date10=(char *)sqlite3_column_text(statement,11);
            if(date10==NULL)
                mModel.ST_COALTYPE=@"";
            else
                mModel.ST_COALTYPE=[NSString stringWithUTF8String:date10];
            
            char *date11=(char *)sqlite3_column_text(statement, 12);
            if(date11==NULL)
                mModel.ST_SUPPLIER=@"";
            else
                mModel.ST_SUPPLIER=[NSString stringWithUTF8String:date11];
            
            
            
            char *date12=(char *)sqlite3_column_text(statement, 13);
            if(date12==NULL)
                mModel.ST_KEYNAME=@"";
            else
                mModel.ST_KEYNAME=[NSString stringWithUTF8String:date12];
            
            
            mModel.ST_ELW=sqlite3_column_double(statement, 14);
            
            mModel.ST_SORT =sqlite3_column_int(statement, 15);
            mModel.ST_SUPID =sqlite3_column_int(statement, 16);
            
            mModel.ST_TYPEID =sqlite3_column_int(statement, 17);
            mModel.ST_KEYVALUE=sqlite3_column_int (statement, 18);
    
    
    
            mModel.S_SHIPID=sqlite3_column_int (statement,19);
            char *date2=(char *)sqlite3_column_text(statement,20);
            if (date2==NULL)
                mModel.S_SHIPNAME=@"";
            else
                mModel.S_SHIPNAME=[NSString stringWithUTF8String:date2];
            char *date3=(char *)sqlite3_column_text(statement,21);
            if (date3==NULL)
                mModel.S_FACTORYCODE =@"";
            else
                mModel.S_FACTORYCODE =[NSString stringWithUTF8String:date3];
            char *date4=(char *)sqlite3_column_text(statement,22);
            if (date4==NULL)
                mModel.S_PORTCODE =@"";
            else
                mModel.S_PORTCODE =[NSString stringWithUTF8String:date4];
            
            char *date5=(char *)sqlite3_column_text(statement,23);
            if (date5==NULL)
                mModel.S_PORTNAME =@"";
            else
                mModel.S_PORTNAME =[NSString stringWithUTF8String:date5];
            char *date6=(char *)sqlite3_column_text(statement,24);
            if (date6==NULL)
                mModel.S_ARRIVETIME =@"";
            else
                mModel.S_ARRIVETIME=[NSString stringWithUTF8String:date6];
            
            char *date7=(char *)sqlite3_column_text(statement,25);
            if (date7==NULL)
                mModel.S_LEAVETIME =@"";
            else
                mModel.S_LEAVETIME=[NSString stringWithUTF8String:date7];
            
            mModel.S_LW=sqlite3_column_double  (statement,26);
            char *date8=(char *)sqlite3_column_text(statement,27);
            if (date8==NULL)
                mModel.S_PLANTYPE =@"";
            else
                mModel.S_PLANTYPE=[NSString stringWithUTF8String:date8];
            mModel.T_SHIPID = sqlite3_column_int(statement, 28);
            char *date9=(char *)sqlite3_column_text(statement,29);
            if (date9==NULL)
                mModel.T_SHIPNAME =@"";
            else
                mModel.T_SHIPNAME=[NSString stringWithUTF8String:date9];
            char *date111=(char *)sqlite3_column_text(statement,30);
            if (date111==NULL)
                mModel.T_FACTORYCODE =@"";
            else
                mModel.T_FACTORYCODE=[NSString stringWithUTF8String:date111];
            char *date112=(char *)sqlite3_column_text(statement,31);
            if (date112==NULL)
                mModel.T_PORTCODE=@"";
            else
                mModel.T_PORTCODE=[NSString stringWithUTF8String:date112];
            char *date113=(char *)sqlite3_column_text(statement,32);
            if (date113==NULL)
                mModel.T_PORTNAME=@"";
            else
                mModel.T_PORTNAME=[NSString stringWithUTF8String:date113];
            
            char *date114=(char *)sqlite3_column_text(statement,33);
            if (date114==NULL)
                mModel.T_ARRIVETIME=@"";
            else
                mModel.T_ARRIVETIME=[NSString stringWithUTF8String:date114];
            
            
            char *date115=(char *)sqlite3_column_text(statement,34);
            if (date115==NULL)
                mModel.T_LEAVETIME=@"";
            else
                mModel.T_LEAVETIME=[NSString stringWithUTF8String:date115];
            
            
            mModel.T_ELW=sqlite3_column_double(statement, 35);
            
            char *date116=(char *)sqlite3_column_text(statement,36);
            if (date116==NULL)
                mModel.T_DESCRIPTION=@"";
            else
                mModel.T_DESCRIPTION=[NSString stringWithUTF8String:date116];
            
            
            char *date117=(char *)sqlite3_column_text(statement,37);
            if (date117==NULL)
                mModel.S_STAGE=@"";
            else
                mModel.S_STAGE=[NSString stringWithUTF8String:date117];
            
            
            
            
            
            
            
            
            char *date118=(char *)sqlite3_column_text(statement,38);
            if (date118==NULL)
                mModel.S_HEATVALUE=@"";
            else
                mModel.S_HEATVALUE=[NSString stringWithUTF8String:date118];
            
            
            char *date119=(char *)sqlite3_column_text(statement,39);
            if (date119==NULL)
                mModel.S_SULFUR=@"";
            else
                mModel.S_SULFUR=[NSString stringWithUTF8String:date119];
            
            
            char *date120=(char *)sqlite3_column_text(statement,40);
            if (date120==NULL)
                mModel.T_HEATVALUE=@"";
            else
                mModel.T_HEATVALUE=[NSString stringWithUTF8String:date120];
            
            char *date121=(char *)sqlite3_column_text(statement,41);
            if (date121==NULL)
                mModel.T_SULFUR=@"";
            else
                mModel.T_SULFUR=[NSString stringWithUTF8String:date121];
            
            
          //  mModel.S_HEATVALUE =sqlite3_column_int(statement, 38);
            //mModel.S_SULFUR=sqlite3_column_double(statement, 39);
            //mModel.T_HEATVALUE=sqlite3_column_int(statement, 40);
           // mModel.T_SULFUR =sqlite3_column_double(statement, 41);

            [d addObject:mModel];
            [ mModel release];
        }
    
    
    }else {
        NSLog(@"--- Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql1);
        sqlite3_finalize(statement);
        
    }
    sqlite3_finalize(statement);
    
   // NSLog(@"d==================[%d]",[d count]);
    
    return d;
}


























@end
