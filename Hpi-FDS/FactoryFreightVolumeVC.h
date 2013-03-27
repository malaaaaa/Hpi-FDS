//
//  FactoryFreightVolumeVC.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-7-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseView.h"
#import "PubInfo.h"
#import "XMLParser.h"
#import "MultipleSelectView.h"
//#import "DataGridComponent.h"
#import "MultiTitleDataGridComponent.h"
#import "DateViewController.h"
#import "ChooseViewDelegate.h"
#import "TBXMLParser.h"
#import <QuartzCore/QuartzCore.h>

@interface FactoryFreightVolumeVC : UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate>{
    UIButton *queryButton;
    UIButton *resetButton;
    UIButton *tradeButton; //贸易性质
    UILabel *tradeLabel;
    UIButton *typeButton; //电厂类型
    UILabel *typeLabel;
    UIPopoverController* popover;
    ChooseView *chooseView;
    MultipleSelectView *multipleSelectView;
    id parentVC;
    UIButton *reloadButton;
    UIActivityIndicatorView *activity;
    TBXMLParser *tbxmlParser;
    IBOutlet UIView *_buttonView;
    IBOutlet UIView *listView;
    NSMutableArray  *listArray;
    DateViewController *_startDateCV;
    DateViewController *_endDateCV;
    NSDate *_startDay;
    NSDate *_endDay;
    IBOutlet UIButton *_startButton;
    IBOutlet UIButton *_endButton;
}
- (IBAction)queryAction:(id)sender;
- (IBAction)reloadAction:(id)sender;
- (IBAction)resetAction:(id)sender;
- (IBAction)tradeAction:(id)sender;
- (IBAction)typeAction:(id)sender;
-(IBAction)startDate:(id)sender;
-(IBAction)endDate:(id)sender;



@property (retain, nonatomic) IBOutlet UIButton *queryButton;
@property (retain, nonatomic) IBOutlet UIButton *resetButton;
@property (retain, nonatomic) IBOutlet UIButton *tradeButton;
@property (retain, nonatomic) IBOutlet UILabel *tradeLabel;
@property (retain, nonatomic) IBOutlet UIButton *typeButton;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) UIPopoverController* popover;
@property (retain, nonatomic) ChooseView *chooseView;
@property (retain, nonatomic) MultipleSelectView *multipleSelectView;
@property (retain, nonatomic) id parentVC;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UIButton *reloadButton;
@property (retain, nonatomic) TBXMLParser *tbxmlParser;
@property (nonatomic,retain) UIView *buttonView;
//@property (nonatomic,retain) UIView *labelView;
@property (nonatomic,retain) UIView *listView;
@property (nonatomic,retain) NSMutableArray *listArray;
@property(nonatomic,retain) DateViewController *startDateCV;
@property(nonatomic,retain) DateViewController *endDateCV;
@property(nonatomic,retain) NSDate *startDay;
@property(nonatomic,retain) NSDate *endDay;
@property(nonatomic,retain) UIButton *startButton;
@property(nonatomic,retain) UIButton *endButton;
@end
