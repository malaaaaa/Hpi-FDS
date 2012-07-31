//
//  BrokenLineLegendVC.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-7-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "BrokenLineLegendVC.h"
#import "PubInfo.h"
#import "ShipCompanyTransShareVC.h"

@interface BrokenLineLegendVC ()

@end

@implementation BrokenLineLegendVC
@synthesize tableView,iDArray,popover;
@synthesize parentMapView;

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
    tableView.allowsSelection=YES;
    [tableView setSeparatorColor:[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1]];

    NSLog(@"count===%d",[iDArray count]);

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
- (void)dealloc {
    [tableView release];
    [super dealloc];
}
#pragma mark - tableView
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [iDArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NTColorConfig *colorConfig=[iDArray objectAtIndex:[indexPath row]];
    
    
    cell.textLabel.text=colorConfig.DESCRIPTION;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font=[UIFont systemFontOfSize:12.0f];
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 60, 10 )];
    colorLabel.backgroundColor=[UIColor colorWithRed:[colorConfig.RED floatValue]/255 green:[colorConfig.GREEN floatValue]/255 blue:[colorConfig.BLUE floatValue]/255 alpha:1];
    
    [cell addSubview:colorLabel];
    [colorLabel release];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20.0;
}

@end
