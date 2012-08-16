//
//  DataQueryPopVC.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataQueryMenuVC.h"

@interface DataQueryPopVC : UIViewController<UIPopoverControllerDelegate>{
    UIPopoverController* popover;
    DataQueryMenuVC *menuView;
}
@property (retain, nonatomic) UIPopoverController* popover;
@property (retain,nonatomic) DataQueryMenuVC *menuView;

@end
