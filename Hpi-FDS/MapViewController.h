//
//  MapViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ChooseView.h"
#import "InfoPortVewController.h"
#import "InfoFactoryViewController.h"
#import "InfoTextViewController.h"
#import "InfoShipViewController.h"
#import "ShipInfoViewController.h"
#import "SummaryInfoViewController.h"
#import "PortInfoBehaviourVC.h"
#import "XMLParser.h"	
#import "Reachability.h"
#import "TBXMLParser.h"
#import "ChooseViewDelegate.h"
#import "SuperViewDelegate.h"
#import "PubInfo.h"
#import "JSBadgeView/JSBadgeView.h"
#import "WebViewController.h"
#import "MemoirListVC.h"

@class WebViewController;

@interface MapViewController : UIViewController <MKMapViewDelegate,UITableViewDelegate,UIPopoverControllerDelegate,UIGestureRecognizerDelegate,ChooseViewDelegate,SuperViewDelegate>{
    IBOutlet MKMapView *mapView;
    IBOutlet MKMapView *mapViewBig;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UISwitch *switchMap;
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *shipButton;
    IBOutlet UIButton *factoryButton;
    IBOutlet UIButton *portButton;
    IBOutlet UIButton *updateButton;
    InfoPortVewController *infoPortVewController;
    InfoFactoryViewController *infoFactoryViewController;
    InfoTextViewController *infoTextViewController;
    InfoShipViewController *infoShipViewController;
    ShipInfoViewController *shipInfoViewController;
    SummaryInfoViewController *summaryInfoViewController;
    PortInfoBehaviourVC *portInfoBehaviourVC;

    //多选栏
    NSMutableArray *portIDArray;
	NSMutableArray *factoryIDArray;
    NSMutableArray *shipIDArray;
    ChooseView *chooseView;

    //坐标
    NSMutableArray *portCoordinateArray;
	NSMutableArray *factoryCoordinateArray;
    NSMutableArray *shipCoordinateArray;
    
    UIPopoverController* popover;
    //
    NSString *curTextViewinfo;
    NSString *curName;
    NSString *curID;
    
    XMLParser *xmlParser;
    TBXMLParser *tbxmlParser;

    /*添加 信息栏 按钮*/
    IBOutlet UIButton *infoBut; 
    IBOutlet UIView *mainVW;
    WebViewController *wbvc;

    IBOutlet UIButton *fileShow;
    IBOutlet UIImageView *_topView;
    IBOutlet UIButton *_portBehaviourButton;
    IBOutlet UIButton *_transportButton;
    UIImageView *_badgeSuperView;
    JSBadgeView *_badgeView;
}

@property(nonatomic,retain) UIButton *infoBut;
@property(nonatomic,retain) UIView *mainVW;
@property(nonatomic,retain) WebViewController *wbvc;
@property(nonatomic,retain) UIButton *fileShow;
@property(nonatomic,retain) UIImageView *topView;
@property(nonatomic,retain) UIButton *portBehaviourButton;
@property(nonatomic,retain) UIButton *transportButton;
@property(nonatomic,retain) UIImageView *badgeSuperView;
@property(nonatomic,retain) JSBadgeView *badgeView;

@property(nonatomic, retain) MKMapView *mapView;
@property(nonatomic, retain) MKMapView *mapViewBig;
@property(nonatomic, retain) UIButton *closeButton;
@property(nonatomic, retain) UIActivityIndicatorView *activity;
@property(nonatomic, retain) UISwitch *switchMap;
@property(nonatomic, retain) UIButton *shipButton;
@property(nonatomic, retain) UIButton *portButton;
@property(nonatomic, retain) UIButton *factoryButton;
@property(nonatomic, retain) UIButton *updateButton;

@property(nonatomic, retain) NSMutableArray *portCoordinateArray;
@property(nonatomic, retain) NSMutableArray *factoryCoordinateArray;
@property(nonatomic, retain) NSMutableArray *shipCoordinateArray;
	
@property (retain,nonatomic)NSMutableArray *portIDArray;
@property (retain,nonatomic)NSMutableArray *factoryIDArray;
@property (retain,nonatomic)NSMutableArray *shipIDArray;
@property (retain,nonatomic)ChooseView *chooseView;

@property (retain,nonatomic)InfoPortVewController *infoPortVewController;
@property (retain,nonatomic)InfoFactoryViewController *infoFactoryViewController;
@property (retain,nonatomic)InfoTextViewController *infoTextViewController;
@property (retain,nonatomic)ShipInfoViewController *shipInfoViewController;
@property (retain,nonatomic)InfoShipViewController *infoShipViewController;
@property (retain,nonatomic)SummaryInfoViewController *summaryInfoViewController;
@property (retain,nonatomic)PortInfoBehaviourVC *portInfoBehaviourVC;
@property (retain,nonatomic) UIPopoverController* popover;
@property (copy,nonatomic) NSString *curTextViewinfo;
@property (copy,nonatomic) NSString *curName;
@property (copy,nonatomic) NSString *curID;

@property (retain,nonatomic)XMLParser *xmlParser;
@property (retain, nonatomic) TBXMLParser *tbxmlParser;

-(void)displayPort;
-(void)getPortCoordinateArray;
-(void)displayFactory;
-(void)getFactoryCoordinateArray;
-(void)displayShip;
-(void)getShipCoordinateArray;
-(void)chooseUpdateView;
//-(void)getShipCoordinateByChoose:(NSString *)shipName :(NSString *)portName :(NSString *)factoryName :(BOOL)move;
-(void)getShipCoordinateByChoose:(NSString *)shipName :(NSString *)companyName :(BOOL)move;
- (void)reStoreMapRegion;
- (void)reStoreBigMapRegion;
- (void)freshBadgeNumber;
@end
