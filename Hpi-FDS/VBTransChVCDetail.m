//
//  VBTransChVCDetail.m
//  Hpi-FDS
//
//  Created by tang bin on 12-10-29.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VBTransChVCDetail.h"
#import "PubInfo.h"
@interface VBTransChVCDetail ()

@end

@implementation VBTransChVCDetail
@synthesize vbtrans;
@synthesize p_Time;
@synthesize pop;
@synthesize f_Time;
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
    
    
    
    if (vbtrans!=nil ) {
        
        p_Time.text=[PubInfo formaDateTime:vbtrans.eTap FormateString:@"yyyy-MM-dd"] ;
         f_Time.text= [PubInfo formaDateTime:vbtrans.eTaf FormateString:@"yyyy-MM-dd"]  ;
        
    }else
    {
        NSLog(@"nil.............");
    
    }
    
    
    
    
    
    
    
    
}

- (void)viewDidUnload
{
    [p_Time release];
    p_Time = nil;
    [f_Time release];
    f_Time = nil;
     [pop release];
       pop = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    [p_Time release];
    [f_Time release];
    [pop release];
    [vbtrans release];
    [super dealloc];
}
@end
