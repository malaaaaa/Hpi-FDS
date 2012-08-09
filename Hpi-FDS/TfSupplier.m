//
//  TfSupplier.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TfSupplier.h"

@implementation TfSupplier
@synthesize SUPID=_SUPID;
@synthesize PID=_PID;
@synthesize SUPPLIER=_SUPPLIER;
@synthesize DESCRIPTION=_DESCRIPTION;
@synthesize LINKMAN=_LINKMAN;
@synthesize CONTACT=_CONTACT;
@synthesize SORT=_SORT;
@synthesize didSelected;

-(void)dealloc
{

    [_SUPPLIER release];
    [_DESCRIPTION release];
    [_LINKMAN release];

    [_CONTACT release];

    [super dealloc];
}

@end
