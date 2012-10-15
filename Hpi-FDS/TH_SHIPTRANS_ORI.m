//
//  TH_SHIPTRANS_ORI.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-10-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TH_SHIPTRANS_ORI.h"

@implementation TH_SHIPTRANS_ORI
-(void)dealloc
{
    [_RECORDDATE release];
    [_DISPATCHNO release];
    [_SHIPCOMPANY release];
    [_SHIPNAME release];
    [_TRIPNO release];
    [_FACTORYCODE release];
    [_FACTORYNAME release];
    [_PORTCODE release];
    [_PORTNAME release];
    [_SUPPLIER release];
    [_COALTYPE release];
    [_KEYVALUE release];
    [_KEYNAME release];
    [_TRADE release];
    [_TRADENAME release];
    [_STAGE release];
    [_STAGENAME release];
    [_STATECODE release];
    [_STATENAME release];
    [_P_ANCHORAGETIME release];
    [_P_HANDLE release];
    [_P_ARRIVALTIME release];
    [_P_DEPARTTIME release];
    [_P_NOTE release];
    [_T_NOTE release];
    [_F_ANCHORAGETIME release];
    [_F_ARRIVALTIME release];
    [_F_DEPARTTIME release];
    [_F_NOTE release];
    [_LATEFEE release];
    [_SCHEDULE release];
    [_PLANTYPE release];
    [_PLANCODE release];
    [_LAYCANSTART release];
    [_LAYCANSTOP release];
    [_RECIEPT release];
    [_SHIPSHIFT release];
    [_F_FINISH release];
    
    [super dealloc];
}
@end
