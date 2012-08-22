//
//  TH_ShipTransDetailCV.m
//  Hpi-FDS
//
//  Created by bin tang on 12-7-24.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TH_ShipTransDetailCV.h"
#import "TH_ShipTrans.h"
#import "PubInfo.h"
@interface TH_ShipTransDetailCV ()

@end

@implementation TH_ShipTransDetailCV
@synthesize p_ANCHORAGETIME;
@synthesize p_DEPARTTIME;
@synthesize p_ARRIVALTIME;
@synthesize p_HANDLE;
@synthesize pop;

@synthesize waitTimeLable;
@synthesize note;
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
    
    NSLog(@"TH_ShipTransDetailCV:------------viewDidLoad------------");
    
        
      
}
-(void)setLable:(TH_ShipTrans *)thShipTrans
{

    if (thShipTrans!=nil) {
        
        
        NSLog(@"属性thShipTrans------------ ");
        NSLog(@"%@",thShipTrans.P_ANCHORAGETIME );
        NSLog(@"%@",thShipTrans.P_ARRIVALTIME );
        NSLog(@"%@",thShipTrans.P_HANDLE );
        NSLog(@"%@",thShipTrans.NOTE );
        
        
        self. p_ANCHORAGETIME.text=  [PubInfo formaDateTime:thShipTrans.P_ANCHORAGETIME FormateString:@"yyyy/MM/dd"];
        
        
        self.p_ARRIVALTIME.text=[PubInfo formaDateTime:thShipTrans.P_ARRIVALTIME FormateString:@"yyyy/MM/dd"] ;
        
        self.p_DEPARTTIME.text=  [PubInfo formaDateTime:thShipTrans.P_DEPARTTIME FormateString:@"yyyy/MM/dd"] ;
        
        
        
        self.p_HANDLE.text=  [PubInfo formaDateTime:thShipTrans.P_HANDLE FormateString:@"yyyy/MM/dd"] ;
        
        self.waitTimeLable.text=[PubInfo formatInfoDate:thShipTrans.P_ARRIVALTIME :thShipTrans.P_ANCHORAGETIME];
        
        
        self.note.text=   thShipTrans.NOTE ;
        
        NSLog(@"------------NOte:%@",thShipTrans.NOTE);
        
        
    }





}

- (void)viewDidUnload
{
    
    [self setPop:nil];
    [self setP_ANCHORAGETIME:nil];
    [self setP_ARRIVALTIME:nil];
    [self setP_DEPARTTIME:nil];
    [self setNote:nil];
    
  
    [self setWaitTimeLable:nil ];
    [self setP_HANDLE:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{

    [super dealloc];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
