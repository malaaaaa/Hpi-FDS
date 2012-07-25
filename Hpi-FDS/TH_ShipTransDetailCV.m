//
//  TH_ShipTransDetailCV.m
//  Hpi-FDS
//
//  Created by bin tang on 12-7-24.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TH_ShipTransDetailCV.h"
#import "TH_ShipTrans.h"
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
        
        
        self. p_ANCHORAGETIME.text=  [self formaDateTime:  thShipTrans.P_ANCHORAGETIME   ];
        
        self.p_ARRIVALTIME.text=[  self formaDateTime:thShipTrans.P_ARRIVALTIME       ]   ;
        
        self.p_DEPARTTIME.text=   [ self formaDateTime:thShipTrans.P_DEPARTTIME    ] ;
        
        self.p_HANDLE.text=  [self formaDateTime:thShipTrans.P_HANDLE     ];
        
        self.waitTimeLable.text=[self formatInfoDate:thShipTrans.P_ARRIVALTIME :thShipTrans.P_ANCHORAGETIME];
        
        
        self.note.text=   thShipTrans.NOTE ;
        
        NSLog(@"------------NOte:%@",thShipTrans.NOTE);
        
        
    }





}


-(NSString *)formaDateTime:(NSString *)string
{
    NSString *str;
   
    
    
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
       
  
    NSDateFormatter *formater1=[[NSDateFormatter alloc] init];
    [formater1 setDateFormat:@"yyyy/MM/dd"];
    
    
    NSString *date=[NSString  stringWithFormat:@"%@",[formater1 stringFromDate:[formater dateFromString:string]]];
    
    NSLog(@"formaDateTime---date--yyyy-MM-dd--:%@",date);
    
    if (![date isEqualToString:@"2000/01/01"]&&![date isEqualToString:@"1900/01/01"]) {
        str=[NSString stringWithFormat:@"%@",date]; 
        
        
        return str;
    }else {
        
        str=[NSString stringWithFormat:@"%@",@"未知"];
        
        NSLog(@"未知：%@",date);
        return  str;
    }

    [formater release];
    [formater1 release];

}



- (NSString *)formatInfoDate:(NSString *)string1 :(NSString *)string2 {
    NSLog(@"string date1: %@", string1);
    NSLog(@"string date2: %@", string2);
   NSString * str;
    
      
    if ([[self formaDateTime:string1] isEqualToString:@"未知"]||[[self formaDateTime:string2] isEqualToString:@"未知"]      ) {
        str=[NSString stringWithFormat:@"%@",@""];
        
        return  str;
        
    }else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *date1 = [formatter dateFromString:string1];
        NSDate *date2 = [formatter dateFromString:string2];
        NSLog(@"date1: %@", [formatter stringFromDate:date1]);
        NSLog(@"date2: %@", [formatter stringFromDate:date2]);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlag = NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents *components = [calendar components:unitFlag fromDate:date1 toDate:date2 options:0];
        int days    =fabs([components day]) ;
        int hours   = fabs([components hour]);
        int minutes =fabs([components minute]) ;
        
        NSLog(@"days :%d", days);
        NSLog(@" hours :%d",hours);
        NSLog(@" minutes :%d",minutes);
        [formatter release];
        
        if(days>=0&&hours>=0&&minutes>=0)
        {
            if(days!=0)
            {
                str=[NSString stringWithFormat:@"%d天%d小时%d分钟",days,hours,minutes];
                return str;
            }
            else if(days==0&&hours!=0)
            {
                str=[NSString stringWithFormat:@"%d小时%d分钟",hours,minutes];
                return str;
            }
            else if(days==0&&hours==0&&minutes!=0)
            {
                str=[NSString stringWithFormat:@"%d分钟",minutes];
                return str;
            }
            else
            {
                str=@"";
                return str;
            }
        }
        else
        {
            str=@"";
            return str;
        }

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
