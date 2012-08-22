//
//  TB_LatefeeChDial.m
//  Hpi-FDS
//
//  Created by bin tang on 12-7-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TB_LatefeeChDial.h"
#import "PubInfo.h"
@interface TB_LatefeeChDial ()

@end

@implementation TB_LatefeeChDial
@synthesize p_Time;
@synthesize f_Time;
@synthesize pfTotalTime;
@synthesize fileName;
@synthesize total;
@synthesize tblatefee;
@synthesize pop;
@synthesize totalLatefee;
NSMutableDictionary *d2;
NSMutableDictionary *d3;
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

    if (tblatefee!=nil&&totalLatefee!=0 ) {
     //   NSLog(@"tblatefee 不为空..................");
        //滞期费合计
        total.text=totalLatefee;
     //   NSLog(@"------------------滞期费合计----------------：【%@】", total.text);
        
        
        
        p_Time.text=[PubInfo formatInfoDate:tblatefee.P_DEPARTTIME :tblatefee.P_ANCHORAGETIME];
        
        
      //  NSLog(@"-------p_Time:[%@]",p_Time.text);
        
        d2=[PubInfo formatInfoDate1:tblatefee.P_DEPARTTIME :tblatefee.P_ANCHORAGETIME];
        
        
        f_Time.text=[PubInfo formatInfoDate:tblatefee.F_DEPARTTIME :tblatefee.F_ANCHORAGETIME];
         //NSLog(@"-------f_Time:[%@]",f_Time.text);
        
        
        
        d3=[PubInfo formatInfoDate1:tblatefee.F_DEPARTTIME :tblatefee.F_ANCHORAGETIME];
        //装卸总时间
        pfTotalTime.text=[PubInfo getTotalTime:d2:d3];
        
       //   NSLog(@"-------pfTotalTime:[%@]",pfTotalTime.text);
        
        fileName.text=@"附件";
    }
  }


- (void)viewDidUnload
{
    [self setP_Time:nil];
    [self setF_Time:nil];
    [self setPfTotalTime:nil];
    [self setFileName:nil];
    [self setPop:nil];
    [self setTotal:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void)dealloc {
    [p_Time release];
    [f_Time release];
    [pfTotalTime release];
    [fileName release];
    [tblatefee  release];
    [pop release];
    
    [d2 release];
    [d3  release] ;
    [totalLatefee    release];
    [total release];
    [super dealloc];
}

@end
