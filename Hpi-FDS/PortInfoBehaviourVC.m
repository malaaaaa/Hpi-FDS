//
//  PortInfoBehaviourVC.m
//  Hpi-FDS
//  首页港口动态
//  Created by 馬文培 on 13-2-27.
//  Copyright (c) 2013年 Landscape. All rights reserved.
//

#import "PortInfoBehaviourVC.h"

@interface PortInfoBehaviourVC ()

@end

@implementation PortInfoBehaviourVC
@synthesize popover,infoLabel,array;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)loadViewData
{
    int i;
    double sumImport=0.0;
    double sumExport=0.0;
    double sumStorage=0.0;
    int sumShipnum=0;
    DataGridComponentDataSource *ds = [[DataGridComponentDataSource alloc] init];
	
	ds.columnWidth = [NSArray arrayWithObjects:@"100",@"60",@"60",@"60",@"60",nil];
	ds.titles = [NSArray arrayWithObjects:@"港口",@"调入",@"调出",@"港存",@"船数",nil];
     NSMutableArray *portarray = [PortBehaviourDao getPortBehaviour];
    NSLog(@"查询港口信息 %d条记录",[portarray count]);
    
    ds.data=[[[NSMutableArray alloc]init] autorelease];
    for (i=0;i<[portarray count];i++) {
        PortBehaviour *portBehaviour= [portarray objectAtIndex:i];
        [ds.data addObject:[NSArray arrayWithObjects:
                            kBLACK,
                            portBehaviour.portName,
                            [NSString stringWithFormat:@"%.1f",portBehaviour.importWeight],
                            [NSString stringWithFormat:@"%.1f",portBehaviour.exportWeight],
                            [NSString stringWithFormat:@"%.1f",portBehaviour.storage],
                            [NSString stringWithFormat:@"%d",portBehaviour.shipNum],
                            nil]];
        sumImport+=portBehaviour.importWeight;
        sumExport+=portBehaviour.exportWeight;
        sumStorage+=portBehaviour.storage;
        sumShipnum+=portBehaviour.shipNum;
        self.infoLabel.text=[NSString stringWithFormat:@"港口动态          %@",portBehaviour.date];
        self.infoLabel.textAlignment=NSTextAlignmentRight;
    }
    //合计
    [ds.data addObject:[NSArray arrayWithObjects:
                        kBLACK,
                        @"合计",
                        [NSString stringWithFormat:@"%.1f",sumImport],
                        [NSString stringWithFormat:@"%.1f",sumExport],
                        [NSString stringWithFormat:@"%.1f",sumStorage],
                        [NSString stringWithFormat:@"%d",sumShipnum],
                        nil]];

	DataGridComponent *grid = [[DataGridComponent alloc] initWithFrame:CGRectMake(0, 35, 340, 285) data:ds];
	[ds release];
	[self.view addSubview:grid];
	[grid release];
    
}

@end
