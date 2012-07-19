//
//  VBFactoryTransDetailVC.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataGridComponent.h"
#import "VbFactoryTrans.h"


@interface VBFactoryTransDetailVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UIPopoverController *popover;
    NSMutableArray  *iDArray;
    id  parentView;
    IBOutlet UIView *labelView;
    IBOutlet    UITableView *listTableview;
}
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain) NSMutableArray  *iDArray;
@property(nonatomic,retain)id parentView;
@property(nonatomic,retain)  UIView *labelView;
@property(nonatomic,retain) UITableView *listTableview;
@end
