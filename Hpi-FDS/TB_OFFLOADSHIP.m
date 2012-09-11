//
//  TB_OFFLOADSHIP.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TB_OFFLOADSHIP.h"

@implementation TB_OFFLOADSHIP
@synthesize ID,FACTORYCODE,RECORDDATE,TYPE,SHIPID,EVENTTIME,LW,HEATVALUE,SULFUR,DRAFT,SUPPLIER,TRADENAME,COALTYPE;


-(void)dealloc
{

    [FACTORYCODE release];
    [RECORDDATE release];
    [TYPE release];
    [EVENTTIME release];
    [SUPPLIER release];
    [TRADENAME release];
    [COALTYPE release];

    [super dealloc];
}
@end
