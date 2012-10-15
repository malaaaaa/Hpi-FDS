//
//  VbFactoryTrans.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-6.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VbFactoryTrans.h"


@implementation VbFactoryTrans
@synthesize FACTORYCODE,DISPATCHNO,SHIPID,SHIPNAME,TYPEID, TRADE,KEYVALUE,SUPID,elw,T_NOTE,F_NOTE,FACTORYNAME,CONSUM,STORAGE,COMPARE,AVALIABLE,MONTHIMP,YEARIMP,CAPACITYSUM,SHIPNUM,P_NOTE;
@synthesize STAGECODE=_STAGECODE;
@synthesize STAGENAME=_STAGENAME;
@synthesize STATECODE=_STATECODE;
@synthesize STATENAME=_STATENAME;
@synthesize DESCRIPTION=_DESCRIPTION;
@synthesize COMID;

-(void)dealloc {
    [FACTORYCODE release];
    [CAPACITYSUM release];
    [DISPATCHNO release];
    [SHIPNAME release];
    [TRADE release];
    [KEYVALUE release];
    [_STATECODE release];
    [_STATENAME release];
    [T_NOTE release];
    [F_NOTE release];
    [FACTORYNAME release];
    [_STAGENAME release];
    [_STAGECODE release];
    [_DESCRIPTION release];
    [P_NOTE release];
    [super dealloc];
}
@end
