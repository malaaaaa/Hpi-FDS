//
//  TH_ShipTransChVC.h
//  Hpi-FDS
//
//  Created by bin tang on 12-7-20.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateViewController.h"
#import "ChooseView.h"
#import "PubInfo.h"
#import "TBXMLParser.h"
#import "ChooseViewDelegate.h"

@interface TH_ShipTransChVC : UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate>

{
    UIPopoverController *popover;
    ChooseView *chooseView;
    TBXMLParser *xmlParser;
    DateViewController *monthCV;
      NSDate *month;
     UIActivityIndicatorView *activity;
     UIButton *resetButton;
     UIButton *queryButton;
     UIButton *reloadButton;
    
    
    
    UIButton *portButton;
    UILabel *portLabel;
    
    UIButton *stageButton;
    UILabel *stageLabel;
    
    
    UIButton *monthButton;
    UILabel *monthLabel;
    
    
    id parentVC;
    
    
    
    
    
   

   
}

@property (retain,nonatomic)IBOutlet UIButton *queryButton;
@property (retain,nonatomic)IBOutlet UIButton *resetButton;
@property (retain,nonatomic)IBOutlet UIButton *reloadButton;


@property(retain,nonatomic)id parentVC;

@property(retain,nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property(retain,nonatomic) DateViewController *monthCV;
@property(retain,nonatomic) ChooseView *chooseView;
@property(retain,nonatomic)  TBXMLParser *xmlParser;
@property(retain,nonatomic)   UIPopoverController *popover;
@property(retain,nonatomic)  NSDate *month;




@property (retain, nonatomic) IBOutlet UIButton *portButton;
@property (retain, nonatomic) IBOutlet UILabel *portLabel;

@property (retain, nonatomic) IBOutlet UIButton *stageButton;
@property (retain, nonatomic) IBOutlet UILabel *stageLabel;

@property (retain, nonatomic) IBOutlet  UIButton *monthButton;
@property (retain, nonatomic) IBOutlet UILabel *monthLabel;


@end
