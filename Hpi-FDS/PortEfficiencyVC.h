//
//  PortEfficiencyVC.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-7.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubInfo.h"
#import "TBXMLParser.h"
#import "MultipleSelectView.h"
#import "DateViewController.h"
#import "PowerPlot_lib/PowerPlot.h"
#import "ChooseView.h"
#import "ChooseViewDelegate.h"


@interface PortEfficiencyVC : UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate>{
    UIPopoverController *_popover;
    DateViewController *_startDateCV;
    DateViewController *_endDateCV;
    NSDate *_startDay;
    NSDate *_endDay;
    IBOutlet UIButton *_startButton;
    IBOutlet UIButton *_endButton;
    IBOutlet UIButton *_queryButton;
    IBOutlet UIButton *typeButton; //电厂类型
    IBOutlet UILabel *typeLabel;
    IBOutlet UIButton *comButton;   //航运公司
    IBOutlet UILabel *comLabel;
    IBOutlet UIButton *scheduleButton; //是否班轮
    IBOutlet UILabel *scheduleLabel;
    MultipleSelectView *_multipleSelectView;
    ChooseView *chooseView;
    id parentVC;
    IBOutlet UIView *_chartView;
    IBOutlet UIView *_buttonView;
    IBOutlet UIView *_listView;
    IBOutlet UIButton *_reloadButton;
    IBOutlet UIActivityIndicatorView *_activity;
    TBXMLParser *_tbxmlParser;

}
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain) DateViewController *startDateCV;
@property(nonatomic,retain) DateViewController *endDateCV;
@property(nonatomic,retain) NSDate *startDay;
@property(nonatomic,retain) NSDate *endDay;
@property(nonatomic,retain) UIButton *startButton;
@property(nonatomic,retain) UIButton *endButton;
@property(nonatomic,retain) UIButton *queryButton;
@property(nonatomic,retain) UIButton *reloadButton;
@property (retain, nonatomic) IBOutlet UIButton *typeButton;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UIButton *comButton;
@property (retain, nonatomic) IBOutlet UILabel *comLabel;
@property (retain, nonatomic) IBOutlet UIButton *scheduleButton;
@property (retain, nonatomic) IBOutlet UILabel *scheduleLabel;
@property(nonatomic,retain) MultipleSelectView *multipleSelectView;
@property (retain, nonatomic) ChooseView *chooseView;
@property (retain, nonatomic) id parentVC;
@property(nonatomic,retain) IBOutlet UIView *chartView;
@property(nonatomic,retain) IBOutlet UIView *buttonView;
@property(nonatomic,retain) IBOutlet UIView *listView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) TBXMLParser *tbxmlParser;


- (IBAction)queryData:(id)sender;
- (IBAction)startDate:(id)sender;
- (IBAction)endDate:(id)sender;
- (IBAction)scheduleAction:(id)sender;
- (IBAction)shipCompanyAction:(id)sender;
- (IBAction)typeAction:(id)sender;
- (WSData *)getData;
- (IBAction)reloadAction:(id)sender;


@end
