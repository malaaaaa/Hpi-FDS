//
//  TH_ShipTransDetailCV.h
//  Hpi-FDS
//
//  Created by bin tang on 12-7-24.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TH_ShipTrans.h"

@interface TH_ShipTransDetailCV : UIViewController
{

   
    
    UIPopoverController *pop;
    
    
    UILabel * p_ANCHORAGETIME;

    UILabel * p_ARRIVALTIME;
    UILabel *p_DEPARTTIME;
    UILabel *waitTimeLable;

    

    UILabel *p_HANDLE;
    UILabel *note;

}

@property(nonatomic,retain)UIPopoverController *pop;




@property(nonatomic,retain)IBOutlet UILabel * p_ANCHORAGETIME;

@property(nonatomic,retain)IBOutlet  UILabel * p_ARRIVALTIME;
@property(nonatomic,retain)IBOutlet   UILabel *p_DEPARTTIME;





@property(nonatomic,retain)IBOutlet    UILabel *waitTimeLable;


@property(nonatomic,retain)IBOutlet   UILabel *p_HANDLE;

@property(nonatomic,retain)IBOutlet    UILabel *note;



-(void)setLable:(TH_ShipTrans *)thShipTrans;
@end
