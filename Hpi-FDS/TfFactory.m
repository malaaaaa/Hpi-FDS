//
//  TfFactory.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//


#import "TfFactory.h"

@implementation TfFactory
@synthesize FACTORYNAME, FACTORYCODE, CAPACITYSUM,DESCRIPTION,SORT,BERTHNUM,BERTHWET,CHANNELDEPTH,CATEGORY,MAXSTORAGE,ORGANCODE;
-(void)dealloc {
    [FACTORYCODE release];
    [FACTORYNAME release];
    [CAPACITYSUM release];
    [DESCRIPTION release];
    [BERTHWET release];
    [CHANNELDEPTH release];
    [CATEGORY release];
    [ORGANCODE release];
    [super dealloc];
}
@end
