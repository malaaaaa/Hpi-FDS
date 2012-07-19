//
//  VBShipDetailController.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-24.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VBShipDetailController.h"
#import <QuartzCore/QuartzCore.h>

@interface VBShipDetailController ()

@end

@implementation VBShipDetailController
@synthesize p_AnchorageTime;
@synthesize p_Handle;
@synthesize p_ArrivalTime;
@synthesize lw;
@synthesize p_DepartTime;
@synthesize p_Note;
@synthesize f_AnchorageTime;
@synthesize f_ArrivalTime;
@synthesize f_DepartTime;
@synthesize f_Note;
@synthesize lateFee;
@synthesize offEfficiency;
@synthesize popover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setP_AnchorageTime:nil];
    [self setP_Handle:nil];
    [self setP_ArrivalTime:nil];
    [self setLw:nil];
    [self setP_DepartTime:nil];
    [self setP_Note:nil];
    [self setF_AnchorageTime:nil];
    [self setF_ArrivalTime:nil];
    [self setF_DepartTime:nil];
    [self setF_Note:nil];
    [self setLateFee:nil];
    [self setOffEfficiency:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [p_AnchorageTime release];
    [p_Handle release];
    [p_ArrivalTime release];
    [lw release];
    [p_DepartTime release];
    [p_Note release];
    [f_AnchorageTime release];
    [f_ArrivalTime release];
    [f_DepartTime release];
    [f_Note release];
    [lateFee release];
    [offEfficiency release];
    [super dealloc];
}

-(void)loadViewData{
//    self.p_AnchorageTime.text = [NSString stringWithFormat:@"%@", p_AnchorageTime];
//    self.p_Handle.text = [NSString stringWithFormat:@"%@", p_Handle];
//    self.p_ArrivalTime.text = [NSString stringWithFormat:@"%@", p_ArrivalTime];
//    self.lw.text = [NSString stringWithFormat:@"%@", lw];
//    self.p_DepartTime.text = [NSString stringWithFormat:@"%@", p_DepartTime];
//    self.p_Note.text = [NSString stringWithFormat:@"%@", p_Note];
//    self.f_AnchorageTime.text = [NSString stringWithFormat:@"%@", f_AnchorageTime];
//    self.f_ArrivalTime.text = [NSString stringWithFormat:@"%@", f_ArrivalTime];
//    self.f_DepartTime.text = [NSString stringWithFormat:@"%@", f_DepartTime];
//    self.f_Note.text = [NSString stringWithFormat:@"%@", f_Note];
//    self.lateFee.text = [NSString stringWithFormat:@"%@", lateFee];
//    self.offEfficiency.text = [NSString stringWithFormat:@"%@", offEfficiency];
}
@end
