//
//  QueryViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBShipChVC.h"
#import "TBShipChVC.h"
#import "DataGridComponent.h"
#import <QuartzCore/QuartzCore.h>
@interface QueryViewController : UIViewController
{
    IBOutlet UISegmentedControl *segment;
    IBOutlet UIView *chooseView;
    IBOutlet UIView *listView;
    NSMutableArray *dataArray;
    TBShipChVC *tbShipChVC;
    VBShipChVC *vbShipChVC;
    DataGridComponent *grid_vb;
    DataGridComponent *grid_tb;
}

@property (nonatomic,retain) UISegmentedControl *segment;
@property (nonatomic,retain) UIView *chooseView;
@property (nonatomic,retain) UIView *listView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) TBShipChVC *tbShipChVC;
@property (nonatomic,retain) VBShipChVC *vbShipChVC;

-(void)loadViewData_vb;
-(void)loadViewData_tb;
@end
