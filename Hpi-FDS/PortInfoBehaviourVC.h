//
//  PortInfoBehaviourVC.h
//  Hpi-FDS
//
//  Created by 馬文培 on 13-2-27.
//  Copyright (c) 2013年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortInfoBehaviourVC.h"
#import "DataGridComponent.h"
#import "PubInfo.h"
#import "PortBehaviour.h"

@interface PortInfoBehaviourVC : UIViewController{
    IBOutlet UILabel *infoLabel;
    UIPopoverController *popover;
    NSMutableArray *array;

}
@property(nonatomic,retain) UILabel *infoLabel;
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain) NSMutableArray *array;
-(void)loadViewData;
@end
