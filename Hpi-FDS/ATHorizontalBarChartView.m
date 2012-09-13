//
//  ATHorizontalBarChartView.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-9-13.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "ATHorizontalBarChartView.h"

@implementation ATHorizontalBarChartView

@synthesize ds,curIndexPath;
- (void)dealloc {
    self.curIndexPath = nil;
    self.ds = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        myPV=[[[ATPagingView alloc] initWithFrame:frame] autorelease];
        myPV.delegate = self;
        [self addSubview:myPV];
    }
    return self;
}

-(void)setDs:(NSArray *)aDS{
    if (ds!=aDS) {
        [ds release];
        ds =[aDS retain];
    }
    [myPV reloadData];
    myPV.currentPageIndex = 0;
}

- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView{
    return self.ds.count;
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index{
    UIView * iv =(UIView *)[pagingView dequeueReusablePage];
    if (!iv) {
        iv =[[[UIView alloc] initWithFrame:pagingView.frame] autorelease];
    }
    WSChart * chart = [self.ds objectAtIndex:index];
    [iv addSubview:chart];
    return iv;
}

-(void)setCurIndexPath:(NSIndexPath *)aCurIndexPath{
    if (curIndexPath) {
        [curIndexPath release];
    }
    curIndexPath = [aCurIndexPath retain];
    
    myPV.currentPageIndex = aCurIndexPath.section;
    
}

@end
