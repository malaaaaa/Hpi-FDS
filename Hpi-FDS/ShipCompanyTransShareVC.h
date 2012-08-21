//
//  ShipCompanyTransShareVC.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-20.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubInfo.h"
//#import "HpiGraphData.h"
#import "BrokenLineGraphData.h"
#import "BrokenLineGraphView.h"
#import "BrokenLineLegendVC.h"
#import "DateViewController.h"
#import "XMLParser.h"
#import "MultipleSelectView.h"
#import "NTColorConfigDao.h"
#import "TBXMLParser.h"
@interface ShipCompanyTransShareVC : UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate>{
    UIPopoverController *_popover;
    DateViewController *_startDateCV;
    DateViewController *_endDateCV;
    NSDate *_startDay;
    NSDate *_endDay;
    IBOutlet UIButton *_portButton;
    IBOutlet UILabel *_portLabel;
    IBOutlet UIButton *_startButton;
    IBOutlet UIButton *_endButton;
    IBOutlet UIButton *_queryButton;
    IBOutlet UIButton *_reloadButton;
    IBOutlet UIButton *_legendButton;
    IBOutlet UIActivityIndicatorView *_activity;
    BrokenLineGraphView *_graphView;
    MultipleSelectView *_multipleSelectView;
    BrokenLineLegendVC *_legendView;
    id parentVC;
    TBXMLParser *tbxmlParser;

}
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain) DateViewController *startDateCV;
@property(nonatomic,retain) DateViewController *endDateCV;
@property(nonatomic,retain) UIButton *portButton;
@property (retain, nonatomic) IBOutlet UILabel *portLabel;
@property(nonatomic,retain) NSDate *startDay;
@property(nonatomic,retain) NSDate *endDay;
@property(nonatomic,retain) UIButton *startButton;
@property(nonatomic,retain) UIButton *endButton;
@property(nonatomic,retain) UIButton *queryButton;
@property(nonatomic,retain) UIButton *reloadButton;
@property(nonatomic,retain) UIButton *legendButton;
@property(nonatomic,retain) UIActivityIndicatorView *activity;
@property(nonatomic,retain) BrokenLineGraphView *graphView;
@property(nonatomic,retain) MultipleSelectView *multipleSelectView;
@property (retain, nonatomic) id parentVC;
@property(nonatomic,retain) BrokenLineLegendVC *legendView;
@property (retain, nonatomic) TBXMLParser *tbxmlParser;


- (IBAction)portAction:(id)sender;
- (IBAction)queryData:(id)sender;
- (IBAction)reloadAction:(id)sender;
- (IBAction)legendAction:(id)sender;
-(IBAction)startDate:(id)sender;
-(IBAction)endDate:(id)sender;
//生成临时表数据
-(void)generateGraphDate;
//折线图
-(void)loadHpiGraphView;

@end
