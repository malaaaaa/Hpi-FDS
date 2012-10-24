

//
//  LoginResponse.m
//  Hpi-FDS
//
//  Created by tang bin on 12-10-23.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "LoginResponse.h"

@implementation LoginResponse



-(void)dealloc
{
    [self.SBID release];
    [self .RETCODE release];
    
    [self.STAGE  release];
    [super dealloc];
}

@end
