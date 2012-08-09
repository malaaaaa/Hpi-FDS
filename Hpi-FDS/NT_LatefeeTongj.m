//
//  NT_LatefeeTongj.m
//  Hpi-FDS
//
//  Created by bin tang on 12-8-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NT_LatefeeTongj.h"

@implementation NT_LatefeeTongj
@synthesize CATEGORY;
@synthesize FACTORYNAME;
@synthesize MONTHLATEFEE;
@synthesize MonthM;


-(void)dealloc
{



    [CATEGORY release];
    [FACTORYNAME release];
    [MONTHLATEFEE    release];
   
    [super dealloc];
}






@end
