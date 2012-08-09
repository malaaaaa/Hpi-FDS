//
//  VBFactoryTransVC.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-3.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseView.h"
#import "PubInfo.h"
#import "XMLParser.h"
#import "MultipleSelectView.h"
#import "VBFactoryTransDetailVC.h"
#import "DataGridComponent.h"
#import "DateViewController.h"
#import "ChooseViewDelegate.h"


@interface VBFactoryTransVC : UIViewController<UITableViewDataSource,UIPopoverControllerDelegate,ChooseViewDelegate>{
    UIButton *factoryButton;
    UILabel *factoryLabel;
    UIButton *comButton;
    UILabel *comLabel;
    UIButton *shipButton;
    UILabel *shipLabel;
    UIButton *typeButton; //煤种
    UILabel *typeLabel;  
    UIButton *keyValueButton; //性质
    UILabel *keyValueLabel; 
    UIButton *tradeButton; //贸易性质
    UILabel *tradeLabel; 
    UIButton *statButton;
    UILabel *statLabel;
    UIButton *supButton; //供货商
    UILabel *supLabel; 
    UIButton *dateButton; 
    UILabel *dateLabel; 
    DateViewController* startDateCV;
    NSDate *startDay;
    UIButton *queryButton;
    UIButton *resetButton;
    UIPopoverController* popover;
    ChooseView *chooseView;
    MultipleSelectView *multipleSelectView;
    id parentVC;
    UIButton *reloadButton;
    UIActivityIndicatorView *activity;
    XMLParser *xmlParser;
    IBOutlet UITableView *listTableview;
    IBOutlet UIView *labelView;
    IBOutlet UIView *listView;
    NSMutableArray  *detailArray;
    VBFactoryTransDetailVC *factorytransDeitail;
    NSMutableArray  *listArray;
}

- (IBAction)factoryAction:(id)sender;
- (IBAction)queryAction:(id)sender;
- (IBAction)reloadAction:(id)sender;
-(IBAction)startDate:(id)sender;
- (IBAction)shipCompanyAction:(id)sender;
- (IBAction)shipAction:(id)sender;
- (IBAction)supplierAction:(id)sender;
- (IBAction)coalTypeAction:(id)sender;
- (IBAction)keyValueAction:(id)sender;
- (IBAction)tradeAction:(id)sender;
- (IBAction)shipStageAction:(id)sender;




@property (retain, nonatomic) IBOutlet UIButton *factoryButton;
@property (retain, nonatomic) IBOutlet UILabel *factoryLabel;
@property (retain, nonatomic) IBOutlet UIButton *comButton;
@property (retain, nonatomic) IBOutlet UILabel *comLabel;
@property (retain, nonatomic) IBOutlet UIButton *shipButton;
@property (retain, nonatomic) IBOutlet UILabel *shipLabel;
@property (retain, nonatomic) IBOutlet UIButton *typeButton;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UIButton *keyValueButton;
@property (retain, nonatomic) IBOutlet UILabel *keyValueLabel;
@property (retain, nonatomic) IBOutlet UIButton *tradeButton;
@property (retain, nonatomic) IBOutlet UILabel *tradeLabel;
@property (retain, nonatomic) IBOutlet UIButton *statButton;
@property (retain, nonatomic) IBOutlet UILabel *statLabel;
@property (retain, nonatomic) IBOutlet UIButton *supButton;
@property (retain, nonatomic) IBOutlet UILabel *supLabel;
@property (retain, nonatomic) IBOutlet UIButton *dateButton;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIButton *queryButton;
@property (retain, nonatomic) IBOutlet UIButton *resetButton;
@property(nonatomic,retain) DateViewController *startDateCV;
@property(nonatomic,retain) NSDate *startDay;
@property (retain, nonatomic) UIPopoverController* popover;
@property (retain, nonatomic) ChooseView *chooseView;
@property (retain, nonatomic) MultipleSelectView *multipleSelectView;
@property (retain, nonatomic) id parentVC;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UIButton *reloadButton;
@property (retain, nonatomic) XMLParser *xmlParser;
@property (nonatomic,retain) UITableView *listTableview;
@property (nonatomic,retain) UIView *labelView;
@property (nonatomic,retain) UIView *listView;
@property (nonatomic,retain) NSMutableArray *detailArray;
@property (nonatomic,retain) NSMutableArray *listArray;
@property (nonatomic,retain) VBFactoryTransDetailVC    *factorytransDeitail;

@end
