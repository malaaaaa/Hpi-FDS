//
//  InfoFactoryViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoFactoryViewController: UIViewController{
    IBOutlet UILabel *infoLabel;
    UIPopoverController *popover;
    NSString *factoryName;
}
@property(nonatomic,retain) UILabel *infoLabel;
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain) NSString *factoryName;
-(void)loadViewData;
@end
