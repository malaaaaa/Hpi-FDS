//
//  VBShipDetailController.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-24.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VBShipDetailController : UIViewController{
    UIPopoverController *popover;
    IBOutlet UILabel  *p_AnchorageTime;
    IBOutlet UILabel  *p_Handle;
    IBOutlet UILabel  *p_ArrivalTime;
    IBOutlet UILabel  *lw;
    IBOutlet UILabel  *p_DepartTime;
    IBOutlet UILabel  *p_Note;
    IBOutlet UILabel  *f_AnchorageTime;
    IBOutlet UILabel  *f_ArrivalTime;
    IBOutlet UILabel  *f_DepartTime;
    IBOutlet UILabel  *f_Note;
    IBOutlet UILabel  *lateFee;
    IBOutlet UILabel  *offEfficiency;
}

@property (nonatomic,retain) UIPopoverController *popover;
@property (retain, nonatomic)  UILabel *p_AnchorageTime;
@property (retain, nonatomic)  UILabel *p_Handle;
@property (retain, nonatomic)  UILabel *p_ArrivalTime;
@property (retain, nonatomic)  UILabel *lw;
@property (retain, nonatomic)  UILabel *p_DepartTime;
@property (retain, nonatomic)  UILabel *p_Note;
@property (retain, nonatomic)  UILabel *f_AnchorageTime;
@property (retain, nonatomic)  UILabel *f_ArrivalTime;
@property (retain, nonatomic)  UILabel *f_DepartTime;
@property (retain, nonatomic)  UILabel *f_Note;
@property (retain, nonatomic)  UILabel *lateFee;
@property (retain, nonatomic)  UILabel *offEfficiency;

-(void)loadViewData;
@end
