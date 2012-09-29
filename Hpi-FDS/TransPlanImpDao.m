//
//  TransPlanImpDao.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TransPlanImpDao.h"
#import "PubInfo.h"
#import "NT_TransPlanImpDao.h"

static sqlite3  *database;
@implementation TransPlanImpDao



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
	NSLog(@"open  database succes ....");
}








+(NSMutableArray *)GetTransPlanImpDataBySql
{
  NSMutableArray *d=[[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *statement;
    
       
    NSString *sql1=  [NSString   stringWithFormat:@"select  substr(S_PLANMONTH ,0,6)as  S_PLANMONTH, S_SHIPID, S_SHIPNAME, S_FACTORYCODE, S_FACTORYNAME, S_TRIPNO, S_PORTCODE, S_PORTNAME, strftime( '%%Y-%%m-%%d %%H:%%M:%%S', S_ARRIVETIME) as  S_ARRIVETIME, strftime( '%%Y-%%m-%%d %%H:%%M:%%S', S_LEAVETIME) as  S_LEAVETIME,  S_COALTYPE, S_SUPPLIER, S_KEYNAME, S_LW, S_PLANTYPE,   S_SORT, S_SUPID, S_TYPEID, S_KEYVALUE, S_STAGE,substr(T_PLANMONTH ,0,6)as T_PLANMONTH,T_SHIPID, T_SHIPNAME, T_FACTORYCODE,  T_FACTORYNAME, T_TRIPNO, T_PORTCODE, T_PORTNAME, strftime( '%%Y-%%m-%%d %%H:%%M:%%S', T_ARRIVETIME) as      T_ARRIVETIME,strftime( '%%Y-%%m-%%d %%H:%%M:%%S', T_LEAVETIME) as  T_LEAVETIME, T_COALTYPE,T_SUPPLIER, T_KEYNAME, T_ELW, T_DESCRIPTION,  T_SORT,T_SUPID, T_TYPEID, T_KEYVALUE, S_HEATVALUE,   S_SULFUR, T_HEATVALUE, T_SULFUR  from (select  substr(a.DISPATCHNO,0,7) as S_PLANMONTH,a.SHIPID as S_SHIPID,a.SHIPNAME as S_SHIPNAME,a.FACTORYCODE as S_FACTORYCODE,  a.FACTORYNAME as S_FACTORYNAME,a.TRIPNO as S_TRIPNO,a.PORTCODE as S_PORTCODE,a.PORTNAME as S_PORTNAME,  case when a.TRADE = 'D' then   a.P_ANCHORAGETIME  else   a.F_ANCHORAGETIME End as S_ARRIVETIME,  case when a.TRADE = 'D' then   a.P_DEPARTTIME   else  a.F_DEPARTTIME   End as S_LEAVETIME,  a.COALTYPE as S_COALTYPE,a.SUPPLIER as S_SUPPLIER,a.KEYNAME as S_KEYNAME,a.LW as S_LW,a.PLANTYPE as S_PLANTYPE,   a.FACSORT as S_SORT,a.SUPID as S_SUPID,a.TYPEID as S_TYPEID,a.KEYVALUE as S_KEYVALUE,a.STAGE as S_STAGE,    b.PLANMONTH as T_PLANMONTH,  b.SHIPID as T_SHIPID,b.SHIPNAME as T_SHIPNAME,b.FACTORYCODE as T_FACTORYCODE,b.FACTORYNAME as T_FACTORYNAME,  b.TRIPNO as T_TRIPNO,   b.PORTCODE as T_PORTCODE,b.PORTNAME as T_PORTNAME,b.ETAP as T_ARRIVETIME,b.ETAF as T_LEAVETIME,b.COALTYPE as T_COALTYPE,    b.SUPPLIER as T_SUPPLIER,b.KEYNAME as T_KEYNAME,b.ELW as T_ELW,b.[DESCRIPTION] as T_DESCRIPTION,b.FACSORT as T_SORT    ,b.SUPID as T_SUPID,b.TYPEID as T_TYPEID,b.KEYVALUE as T_KEYVALUE   ,a.HEATVALUE S_HEATVALUE,null as S_SULFUR,b.HEATVALUE as T_HEATVALUE,b.SULFUR as T_SULFUR  from VbShiptrans  as  a   left outer join VbTransplan    as   b      on a.PLANCODE = b.PLANCODE   union  select    substr(a.DISPATCHNO,0,7) as S_PLANMONTH,a.SHIPID as S_SHIPID,a.SHIPNAME as S_SHIPNAME,a.FACTORYCODE as S_FACTORYCODE,  a.FACTORYNAME as S_FACTORYNAME,a.TRIPNO as S_TRIPNO,a.PORTCODE as S_PORTCODE,a.PORTNAME as S_PORTNAME,  case when a.TRADE = 'D' then a.P_ANCHORAGETIME   else  a.F_ANCHORAGETIME  End as S_ARRIVETIME,  case when a.TRADE = 'D' then  a.P_DEPARTTIME   else   a.F_DEPARTTIME   End as S_LEAVETIME,	  a.COALTYPE as S_COALTYPE,a.SUPPLIER as S_SUPPLIER,a.KEYNAME as S_KEYNAME,a.LW as S_LW,a.PLANTYPE as S_PLANTYPE, a.FACSORT as S_SORT,a.SUPID as S_SUPID,a.TYPEID as S_TYPEID,a.KEYVALUE as S_KEYVALUE,a.STAGE as S_STAGE, b.PLANMONTH as T_PLANMONTH,  b.SHIPID as T_SHIPID,b.SHIPNAME as T_SHIPNAME,b.FACTORYCODE as T_FACTORYCODE,b.FACTORYNAME as T_FACTORYNAME, b.TRIPNO as T_TRIPNO, b.PORTCODE as T_PORTCODE,b.PORTNAME as T_PORTNAME,b.ETAP as T_ARRIVETIME,b.ETAF as T_LEAVETIME,b.COALTYPE as T_COALTYPE,  b.SUPPLIER as T_SUPPLIER,b.KEYNAME as T_KEYNAME,b.ELW as T_ELW,b.[DESCRIPTION] as T_DESCRIPTION,b.FACSORT as T_SORT  ,b.SUPID as T_SUPID,b.TYPEID as T_TYPEID,b.KEYVALUE as T_KEYVALUE ,a.HEATVALUE S_HEATVALUE,null as S_SULFUR,b.HEATVALUE as T_HEATVALUE,b.SULFUR as T_SULFUR     from    VbTransplan    as   b    left outer join    VbShiptrans  as  a      on a.PLANCODE = b.PLANCODE      ) as t     "];

    NSLog(@"执行 GetTransPlanImpDataBySql [%@]",sql1);
    if (sqlite3_prepare(database, [sql1 UTF8String], -1, &statement, NULL)==SQLITE_OK) {
        while ( sqlite3_step(statement)==SQLITE_ROW) {
            
            TransPlanImpModel *mModel=[[TransPlanImpModel alloc] init];
            // T_PLANMONTH
            char *date1=(char *)sqlite3_column_text(statement, 20);
            if (date1!=NULL)
            {

             char *date01=(char *)sqlite3_column_text(statement, 20);
             if(date01==NULL)
                 mModel.ST_PLANMONTH=@"";
                else
                  mModel.ST_PLANMONTH=[NSString stringWithUTF8String:date01];
            
                mModel.ST_IntPlanMonth =sqlite3_column_int(statement, 20);
            
                mModel.ST_SHIPID=sqlite3_column_int(statement, 21);
                
                char *date02=(char *)sqlite3_column_text(statement, 22);
                if(date02==NULL)
                    mModel.ST_SHIPNAME=@"";
                else
                    mModel.ST_SHIPNAME=[NSString stringWithUTF8String:date02];
                char *date03=(char *)sqlite3_column_text(statement,23);
                if(date03==NULL)
                    mModel.ST_FACTORYCODE=@"";
                else
                    mModel.ST_FACTORYCODE=[NSString stringWithUTF8String:date03];

                char *date04=(char *)sqlite3_column_text(statement, 24);
                if(date04==NULL)
                    mModel.ST_FACTORYNAME=@"";
                else
                    mModel.ST_FACTORYNAME=[NSString stringWithUTF8String:date04];
                
                
                char *date05=(char *)sqlite3_column_text(statement, 25);
                if(date05==NULL)
                   mModel.ST_TRIPNO=@"";
                else
                   mModel.ST_TRIPNO=[NSString stringWithUTF8String:date05];
                
                
                char *date06=(char *)sqlite3_column_text(statement, 26);
                if(date06==NULL)
                   mModel.ST_PORTCODE=@"";
                else
                    mModel.ST_PORTCODE=[NSString stringWithUTF8String:date06];
                
                
                char *date07=(char *)sqlite3_column_text(statement, 27);
                if(date07==NULL)
                    mModel.ST_PORTNAME=@"";
                else
                    mModel.ST_PORTNAME=[NSString stringWithUTF8String:date07];
                
                char *date08=(char *)sqlite3_column_text(statement, 28);
                if(date08==NULL)
                    mModel.ST_ARRIVETIME=@"";
                else
                   mModel.ST_ARRIVETIME=[NSString stringWithUTF8String:date08];
                
                
                
                char *date09=(char *)sqlite3_column_text(statement, 29);
                if(date09==NULL)
                    mModel.ST_LEAVETIME=@"";
                else
                    mModel.ST_LEAVETIME=[NSString stringWithUTF8String:date09];

                
                
                char *date10=(char *)sqlite3_column_text(statement, 30);
                if(date10==NULL)
                   mModel.ST_COALTYPE=@"";
                else
                   mModel.ST_COALTYPE=[NSString stringWithUTF8String:date10];
                
                char *date11=(char *)sqlite3_column_text(statement, 31);
                if(date11==NULL)
                 mModel.ST_SUPPLIER=@"";
                else
                   mModel.ST_SUPPLIER=[NSString stringWithUTF8String:date11];
                
                
                
                char *date12=(char *)sqlite3_column_text(statement, 32);
                if(date12==NULL)
                   mModel.ST_KEYNAME=@"";
                else
                   mModel.ST_KEYNAME=[NSString stringWithUTF8String:date12];
                
                
                 mModel.ST_ELW=sqlite3_column_double(statement,33);
                
                 mModel.ST_SORT =sqlite3_column_int(statement, 35);
                 mModel.ST_SUPID =sqlite3_column_int(statement, 36);
                
                mModel.ST_TYPEID =sqlite3_column_int(statement, 37);
                mModel.ST_KEYVALUE=sqlite3_column_int (statement, 38);
                
            }
            else
            {
            
                       
                char *date01=(char *)sqlite3_column_text(statement, 0);
                if(date01==NULL)
                    mModel.ST_PLANMONTH=@"";
                else
                    mModel.ST_PLANMONTH=[NSString stringWithUTF8String:date01];
                
                mModel.ST_IntPlanMonth =sqlite3_column_int(statement, 0);
                
                mModel.ST_SHIPID=sqlite3_column_int(statement, 1);
                
                char *date02=(char *)sqlite3_column_text(statement, 2);
                if(date02==NULL)
                    mModel.ST_SHIPNAME=@"";
                else
                    mModel.ST_SHIPNAME=[NSString stringWithUTF8String:date02];
                char *date03=(char *)sqlite3_column_text(statement,3);
                if(date03==NULL)
                    mModel.ST_FACTORYCODE=@"";
                else
                    mModel.ST_FACTORYCODE=[NSString stringWithUTF8String:date03];
                
                char *date04=(char *)sqlite3_column_text(statement,4);
                if(date04==NULL)
                    mModel.ST_FACTORYNAME=@"";
                else
                    mModel.ST_FACTORYNAME=[NSString stringWithUTF8String:date04];
                
                
                char *date05=(char *)sqlite3_column_text(statement, 5);
                if(date05==NULL)
                    mModel.ST_TRIPNO=@"";
                else
                    mModel.ST_TRIPNO=[NSString stringWithUTF8String:date05];
                
                
                char *date06=(char *)sqlite3_column_text(statement, 6);
                if(date06==NULL)
                    mModel.ST_PORTCODE=@"";
                else
                    mModel.ST_PORTCODE=[NSString stringWithUTF8String:date06];
                
                
                char *date07=(char *)sqlite3_column_text(statement, 7);
                if(date07==NULL)
                    mModel.ST_PORTNAME=@"";
                else
                    mModel.ST_PORTNAME=[NSString stringWithUTF8String:date07];
                
                char *date08=(char *)sqlite3_column_text(statement, 8);
                if(date08==NULL)
                    mModel.ST_ARRIVETIME=@"";
                else
                    mModel.ST_ARRIVETIME=[NSString stringWithUTF8String:date08];
                char *date09=(char *)sqlite3_column_text(statement,9);
                if(date09==NULL)
                    mModel.ST_LEAVETIME=@"";
                else
                    mModel.ST_LEAVETIME=[NSString stringWithUTF8String:date09];
                char *date10=(char *)sqlite3_column_text(statement,10);
                if(date10==NULL)
                    mModel.ST_COALTYPE=@"";
                else
                    mModel.ST_COALTYPE=[NSString stringWithUTF8String:date10];
                
                char *date11=(char *)sqlite3_column_text(statement, 11);
                if(date11==NULL)
                    mModel.ST_SUPPLIER=@"";
                else
                    mModel.ST_SUPPLIER=[NSString stringWithUTF8String:date11];
                char *date12=(char *)sqlite3_column_text(statement, 12);
                if(date12==NULL)
                    mModel.ST_KEYNAME=@"";
                else
                    mModel.ST_KEYNAME=[NSString stringWithUTF8String:date12];
                
                
                mModel.ST_ELW=sqlite3_column_double(statement, 13);
                
                mModel.ST_SORT =sqlite3_column_int(statement, 15);
                mModel.ST_SUPID =sqlite3_column_int(statement, 16);
                
                mModel.ST_TYPEID =sqlite3_column_int(statement, 17);
                mModel.ST_KEYVALUE=sqlite3_column_int (statement, 18);
            
            
            
            
            }
            mModel.S_SHIPID=sqlite3_column_int (statement,1);
            char *date2=(char *)sqlite3_column_text(statement,2);
            if (date2==NULL)
                  mModel.S_SHIPNAME=@"";
            else
                  mModel.S_SHIPNAME=[NSString stringWithUTF8String:date2];
            char *date3=(char *)sqlite3_column_text(statement,3);
            if (date3==NULL)
               mModel.S_FACTORYCODE =@"";
            else
                mModel.S_FACTORYCODE =[NSString stringWithUTF8String:date3];
            char *date4=(char *)sqlite3_column_text(statement,6);
            if (date4==NULL)
               mModel.S_PORTCODE =@"";
            else
               mModel.S_PORTCODE =[NSString stringWithUTF8String:date4];
            
            char *date5=(char *)sqlite3_column_text(statement,7);
            if (date5==NULL)
                mModel.S_PORTNAME =@"";
            else
                 mModel.S_PORTNAME =[NSString stringWithUTF8String:date5];
            char *date6=(char *)sqlite3_column_text(statement,8);
            if (date6==NULL)
                mModel.S_ARRIVETIME =@"";
            else
                mModel.S_ARRIVETIME=[NSString stringWithUTF8String:date6];

            char *date7=(char *)sqlite3_column_text(statement,9);
            if (date7==NULL)
                 mModel.S_LEAVETIME =@"";
            else
                 mModel.S_LEAVETIME=[NSString stringWithUTF8String:date7];
            
             mModel.S_LW=sqlite3_column_double  (statement,13);
            char *date8=(char *)sqlite3_column_text(statement,14);
            if (date8==NULL)
                mModel.S_PLANTYPE =@"";
            else
                mModel.S_PLANTYPE=[NSString stringWithUTF8String:date8];
            mModel.T_SHIPID = sqlite3_column_int(statement, 21);
            char *date9=(char *)sqlite3_column_text(statement,22);
            if (date9==NULL)
                mModel.T_SHIPNAME =@"";
            else
                mModel.T_SHIPNAME=[NSString stringWithUTF8String:date9];
            char *date111=(char *)sqlite3_column_text(statement,23);
            if (date111==NULL)
                   mModel.T_FACTORYCODE =@"";
            else
                  mModel.T_FACTORYCODE=[NSString stringWithUTF8String:date111];
            char *date112=(char *)sqlite3_column_text(statement,26);
            if (date112==NULL)
               mModel.T_PORTCODE=@"";
            else
                 mModel.T_PORTCODE=[NSString stringWithUTF8String:date112];
            char *date113=(char *)sqlite3_column_text(statement,27);
            if (date113==NULL)
               mModel.T_PORTNAME=@"";
            else
               mModel.T_PORTNAME=[NSString stringWithUTF8String:date113];
            
            char *date114=(char *)sqlite3_column_text(statement,28);
            if (date114==NULL)
                mModel.T_ARRIVETIME=@"";
            else
                 mModel.T_ARRIVETIME=[NSString stringWithUTF8String:date114];
            
            
            char *date115=(char *)sqlite3_column_text(statement,29);
            if (date115==NULL)
               mModel.T_LEAVETIME=@"";
            else
                mModel.T_LEAVETIME=[NSString stringWithUTF8String:date115];

            
            mModel.T_ELW=sqlite3_column_double(statement, 33);
            
            char *date116=(char *)sqlite3_column_text(statement,34);
            if (date116==NULL)
                mModel.T_DESCRIPTION=@"";
            else
               mModel.T_DESCRIPTION=[NSString stringWithUTF8String:date116];
            
            
            char *date117=(char *)sqlite3_column_text(statement,19);
            if (date117==NULL)
                mModel.S_STAGE=@"";
            else
                mModel.S_STAGE=[NSString stringWithUTF8String:date117];
            
            
            //读取错误==========================================

            
            char *date118=(char *)sqlite3_column_text(statement,39);
            if (date118==NULL)
                mModel.S_HEATVALUE=@"";
            else
                mModel.S_HEATVALUE=[NSString stringWithUTF8String:date118];
            
            
            char *date119=(char *)sqlite3_column_text(statement,40);
            if (date119==NULL)
                mModel.S_SULFUR=@"";
            else
                mModel.S_SULFUR=[NSString stringWithUTF8String:date119];
            
            
            char *date120=(char *)sqlite3_column_text(statement,41);
            if (date120==NULL)
                mModel.T_HEATVALUE=@"";
            else
                mModel.T_HEATVALUE=[NSString stringWithUTF8String:date120];
            
            char *date121=(char *)sqlite3_column_text(statement,42);
            if (date121==NULL)
                mModel.T_SULFUR=@"";
            else
                mModel.T_SULFUR=[NSString stringWithUTF8String:date121];


            
            [d addObject:mModel];
            [ mModel release];
        }
    }else {
        NSLog(@"--- Error: select  error message [%s]  sql[%@]", sqlite3_errmsg(database),sql1);
        sqlite3_finalize(statement);
     
    }
    sqlite3_finalize(statement);
    
    NSLog(@"d[%d]",[d count]);
    return d;
}


@end
