//
//  FactoryWaitDynamicViewController.h
//  Hpi-FDS
//
//  Created by tang bin on 12-8-27.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiTitleDataGridComponent.h"
#import "ChooseView.h"
#import "ChooseViewDelegate.h"
#import "DateViewController.h"
#import "TBXMLParser.h"
#import <QuartzCore/QuartzCore.h>



@interface FactoryWaitDynamicViewController : UIViewController<UIPopoverControllerDelegate  ,ChooseViewDelegate,UIScrollViewDelegate,UITabBarDelegate,UITableViewDataSource>
{ 
    UIPopoverController *popover;
    ChooseView *chooseView;
    DateViewController *monthVC;
    TBXMLParser *tbxmlParser;
    NSDate *month;
    
    UILabel *factoryLable;
    UIButton *factoryButton;
    
    UILabel *startTime;
    //UIButton *startButton;
    
    UIActivityIndicatorView *activty;
    UIButton *reload;
    UIView *scrool;
    UIView *dcView;
    
    DataGridScrollView *ds;
    
    UIView *TitleView;
    
    UITableView *listTableview;
    
    MultiTitleDataSource *source;
    
    UIView *cView;
    
}


@property (retain, nonatomic)IBOutlet   UIView *cView;
@property (retain, nonatomic)MultiTitleDataSource *source;
@property (retain, nonatomic)IBOutlet   UIView *TitleView;
@property (retain, nonatomic)IBOutlet   UITableView *listTableview;
@property (retain, nonatomic)DataGridScrollView *ds;
@property (retain, nonatomic)NSDate *month;
@property (retain, nonatomic) TBXMLParser *tbxmlParser;
@property (retain, nonatomic) DateViewController *monthVC;
@property (retain, nonatomic)ChooseView *chooseView;
@property (retain, nonatomic)UIPopoverController *popover;
@property (retain, nonatomic)  IBOutlet   UIView *dcView;
@property (retain, nonatomic)  IBOutlet  UIView *scrool;
@property (retain, nonatomic)  IBOutlet UIButton *reload;
//@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UILabel *startTime;
@property (retain, nonatomic) IBOutlet UIButton *factoryButton;
@property (retain, nonatomic) IBOutlet UILabel *factoryLable;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activty;
@end
