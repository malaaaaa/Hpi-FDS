//
//  QueryViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "QueryViewController.h"
@interface QueryViewController ()

@end

@implementation QueryViewController
@synthesize segment,chooseView,listView,dataArray;
@synthesize tbShipChVC;
@synthesize vbShipChVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"动态查询", @"5th");
        self.tabBarItem.image = [UIImage imageNamed:@"query"];
    }
    return self;
}

- (void)viewDidLoad
{
    //self.segment.tintColor= [UIColor colorWithRed:116.0/255 green:67.0/255 blue:167.0/255 alpha:1];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vbShipChVC =[[[ VBShipChVC alloc ]initWithNibName:@"VBShipChVC" bundle:nil] autorelease];
    vbShipChVC.parentVC=self;
    vbShipChVC.view.center = CGPointMake(512, 60);
    [self.chooseView addSubview:vbShipChVC.view];
    
    self.tbShipChVC =[[[ TBShipChVC alloc ]initWithNibName:@"TBShipChVC" bundle:nil] autorelease];
    tbShipChVC.parentVC=self;
    tbShipChVC.view.center = CGPointMake(512, 60);
    [self.chooseView addSubview:tbShipChVC.view];
    
    [self.chooseView bringSubviewToFront:vbShipChVC.view];
    //为视图增加边框      
    //    chooseView.layer.masksToBounds=YES;      
    //    chooseView.layer.cornerRadius=10.0;      
    //    chooseView.layer.borderWidth=10.0;      
    //    chooseView.layer.borderColor=[[UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1]CGColor];  
    chooseView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1];
    
    //为视图增加边框
    listView.layer.masksToBounds=YES;      
    listView.layer.cornerRadius=10.0;      
    listView.layer.borderWidth=10.0;      
    listView.layer.borderColor=[[UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1]CGColor];
    listView.backgroundColor=[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
    
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [segment release];
    segment = nil;
    [chooseView release];
    chooseView = nil;
    [listView release];
    listView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [segment release];
    [chooseView release];
    [listView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-( void )viewDidAppear:( BOOL )animated
{
    
}

#pragma mark - 刷新各个查询页面
-(void)loadViewData_tb
{
    for (UIView *v in listView.subviews)
    {
        [v  removeFromSuperview];
    }
    int i;
    DataGridComponentDataSource *ds = [[DataGridComponentDataSource alloc] init];
	
	ds.columnWidth = [NSArray arrayWithObjects:@"180",@"80",@"60",@"80",@"130",@"60",@"50",@"80",@"60",@"60",@"140",@"140",@"140",@"140",@"140",@"140",@"140",@"140",@"140",@"140",@"140",@"140",nil];
	ds.titles = [NSArray arrayWithObjects:@"航运公司--船名",@"航次",@"流向",@"装港",@"供货方",@"性质",@"煤质",@"贸易性质",@"煤种",@"状态",@"装港-锚地时间",@"装港-手续办理",@"装港-靠泊时间",@"装港-载重",@"装港-离港时间",@"装港-时间",@"卸港-锚地时间",@"卸港-靠卸时间",@"卸港-离港时间",@"卸港-卸港时间",@"卸港-预估滞期费",@"卸港-效率",nil];
    
    NSLog(@"查询 %d条记录",[self.dataArray count]);
    
    ds.data=[[[NSMutableArray alloc]init] autorelease];
    for (i=0;i<[dataArray count];i++) {
        VbShiptrans *vbShiptrans=[dataArray objectAtIndex:i];
        if ([vbShiptrans.stage isEqualToString:@"0"]) {
            [ds.data addObject:[NSArray arrayWithObjects:
                                kGREEN,
                                [NSString stringWithFormat:@"   %@ -%@",vbShiptrans.shipCompany,vbShiptrans.shipName],
                                vbShiptrans.tripNo,
                                vbShiptrans.factoryName,
                                vbShiptrans.portName,
                                vbShiptrans.supplier,
                                vbShiptrans.keyName,
                                [NSString stringWithFormat:@"%d",vbShiptrans.heatValue],
                                vbShiptrans.tradeName,
                                vbShiptrans.coalType,
                                vbShiptrans.stateName,
                                vbShiptrans.p_AnchorageTime,
                                vbShiptrans.p_Handle,
                                vbShiptrans.p_ArrivalTime,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lw],
                                vbShiptrans.p_DepartTime,
                                vbShiptrans.p_Note,
                                vbShiptrans.f_AnchorageTime,
                                vbShiptrans.f_ArrivalTime,
                                vbShiptrans.f_DepartTime,
                                vbShiptrans.f_Note,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lateFee],
                                [NSString stringWithFormat:@"%d",vbShiptrans.offEfficiency],
                                nil]];
        }
        else if ([vbShiptrans.stage isEqualToString:@"2"]) {
            [ds.data addObject:[NSArray arrayWithObjects:
                                kRED,
                                [NSString stringWithFormat:@"   %@ -%@",vbShiptrans.shipCompany,vbShiptrans.shipName],
                                vbShiptrans.tripNo,
                                vbShiptrans.factoryName,
                                vbShiptrans.portName,
                                vbShiptrans.supplier,
                                vbShiptrans.keyName,
                                [NSString stringWithFormat:@"%d",vbShiptrans.heatValue],
                                vbShiptrans.tradeName,
                                vbShiptrans.coalType,
                                vbShiptrans.stateName,
                                vbShiptrans.p_AnchorageTime,
                                vbShiptrans.p_Handle,
                                vbShiptrans.p_ArrivalTime,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lw],
                                vbShiptrans.p_DepartTime,
                                vbShiptrans.p_Note,
                                vbShiptrans.f_AnchorageTime,
                                vbShiptrans.f_ArrivalTime,
                                vbShiptrans.f_DepartTime,
                                vbShiptrans.f_Note,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lateFee],
                                [NSString stringWithFormat:@"%d",vbShiptrans.offEfficiency],
                                nil]];
        }
        else {
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                [NSString stringWithFormat:@"   %@ -%@",vbShiptrans.shipCompany,vbShiptrans.shipName],
                                vbShiptrans.tripNo,
                                vbShiptrans.factoryName,
                                vbShiptrans.portName,
                                vbShiptrans.supplier,
                                vbShiptrans.keyName,
                                [NSString stringWithFormat:@"%d",vbShiptrans.heatValue],
                                vbShiptrans.tradeName,
                                vbShiptrans.coalType,
                                vbShiptrans.stateName,
                                vbShiptrans.p_AnchorageTime,
                                vbShiptrans.p_Handle,
                                vbShiptrans.p_ArrivalTime,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lw],
                                vbShiptrans.p_DepartTime,
                                vbShiptrans.p_Note,
                                vbShiptrans.f_AnchorageTime,
                                vbShiptrans.f_ArrivalTime,
                                vbShiptrans.f_DepartTime,
                                vbShiptrans.f_Note,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lateFee],
                                [NSString stringWithFormat:@"%d",vbShiptrans.offEfficiency],
                                nil]];
        }
        
    }
	DataGridComponent *grid = [[DataGridComponent alloc] initWithFrame:CGRectMake(20, 20, 984,480) data:ds ];
	[ds release];
	[self.listView addSubview:grid];
	[grid release];
}

-(void)loadViewData_vb
{
    for (UIView *v in listView.subviews)
    {
        [v  removeFromSuperview];
    }
    int i;
    DataGridComponentDataSource *ds = [[DataGridComponentDataSource alloc] init];
	
	ds.columnWidth = [NSArray arrayWithObjects:@"80",@"120",@"80",@"100",@"100",@"150",@"70",@"70",@"70",@"70",@"80",@"140",@"140",@"140",@"140",@"140",@"140",@"140",@"140",@"140",@"140",@"140",@"140",nil];
	ds.titles = [NSArray arrayWithObjects:@"航运公司",@"船名",@"航次",@"流向",@"装港",@"供货方",@"性质",@"煤质",@"贸易性质",@"煤种",@"状态",@"装港-锚地时间",@"装港-手续办理",@"装港-靠泊时间",@"装港-载重",@"装港-离港时间",@"装港-时间",@"卸港-锚地时间",@"卸港-靠卸时间",@"卸港-离港时间",@"卸港-卸港时间",@"卸港-预估滞期费",@"卸港-效率",nil];
    
    NSLog(@"查询 %d条记录",[self.dataArray count]);
    
    ds.data=[[[NSMutableArray alloc]init] autorelease];
    for (i=0;i<[dataArray count];i++) {
        VbShiptrans *vbShiptrans=[dataArray objectAtIndex:i];
        if ([vbShiptrans.stage isEqualToString:@"0"]) {
            [ds.data addObject:[NSArray arrayWithObjects:
                                kGREEN,
                                vbShiptrans.shipCompany,
                                vbShiptrans.shipName,
                                vbShiptrans.tripNo,
                                vbShiptrans.factoryName,
                                vbShiptrans.portName,
                                vbShiptrans.supplier,
                                vbShiptrans.keyName,
                                [NSString stringWithFormat:@"%d",vbShiptrans.heatValue],
                                vbShiptrans.tradeName,
                                vbShiptrans.coalType,
                                vbShiptrans.stateName,
                                vbShiptrans.p_AnchorageTime,
                                vbShiptrans.p_Handle,
                                vbShiptrans.p_ArrivalTime,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lw],
                                vbShiptrans.p_DepartTime,
                                vbShiptrans.p_Note,
                                vbShiptrans.f_AnchorageTime,
                                vbShiptrans.f_ArrivalTime,
                                vbShiptrans.f_DepartTime,
                                vbShiptrans.f_Note,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lateFee],
                                [NSString stringWithFormat:@"%d",vbShiptrans.offEfficiency],
                                nil]];
        }
        else if ([vbShiptrans.stage isEqualToString:@"2"]) {
            [ds.data addObject:[NSArray arrayWithObjects:
                                kRED,
                                vbShiptrans.shipCompany,
                                vbShiptrans.shipName,
                                vbShiptrans.tripNo,
                                vbShiptrans.factoryName,
                                vbShiptrans.portName,
                                vbShiptrans.supplier,
                                vbShiptrans.keyName,
                                [NSString stringWithFormat:@"%d",vbShiptrans.heatValue],
                                vbShiptrans.tradeName,
                                vbShiptrans.coalType,
                                vbShiptrans.stateName,
                                vbShiptrans.p_AnchorageTime,
                                vbShiptrans.p_Handle,
                                vbShiptrans.p_ArrivalTime,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lw],
                                vbShiptrans.p_DepartTime,
                                vbShiptrans.p_Note,
                                vbShiptrans.f_AnchorageTime,
                                vbShiptrans.f_ArrivalTime,
                                vbShiptrans.f_DepartTime,
                                vbShiptrans.f_Note,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lateFee],
                                [NSString stringWithFormat:@"%d",vbShiptrans.offEfficiency],
                                nil]];
        }
        else {
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                vbShiptrans.shipCompany,
                                vbShiptrans.shipName,
                                vbShiptrans.tripNo,
                                vbShiptrans.factoryName,
                                vbShiptrans.portName,
                                vbShiptrans.supplier,
                                vbShiptrans.keyName,
                                [NSString stringWithFormat:@"%d",vbShiptrans.heatValue],
                                vbShiptrans.tradeName,
                                vbShiptrans.coalType,
                                vbShiptrans.stateName,
                                vbShiptrans.p_AnchorageTime,
                                vbShiptrans.p_Handle,
                                vbShiptrans.p_ArrivalTime,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lw],
                                vbShiptrans.p_DepartTime,
                                vbShiptrans.p_Note,
                                vbShiptrans.f_AnchorageTime,
                                vbShiptrans.f_ArrivalTime,
                                vbShiptrans.f_DepartTime,
                                vbShiptrans.f_Note,
                                [NSString stringWithFormat:@"%d",vbShiptrans.lateFee],
                                [NSString stringWithFormat:@"%d",vbShiptrans.offEfficiency],
                                nil]];
        }
        
    }
	DataGridComponent *grid = [[DataGridComponent alloc] initWithFrame:CGRectMake(20, 20, 984,480) data:ds ];
	[ds release];
	[self.listView addSubview:grid];
	[grid release];
}

#pragma mark - segment
//根据选择，显示不同类型的坐标点
-(void)segmentChanged:(id) sender
{
    for (UIView *v in listView.subviews)
    {
        [v  removeFromSuperview];
    }

    if(segment.selectedSegmentIndex==0)
    {
        NSLog(@"实时船舶查询");
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.endProgress = 1;
        animation.removedOnCompletion = NO;
        animation.type = @"cube";
        [self.chooseView.layer addAnimation:animation forKey:@"animation"];
        [self.chooseView bringSubviewToFront:vbShipChVC.view];
    }
    else if (segment.selectedSegmentIndex==6)
    {
        NSLog(@"船舶动态查询");
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.endProgress = 1;
        animation.removedOnCompletion = NO;
        animation.type = @"cube";
        [self.chooseView.layer addAnimation:animation forKey:@"animation"];
        [self.chooseView bringSubviewToFront:tbShipChVC.view];
    }
}

@end
