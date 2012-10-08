//
//  PortViewController.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CorePlot/CorePlot.h>
#import "DateViewController.h"
#import "PubInfo.h"
#import "HpiGraphData.h"
#import "HpiGraphView.h"
#import "TBXMLParser.h"
#import "ChooseView.h"
#import "MarketOneController.h"
#import "ChooseViewDelegate.h"

@interface PortViewController : UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate>{
    IBOutlet UISegmentedControl *segment;
    UIPopoverController* popover;
    DateViewController* startDateCV;
    DateViewController* endDateCV;
    NSDate *startDay;
    NSDate *endDay;
    IBOutlet UIButton *portButton;
    IBOutlet UILabel *portLabel;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *endButton;
    IBOutlet UIButton *queryButton;
    IBOutlet UIButton *reloadButton;
    IBOutlet UIActivityIndicatorView *activity;
    TBXMLParser *tbxmlParser;
    HpiGraphView *graphView;
    ChooseView *chooseView;
    MarketOneController *marketOneController;
    IBOutlet UIView *_buttonView;
    IBOutlet UIView *_listView;
}
@property(nonatomic,retain) UISegmentedControl *segment;
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain) DateViewController *startDateCV;
@property(nonatomic,retain) DateViewController *endDateCV;
@property(nonatomic,retain) NSDate *startDay;
@property(nonatomic,retain) NSDate *endDay;
@property(nonatomic,retain) UIButton *portButton;
@property (retain, nonatomic) IBOutlet UILabel *portLabel;
@property(nonatomic,retain) UIButton *startButton;
@property(nonatomic,retain) UIButton *endButton;
@property(nonatomic,retain) UIButton *queryButton;
@property(nonatomic,retain) UIButton *reloadButton;
@property(nonatomic,retain) UIActivityIndicatorView *activity;
@property(nonatomic,retain) TBXMLParser *tbxmlParser;
@property(nonatomic,retain) HpiGraphView *graphView;
@property(nonatomic,retain) ChooseView *chooseView;
@property(nonatomic,retain) MarketOneController *marketOneController;
@property(nonatomic,retain) UIView *buttonView;
@property(nonatomic,retain) UIView *listView;
@end
