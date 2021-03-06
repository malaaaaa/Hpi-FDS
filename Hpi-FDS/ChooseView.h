//
//  ChooseView.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseViewDelegate.h"



@interface ChooseView : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tableView;
    NSMutableArray *iDArray;
    UIPopoverController *popover;
    id<ChooseViewDelegate> parentMapView;
    NSInteger type;
}
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *iDArray;
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain)id<ChooseViewDelegate> parentMapView;
@property NSInteger type;
@end
