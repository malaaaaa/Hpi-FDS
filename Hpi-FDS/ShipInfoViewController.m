//
//  ShipInfoViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-5.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "ShipInfoViewController.h"

@interface ShipInfoViewController ()

@end

@implementation ShipInfoViewController
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
    DataGridComponentDataSource *ds = [[DataGridComponentDataSource alloc] init];
	
	ds.columnWidth = [NSArray arrayWithObjects:@"80",@"80",@"80",@"100",@"60",nil];
	ds.titles = [NSArray arrayWithObjects:@"装运港",@"流向",@"船名",@"供货方",@"装重(吨)",nil];
    
    NSLog(@"查询在途信息 %d条记录",[self.array count]);
    
    ds.data=[[NSMutableArray alloc]init];
    for (i=0;i<[array count];i++) {
        TgShip *tgShip=[self.array objectAtIndex:i];
        if([tgShip.stage isEqualToString:@"0"])
        {
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                tgShip.portName,
                                tgShip.destination,
                                tgShip.shipName,
                                tgShip.supplier,
                                [NSString stringWithFormat:@"%d",tgShip.lw],
                                nil]];
        }
        else {
            [ds.data addObject:[NSArray arrayWithObjects:
                                kRED,
                                tgShip.portName,
                                tgShip.destination,
                                tgShip.shipName,
                                tgShip.supplier,
                                [NSString stringWithFormat:@"%d",tgShip.lw],
                                nil]];
            
        }
        
        
    }
	DataGridComponent *grid = [[DataGridComponent alloc] initWithFrame:CGRectMake(0, 31, 400, 470) data:ds];
	[ds release];
	[self.view addSubview:grid];
	[grid release];
    
}
@end
