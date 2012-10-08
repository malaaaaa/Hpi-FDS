//
//  TsFileinfo.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TsFileinfo.h"

@implementation TsFileinfo
@synthesize fileId;
@synthesize fileType, title, filePath, fileName, userName, recordTime,xzbz;

-(void)dealloc {
    NSLog(@"delllllllllloc");
    [fileType release];
    fileType=nil;
    [title release];
    title=nil;
    [filePath release];
    filePath=nil;
    [fileName release];
    fileName=nil;
    [userName release];
    userName=nil;
    [recordTime release];
    recordTime=nil;
    [xzbz release];
    xzbz=nil;
    [super dealloc];
}

@end
