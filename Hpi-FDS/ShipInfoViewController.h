//
//  ShipInfoViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-5.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "InfoPortVewController.h"
#import "DataGridComponent.h"
#import "PubInfo.h"

@interface ShipInfoViewController : UIViewController{
    IBOutlet UILabel *infoLabel;
    UIPopoverController *popover;
    NSMutableArray *array;
}
@property(nonatomic,retain) UILabel *infoLabel;
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain) NSMutableArray *array;
-(void)loadViewData;
@end
