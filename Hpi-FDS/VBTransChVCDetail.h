//
//  VBTransChVCDetail.h
//  Hpi-FDS
//
//  Created by tang bin on 12-10-29.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBTransChVC.h"
@interface VBTransChVCDetail : UIViewController
{

    UIPopoverController *pop;

    IBOutlet UILabel *p_Time;

    IBOutlet UILabel *f_Time;
    VbTransplan *vbtrans;
    
    
}
@property (nonatomic,retain)UILabel *p_Time;
@property (nonatomic,retain) VbTransplan *vbtrans;
@property (nonatomic,retain)UILabel *f_Time;
@property(nonatomic,retain)UIPopoverController *pop;
@end
