//
//  BrokenLineGraphData.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-25.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "BrokenLineGraphData.h"

@implementation BrokenLineGraphData
@synthesize xtitles,ytitles,pointArray;
@synthesize yNum,xNum;

- (void) dealloc
{
    [xtitles release];
    [ytitles release];
    [pointArray release];
	[super dealloc];
}
@end



@implementation LineArray
@synthesize red,green,blue,pointArray;
- (void) dealloc
{
    [pointArray release];
	[super dealloc];
}
@end

@implementation BrokenLineGraphPoint
@synthesize companyShare,x,y;
- (void) dealloc
{
    [companyShare release];
	[super dealloc];
}
@end