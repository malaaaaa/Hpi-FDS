//
//  DataQueryMenuVC.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "DataQueryMenuVC.h"

@interface DataQueryMenuVC ()

@end

@implementation DataQueryMenuVC
@synthesize parentView;
@synthesize tableView;

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
    tableView.allowsSelection=YES;
    [tableView setSeparatorColor:[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [tableView release];
    [iDArray release];
    [self removeAllSubView];
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
#pragma mark - tableView
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kDataQueryMenu_MAX;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.popover dismissPopoverAnimated:YES];
    [self removeAllSubView];
    if (kMenuDCDTCX==[indexPath row]) {
        vbFactoryTransVC=[[ VBFactoryTransVC alloc ]initWithNibName:@"VBFactoryTransVC" bundle:nil] ;
        vbFactoryTransVC.view.frame = CGRectMake(0, 40, 1024,661 );
        [parentView addSubview:vbFactoryTransVC.view];
        
    }
    else if (kMenuHYGSFETJ==[indexPath row]){
        shipCompanyTransShareVC=[[ ShipCompanyTransShareVC alloc ]initWithNibName:@"ShipCompanyTransShareVC" bundle:nil] ;
        shipCompanyTransShareVC.view.frame = CGRectMake(0, 40, 1024,661 );
        [parentView addSubview:shipCompanyTransShareVC.view];
    }
    else if (kMenuDCYLYLTJ==[indexPath row]){
        factoryFreightVolumeVC=[[ FactoryFreightVolumeVC alloc ]initWithNibName:@"FactoryFreightVolumeVC" bundle:nil] ;
        factoryFreightVolumeVC.view.frame = CGRectMake(0, 40, 1024,661 );
        [parentView addSubview:factoryFreightVolumeVC.view];
    }
    else if (kMenuZXGXLTJ==[indexPath row]){
        portEfficiencyVC=[[ PortEfficiencyVC alloc ]initWithNibName:@"PortEfficiencyVC" bundle:nil] ;
        portEfficiencyVC.view.frame = CGRectMake(0, 40, 1024,661 );
        [parentView addSubview:portEfficiencyVC.view];
    }
    else if (kMenuZQFDMFX==[indexPath row]){
        ntLateFeeDmfxVC=[[ NTLateFeeDmfxVC alloc ]initWithNibName:@"NTLateFeeDmfxVC" bundle:nil] ;
        ntLateFeeDmfxVC.view.frame = CGRectMake(0, 40, 1024,661 );
        [parentView addSubview:ntLateFeeDmfxVC.view];
    }
    else if (kMenuZQFHCFX==[indexPath row]){
        ntLateFeeHcfxVC=[[ NTLateFeeHcfxVC alloc ]initWithNibName:@"NTLateFeeHcfxVC" bundle:nil] ;
        ntLateFeeHcfxVC.view.frame = CGRectMake(0, 40, 1024,661 );
        [parentView addSubview:ntLateFeeHcfxVC.view];
    }
    else{
        dataQueryVC=[[ DataQueryVC alloc ]initWithNibName:@"DataQueryVC" bundle:nil] ;
        dataQueryVC.view.frame = CGRectMake(0, 40, 1024,661 );
        [dataQueryVC setSegmentIndex:[indexPath row]];
        [parentView addSubview:dataQueryVC.view];
    }
    
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch ([indexPath row]) {
        case kMenuDCDTCX:
            cell.textLabel.text=@"电厂动态查询";
            break;
        case kMenuHYGSFETJ:
            cell.textLabel.text=@"航运公司份额统计";
            break;
        case kMenuDCYLYLTJ:
            cell.textLabel.text=@"电厂运力运量统计";
            break;
        case kMenuZXGXLTJ:
            cell.textLabel.text=@"装卸港效率统计";
            break;
        case kMenuSSCBCX:
            cell.textLabel.text=@"实时船舶查询";
            break;
        case kMenuCYJH:
            cell.textLabel.text=@"船运计划";
            break;
        case kMenuDDRZCX:
            cell.textLabel.text=@"调度日志查询";
            break;
        case kMenuZQFMXCX:
            cell.textLabel.text=@"滞期费明细查询";
            break;
        case kMenuZQFTJ:
            cell.textLabel.text=@"滞期费统计";
            break;
        case kMenuGKMJZGSJ:
            cell.textLabel.text=@"港口平均装港时间统计";
            break;
        case kMenuFcAvgZXTime:
            cell.textLabel.text=@"电厂平均装卸港时间统计";
            break;
        case kMenuZQFDMFX:
            cell.textLabel.text=@"滞期费吨煤分析";
            break;
        case kMenuZQFHCFX:
            cell.textLabel.text=@"滞期费航次分析";
            break;
        default:
            break;
    }
    
    
    //cell.textLabel.textColor =[UIColor colorWithRed:38.0/255.0 green:150.0/255.0 blue:200.0/255.0 alpha:1];
    cell.textLabel.textColor =[UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
- (void)removeAllSubView{
    if(vbFactoryTransVC){
        self.vbFactoryTransVC=nil;
    }
    if(shipCompanyTransShareVC){
        self.shipCompanyTransShareVC=nil;
    }
    if(factoryFreightVolumeVC){
        self.factoryFreightVolumeVC=nil;
    }
    if(portEfficiencyVC){
        self.portEfficiencyVC=nil;
    }
    if(dataQueryVC){
        self.dataQueryVC=nil;
    }
    if(ntLateFeeDmfxVC){
        self.ntLateFeeDmfxVC=nil;
    }
    if(ntLateFeeHcfxVC){
        self.ntLateFeeHcfxVC=nil;
    }
}

@end
