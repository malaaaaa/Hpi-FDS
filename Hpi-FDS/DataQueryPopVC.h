//
//  DataQueryPopVC.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataQueryMenuVC.h"
#import "CurrentViewTitel.h"
@interface DataQueryPopVC : UIViewController<UIPopoverControllerDelegate,CurrentViewTitel>{
    UIPopoverController* popover;
    DataQueryMenuVC *menuView;
    VBFactoryTransVC *_vbFactoryTransVC;
    DataQueryVC *_dataQueryVC;
}
@property (retain, nonatomic) UIPopoverController* popover;
@property (retain,nonatomic) DataQueryMenuVC *menuView;
@property(retain,nonatomic) VBFactoryTransVC *vbFactoryTransVC;
@property(retain,nonatomic) DataQueryVC *_dataQueryVC;
@end
