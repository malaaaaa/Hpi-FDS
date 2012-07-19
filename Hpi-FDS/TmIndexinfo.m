//
//  TmIndexinfo.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TmIndexinfo.h"

@implementation TmIndexinfo

@synthesize infoId, infoValue;
@synthesize indexName, recordTime;


-(void)dealloc {
    [indexName release];
    [recordTime release];
    [infoValue release];
    [super dealloc];
}

@end
