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
#import "ShipInfoViewController.h"
#import "XMLParser.h"

@interface MapViewController : UIViewController <MKMapViewDelegate,UITableViewDelegate,UIPopoverControllerDelegate,UIGestureRecognizerDelegate>{
    IBOutlet MKMapView *mapView;
    IBOutlet MKMapView *mapViewBig;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UISwitch *switchMap;
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *shipButton;
    IBOutlet UIButton *factoryButton;
    IBOutlet UIButton *portButton;
    InfoPortVewController *infoPortVewController;
    InfoFactoryViewController *infoFactoryViewController;
    InfoTextViewController *infoTextViewController;
    ShipInfoViewController *shipInfoViewController;
    
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
    //
    NSString *chooseShip;
    NSString *chooseFactory;
    NSString *choosePort;
    
    XMLParser *xmlParser;
}
@property(nonatomic, retain) MKMapView *mapView;
@property(nonatomic, retain) MKMapView *mapViewBig;
@property(nonatomic, retain) UIButton *closeButton;
@property(nonatomic, retain) UIActivityIndicatorView *activity;
@property(nonatomic, retain) UISwitch *switchMap;
@property(nonatomic, retain) UIButton *shipButton;
@property(nonatomic, retain) UIButton *portButton;
@property(nonatomic, retain) UIButton *factoryButton;

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
@property (retain,nonatomic) UIPopoverController* popover;
@property (retain,nonatomic) NSString *curTextViewinfo;
@property (retain,nonatomic) NSString *curName;
@property (retain,nonatomic) NSString *curID;

@property (retain,nonatomic) NSString *chooseShip;
@property (retain,nonatomic) NSString *chooseFactory;
@property (retain,nonatomic) NSString *choosePort;

@property (retain,nonatomic)XMLParser *xmlParser;

-(void)displayPort;
-(void)getPortCoordinateArray;
-(void)displayFactory;
-(void)getFactoryCoordinateArray;
-(void)displayShip;
-(void)getShipCoordinateArray;
-(void)chooseUpdateView;

@end
