//
//  TransPlanImplement.h
//  Hpi-FDS
//
//  Created by tang bin on 12-9-11.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubInfo.h"
#import "TB_Latefee.h"
#import "TB_LatefeeDao.h"
#import "ChooseView.h"
#import "TBXMLParser.h"
#import "DateViewController.h"
#import "ChooseViewDelegate.h"
#import "FactoryWaitFootTable.h"
#import "TransPlanImpDao.h"


#import "PMCalendar.h"

#import "PMCalendarController.h"
@interface TransPlanImplement : UIViewController<UIPopoverControllerDelegate,ChooseViewDelegate ,PMCalendarControllerDelegate,UITabBarDelegate,UITableViewDataSource>
{


    UIPopoverController *poper;
    UILabel *comLabel;
    UIButton *comButton;
    UILabel *shipLabel;
    UIButton *shipButton;
    UILabel *factoryLabel;
    UIButton *factoryButton;
    
    UILabel *portLabel;
    UIButton *portButton;
    UILabel *supLable;
    UIButton *supButton;
    
    UILabel *coalTypeLabel;
    UIButton *coalTypeButton;
    UILabel *typeLabel;
    UIButton *typeButton;
 
    
    UILabel *startTime;
    UIButton *startButton;
    UILabel *endTime;
    UIButton *endButton;
    UIButton *reload;
    UIActivityIndicatorView *active;
    
    
    TBXMLParser *xmlParser;
    NSDate *month;
    DateViewController  *monthCV;
    ChooseView *chooseView;


    MultiTitleDataSource *source;

    UIView *dcView;
    
     
    SearchModel *model;


    
    UIView *TitleView;
    
    UITableView *listTableview;
    
    
    UIView *listView;
    
}

@property (retain, nonatomic) IBOutlet UIView *listView;


@property (retain, nonatomic)IBOutlet   UIView *TitleView;
@property (retain, nonatomic)IBOutlet   UITableView *listTableview;




@property (retain, nonatomic) IBOutlet UIView *dcView;
@property(nonatomic,retain)SearchModel *model;

@property(nonatomic,retain)MultiTitleDataSource *source;



@property(nonatomic,retain) ChooseView *chooseView;

@property(nonatomic,retain) DateViewController  *monthCV;
@property(nonatomic,retain) TBXMLParser *xmlParser;
@property(nonatomic,retain) NSDate *month;
@property(nonatomic,retain)UIPopoverController *poper;

@property (retain, nonatomic) IBOutlet UILabel *comLabel;
@property (retain, nonatomic) IBOutlet UIButton *comButton;
@property (retain, nonatomic) IBOutlet UILabel *shipLabel;
@property (retain, nonatomic) IBOutlet UIButton *shipButton;
@property (retain, nonatomic) IBOutlet UILabel *factoryLabel;
@property (retain, nonatomic) IBOutlet UIButton *factoryButton;

@property (retain, nonatomic) IBOutlet UILabel *portLabel;
@property (retain, nonatomic) IBOutlet UIButton *portButton;
@property (retain, nonatomic) IBOutlet UILabel *supLable;
@property (retain, nonatomic) IBOutlet UIButton *supButton;

@property (retain, nonatomic) IBOutlet UILabel *coalTypeLabel;
@property (retain, nonatomic) IBOutlet UIButton *coalTypeButton;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UIButton *typeButton;

@property (retain, nonatomic) IBOutlet UILabel *startTime;
@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UILabel *endTime;
@property (retain, nonatomic) IBOutlet UIButton *endButton;
@property (retain, nonatomic) IBOutlet UIButton *reload;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *active;


@end
