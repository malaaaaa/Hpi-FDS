//
//  TfShip.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-5.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TfShip.h"

@implementation TfShip

@synthesize SHIPID
,COMID
,SHIPNAME
,SHIPCODE
,MMSI
,LENGTH
,WIDTH
,MAXSPEED
,LOADWEIGHT
,DRAFT
,VOLUME
,CABINNUM
,GATENUM
,TELEPHONE
,FEERATE
,ALLOWPERIOD
,DESPATCHRATE;





-(void)dealloc
{

    [SHIPCODE release];
    [SHIPNAME release];
    [MMSI release];
    [TELEPHONE release  ];
    [super dealloc];
}




@end
