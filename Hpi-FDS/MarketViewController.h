//
//  MarketViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-7.
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
#import "MarketOneController.h"

@interface MarketViewController : UIViewController<UIPopoverControllerDelegate>{
    IBOutlet UISegmentedControl *segment;
    UIPopoverController* popover;
    DateViewController* startDateCV;
    DateViewController* endDateCV;
    NSDate *startDay;
    NSDate *endDay;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *endButton;
    IBOutlet UIButton *queryButton;
    IBOutlet UIButton *dataButton;
    IBOutlet UIButton *reloadButton;
    IBOutlet UIActivityIndicatorView *activity;
    TBXMLParser *tbxmlParser;
    HpiGraphView *graphView;
    MarketOneController *marketOneController;
}
@property(nonatomic,retain) UISegmentedControl *segment;
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain) DateViewController *startDateCV;
@property(nonatomic,retain) DateViewController *endDateCV;
@property(nonatomic,retain) NSDate *startDay;
@property(nonatomic,retain) NSDate *endDay;
@property(nonatomic,retain) UIButton *startButton;
@property(nonatomic,retain) UIButton *endButton;
@property(nonatomic,retain) UIButton *queryButton;
@property(nonatomic,retain) UIButton *dataButton;
@property(nonatomic,retain) UIButton *reloadButton;
@property(nonatomic,retain) UIActivityIndicatorView *activity;
@property (retain, nonatomic) TBXMLParser *tbxmlParser;
@property(nonatomic,retain) HpiGraphView *graphView;
@property(nonatomic,retain) MarketOneController *marketOneController;
@end