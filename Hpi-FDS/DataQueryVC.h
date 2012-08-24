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
#import "ShipCompanyTransShareVC.h"
#import "TB_LatefeeChVC.h"
#import "TfPort.h"
#import "TfPortDao.h"
#import "AvgPortPTimeChVC.h"
#import "NT_LatefeeTongj.h"
#import "NT_LatefeeTongjChVC.h"
#import "NT_LatefeeTongjDao.h"
#import "FactoryFreightVolumeVC.h"
#import "PortEfficiencyVC.h"

#import "AvgFactoryTimeChVC.h"


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
    //新添 滞期费
    TB_LatefeeChVC  *tblatefeeVC;
    
    NT_LatefeeTongjChVC *latefeeTj;
    
    AvgPortPTimeChVC *avgTimePort;
    AvgFactoryTimeChVC *avgTimeZXFactory;
    
    
    DataGridComponentDataSource *dataSource;
    
    
    DataGridComponent *grid_vb;
    DataGridComponent *grid_tb;
    IBOutlet UITableView *listTableview;
    IBOutlet UIView *labelView;
    UIPopoverController* popover;
    NSMutableArray  *detailArray;
    ShipCompanyTransShareVC *shipCompanyTrnasShareVC;
    FactoryFreightVolumeVC *factoryFreightVolumeVC;
    PortEfficiencyVC *portEfficiencyVC;
    
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
//新添滞期费
 @property (nonatomic,retain)  TB_LatefeeChVC  *tblatefeeVC;

 @property (nonatomic,retain)NT_LatefeeTongjChVC *latefeeTj;
   @property (nonatomic,retain) AvgPortPTimeChVC *avgTimePort;

  @property (nonatomic,retain) AvgFactoryTimeChVC *avgTimeZXFactory;


@property (nonatomic,retain) UITableView *listTableview;
@property (nonatomic,retain) UIPopoverController* popover;
@property (nonatomic,retain) UIView *labelView;
@property (nonatomic,retain) NSMutableArray *detailArray;
@property (nonatomic,retain) ShipCompanyTransShareVC *shipCompanyTrnasShareVC;


@property (nonatomic,retain) DataGridComponentDataSource *dataSource;
@property(nonatomic,retain) FactoryFreightVolumeVC *factoryFreightVolumeVC;
@property(nonatomic,retain) PortEfficiencyVC *portEfficiencyVC;


//-(void)loadViewData_vb;
//-(void)loadViewData_tb;
-(void)setSegmentIndex:(NSInteger) index;


@end
