//
//  DataQueryMenuVC.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBFactoryTransVC.h"
#import "ShipCompanyTransShareVC.h"
#import "FactoryFreightVolumeVC.h"
#import "PortEfficiencyVC.h"
#import "DataQueryVC.h"
#import "FactoryWaitDynamicViewController.h"
#import "TransPlanImplement.h"
#import "NTLateFeeDmfxVC.h"
#import "NTLateFeeHcfxVC.h"
#import "NTZxgsjtjVC.h"
#import "CurrentViewTitel.h"
@interface DataQueryMenuVC : UIViewController<UITableViewDataSource,UITableViewDelegate,CurrentViewTitel>{
    IBOutlet UITableView *tableView;
    NSMutableArray *iDArray;
    UIPopoverController *popover;
    UIViewController <CurrentViewTitel> *parentView;
     VBFactoryTransVC *vbFactoryTransVC;
     ShipCompanyTransShareVC *shipCompanyTransShareVC;
     FactoryFreightVolumeVC *factoryFreightVolumeVC;
     PortEfficiencyVC *portEfficiencyVC;
    FactoryWaitDynamicViewController *factoryWait;
    TransPlanImplement *transPI;
    
    DataQueryVC *dataQueryVC;
    NTLateFeeDmfxVC *ntLateFeeDmfxVC;
    NTLateFeeHcfxVC *ntLateFeeHcfxVC;
    NTZxgsjtjVC *ntZxgsjtjVC;
}
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *iDArray;
@property(nonatomic,retain) UIPopoverController *popover;
@property (retain, nonatomic) UIViewController <CurrentViewTitel> * parentView;
@property(nonatomic,assign) VBFactoryTransVC *vbFactoryTransVC;
@property(nonatomic,assign) ShipCompanyTransShareVC *shipCompanyTransShareVC;
@property(nonatomic,assign) FactoryFreightVolumeVC *factoryFreightVolumeVC;
@property(nonatomic,assign) PortEfficiencyVC *portEfficiencyVC;
@property(nonatomic,assign) DataQueryVC *dataQueryVC;
@property(nonatomic,assign)   FactoryWaitDynamicViewController *factoryWait;
@property(nonatomic,assign)  TransPlanImplement *transPI;
@property(nonatomic,assign) NTLateFeeDmfxVC *ntLateFeeDmfxVC;
@property(nonatomic,assign) NTLateFeeHcfxVC *ntLateFeeHcfxVC;
@property(nonatomic,assign) NTZxgsjtjVC *ntZxgsjtjVC;

@end
