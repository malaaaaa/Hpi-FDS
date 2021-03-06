//
//  DataQueryMenuVC.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "DataQueryMenuVC.h"

#import "DataQueryPopVC.h"
@interface DataQueryMenuVC ()

@end

@implementation DataQueryMenuVC
@synthesize parentView;
@synthesize tableView;
@synthesize vbFactoryTransVC;
@synthesize ntLateFeeDmfxVC;
@synthesize ntLateFeeHcfxVC;
@synthesize iDArray;
@synthesize popover;
@synthesize ntZxgsjtjVC;
@synthesize shipCompanyTransShareVC;
@synthesize factoryFreightVolumeVC;
@synthesize factoryWait;
@synthesize transPI;
@synthesize dataQueryVC;
@synthesize portEfficiencyVC;


static  NSMutableArray *actionTitle;
 static NSMutableDictionary *dic;
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
   
    actionTitle=[[NSMutableArray alloc ] initWithObjects:@"实时查询",@"查询统计",@"滞期费查询", nil];
   // @"电厂靠泊动态",
//    dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSMutableArray alloc] initWithObjects:@"实时电厂动态", @"实时船舶动态",@"航运计划",nil],@"0",[[NSMutableArray alloc] initWithObjects:@"航运公司份额统计", @"电厂运力运量统计",@"装卸港效率统计",@"调度日志查询",@"港口平均装港时间统计",@"电厂平均装卸港时间统计",@"装卸港时间统计",@"航运计划执行情况",nil],@"1",[[NSMutableArray alloc] initWithObjects:@"滞期费明细查询", @"滞期费统计",@"滞期费吨煤分析",@"滞期费航次分析",nil],@"2", nil];
     dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSMutableArray alloc] initWithObjects:@"实时电厂动态", @"实时船舶动态",@"航运计划",nil],@"0",[[NSMutableArray alloc] initWithObjects:@"航运公司份额统计", @"电厂运力运量统计",@"装卸港效率统计",@"港口平均装港时间统计",@"电厂平均装卸港时间统计",@"装卸港时间统计",@"航运计划执行情况",nil],@"1",[[NSMutableArray alloc] initWithObjects:@"滞期费明细查询", @"滞期费统计",@"滞期费吨煤分析",@"滞期费航次分析",nil],@"2", nil];
    
   // NSLog(@"sfdafas");
    
    
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
    [dic     release];
    [actionTitle release];
    [self removeAllSubView];
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
#pragma mark - tableView
// Customize the number of rows in the table view.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [actionTitle count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[dic objectForKey:[NSString stringWithFormat:@"%d",section]] count];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return [actionTitle objectAtIndex:section];



  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.popover dismissPopoverAnimated:YES];
      [self removeAllSubView];
    NSArray*a=[dic objectForKey:[NSString stringWithFormat:@"%d",indexPath.section] ];
    if (indexPath.section==kMenuSelect) {
        
        if (indexPath.row==kMenuSSCBCX) {//实时船舶查询
            [self removeAllSubView];
            dataQueryVC=[[ DataQueryVC alloc ]initWithNibName:@"DataQueryVC" bundle:nil] ;
            dataQueryVC.view.frame = CGRectMake(0, 40, 1024,661 );
           [dataQueryVC setSegmentIndex:[indexPath row]:[indexPath section]]; 
            [parentView.view addSubview:dataQueryVC.view];
        }
        
        else if (indexPath.row==kMenuCYJH)//船运计划
        {
            [self removeAllSubView];
            dataQueryVC=[[ DataQueryVC alloc ]initWithNibName:@"DataQueryVC" bundle:nil] ;
            dataQueryVC.view.frame = CGRectMake(0, 40, 1024,661 );
            [dataQueryVC setSegmentIndex:[indexPath row]:[indexPath section]];
            [parentView.view addSubview:dataQueryVC.view];
        }

        //   移除    电厂靠泊
        /*
        
        else if ([indexPath row]==kMenuFactoryWaitState)//电厂靠泊
        {
            [self removeAllSubView];
            factoryWait=[[FactoryWaitDynamicViewController   alloc] initWithNibName:@"FactoryWaitDynamicViewController" bundle:nil];
            factoryWait.view.frame = CGRectMake(0, 40, 1024,661 );
            
           //[self.parentView setTitelValue:@"2"];
            
            [parentView.view addSubview:factoryWait.view];
        }*/

        if (kMenuDCDTCX==[indexPath row]) {//电厂动态查询
            [self removeAllSubView];
            vbFactoryTransVC=[[ VBFactoryTransVC alloc ]initWithNibName:@"VBFactoryTransVC" bundle:nil] ;
            vbFactoryTransVC.view.frame = CGRectMake(0, 40, 1024,661 );
         //[self.parentView setTitelValue:@"3"];
            [parentView.view addSubview:vbFactoryTransVC.view];
            
        }
        
        
    }
    
    
    if (indexPath.section==kMenuTJ) {
        
        if (indexPath.row==kMenuHYGSFETJ) {//航运公司份额统计
            [self removeAllSubView];
            shipCompanyTransShareVC=[[ ShipCompanyTransShareVC alloc ]initWithNibName:@"ShipCompanyTransShareVC" bundle:nil] ;
            shipCompanyTransShareVC.view.frame = CGRectMake(0, 40, 1024,661 );
          //  [self.parentView setTitelValue:@"4"];
            
            [parentView.view addSubview:shipCompanyTransShareVC.view];
        }
        else if (kMenuDCYLYLTJ==[indexPath row]){//电厂运力运量统计
            [self removeAllSubView];
            factoryFreightVolumeVC=[[ FactoryFreightVolumeVC alloc ]initWithNibName:@"FactoryFreightVolumeVC" bundle:nil] ;
            factoryFreightVolumeVC.view.frame = CGRectMake(0, 40, 1024,661 );
            //[self.parentView setTitelValue:@"5"];
            [parentView.view addSubview:factoryFreightVolumeVC.view];
        }
        else if (kMenuZXGXLTJ==[indexPath row]){//装卸港效率统计
            [self removeAllSubView];
            portEfficiencyVC=[[ PortEfficiencyVC alloc ]initWithNibName:@"PortEfficiencyVC" bundle:nil] ;
            portEfficiencyVC.view.frame = CGRectMake(0, 40, 1024,661 );
            // [self.parentView setTitelValue:@"6"];
            [parentView.view addSubview:portEfficiencyVC.view];
        }
//       else if (kMenuDDRZCX==[indexPath row]||kMenuGKMJZGSJ==[indexPath row]||kMenuFcAvgZXTime==[indexPath row]){//调度日志查询、港口平均装港时间统计、电厂装卸港时间统计
        else if (kMenuGKMJZGSJ==[indexPath row]||kMenuFcAvgZXTime==[indexPath row]){//调度日志查询、港口平均装港时间统计、电厂装卸港时间统计
 
           
           [self removeAllSubView];
           dataQueryVC=[[ DataQueryVC alloc ]initWithNibName:@"DataQueryVC" bundle:nil] ;
           dataQueryVC.view.frame = CGRectMake(0, 40, 1024,661 );
            [dataQueryVC setSegmentIndex:[indexPath row]:[indexPath section]];
           
           
           
          //  [self.parentView setTitelValue:@"7"];
           [parentView.view addSubview:dataQueryVC.view];
            
           // NSLog(@"MenuVC");
            
            
        }
       else if (kMenuZXGSJTJ==[indexPath row]){//装卸港时间统计
           ntZxgsjtjVC=[[ NTZxgsjtjVC alloc ]initWithNibName:@"NTZxgsjtjVC" bundle:nil] ;
           ntZxgsjtjVC.view.frame = CGRectMake(0, 40, 1024,661 );
          //[self.parentView setTitelValue:@"8"];
           [parentView.view addSubview:ntZxgsjtjVC.view];
       }
       else if ([indexPath row]==kMenuTransPlanimplment)//航运计划执行情况
       {
           [self removeAllSubView];
           transPI=[[ TransPlanImplement   alloc] initWithNibName:@"TransPlanImplement" bundle:nil];
           transPI.view.frame = CGRectMake(0, 40, 1024,661 );
         // [self.parentView setTitelValue:@"9"];
           [parentView.view addSubview:transPI.view];
       }
    }
    if (indexPath.section==kMenuLatefee) {
        if (indexPath.row==kMenuZQFMXCX||indexPath.row==kMenuZQFTJ) {
            
            [self removeAllSubView];
            dataQueryVC=[[ DataQueryVC alloc ]initWithNibName:@"DataQueryVC" bundle:nil] ;
            dataQueryVC.view.frame = CGRectMake(0, 40, 1024,661 );
           [dataQueryVC setSegmentIndex:[indexPath row]:[indexPath section]];
            
            
           // [self.parentView setTitelValue:@"10"];
           
            [parentView.view addSubview:dataQueryVC.view];
            
            
        }
        else if (kMenuZQFDMFX==[indexPath row]){
            ntLateFeeDmfxVC=[[ NTLateFeeDmfxVC alloc ]initWithNibName:@"NTLateFeeDmfxVC" bundle:nil] ;
            ntLateFeeDmfxVC.view.frame = CGRectMake(0, 40, 1024,661 );
         //  [self.parentView setTitelValue:@"11"];
            [parentView.view addSubview:ntLateFeeDmfxVC.view];
        }
        
        else if (kMenuZQFHCFX==[indexPath row]){
            ntLateFeeHcfxVC=[[ NTLateFeeHcfxVC alloc ]initWithNibName:@"NTLateFeeHcfxVC" bundle:nil] ;
            ntLateFeeHcfxVC.view.frame = CGRectMake(0, 40, 1024,661 );
         // [self.parentView setTitelValue:@"12"];
            [parentView.view  addSubview:ntLateFeeHcfxVC.view];
        }
        
        
        
        
    }
    
    
      [self.parentView setTitelValue:[a objectAtIndex:indexPath.row]];
    
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
        
    NSMutableArray *title=[dic objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
        
    cell.textLabel.text=[title objectAtIndex:indexPath.row];
  // cell.textLabel.textColor =[UIColor colorWithRed:38.0/255.0 green:150.0/255.0 blue:200.0/255.0 alpha:1];
    cell.textLabel.textColor =[UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 34.0;
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
if(factoryWait){
    self.factoryWait=nil;
    [factoryWait release];
}
if(transPI){
    self.transPI=nil;
}
    if(dataQueryVC){
        self.dataQueryVC=nil;
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
    if(ntZxgsjtjVC){
        self.ntZxgsjtjVC=nil;
    }
}





@end
