//
//  NTFactoryFreightVolume.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NTFactoryFreightVolume.h"

@implementation NTFactoryFreightVolume
@synthesize TRADETIME,TRADE,TRADENAME,CATEGORY,FACTORYNAME;
@synthesize LW,COUNT;


-(void)dealloc
{

    [TRADENAME release];
    [TRADETIME release];
    [TRADE release];
    [CATEGORY release];
    [FACTORYNAME release];
    [super dealloc];
}
@end
