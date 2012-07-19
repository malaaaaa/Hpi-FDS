//
//  TmCoalinfo.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TmCoalinfo.h"

@implementation TmCoalinfo

@synthesize infoId,portCode,recordDate,import,Export,storage;

-(void)dealloc {
    [portCode release];
    [recordDate release];
    [super dealloc];
}

@end
