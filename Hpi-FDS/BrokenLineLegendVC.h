//
//  BrokenLineLegendVC.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-7-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrokenLineLegendVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tableView;
    NSMutableArray *iDArray;
    UIPopoverController *popover;
    id parentMapView;
    
}
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *iDArray;
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain)id parentMapView;

@end
