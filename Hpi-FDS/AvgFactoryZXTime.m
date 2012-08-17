//
//  AvgFactoryZXTime.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-17.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//


#import "AvgFactoryZXTime.h"

@implementation AvgFactoryZXTime


@synthesize avgLT;
@synthesize avgXG;
@synthesize avgZG;
@synthesize FactoryName;
@synthesize TradeMonth;



-(void)dealloc
{
    
    
    [avgXG release];
    [avgZG  release];
    [avgLT release];
    [FactoryName release];
    [TradeMonth release];
    
    [super dealloc];
}





@end
