//
//  SummaryInfoViewController.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-23.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DataGridComponent.h"
#import "PubInfo.h"
@interface SummaryInfoViewController : UIViewController<UIScrollViewDelegate>{
    UIPopoverController *popover;
    
    
  
    DataGridScrollView *scroll;
}

@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain) DataGridScrollView *scroll;



-(void)loadViewData;

@end
