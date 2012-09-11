//
//  TfCoalType.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TfCoalType.h"

@implementation TfCoalType


@synthesize COALTYPE;
@synthesize TYPEID,SULFUR,SORT,HEATVALUE;

@synthesize didSelected;


-(void)dealloc
{


    [COALTYPE release];
    [super dealloc];
}


@end
