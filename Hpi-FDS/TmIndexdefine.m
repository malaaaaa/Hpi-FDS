//
//  TmIndexdefine.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TmIndexdefine.h"

@implementation TmIndexdefine

@synthesize indexId, maxiMum, miniMum;
@synthesize indexName, indexType, displayName;

-(void)dealloc {
    [indexName release];
    [indexType release];
    [displayName release];
    [super dealloc];
}

@end
