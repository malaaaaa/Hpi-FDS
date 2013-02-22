//
//  MultipleSelectView.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "MultipleSelectView.h"
#import "MapViewController.h"
#import "PubInfo.h"
#import "PortViewController.h"
#import "VBFactoryTransVC.h"
#import "ShipCompanyTransShareVC.h"


@interface MultipleSelectView ()

@end

@implementation MultipleSelectView
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    tableView.allowsSelection=YES;
    [tableView setSeparatorColor:[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void)dealloc {
    [tableView release];
    [iDArray release];
    [super dealloc];
}
#pragma mark - tableView
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count%d",[self.iDArray count]);
	return [self.iDArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.parentMapView multipleSelectViewdidSelectRow:[indexPath row]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //选中后的反显颜色即刻消失
    [self.tableView reloadData];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(self.type==kChFACTORY){
        
        
        cell.textLabel.text=((TgFactory *)[iDArray objectAtIndex:[indexPath row]]).factoryName;
        if (((TgFactory *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected==YES) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
        }
        else {
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
    }
    
    else if (self.type==kSHIPCOMPANY){
        
        
        cell.textLabel.text=((TfShipCompany *)[iDArray objectAtIndex:[indexPath row]]).company;
        if (((TfShipCompany *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected==YES) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
        }
        else {
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
    }
    else if (self.type==kSHIP){
        
        
        cell.textLabel.text=((TgShip *)[iDArray objectAtIndex:[indexPath row]]).shipName;
        if (((TgShip *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected==YES) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
        }
        else {
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    else if (self.type==kSUPPLIER){
        
        
        cell.textLabel.text=((TfSupplier *)[iDArray objectAtIndex:[indexPath row]]).SUPPLIER;
        if (((TfSupplier *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected==YES) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
        }
        else {
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
    }
    else if (self.type==kCOALTYPE){
        
        
        cell.textLabel.text=((TfCoalType *)[iDArray objectAtIndex:[indexPath row]]).COALTYPE;
        if (((TfCoalType *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected==YES) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
        }
        else {
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
    }
    else if (self.type==kSHIPSTAGE){
        
        
        cell.textLabel.text=((TsShipStage *)[iDArray objectAtIndex:[indexPath row]]).STAGENAME;
        if (((TsShipStage *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected==YES) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
        }
        else {
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
    }
    else if (self.type==kPORT){
        
        
        cell.textLabel.text=((TgPort *)[iDArray objectAtIndex:[indexPath row]]).portName;
        if (((TgPort *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected==YES) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
        }
        else {
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
    }
    else if (self.type==kPORT_F){
        
        
        cell.textLabel.text=((TfPort *)[iDArray objectAtIndex:[indexPath row]]).PORTNAME;
        if (((TfPort *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected==YES) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
        }
        else {
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
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
