//
//  NTZxgsjtjVC.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-9-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubInfo.h"
#import "TBXMLParser.h"
#import "MultipleSelectView.h"
#import "ChooseView.h"
#import "ChooseViewDelegate.h"
#import "DateViewController.h"
#import "PowerPlot_lib/PowerPlot.h"
#import "ATHorizontalBarChartView.h"

@interface NTZxgsjtjVC : UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate>{
    UIPopoverController *_popover;
    DateViewController *_startDateCV;
    DateViewController *_endDateCV;
    NSDate *_startDay;
    NSDate *_endDay;
    IBOutlet UIButton *_startButton;
    IBOutlet UIButton *_endButton;
    IBOutlet UIButton *_queryButton;
    IBOutlet UIButton *_comButton;   //航运公司
    IBOutlet UILabel *_comLabel;
    IBOutlet UIButton *_typeButton; //电厂类型
    IBOutlet UILabel *_typeLabel;
    IBOutlet UIButton *_scheduleButton; //是否班轮
    IBOutlet UILabel *_scheduleLabel;
    MultipleSelectView *_multipleSelectView;
    ChooseView *_chooseView;
    id parentVC;
    IBOutlet UIView *_chartView;
    IBOutlet UIView *_buttonView;
    IBOutlet UIActivityIndicatorView *_activity;
    TBXMLParser *_tbxmlParser;
    ATHorizontalBarChartView *_shv;
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
@property (retain, nonatomic)  UIButton *comButton;
@property (retain, nonatomic)  UILabel *comLabel;
@property(nonatomic,retain) MultipleSelectView *multipleSelectView;
@property (retain, nonatomic) ChooseView *chooseView;
@property (retain, nonatomic) id parentVC;
@property(nonatomic,retain)  UIView *chartView;
@property(nonatomic,retain)  UIView *buttonView;
@property (retain, nonatomic)  UIActivityIndicatorView *activity;
@property (retain, nonatomic) TBXMLParser *tbxmlParser;
@property (retain, nonatomic) ATHorizontalBarChartView *shv;
@property (retain, nonatomic)  UIButton *typeButton;
@property (retain, nonatomic)  UILabel *typeLabel;
@property (retain, nonatomic)  UIButton *scheduleButton;
@property (retain, nonatomic)  UILabel *scheduleLabel;

- (IBAction)queryData:(id)sender;
- (IBAction)startDate:(id)sender;
- (IBAction)endDate:(id)sender;
- (IBAction)shipCompanyAction:(id)sender;
//获得装港数据
- (WSData *)getData_ZG;
//获得卸港数据
- (WSData *)getData_XG;
//获得合计数据
- (WSData *)getData_LT;
- (IBAction)reloadAction:(id)sender;
- (IBAction)scheduleAction:(id)sender;
- (IBAction)typeAction:(id)sender;

@end
