//
//  TB_LatefeeChVC.h
//  Hpi-FDS
//
//  Created by bin tang on 12-7-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubInfo.h"
#import "TB_Latefee.h"
#import "TB_LatefeeDao.h"
#import "ChooseView.h"
#import "XMLParser.h"
#import "DateViewController.h"
@class ChooseView;

@interface TB_LatefeeChVC : UIViewController<UIPopoverControllerDelegate>
{
    UIPopoverController *poper;
    UILabel *comLabel;
    UIButton *comButton;
    UILabel *shipLabel;
    UIButton *shipButton;
    UILabel *factoryLabel;
    UIButton *factoryButton;
    UILabel *typeLabel;
    UIButton *typeButton;
    UILabel *supLable;
    UIButton *supButton;
    UILabel *startTime;
    UIButton *startButton;
    UILabel *endTime;
    UIButton *endButton;
    UIButton *reload;
    UIActivityIndicatorView *active;
    id  parentVC;
    XMLParser *xmlParser;
    NSDate *month;
    DateViewController  *monthCV;
    ChooseView *chooseView;
}
@property(nonatomic,retain) ChooseView *chooseView;
@property(nonatomic,retain) id  parentVC;
@property(nonatomic,retain) DateViewController  *monthCV;
@property(nonatomic,retain) XMLParser *xmlParser;
@property(nonatomic,retain) NSDate *month;
@property(nonatomic,retain)UIPopoverController *poper;
@property (retain, nonatomic) IBOutlet UILabel *comLabel;
@property (retain, nonatomic) IBOutlet UIButton *comButton;
@property (retain, nonatomic) IBOutlet UILabel *shipLabel;
@property (retain, nonatomic) IBOutlet UIButton *shipButton;
@property (retain, nonatomic) IBOutlet UILabel *factoryLabel;
@property (retain, nonatomic) IBOutlet UIButton *factoryButton;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UIButton *typeButton;
@property (retain, nonatomic) IBOutlet UILabel *supLable;
@property (retain, nonatomic) IBOutlet UIButton *supButton;
@property (retain, nonatomic) IBOutlet UILabel *startTime;
@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UILabel *endTime;
@property (retain, nonatomic) IBOutlet UIButton *endButton;
@property (retain, nonatomic) IBOutlet UIButton *reload;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *active;
@end
