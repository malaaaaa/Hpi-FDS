//
//  HpiGraphData.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-25.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "HpiGraphData.h"
@implementation HpiGraphData
@synthesize xtitles,ytitles,pointArray,pointArray2,pointArray3;
@synthesize yNum,xNum;

- (void) dealloc
{
    [xtitles release];
    [ytitles release];
    [pointArray release];
    [pointArray2 release];
    [pointArray3 release];
	[super dealloc];
}
@end


@implementation HpiPoint
@synthesize title,x,y;
- (void) dealloc
{
    [title release];
	[super dealloc];
}
@end