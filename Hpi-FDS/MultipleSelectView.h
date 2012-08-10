//
//  MultipleSelectView.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseViewDelegate.h"

@interface MultipleSelectView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
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
