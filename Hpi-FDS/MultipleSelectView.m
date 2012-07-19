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
    //MapViewController *mapView=(MapViewController*) self.parentMapView;
    if(self.type==kPORT)
    {
        MapViewController *mapView=(MapViewController*) self.parentMapView;
        [mapView.portButton setTitle:(NSString *)[self.iDArray objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
        [mapView chooseUpdateView];
    }
    else if(self.type==kChFACTORY)
    {
        
        VBFactoryTransVC *factoryView=(VBFactoryTransVC*) self.parentMapView;
        
        factoryView.factoryLabel.text =((TgFactory *)[self.iDArray objectAtIndex:[indexPath row]]).factoryName;
        factoryView.factoryLabel.hidden=YES;
        NSLog(@"1beforre%@",factoryView.factoryLabel.text);
        
        if ([((TgFactory *)[self.iDArray objectAtIndex:[indexPath row]]).factoryName isEqualToString:All_]) {
            factoryView.factoryLabel.hidden=YES;
            [factoryView.factoryButton setTitle:@"电厂" forState:UIControlStateNormal];
            if(((TgFactory *)[self.iDArray objectAtIndex:0]).didSelected==YES){
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TgFactory *)[self.iDArray objectAtIndex:i]).didSelected=NO;
                }
                
            }
            else {
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TgFactory *)[self.iDArray objectAtIndex:i]).didSelected=YES;
                }
            }
            
        }
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		if (cell.accessoryType == UITableViewCellAccessoryNone){
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            ((TgFactory *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=YES;                        
        }
		else{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
            ((TgFactory *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=NO;
            ((TgFactory *)[self.iDArray objectAtIndex:0]).didSelected=NO;
            
		}
        
        //只要有条件选中，附加星号标示
        for (int i=0; i<[self.iDArray count]; i++) {
            if(((TgFactory *)[self.iDArray objectAtIndex:i]).didSelected==YES)
            {
                factoryView.factoryLabel.hidden=YES;
                [factoryView.factoryButton setTitle:@"电厂(*)" forState:UIControlStateNormal];   
            }
        }
        
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        [self.tableView reloadData];
        
    }
    else if(self.type==kSHIPCOMPANY)
    {
        
        VBFactoryTransVC *factoryView=(VBFactoryTransVC*) self.parentMapView;
        
        factoryView.comLabel.text =((TfShipCompany *)[self.iDArray objectAtIndex:[indexPath row]]).company;
        factoryView.comLabel.hidden=YES;
        
        NSLog(@"laaaaaaaa==%d==%@",[indexPath row],((TgShip *)[self
                                                               .iDArray objectAtIndex:0]).company);
        if ([((TfShipCompany *)[self.iDArray objectAtIndex:[indexPath row]]).company isEqualToString:All_]) {
            factoryView.comLabel.hidden=YES;
            [factoryView.comButton setTitle:@"航运公司" forState:UIControlStateNormal];
            if(((TfShipCompany *)[self.iDArray objectAtIndex:0]).didSelected==YES){
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TfShipCompany *)[self.iDArray objectAtIndex:i]).didSelected=NO;
                }
                
            }
            else {
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TfShipCompany *)[self.iDArray objectAtIndex:i]).didSelected=YES;
                }
            }
            
        }
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		if (cell.accessoryType == UITableViewCellAccessoryNone){
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            ((TfShipCompany *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=YES;                        
        }
		else{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
            ((TfShipCompany *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=NO;
            ((TfShipCompany *)[self.iDArray objectAtIndex:0]).didSelected=NO;
            
		}
        
        //只要有条件选中，附加星号标示
        for (int i=0; i<[self.iDArray count]; i++) {
            if(((TfShipCompany *)[self.iDArray objectAtIndex:i]).didSelected==YES)
            {
                factoryView.comLabel.hidden=YES;
                [factoryView.comButton setTitle:@"航运公司(*)" forState:UIControlStateNormal];   
            }
        }
        
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        [self.tableView reloadData];
        
    }
    else if(self.type==kSHIP)
    {
        
        VBFactoryTransVC *factoryView=(VBFactoryTransVC*) self.parentMapView;
        
        factoryView.shipLabel.text =((TgShip *)[self.iDArray objectAtIndex:[indexPath row]]).company;
        factoryView.shipLabel.hidden=YES;
        
        if ([((TgShip *)[self.iDArray objectAtIndex:[indexPath row]]).shipName isEqualToString:All_]) {
            factoryView.shipLabel.hidden=YES;
            [factoryView.shipButton setTitle:@"船名" forState:UIControlStateNormal];
            if(((TgShip *)[self.iDArray objectAtIndex:0]).didSelected==YES){
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TgShip *)[self.iDArray objectAtIndex:i]).didSelected=NO;
                }
                
            }
            else {
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TgShip *)[self.iDArray objectAtIndex:i]).didSelected=YES;
                }
            }
            
        }
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		if (cell.accessoryType == UITableViewCellAccessoryNone){
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            ((TgShip *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=YES;                        
        }
		else{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
            ((TgShip *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=NO;
            ((TgShip *)[self.iDArray objectAtIndex:0]).didSelected=NO;
            
		}
        
        //只要有条件选中，附加星号标示
        for (int i=0; i<[self.iDArray count]; i++) {
            if(((TgShip *)[self.iDArray objectAtIndex:i]).didSelected==YES)
            {
                factoryView.shipLabel.hidden=YES;
                [factoryView.shipButton setTitle:@"船名(*)" forState:UIControlStateNormal];   
            }
        }
        
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        [self.tableView reloadData];
        
    }
    else if(self.type==kSUPPLIER)
    {
        
        VBFactoryTransVC *factoryView=(VBFactoryTransVC*) self.parentMapView;
        
        factoryView.supLabel.text =((TfSupplier *)[self.iDArray objectAtIndex:[indexPath row]]).SUPPLIER;
        factoryView.supLabel.hidden=YES;
        
        if ([((TfSupplier *)[self.iDArray objectAtIndex:[indexPath row]]).SUPPLIER isEqualToString:All_]) {
            factoryView.supLabel.hidden=YES;
            [factoryView.supButton setTitle:@"供货商" forState:UIControlStateNormal];
            if(((TfSupplier *)[self.iDArray objectAtIndex:0]).didSelected==YES){
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TfSupplier *)[self.iDArray objectAtIndex:i]).didSelected=NO;
                }
                
            }
            else {
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TfSupplier *)[self.iDArray objectAtIndex:i]).didSelected=YES;
                }
            }
            
        }
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		if (cell.accessoryType == UITableViewCellAccessoryNone){
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            ((TfSupplier *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=YES;                        
        }
		else{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
            ((TfSupplier *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=NO;
            ((TfSupplier *)[self.iDArray objectAtIndex:0]).didSelected=NO;
            
		}
        
        //只要有条件选中，附加星号标示
        for (int i=0; i<[self.iDArray count]; i++) {
            if(((TfSupplier *)[self.iDArray objectAtIndex:i]).didSelected==YES)
            {
                factoryView.supLabel.hidden=YES;
                [factoryView.supButton setTitle:@"供货商(*)" forState:UIControlStateNormal];   
            }
        }
        
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        [self.tableView reloadData];
        
    }
    else if(self.type==kCOALTYPE)
    {
        
        VBFactoryTransVC *factoryView=(VBFactoryTransVC*) self.parentMapView;
        
        factoryView.typeLabel.text =((TfCoalType *)[self.iDArray objectAtIndex:[indexPath row]]).COALTYPE;
        factoryView.typeLabel.hidden=YES;
        
        if ([((TfCoalType *)[self.iDArray objectAtIndex:[indexPath row]]).COALTYPE isEqualToString:All_]) {
            factoryView.typeLabel.hidden=YES;
            [factoryView.typeButton setTitle:@"煤种" forState:UIControlStateNormal];
            if(((TfCoalType *)[self.iDArray objectAtIndex:0]).didSelected==YES){
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TfCoalType *)[self.iDArray objectAtIndex:i]).didSelected=NO;
                }
                
            }
            else {
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TfCoalType *)[self.iDArray objectAtIndex:i]).didSelected=YES;
                }
            }
            
        }
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		if (cell.accessoryType == UITableViewCellAccessoryNone){
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            ((TfCoalType *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=YES;                        
        }
		else{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
            ((TfCoalType *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=NO;
            ((TfCoalType *)[self.iDArray objectAtIndex:0]).didSelected=NO;
            
		}
        
        //只要有条件选中，附加星号标示
        for (int i=0; i<[self.iDArray count]; i++) {
            if(((TfCoalType *)[self.iDArray objectAtIndex:i]).didSelected==YES)
            {
                factoryView.typeLabel.hidden=YES;
                [factoryView.typeButton setTitle:@"煤种(*)" forState:UIControlStateNormal];   
            }
        }
        
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        [self.tableView reloadData];
        
    }
    else if(self.type==kSHIPSTAGE)
    {
        
        VBFactoryTransVC *factoryView=(VBFactoryTransVC*) self.parentMapView;
        
        factoryView.statLabel.text =((TsShipStage *)[self.iDArray objectAtIndex:[indexPath row]]).STAGENAME;
        factoryView.statLabel.hidden=YES;
        
        if ([((TsShipStage *)[self.iDArray objectAtIndex:[indexPath row]]).STAGENAME isEqualToString:All_]) {
            factoryView.statLabel.hidden=YES;
            [factoryView.statButton setTitle:@"状态" forState:UIControlStateNormal];
            if(((TsShipStage *)[self.iDArray objectAtIndex:0]).didSelected==YES){
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TsShipStage *)[self.iDArray objectAtIndex:i]).didSelected=NO;
                }
            }
            else {
                for (int i=0; i<[self.iDArray count]; i++) {
                    ((TsShipStage *)[self.iDArray objectAtIndex:i]).didSelected=YES;
                }
            }
            
        }
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		if (cell.accessoryType == UITableViewCellAccessoryNone){
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            ((TsShipStage *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=YES;                        
        }
		else{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
            ((TsShipStage *)[self.iDArray objectAtIndex:[indexPath row]]).didSelected=NO;
            ((TsShipStage *)[self.iDArray objectAtIndex:0]).didSelected=NO;
            
		}
        
        //只要有条件选中，附加星号标示
        for (int i=0; i<[self.iDArray count]; i++) {
            if(((TsShipStage *)[self.iDArray objectAtIndex:i]).didSelected==YES)
            {
                factoryView.statLabel.hidden=YES;
                [factoryView.statButton setTitle:@"状态(*)" forState:UIControlStateNormal];   
            }
        }
        
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        [self.tableView reloadData];
        
    }
    
    
    //[self.popover dismissPopoverAnimated:YES];
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
    
    
    //cell.textLabel.textColor =[UIColor colorWithRed:38.0/255.0 green:150.0/255.0 blue:200.0/255.0 alpha:1];
    cell.textLabel.textColor =[UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return 44.0;
} 


@end
