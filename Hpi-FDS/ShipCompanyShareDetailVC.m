//
//  ShipCompanyShareDetailVC.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-27.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "ShipCompanyShareDetailVC.h"

@interface ShipCompanyShareDetailVC ()

@end

@implementation ShipCompanyShareDetailVC
@synthesize popover;
@synthesize company=_company;
@synthesize lw=_lw;
@synthesize percent=_percent;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
