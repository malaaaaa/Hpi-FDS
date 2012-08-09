//
//  VBShipChVC.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseView.h"
#import "PubInfo.h"
#import "XMLParser.h"

#import "ChooseViewDelegate.h"

@interface VBShipChVC : UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate>{
    UIButton *comButton;
    UILabel *comLabel;
    UIButton *shipButton;
    UILabel *shipLabel;
    UIButton *portButton;
    UILabel *portLabel;
    UIButton *factoryButton;
    UILabel *factoryLabel;
    UIButton *statButton;
    UILabel *statLabel;
    UIButton *queryButton;
    UIButton *resetButton;
    UIPopoverController* popover;
    ChooseView *chooseView;
    id parentVC;
    UIButton *reloadButton;
    UIActivityIndicatorView *activity;
    XMLParser *xmlParser;
}
@property (retain, nonatomic) IBOutlet UIButton *comButton;
@property (retain, nonatomic) IBOutlet UILabel *comLabel;
@property (retain, nonatomic) IBOutlet UIButton *shipButton;
@property (retain, nonatomic) IBOutlet UILabel *shipLabel;
@property (retain, nonatomic) IBOutlet UIButton *portButton;
@property (retain, nonatomic) IBOutlet UILabel *portLabel;
@property (retain, nonatomic) IBOutlet UIButton *factoryButton;
@property (retain, nonatomic) IBOutlet UILabel *factoryLabel;
@property (retain, nonatomic) IBOutlet UIButton *statButton;
@property (retain, nonatomic) IBOutlet UILabel *statLabel;
@property (retain, nonatomic) IBOutlet UIButton *queryButton;
@property (retain, nonatomic) IBOutlet UIButton *resetButton;
@property (retain, nonatomic) UIPopoverController* popover;
@property (retain, nonatomic) ChooseView *chooseView;
@property (retain, nonatomic) id parentVC;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UIButton *reloadButton;
@property (retain, nonatomic) XMLParser *xmlParser;
@end
