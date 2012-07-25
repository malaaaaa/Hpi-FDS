//
//  DataQueryVC.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-24.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBShipChVC.h"
#import "TBShipChVC.h"
#import "VBTransChVC.h"
#import "TH_ShipTransChVC.h"

#import "DataGridComponent.h"
#import "VBShipDetailController.h"

@class VBFactoryTransVC;

@interface DataQueryVC : UIViewController<UITableViewDataSource,UITabBarDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UISegmentedControl *segment;
    IBOutlet UIView *chooseView;
    IBOutlet UIView *listView;
    NSMutableArray *dataArray;
    TBShipChVC *tbShipChVC;
    VBShipChVC *vbShipChVC;
    VBTransChVC *vbTransChVC;
    
    VBFactoryTransVC  *vbFactoryTransVC;
    TH_ShipTransChVC  *thShipTransVC;
    
    DataGridComponentDataSource *dataSource;
    
    
    DataGridComponent *grid_vb;
    DataGridComponent *grid_tb;
    IBOutlet UITableView *listTableview;
    IBOutlet UIView *labelView;
    UIPopoverController* popover;
    NSMutableArray  *detailArray;
}

@property (nonatomic,retain) UISegmentedControl *segment;
@property (nonatomic,retain) UIView *chooseView;
@property (nonatomic,retain) UIView *listView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) TBShipChVC *tbShipChVC;
@property (nonatomic,retain) VBShipChVC  *vbShipChVC;
@property (nonatomic,retain) VBTransChVC *vbTransChVC;

@property (nonatomic,retain) VBFactoryTransVC *vbFactoryTransVC;
@property (nonatomic,retain) TH_ShipTransChVC  *thShipTransVC;



@property (nonatomic,retain) UITableView *listTableview;
@property (nonatomic,retain) UIPopoverController* popover;
@property (nonatomic,retain) UIView *labelView;
@property (nonatomic,retain) NSMutableArray *detailArray;


@property (nonatomic,retain) DataGridComponentDataSource *dataSource;




-(void)loadViewData_vb;
-(void)loadViewData_tb;

@end
