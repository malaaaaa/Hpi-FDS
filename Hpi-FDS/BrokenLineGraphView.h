//
//  BrokenLineGraphView.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-25.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "PubInfo.h"
#import "BrokenLineGraphData.h"
#import "ShipCompanyShareDetailVC.h"


@interface BrokenLineGraphView : UIView<UIPopoverControllerDelegate>{
    // DATA
	BrokenLineGraphData *data;
	// BASE ELEMENTS
	UILabel *titleLabel;
	//上下左右留边大小, 
	NSInteger marginLeft,marginTop,marginRight,marginBottom;
  
}

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) BrokenLineGraphData *data;
@property NSInteger marginLeft;
@property NSInteger marginTop;
@property NSInteger marginRight;
@property NSInteger marginBottom;

- (id) initWithFrame:(CGRect)frame :(BrokenLineGraphData *) graphData ;
//画触发点
- (void)drawTriggerPoint:(CGContextRef)context rect:(CGRect)_rect;

@end
