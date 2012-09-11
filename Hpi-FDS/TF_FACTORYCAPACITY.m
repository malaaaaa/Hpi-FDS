//
//  TF_FACTORYCAPACITY.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TF_FACTORYCAPACITY.h"

@implementation TF_FACTORYCAPACITY
@synthesize FACTORYCODE,DESCRIPTION;
@synthesize CAPACITY,CAPID,UNITS;

-(void)dealloc
{
    [FACTORYCODE release];
    [DESCRIPTION release];


    [super dealloc];
}

@end
