//
//  TB_LatefeeChDial.h
//  Hpi-FDS
//
//  Created by bin tang on 12-7-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TB_Latefee.h"
@interface TB_LatefeeChDial : UIViewController
{
    UIPopoverController *pop;

UILabel *p_Time;
    UILabel *f_Time;

UILabel *pfTotalTime;

UILabel *fileName;
    UILabel *total;
    NSString * totalLatefee;
    
    TB_Latefee *tblatefee;
    
    
    
}
@property(nonatomic,retain) TB_Latefee *tblatefee;
@property(nonatomic,retain) NSString *  totalLatefee;
@property(nonatomic,retain)UIPopoverController *pop;
@property (retain, nonatomic) IBOutlet UILabel *p_Time;
@property (retain, nonatomic) IBOutlet UILabel *f_Time;
@property (retain, nonatomic) IBOutlet UILabel *pfTotalTime;
@property (retain, nonatomic) IBOutlet UILabel *fileName;
@property (retain, nonatomic) IBOutlet UILabel *total;
@end
