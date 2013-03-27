//
//  NTLateFeeHcfxVC.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-9-13.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubInfo.h"
#import "TBXMLParser.h"
#import "MultipleSelectView.h"
#import "DateViewController.h"
#import "PowerPlot_lib/PowerPlot.h"
#import "ATHorizontalBarChartView.h"
#import <QuartzCore/QuartzCore.h>
@interface NTLateFeeHcfxVC : UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate>{
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
    MultipleSelectView *_multipleSelectView;
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
@property (retain, nonatomic) id parentVC;
@property(nonatomic,retain)  UIView *chartView;
@property(nonatomic,retain)  UIView *buttonView;
@property (retain, nonatomic)  UIActivityIndicatorView *activity;
@property (retain, nonatomic) TBXMLParser *tbxmlParser;
@property (retain, nonatomic) ATHorizontalBarChartView *shv;


- (IBAction)queryData:(id)sender;
- (IBAction)startDate:(id)sender;
- (IBAction)endDate:(id)sender;
- (IBAction)shipCompanyAction:(id)sender;
//获得滞期费数据
- (WSData *)getData_LATEFEE;
//获得航次数据
- (WSData *)getData_HC;
//获得运量数据
- (WSData *)getData_YL;
- (IBAction)reloadAction:(id)sender;
@end
