//
//  TH_ShipTrans.m
//  Hpi-FDS
//
//  Created by bin tang on 12-7-19.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TH_ShipTrans.h"

@implementation TH_ShipTrans

@synthesize RECID=_RECID;
@synthesize RECORDDATE=_RECORDDATE;

@synthesize STATECODE=_STATECODE;

@synthesize STATENAME=_STATENAME;
@synthesize SHIPNAME=_SHIPNAME;

@synthesize TRIPNO=_TRIPNO;

@synthesize FACTORYNAME=_FACTORYNAME;

@synthesize PORTCODE=_PORTCODE;
@synthesize PORTNAME=_PORTNAME;

@synthesize SUPPLIER=_SUPPLIER;

@synthesize COALTYPE=_COALTYPE;







@synthesize LW=_LW;



@synthesize P_ANCHORAGETIME=_P_ANCHORAGETIME    ;
@synthesize P_ARRIVALTIME=_P_ARRIVALTIME;

@synthesize P_HANDLE=_P_HANDLE;

@synthesize P_DEPARTTIME=_P_DEPARTTIME;

@synthesize NOTE=_NOTE;


-(void)dealloc
{
    [_PORTCODE release];
    [_STATENAME release];
    [_RECORDDATE release];
    [_PORTNAME  release];
    [_SUPPLIER release];
    [_COALTYPE release];
    [_P_ANCHORAGETIME release];
    [_P_ARRIVALTIME release];
    
    [_P_DEPARTTIME release];
    [_P_HANDLE release];
    [_NOTE release];
    [_FACTORYNAME release];
    [_TRIPNO release];
    [_SHIPNAME release];
    
    
    [super dealloc];
}





@end
