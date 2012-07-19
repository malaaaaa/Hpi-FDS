//
//  InfoShipViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoShipViewController : UIViewController{
    IBOutlet UILabel *infoLabel;
    UIPopoverController *popover;
    NSString *shipName;
    UILabel *labelShipName;
    UILabel *company;
    UILabel *portName;
    UILabel *factoryName;
    UILabel *tripNo;
    UILabel *supplier;
    UILabel *heatValue;
    UILabel *lw;
    UILabel *length;
    UILabel *width;
    UILabel *draft;
    UILabel *eta;
    UILabel *lat;
    UILabel *lon;
    UILabel *sog;
    UILabel *destination;
    UILabel *infoTime;
    UILabel *stageName;
}
@property (retain, nonatomic) IBOutlet UILabel *labelShipName;
@property (retain, nonatomic) IBOutlet UILabel *company;
@property (retain, nonatomic) IBOutlet UILabel *portName;
@property (retain, nonatomic) IBOutlet UILabel *factoryName;
@property (retain, nonatomic) IBOutlet UILabel *tripNo;
@property (retain, nonatomic) IBOutlet UILabel *supplier;
@property (retain, nonatomic) IBOutlet UILabel *heatValue;
@property (retain, nonatomic) IBOutlet UILabel *lw;
@property (retain, nonatomic) IBOutlet UILabel *length;
@property (retain, nonatomic) IBOutlet UILabel *width;
@property (retain, nonatomic) IBOutlet UILabel *draft;
@property (retain, nonatomic) IBOutlet UILabel *eta;
@property (retain, nonatomic) IBOutlet UILabel *lat;
@property (retain, nonatomic) IBOutlet UILabel *lon;
@property (retain, nonatomic) IBOutlet UILabel *sog;
@property (retain, nonatomic) IBOutlet UILabel *destination;
@property (retain, nonatomic) IBOutlet UILabel *infoTime;
@property (retain, nonatomic) IBOutlet UILabel *stageName;
@property (nonatomic,retain) UILabel *infoLabel;
@property (nonatomic,retain) UIPopoverController *popover;
@property (nonatomic,copy) NSString *shipName;
-(void)loadViewData;

@end
