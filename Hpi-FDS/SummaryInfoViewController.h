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
@interface SummaryInfoViewController : UIViewController{
    UIPopoverController *popover;
}

@property(nonatomic,retain) UIPopoverController *popover;
-(void)loadViewData;

@end
