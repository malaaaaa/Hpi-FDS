//
//  AvgPortPTimeChVC.h
//  Hpi-FDS
//
//  Created by bin tang on 12-8-7.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseView.h"
#import "PubInfo.h"
#import "DataGridComponent.h"
#import "DateViewController.h"
#import "TBXMLParser.h"
#import "ChooseViewDelegate.h"
@interface AvgPortPTimeChVC : UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate>
{
    UIPopoverController *popover;
    UIButton *startButton;
    UILabel *startTime;
    UIButton *endButton;
    UILabel *endTime;

DataGridComponent     *dc;

    UIActivityIndicatorView *activty;
    UIButton *reload;
    
    ChooseView *chooseView;
    
    DateViewController *monthVC; 
    
    id parentVC;
    TBXMLParser *tbxmlParser;
    NSDate *month;



}
@property (retain, nonatomic)DataGridComponent     *dc;

@property (retain, nonatomic)NSDate *month;
@property (retain, nonatomic) TBXMLParser *tbxmlParser;

@property (retain, nonatomic) id parentVC;  

@property (retain, nonatomic) DateViewController *monthVC;

@property (retain, nonatomic)ChooseView *chooseView;

@property (retain, nonatomic)UIPopoverController *popover;

@property (retain, nonatomic)  IBOutlet UIButton *reload;
@property (retain, nonatomic) IBOutlet UIButton *startButton;

@property (retain, nonatomic) IBOutlet UILabel *startTime;

@property (retain, nonatomic) IBOutlet UIButton *endButton;

@property (retain, nonatomic) IBOutlet UILabel *endTime;


@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activty;


@end
