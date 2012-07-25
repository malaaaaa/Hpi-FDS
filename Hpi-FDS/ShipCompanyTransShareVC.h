//
//  ShipCompanyTransShareVC.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-20.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubInfo.h"
#import "HpiGraphData.h"
#import "HpiGraphView.h"
#import "DateViewController.h"
#import "XMLParser.h"
#import "MultipleSelectView.h"


@interface ShipCompanyTransShareVC : UIViewController<UIPopoverControllerDelegate>{
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
    IBOutlet UIActivityIndicatorView *_activity;
    XMLParser *_xmlParser;
    HpiGraphView *_graphView;
    MultipleSelectView *_multipleSelectView;
    id parentVC;

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
@property(nonatomic,retain) UIActivityIndicatorView *activity;
@property(nonatomic,retain) XMLParser *xmlParser;
@property(nonatomic,retain) HpiGraphView *graphView;
@property(nonatomic,retain) MultipleSelectView *multipleSelectView;
@property (retain, nonatomic) id parentVC;



- (IBAction)queryAction:(id)sender;
- (IBAction)reloadAction:(id)sender;
@end
