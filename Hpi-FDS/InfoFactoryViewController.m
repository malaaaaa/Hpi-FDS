//
//  InfoFactoryViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "InfoFactoryViewController.h"
#import "DataGridComponent.h"
#import "PubInfo.h"
@implementation InfoFactoryViewController
@synthesize popover,infoLabel,factoryName;

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
    [popover release];
    [factoryName release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)loadViewData
{
    int i;
    DataGridComponentDataSource *ds = [[DataGridComponentDataSource alloc] init];
	
	ds.columnWidth = [NSArray arrayWithObjects:@"30",@"70",@"100",@"60",@"120",@"30",@"60",@"40",@"100",nil];
	ds.titles = [NSArray arrayWithObjects:@"序号",@"船名",@"航运公司",@"航次",@"供货方",@"热值",@"装载量",@"状态",@"预计到达时间",nil];
    
    NSMutableArray *array=[TgShipDao getTgShipZCPort:self.factoryName];
    NSLog(@"查询 %@ 在厂信息 %d条记录",self.factoryName,[array count]);
    
    ds.data=[[NSMutableArray alloc]init];
    for (i=0;i<[array count];i++) {
        TgShip *tgShip=[array objectAtIndex:i];
        [ds.data addObject:[NSArray arrayWithObjects:
                            kBLACK,
                            [NSString stringWithFormat:@"%d",i+1],
                            tgShip.shipName,
                            tgShip.company,
                            tgShip.tripNo,
                            tgShip.supplier,
                            [NSString stringWithFormat:@"%d",tgShip.heatValue],
                            [NSString stringWithFormat:@"%d",tgShip.lw],
                            tgShip.statName,
                            tgShip.eta,nil]];
        
    }
	DataGridComponent *grid = [[DataGridComponent alloc] initWithFrame:CGRectMake(0, 36, 600, 175) data:ds];
	[ds release];
	[self.view addSubview:grid];
	[grid release];
}
@end
