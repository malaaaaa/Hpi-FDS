//
//  TmIndextype.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TmIndextype.h"

@implementation TmIndextype

@synthesize typeId;
@synthesize indexType, typeName;

-(void)dealloc {
    [indexType release];
    [typeName release];
    [super dealloc];
}

@end
