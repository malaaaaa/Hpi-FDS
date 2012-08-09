//
//  VBTransChVC.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateViewController.h"
#import "ChooseView.h"
#import "PubInfo.h"
#import "XMLParser.h"
#import "ChooseViewDelegate.h"



@interface VBTransChVC :  UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate>{
    UIButton *comButton;
    UILabel *comLabel;
    UIButton *shipButton;
    UILabel *shipLabel;
    UIButton *portButton;
    UILabel *portLabel;
    UIButton *typeButton;
    UILabel *typeLabel;
    UIButton *factoryButton;
    UILabel *factoryLabel;
    UIButton *monthButton;
    UILabel *monthLabel;
    UITextField *codeTextField;
    UIButton *queryButton;
    UIButton *resetButton;
    UIPopoverController* popover;
    ChooseView *chooseView;
    id parentVC;
    UIButton *reloadButton;
    UIActivityIndicatorView *activity;
    XMLParser *xmlParser;
    NSDate *month;
    DateViewController *monthCV;
    
    

}

@property (retain, nonatomic) IBOutlet UIButton *comButton;
@property (retain, nonatomic) IBOutlet UILabel *comLabel;
@property (retain, nonatomic) IBOutlet UIButton *shipButton;
@property (retain, nonatomic) IBOutlet UILabel *shipLabel;
@property (retain, nonatomic) IBOutlet UIButton *portButton;
@property (retain, nonatomic) IBOutlet UILabel *portLabel;
@property (retain, nonatomic) IBOutlet UIButton *typeButton;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UIButton *factoryButton;
@property (retain, nonatomic) IBOutlet UILabel *factoryLabel;
@property (retain, nonatomic) IBOutlet UIButton *monthButton;
@property (retain, nonatomic) IBOutlet UILabel *monthLabel;
@property (retain, nonatomic) IBOutlet UITextField *codeTextField;
@property (retain, nonatomic) IBOutlet UIButton *queryButton;
@property (retain, nonatomic) IBOutlet UIButton *resetButton;
@property (retain, nonatomic) UIPopoverController* popover;
@property (retain, nonatomic) ChooseView *chooseView;
@property (retain, nonatomic) id parentVC;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UIButton *reloadButton;
@property (retain, nonatomic) XMLParser *xmlParser;
@property (retain, nonatomic) NSDate *month;
@property (retain, nonatomic) DateViewController *monthCV;
@end
