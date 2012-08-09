//
//  TfPort.m
//  Hpi-FDS
//
//  Created by bin tang on 12-8-7.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TfPort.h"

@implementation TfPort

@synthesize  PORTCODE,PORTNAME,SORT,UPLOAD,DOWNLOAD,NATIONALTYPE;
-(void)dealloc
{
    [PORTCODE release];
    [PORTNAME release];
    [SORT release];
    [UPLOAD release];
    [DOWNLOAD release];
    [NATIONALTYPE release];
    
    [super dealloc];
}




@end
