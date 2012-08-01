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
#import "VBShipChVC.h"
#import "PortViewController.h"
#import "VBFactoryTransVC.h"
#import "VBTransChVC.h"
#import "TH_ShipTransChVC.h"
#import "FactoryFreightVolumeVC.h"

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
    //MapViewController *mapView=(MapViewController*) self.parentMapView;
    if(self.type==kPORT)
    {
        MapViewController *mapView=(MapViewController*) self.parentMapView;
        [mapView.portButton setTitle:(NSString *)[self.iDArray objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
        [mapView chooseUpdateView];
    }
    else if(self.type==kFACTORY)
    {
        MapViewController *mapView=(MapViewController*) self.parentMapView;
        [mapView.factoryButton setTitle:(NSString *)[self.iDArray objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
        [mapView chooseUpdateView];
    }
    else if(self.type==kSHIP)
    {
        MapViewController *mapView=(MapViewController*) self.parentMapView;
        [mapView.shipButton setTitle:(NSString *)[self.iDArray objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
        [mapView chooseUpdateView];
    }
    else if(self.type==kChCOM)
    {
        VBShipChVC *view1=(VBShipChVC*) self.parentMapView;
        view1.comLabel.text =[self.iDArray objectAtIndex:[indexPath row]];
        if (![view1.comLabel.text isEqualToString:All_]) {
            view1.comLabel.hidden=NO;
            [view1.comButton setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            view1.comLabel.hidden=YES;
            [view1.comButton setTitle:@"航运公司" forState:UIControlStateNormal];
        }
    }
    else if(self.type==kChSTAT)
    {
        VBShipChVC *view1=(VBShipChVC*) self.parentMapView;
        view1.statLabel.text =[self.iDArray objectAtIndex:[indexPath row]];
        if (![view1.statLabel.text isEqualToString:All_]) {
            view1.statLabel.hidden=NO;
            [view1.statButton setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            view1.statLabel.hidden=YES;
            [view1.statButton setTitle:@"状态" forState:UIControlStateNormal];
        }
    }
    else if(self.type==kChSHIP)
    {
        VBShipChVC *view1=(VBShipChVC*) self.parentMapView;
        view1.shipLabel.text =[self.iDArray objectAtIndex:[indexPath row]];
        if (![view1.shipLabel.text isEqualToString:All_]) {
            view1.shipLabel.hidden=NO;
            [view1.shipButton setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            view1.shipLabel.hidden=YES;
            [view1.shipButton setTitle:@"船名" forState:UIControlStateNormal];
        }
    }
    else if(self.type==kChFACTORY)
    {
        VBShipChVC *view1=(VBShipChVC*) self.parentMapView;
        view1.factoryLabel.text =[self.iDArray objectAtIndex:[indexPath row]];
        if (![view1.factoryLabel.text isEqualToString:All_]) {
            view1.factoryLabel.hidden=NO;
            [view1.factoryButton setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            view1.factoryLabel.hidden=YES;
            [view1.factoryButton setTitle:@"电厂" forState:UIControlStateNormal];
        }
    }
    else if(self.type==kChPORT)
    {
        VBShipChVC *view1=(VBShipChVC*) self.parentMapView;
        view1.portLabel.text =[self.iDArray objectAtIndex:[indexPath row]];
        if (![view1.portLabel.text isEqualToString:All_]) {
            view1.portLabel.hidden=NO;
            [view1.portButton setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            view1.portLabel.hidden=YES;
            [view1.portButton setTitle:@"装运港" forState:UIControlStateNormal];
        }
    }
    else if(self.type==kPORTBUTTON)
    {
        PortViewController *view1=(PortViewController*) self.parentMapView;
        view1.portLabel.text =[self.iDArray objectAtIndex:[indexPath row]];
        if (![view1.portLabel.text isEqualToString:NULL]) {
            view1.portLabel.hidden=NO;
            [view1.portButton setTitle:@"" forState:UIControlStateNormal];
        }
    }
    else if(self.type==kKEYVALUE)
    {
        VBFactoryTransVC *view1=(VBFactoryTransVC*) self.parentMapView;
        view1.keyValueLabel.text =[self.iDArray objectAtIndex:[indexPath row]];
        NSLog(@"text=%@",view1.keyValueLabel.text);
        NSLog(@"iDArray=%d",[self.iDArray count]);

        if (![view1.keyValueLabel.text isEqualToString:All_]) {
            view1.keyValueLabel.hidden=NO;
            [view1.keyValueButton setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            view1.keyValueLabel.hidden=YES;
            [view1.keyValueButton setTitle:@"性质" forState:UIControlStateNormal];
        }
    }
    else if(self.type==kTRADE)
    {
        VBFactoryTransVC *view1=(VBFactoryTransVC*) self.parentMapView;
        view1.tradeLabel.text =[self.iDArray objectAtIndex:[indexPath row]];
        if (![view1.tradeLabel.text isEqualToString:All_]) {
            view1.tradeLabel.hidden=NO;
            [view1.tradeButton setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            view1.tradeLabel.hidden=YES;
            [view1.tradeButton setTitle:@"贸易性质" forState:UIControlStateNormal];
        }
    }
    //新添 VBTransChVC   视图下的  煤种 信息   kCOALTYPE
    else if (self.type==kCOALTYPE) {
        
        VBTransChVC *view1=(VBTransChVC *)self.parentMapView;
        view1.typeLabel.text=[self.iDArray objectAtIndex:[indexPath row  ]];
        if (![view1.typeLabel.text isEqualToString:All_]) {
            view1.typeLabel.hidden=NO;
            [view1.typeButton setTitle:@"" forState:UIControlStateNormal];
            
            
        }else {
            view1.typeLabel.hidden=YES;
            [view1.typeButton   setTitle:@"煤种" forState:UIControlStateNormal];
        }
        
    }
    
    //新添  TH_SHIPTRANS    STAGE
    else if (self.type==kshiptransStage) {
        TH_ShipTransChVC *view1=(TH_ShipTransChVC *)self.parentMapView;
        view1.stageLabel.text=[self.iDArray objectAtIndex:[indexPath row    ]];
        if (![view1.stageLabel.text isEqualToString:All_]) {
            view1.stageLabel.hidden=NO;
            [view1.stageButton setTitle:@"" forState:UIControlStateNormal   ];
        }else {
            view1.stageLabel.hidden=YES;
            [view1.stageButton setTitle:@"状态" forState:UIControlStateNormal ];
        }
        
        
    }
    //电厂类型
    else if(kTYPE_FFV==self.type)
    {
        FactoryFreightVolumeVC *view1=(FactoryFreightVolumeVC*) self.parentMapView;
        view1.typeLabel.text =[self.iDArray objectAtIndex:[indexPath row]];
        if (![view1.typeLabel.text isEqualToString:All_]) {
            view1.typeLabel.hidden=NO;
            [view1.typeButton setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            view1.typeLabel.hidden=YES;
            [view1.typeButton setTitle:@"电厂类型" forState:UIControlStateNormal];
        }
    }
    //贸易性质
    else if(kTRADE_FFV==self.type)
    {
        FactoryFreightVolumeVC *view1=(FactoryFreightVolumeVC*) self.parentMapView;
        view1.tradeLabel.text =[self.iDArray objectAtIndex:[indexPath row]];
        if (![view1.tradeLabel.text isEqualToString:All_]) {
            view1.tradeLabel.hidden=NO;
            [view1.tradeButton setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            view1.tradeLabel.hidden=YES;
            [view1.tradeButton setTitle:@"贸易性质" forState:UIControlStateNormal];
        }
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
    
    
    
    cell.textLabel.text=[iDArray objectAtIndex:[indexPath row]];
       
    //cell.textLabel.textColor =[UIColor colorWithRed:38.0/255.0 green:150.0/255.0 blue:200.0/255.0 alpha:1];
    cell.textLabel.textColor =[UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return 44.0;
} 


@end
