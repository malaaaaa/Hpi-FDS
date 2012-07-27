//
//  ShipCompanyShareDetailVC.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-27.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipCompanyShareDetailVC : UIViewController{
    IBOutlet UILabel *_company;
    IBOutlet UILabel *_lw; //载煤量
    IBOutlet UILabel *_percent;
    UIPopoverController *popover;
}

@property(nonatomic,retain) UILabel *company;
@property(nonatomic,retain) UILabel *lw;
@property(nonatomic,retain) UILabel *percent;
@property(nonatomic,retain) UIPopoverController *popover;

@end
