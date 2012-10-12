//
//  ChooseView.m
//  Hpi-FDS
//
//  Created by zcx on 12-3-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//  

#import "ChooseView.h"
#import "MapViewController.h"
#import "PubInfo.h"

@implementation ChooseView
@synthesize tableView,iDArray,popover;
@synthesize parentMapView,type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [tableView release];
    [iDArray release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView.allowsSelection=YES; 
    [tableView setSeparatorColor:[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - tableView
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"状态 【%d】",[self.iDArray count]);
	return [self.iDArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (type==kchship_Latefee||type==kChFACTORY_Latefee||type==kChCOM_Latefee||type==kCOALTYPE_Latefee||type==kSUPPLIER_Latefee) {
        if (indexPath.row==0) {
            [self.parentMapView setLableValue:(NSString *)[self.iDArray objectAtIndex:[indexPath row]]];
        }
        if (indexPath.row>0) {
             [self.parentMapView setLableValue:[NSString stringWithFormat:@"%@,%@",[[self.iDArray objectAtIndex:[indexPath row]] objectAtIndex:0] ,[[self.iDArray objectAtIndex:[indexPath row]] objectAtIndex:1] ]    ];
        }
       
        
        
        
    }else
    {
        
  [self.parentMapView setLableValue:(NSString *)[self.iDArray objectAtIndex:[indexPath row]]];
    
    }
    
    
    
    
    
    
    [self.popover dismissPopoverAnimated:YES];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (type==kchship_Latefee||type==kChFACTORY_Latefee||type==kChCOM_Latefee||type==kCOALTYPE_Latefee||type==kSUPPLIER_Latefee   ) {
        if (indexPath.row==0) {
            cell.textLabel.text=[iDArray objectAtIndex:[indexPath row]];
        }
        if (indexPath.row>0) {
        
            NSMutableArray *arrD=[iDArray objectAtIndex:[indexPath row]];
            cell.textLabel.text=[arrD objectAtIndex:0];
        }
        
        
       
        
      
    }else{
       
        cell.textLabel.text=[iDArray objectAtIndex:[indexPath row]];
    
    }
    
    
    

       
    //cell.textLabel.textColor =[UIColor colorWithRed:38.0/255.0 green:150.0/255.0 blue:200.0/255.0 alpha:1];
    cell.textLabel.textColor =[UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return 44.0;
} 


@end
