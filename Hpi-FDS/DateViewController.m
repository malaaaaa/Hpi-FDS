//
//  DateViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-16.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController
@synthesize popover,picker,selectedDate;
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
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init]; 
    [myFormatter setDateFormat:@"MM/dd/yyyy"]; 
    NSDate *minDate = [myFormatter dateFromString:@"01/01/2011"];
    [picker setMinimumDate:minDate]; 
    NSDate *maxDate = [NSDate date]; 
    [picker setMaximumDate:maxDate];
    NSDate *initialDate = [NSDate date]; 
    [picker setDate:initialDate animated:YES];
    
    [super viewDidLoad];
    if (!selectedDate) {
        [picker setDate:[NSDate date] animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (selectedDate) {
    [picker setDate:self.selectedDate animated:NO];
    }
}

- (void)viewDidUnload
{
    [picker release];
    picker = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [picker release];
    [super dealloc];
}

#pragma mark
#pragma date picker
-(IBAction)datePickerValueChanged: (id)sender {
    self.selectedDate = [sender date];
    //NSLog(@"selectedDate %@",selectedDate);
}
@end
