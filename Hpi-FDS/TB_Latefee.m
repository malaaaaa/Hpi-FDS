//
//  TB_Latefee.m
//  Hpi-FDS
//
//  Created by bin tang on 12-7-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TB_Latefee.h"

@implementation TB_Latefee

@synthesize DISPATCHNO,PORTCODE,FACTORYCODE,FEERATE,ALLOWPERIOD,TRADE,KEYVALUE,TRIPNO,TRADETIME,P_ANCHORAGETIME,P_DEPARTTIME,P_CONFIRM,P_CONUSER,P_CONTIME,
F_ANCHORAGETIME,F_DEPARTTIME,F_CONFIRM,F_CONTIME,F_CONUSER,LATEFEE,P_CORRECT,P_NOTE,F_CORRECT,F_NOTE,ISCAL,CURRENCY,EXCHANGRATE,PORTNAME, FACTORYNAME,  COMPANY,SHIPNAME, SUPPLIER ,COALTYPE; 
@synthesize COMID,SHIPID,LW ,SUPID,TYPEID;


-(void)dealloc
{



    [DISPATCHNO release];
    [PORTCODE release];
    [PORTNAME release];
    [FACTORYCODE release];
    [FACTORYNAME     release];
    [COMPANY release];
    [SHIPNAME release];
    [FEERATE release];
    [ALLOWPERIOD release];
    [SUPPLIER    release];
    [COALTYPE release];
    [TRADE release];
    [KEYVALUE release];
    [TRIPNO release];
    [TRADETIME release];
    
    [P_ANCHORAGETIME release];
    [P_CONFIRM release];
    [P_DEPARTTIME release];
    [P_CONTIME  release];
    [P_CONUSER release];
    [P_NOTE release];
    [F_ANCHORAGETIME     release];
    [F_CONFIRM   release];
    [F_CONTIME release];
    [F_CONUSER release];
    [F_CORRECT release];
    [F_DEPARTTIME release];
    
    
    [F_NOTE release];
    [LATEFEE release];
    [P_CORRECT release];
    [ISCAL release];
    
    [CURRENCY release];
    [EXCHANGRATE release];
    
    [super dealloc];}

@end
