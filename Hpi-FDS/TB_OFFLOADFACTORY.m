//
//  TB_OFFLOADFACTORY.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TB_OFFLOADFACTORY.h"

@implementation TB_OFFLOADFACTORY
@synthesize FACTORYCODE,NOTE,RECORDDATE,ID,CONSUM,STORAGE,HEATVALUE,SULFUR,AVALIABLE,MINDEPTH,tbShipList;

-(void)dealloc
{
    [FACTORYCODE release];
    [NOTE release];
    [RECORDDATE release];
    [tbShipList release];
    [super dealloc];
}
@end
