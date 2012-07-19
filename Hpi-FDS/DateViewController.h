//
//  DateViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-16.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateViewController : UIViewController{
    UIPopoverController *popover;
    IBOutlet UIDatePicker *picker;
    NSDate *selectedDate;
}
@property(nonatomic,retain) UIPopoverController *popover;
@property(nonatomic,retain) UIDatePicker *picker;
@property(nonatomic,retain) NSDate *selectedDate;
-(IBAction)datePickerValueChanged: (id)sender;
@end

