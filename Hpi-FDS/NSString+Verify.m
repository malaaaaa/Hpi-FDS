//
//  NSString+Verify.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-23.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NSString+Verify.h"

@implementation NSString (Verify)
-(BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self]; 
    int val; 
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
