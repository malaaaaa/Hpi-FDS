//
//  InfoShipViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "InfoShipViewController.h"
#import "PubInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "DataGridComponent.h"
@implementation InfoShipViewController
@synthesize labelShipName;
@synthesize company;
@synthesize portName;
@synthesize factoryName;
@synthesize tripNo;
@synthesize supplier;
@synthesize heatValue;
@synthesize lw;
@synthesize length;
@synthesize width;
@synthesize draft;
@synthesize eta;
@synthesize lat;
@synthesize lon;
@synthesize sog;
@synthesize destination;
@synthesize infoTime;
@synthesize stageName;
@synthesize infoLabel, popover, shipName,dynamic;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setLabelShipName:nil];
    [self setCompany:nil];
    [self setPortName:nil];
    [self setFactoryName:nil];
    [self setTripNo:nil];
    [self setSupplier:nil];
    [self setHeatValue:nil];
    [self setLw:nil];
    [self setLength:nil];
    [self setWidth:nil];
    [self setDraft:nil];
    [self setEta:nil];
    [self setLat:nil];
    [self setLon:nil];
    [self setSog:nil];
    [self setDestination:nil];
    [self setInfoTime:nil];
    [self setStageName:nil];
    [self setDynamic:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [popover release];
    [shipName release];
    [labelShipName release];
    [company release];
    [portName release];
    [factoryName release];
    [tripNo release];
    [supplier release];
    [heatValue release];
    [lw release];
    [length release];
    [width release];
    [draft release];
    [eta release];
    [lat release];
    [lon release];
    [sog release];
    [destination release];
    [infoTime release];
    [stageName release];
    [dynamic release];
    [super dealloc];
}

-(void)loadViewData{
//    int i=0;
    DataGridComponentDataSource *ds = [[DataGridComponentDataSource alloc] init];
	ds.columnWidth = [NSArray arrayWithObjects:@"100",@"100",@"100",@"100",@"100",@"100",nil];
	ds.titles = [NSArray arrayWithObjects:@"序号",@"流向",@"装港",@"供货方",@"预计载重",@"预计抵港时间",nil];
    
    NSMutableArray *array=[TgShipDao getTgShipByName:shipName];

    ds.data=[[NSMutableArray alloc]init];
    
    TgShip *tgShip=[array objectAtIndex:0];
    
    /** 改为剩余航运计划 modified by mawp **/
    //    [ds.data addObject:[NSArray arrayWithObjects:
    //                        kBLACK,
    //                        [NSString stringWithFormat:@"%d",i+1],
    //                            tgShip.factoryName,
    //                            tgShip.portName,
    //                            tgShip.supplier,
    //                            [NSString stringWithFormat:@"%d",tgShip.lw],
    //                            tgShip.eta,nil]];
    NSMutableArray *arrayPlan=[VbTransplanDao getVbTransplanByTripNO:tgShip.tripNo ShipID:tgShip.shipID];
    
    for (int i=0; i<[arrayPlan count]; i++) {
        VbTransplan *vbPlan=[arrayPlan objectAtIndex:i];
        [ds.data addObject:[NSArray arrayWithObjects:
                            kBLACK,
                            [NSString stringWithFormat:@"%d",i+1],
                            vbPlan.factoryName,
                            vbPlan.portName,
                            vbPlan.supplier,
                            [NSString stringWithFormat:@"%.2f",vbPlan.eLw],
                            [vbPlan.eTap substringToIndex:10],nil]];
    }
    
 
    self.labelShipName.text = [NSString stringWithFormat:@"%@", tgShip.shipName];
    self.company.text = [NSString stringWithFormat:@"%@", tgShip.company];
    self.portName.text = [NSString stringWithFormat:@"%@", tgShip.portName];
    self.factoryName.text = [NSString stringWithFormat:@"%@", tgShip.factoryName];
    self.tripNo.text = [NSString stringWithFormat:@"%@", tgShip.tripNo];
    self.supplier.text = [NSString stringWithFormat:@"%@", tgShip.supplier];
    self.heatValue.text = [NSString stringWithFormat:@"%d", tgShip.heatValue];
    self.lw.text = [NSString stringWithFormat:@"%d", tgShip.lw];
    self.length.text = [NSString stringWithFormat:@"%@", tgShip.length];
    self.width.text = [NSString stringWithFormat:@"%@", tgShip.width];
    self.draft.text = [NSString stringWithFormat:@"%@", tgShip.draft];
    self.eta.text = [NSString stringWithFormat:@"%@", tgShip.eta];
    self.lat.text = [NSString stringWithFormat:@"%@", tgShip.lat];
    self.lon.text = [NSString stringWithFormat:@"%@", tgShip.lon];
    self.sog.text = [NSString stringWithFormat:@"%@", tgShip.sog];
    self.destination.text = [NSString stringWithFormat:@"%@", tgShip.destination];
    self.infoTime.text = [NSString stringWithFormat:@"%@", tgShip.infoTime];
    self.stageName.text = [NSString stringWithFormat:@"%@", tgShip.stageName];
    self.dynamic.text=[NSString stringWithFormat:@"%@", tgShip.dynamic];
    
	DataGridComponent *grid = [[DataGridComponent alloc] initWithFrame:CGRectMake(0, 349, 600, 154) data:ds];

//    [ds.data release];

	[ds release];
	[self.view addSubview:grid];

	[grid release];

}
@end
