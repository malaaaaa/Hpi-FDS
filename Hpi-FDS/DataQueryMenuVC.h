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
#import "NTLateFeeDmfxVC.h"
#import "NTLateFeeHcfxVC.h"

@interface DataQueryMenuVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tableView;
    NSMutableArray *iDArray;
    UIPopoverController *popover;
    id parentView;
     VBFactoryTransVC *vbFactoryTransVC;
     ShipCompanyTransShareVC *shipCompanyTransShareVC;
     FactoryFreightVolumeVC *factoryFreightVolumeVC;
     PortEfficiencyVC *portEfficiencyVC;
    DataQueryVC *dataQueryVC;
    NTLateFeeDmfxVC *ntLateFeeDmfxVC;
    NTLateFeeHcfxVC *ntLateFeeHcfxVC;

}
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *iDArray;
@property(nonatomic,retain) UIPopoverController *popover;
@property (retain, nonatomic) id parentView;
@property(nonatomic,assign) VBFactoryTransVC *vbFactoryTransVC;
@property(nonatomic,assign) ShipCompanyTransShareVC *shipCompanyTransShareVC;
@property(nonatomic,assign) FactoryFreightVolumeVC *factoryFreightVolumeVC;
@property(nonatomic,assign) PortEfficiencyVC *portEfficiencyVC;
@property(nonatomic,assign) DataQueryVC *dataQueryVC;
@property(nonatomic,assign) NTLateFeeDmfxVC *ntLateFeeDmfxVC;
@property(nonatomic,assign) NTLateFeeHcfxVC *ntLateFeeHcfxVC;




@end
