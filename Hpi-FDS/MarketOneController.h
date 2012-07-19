//
//  MarketOneController.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-15.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketOneController : UIViewController{
    UIPopoverController *popover;
}

@property(nonatomic,retain) UIPopoverController *popover;

-(void)loadViewData :(NSString *)stringType :(NSDate*)startDay :(NSDate *)endDay :(NSString *)portCode;

@end
