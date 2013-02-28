//
//  InfoPortVewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InfoPortVewController.h"
#import "DataGridComponent.h"
#import "PubInfo.h"
@implementation InfoPortVewController
@synthesize infoLabel,popover,portName;

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
    [portName release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    int i;
//    // Do any additional setup after loading the view from its nib.


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
    DataGridComponentDataSource *ds = [[DataGridComponentDataSource alloc] init] ;
	
	ds.columnWidth = [NSArray arrayWithObjects:@"150",@"100",@"90",@"110",@"150",@"60",@"150",@"50",@"50",@"50",nil];
	ds.titles = [NSArray arrayWithObjects:@"序号 - 船名",@"航运公司",@"航次",@"流向",@"供货方",@"装载量",@"锚地",@"待办",@"待靠",@"在装",nil];
    
    NSMutableArray *array=[TgShipDao getTgShipZGPort:self.portName] ;
    NSLog(@"查询 %@ 在港信息 %d条记录",self.portName,[array count]);
    
    ds.data=[[[NSMutableArray alloc]init] autorelease] ;
    for (i=0;i<[array count];i++) {
        TgShip *tgShip=[array objectAtIndex:i];
        [ds.data addObject:[NSArray arrayWithObjects:
                            kBLACK,
                            [NSString stringWithFormat:@"   %d - %@",i+1,tgShip.shipName ],
                            tgShip.company,
                            tgShip.tripNo,
                            tgShip.factoryName,
                            tgShip.supplier,
                            [NSString stringWithFormat:@"%d",tgShip.lw],
                            tgShip.eta,
                            [tgShip.stateCode isEqualToString:@"2"]?@"Y":@"",
                            [tgShip.stateCode isEqualToString:@"3"]?@"Y":@"",
                            [tgShip.stateCode isEqualToString:@"4"]?@"Y":@"",
                            nil]];
    }
	DataGridComponent *grid = [[DataGridComponent alloc] initWithFrame:CGRectMake(0, 61, 600, 175) data:ds];
	[ds release];
	[self.view addSubview:grid];
	[grid release];
    
    DataGridComponentDataSource *ds1 = [[DataGridComponentDataSource alloc] init];
	
	ds1.columnWidth = [NSArray arrayWithObjects:@"150",@"100",@"90",@"110",@"150",@"60",@"150",nil];
	ds1.titles = [NSArray arrayWithObjects:@"序号 - 船名",@"航运公司",@"航次",@"流向",@"供货方",@"装载量",@"预计到达时间",nil];
    
    NSMutableArray *array1=[TgShipDao getTgShipSZZTPort:portName];
    NSLog(@"查询 %@港 受载在途信息 %d条记录",self.portName,[array1 count]);
    ds1.data=[[[NSMutableArray alloc]init] autorelease];
    for (i=0;i<[array1 count];i++) {
        TgShip *tgShip=[array1 objectAtIndex:i];
        [ds1.data addObject:[NSArray arrayWithObjects:
                             kBLACK,
                             [NSString stringWithFormat:@"   %d - %@",i+1,
                             tgShip.shipName],
                             tgShip.company,
                             tgShip.tripNo,
                             tgShip.factoryName,
                             tgShip.supplier,
                             [NSString stringWithFormat:@"%d",tgShip.lw],
                             tgShip.eta,
                             nil]];
        
    }
	DataGridComponent *grid1 = [[DataGridComponent alloc] initWithFrame:CGRectMake(0, 262, 600, 175) data:ds1];
	[ds1 release];
	[self.view addSubview:grid1];
	[grid1 release];
}
@end
