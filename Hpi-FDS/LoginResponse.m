

//
//  LoginResponse.m
//  Hpi-FDS
//
//  Created by tang bin on 12-10-23.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "LoginResponse.h"

@implementation LoginResponse
@synthesize SBID,RETCODE,STAGE,ISHAVE;


-(void)dealloc
{
    [self.SBID release];
    [self .RETCODE release];
    
    [self.STAGE  release];
      [self .ISHAVE release];
    [super dealloc];
}

@end
