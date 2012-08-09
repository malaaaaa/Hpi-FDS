//
//  AvgPortPTimeChVC.m
//  Hpi-FDS
//
//  Created by bin tang on 12-8-7.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "AvgPortPTimeChVC.h"
#import "DataQueryVC.h"


#import "DataGridComponent.h"
@interface AvgPortPTimeChVC ()

@end

@implementation AvgPortPTimeChVC
@synthesize startButton;
@synthesize startTime;
@synthesize endButton;
@synthesize endTime;
@synthesize activty;
@synthesize xmlParser;
@synthesize parentVC;
@synthesize chooseView;
@synthesize month;
@synthesize monthVC;
@synthesize popover;
@synthesize reload;


//初始化 父视图
DataQueryVC *dataQueryVC;
static  DataGridComponentDataSource *source;
static  int  whichButton=0;
DataGridComponent     *dc;
NSDateFormatter *formater;


NSString *yeas;
int currentMonth;
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
    month=[[NSDate alloc] init];
    NSLog(@"----------------初始化month------------------：%@",month);
    formater=[[NSDateFormatter alloc] init];

    [formater setDateFormat:@"yyyy-MM"];
 
    [formater stringFromDate:month];

    //获得当前月份和年份
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy"];
    yeas=[f stringFromDate:[NSDate date]];
    NSLog(@"-------yyyy:[%@]",[f stringFromDate:[NSDate date]]);
    [f setDateFormat:@"MM"];
    NSLog(@"-------MM:[%@]",[f stringFromDate:[NSDate date]] );
     currentMonth=[[f stringFromDate:[NSDate date]] intValue];

    
    
    
    
    
    self.startTime.text=[NSString stringWithFormat:@"%@-01",yeas];
    [self.startButton setTitle:[NSString stringWithFormat:@"%@-01",yeas] forState:UIControlStateNormal];
    
    self.endTime.text=[NSString stringWithFormat:@"%@-%d",yeas,(currentMonth-1)==0?1:(currentMonth-1)];
    [self.endButton setTitle:[NSString stringWithFormat:@"%@-%d",yeas,(currentMonth-1)==0?1:(currentMonth-1)] forState:UIControlStateNormal];
    
    [activty removeFromSuperview];
    xmlParser=[[XMLParser alloc] init];
   
    self.startTime.hidden=YES;
    self.endTime.hidden=YES;

    
    //初始化 父视图
    dataQueryVC=(DataQueryVC *)self.parentVC;
   // dataQueryVC.labelView.hidden=YES;
   // dataQueryVC.listTableview.hidden=YES;

    DataGridComponentDataSource *source=[[DataGridComponentDataSource alloc] init   ];
    source.titles=[[NSMutableArray alloc] init];
    source.columnWidth=[[NSMutableArray alloc] init];
    source.data=[[NSMutableArray alloc] init];
    
    [source.titles addObject:@"港口"];
    [source.columnWidth addObject:@"90"];
    

    
    
    
    
        
    
    if (currentMonth>2) {
        for(int column = 1;column <currentMonth;column++){
            [source.titles addObject:[NSString stringWithFormat:@"%@-%d",yeas ,column]];
            
            if (currentMonth<12) {
                [ source.columnWidth addObject:[NSString stringWithFormat:@"%d",840/(currentMonth-1)]];
          
            }else {
                [ source.columnWidth addObject:@"70"];
                
            }
        } 

    }else {
        [source.titles addObject:[NSString stringWithFormat:@"%@-%d",yeas ,1]];
        [ source.columnWidth addObject:@"840"];
    }
    
        
    [source.titles addObject:@"平均时间"];
    [ source.columnWidth addObject:@"80"];
    [f release];

        
    dc=[[DataGridComponent alloc] initWithFrame:CGRectMake(0, 0, 1024, 490) data:source];
    
    
    //动画
    CATransition *animation=[CATransition animation];
    animation.delegate=self;
    animation.duration=0.5f;
    animation.timingFunction=UIViewAnimationCurveEaseInOut;
    animation.fillMode=kCAFillModeForwards;
    animation.endProgress=1;
    animation.removedOnCompletion=NO;
    animation.type=@"cube";
    [dataQueryVC.chooseView.layer addAnimation:animation forKey:@"animation"];
    [dataQueryVC.chooseView bringSubviewToFront:self.view];
     animation.type= @"oglFlip";
    [dc.layer addAnimation:animation forKey:@"animation"];
    [dataQueryVC.listView   addSubview:dc];
         
    /*
    //动画
    CATransition *animation=[CATransition animation];
    animation.delegate=self;
    animation.duration=0.5f;
    animation.timingFunction=UIViewAnimationCurveEaseInOut;
    animation.fillMode=kCAFillModeForwards;
    animation.endProgress=1;
    animation.removedOnCompletion=NO;
    animation.type=@"cube";

    
    [dataQueryVC.chooseView.layer addAnimation:animation forKey:@"animation"];
    [dataQueryVC.chooseView bringSubviewToFront:self.view];
    float columnOffset = 0.0;
    dataSource=[[DataGridComponentDataSource alloc] init];
    
    
    //
    dataSource.titles=[ NSArray arrayWithObjects:@"电厂",@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月", @"合计",nil];
    dataSource.columnWidth=[NSArray arrayWithObjects:@"70",@"70",@"70",@"70",@"70",@"70",@"70",@"70",@"70",@"70",@"70",@"70",@"70",@"95",nil];

    
    
    
    animation.type= @"oglFlip";
    [dataQueryVC.labelView.layer addAnimation:animation forKey:@"animation"];
    [dataQueryVC.labelView removeFromSuperview  ];
    
    
    //填充 标题数据
    for(int column = 0;column < [dataSource.titles count];column++){
        float columnWidth=[[dataSource.columnWidth objectAtIndex:column ] floatValue];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth -1, 40+2 )];
        l.font = [UIFont systemFontOfSize:16.0f];
        l.text = [dataSource.titles objectAtIndex:column];
        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
        l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(0, -0.5);
        l.textAlignment = UITextAlignmentCenter;
        [dataQueryVC.labelView addSubview:l];
        [l release];
        columnOffset += columnWidth;
        
    }
    
    [dataQueryVC.listView addSubview:dataQueryVC.labelView];
    */

    
      
}

- (IBAction)startTimeSelect:(id)sender {
    whichButton=1;
    NSLog(@"startmonth。。。。。");
    if (self.popover .popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    if(!monthVC)
        monthVC=[[DateViewController alloc] init];
    [monthVC .view setFrame:CGRectMake(0, 0, 195, 216)];
    monthVC.contentSizeForViewInPopover=CGSizeMake(195, 216);
    UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:monthVC];
    monthVC.popover=pop;//没什么用？
    monthVC.selectedDate=self.month;//初始化  属性[[NSDate alloc] init];  也可以不用他来初始化
    self.popover=pop;
    self.popover.delegate=self;
    self.popover.popoverContentSize=CGSizeMake(195, 216);
    [self.popover presentPopoverFromRect:CGRectMake(407, 40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    //不能释放
    //[monthVC release];
    [pop release];
    
    
}
- (IBAction)endTimeSelect:(id)sender {
    whichButton=2;
    NSLog(@"endmonth。。。。。");
    if (self.popover .popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    if(!monthVC)
        monthVC=[[DateViewController alloc] init];
    [monthVC .view setFrame:CGRectMake(0, 0, 195, 216)];
    monthVC.contentSizeForViewInPopover=CGSizeMake(195, 216);
    
    UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:monthVC];
    monthVC.popover=pop;//没什么用？
    monthVC.selectedDate=self.month;//初始化  属性[[NSDate alloc] init];  也可以不用他来初始化
    
    self.popover=pop;
    self.popover.delegate=self;
    
    self.popover.popoverContentSize=CGSizeMake(195, 216);
    
    [self.popover presentPopoverFromRect:CGRectMake(767,40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    // [monthVC release];
    [pop release];
    
}

- (IBAction)Select:(id)sender {
    
    NSLog(@"startTime:[%@]",startTime.text);
    NSLog(@"endTime:[%@]",endTime.text);
    if (![startButton .titleLabel.text isEqualToString:@"开始时间"]) {
        startTime.text=startButton.titleLabel.text;
    }
    if (![endButton .titleLabel.text isEqualToString:@"结束时间"]) {
        endTime.text=endButton.titleLabel.text;
    }
    
    NSLog(@"开始时间为：%@",startTime.text);
    NSLog(@"结束时间为：%@",endTime.text); 
    
    NSAutoreleasePool *looPool=[[NSAutoreleasePool   alloc] init];    
    
    
    dataQueryVC.dataArray=[[NSMutableArray  alloc] init ];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    [looPool drain];
    
}

- (IBAction)release:(id)sender {
    //获得当前月份和年份
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy"];
    yeas=[f stringFromDate:[NSDate date]];
    NSLog(@"-------yyyy:[%@]",[f stringFromDate:[NSDate date]]);
    [f setDateFormat:@"MM"];
    NSLog(@"-------MM:[%@]",[f stringFromDate:[NSDate date]] );
    currentMonth=[[f stringFromDate:[NSDate date]] intValue];

    
    
    self.startTime.text=[NSString stringWithFormat:@"%@-01",yeas];
    self.startTime.hidden=YES;
    [self.startButton setTitle:[NSString stringWithFormat:@"%@-01",yeas] forState:UIControlStateNormal];
    self.endTime.text=[NSString stringWithFormat:@"%@-%d",yeas,(currentMonth-1)==0?1:(currentMonth-1)];
    self.endTime.hidden=YES;
    [self.endButton setTitle:[NSString stringWithFormat:@"%@-%d",yeas,(currentMonth-1)==0?1:(currentMonth-1)]  forState:UIControlStateNormal];

    
    [f release];
    
}
- (IBAction)reload:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间"  delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步", nil];
    
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.view addSubview:activty];
        [reload setTitle:@"同步中...." forState:UIControlStateNormal];
        [activty startAnimating];
        //解析入库
        [xmlParser setISoapNum:1];
        
        
        [xmlParser  getTfPort]; 
        [xmlParser getVbShiptrans];
        
        
        
        [self runActivity];
    }
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setStartButton:nil];
    [self setEndButton:nil];
    [self setEndButton:nil];
    
    [self setActivty:nil];
    [self setPopover:nil];
    [self setChooseView:nil];
    [self setMonthVC:nil]; 
    
    
    
    
    [reload release];
    reload = nil;
  
    [dc release];

    
        
    
    
}
- (void)dealloc {
    //[dc removeFromSuperview];    
    
    [dc release];

    //dataQueryVC.listTableview.hidden=NO;
    //dataQueryVC.labelView.hidden=NO;
   
    
    
    [source release];
    
    [startTime release];
    [endTime release];
    [startButton release];
    [endButton release];
    
  
    [activty release];
    
    //该不该释放
    //[dataSource release];
   [dataQueryVC release];
    
    
    [xmlParser release];
    [parentVC release];
    [monthVC release];
    [month   release];
    [chooseView release];
    [popover release];
    [reload release];
    
    
    [ formater release];
  
    [super dealloc];
}
#pragma  mark  poper delegate Method
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController   
{
    
    if (monthVC) {
        NSLog(@"monthCV 不为空。。。");
        self.month=monthVC.selectedDate;
    }
    
    NSLog(@"当前picket的日期为%@",monthVC.selectedDate);
    return YES;
}
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController  
{
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
    if (whichButton==1) {
        [startButton setTitle:[formater stringFromDate:month] forState:UIControlStateNormal ];
        NSLog(@"startButton:[%@]",[formater stringFromDate:month]);
        
        
        whichButton=0;
    }else if (whichButton==2) {
        [endButton setTitle:[formater stringFromDate:month] forState:UIControlStateNormal ];
        NSLog(@"endButton:[%@]",[formater stringFromDate:month]);
        whichButton=0;
        
    }
    
    [formater   release];
    
}

#pragma mark activety
-(void)runActivity
{
    
    NSLog(@"runActivity-----iSoapNum-[%d]",xmlParser.iSoapNum);
    if (xmlParser.iSoapNum==0) {
        [activty stopAnimating];
        
        [activty removeFromSuperview];
        
        [reload setTitle:@"网络同步" forState:UIControlStateNormal];
        
        return;
        
        
    }else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runActivity) userInfo:NULL repeats:NO];
        
        
    }
    
    
}

#pragma mark SetSelectValue  Method
-(void)setLableValue:(NSString *)currentSelectValue
{
    
    
    
    
    
    
    
}   

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
