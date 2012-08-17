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
#import "AvgPortPTimeDao.h"
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
@synthesize dc;
//初始化 父视图
DataQueryVC *dataQueryVC;
static  DataGridComponentDataSource *source;
static  int  whichButton=0;

NSDateFormatter *formater;
NSDateFormatter *f;
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
    formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
    [formater stringFromDate:month];
    //获得当前月份和年份
    f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy"];
    yeas=[f stringFromDate:[NSDate date]] ;
    [f setDateFormat:@"MM"];
     currentMonth=[[f stringFromDate:[NSDate date]] intValue];
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:currentMonth-1];
    [comp setDay:31];
    [comp setYear:[yeas intValue]];
    NSCalendar *myCal = [[NSCalendar alloc ]    initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *myDate1 = [myCal dateFromComponents:comp];
    self.startTime.text=[NSString stringWithFormat:@"%@-01",yeas];
    [self.startButton setTitle:[NSString stringWithFormat:@"%@-01",yeas] forState:UIControlStateNormal];
    self.endTime.text=[NSString stringWithFormat:@"%@",[formater stringFromDate:myDate1]];
    [self.endButton setTitle:[NSString stringWithFormat:@"%@",[formater stringFromDate:myDate1]] forState:UIControlStateNormal];
    [activty removeFromSuperview];
    xmlParser=[[XMLParser alloc] init];
    self.startTime.hidden=YES;
    self.endTime.hidden=YES;

    [ self  getDateSource:self.startTime.text :self.endTime.text :0];
    [comp    release];
 
}
-(void)getDateSource:(NSString *)cStartTime:(NSString *)cEndTime:(NSInteger)initAndSelect
{
    if(dc){
        [dc removeFromSuperview];
        [dc release];
         dc=[[DataGridComponent alloc ] init];
    }else
    {
        dc=[[DataGridComponent alloc ] init];
    }
    if(!dataQueryVC){
        //初始化 父视图
        dataQueryVC=(DataQueryVC *)self.parentVC;
    }
    if(source){
        [source release];
        source=[[DataGridComponentDataSource alloc] init   ];
        source.titles=[[NSMutableArray alloc] init ];
        source.data=[[NSMutableArray alloc] init ];
        source.columnWidth=[[NSMutableArray alloc] init ];  
    }else{
        source=[[DataGridComponentDataSource alloc] init   ];
        source.titles=[[NSMutableArray alloc] init ];
        source.data=[[NSMutableArray alloc] init ];
        source.columnWidth=[[NSMutableArray alloc] init ];
    }
        NSMutableArray *tites=[AvgPortPTimeDao getTime:cStartTime :cEndTime];
        [source.titles addObject:@"港口"];
        [source.columnWidth addObject:@"90"];
        //tites count  不为0
        for (int t=0; t<[tites count]; t++) {
            [source.titles addObject:[tites objectAtIndex:t]];
             [ source.columnWidth addObject:[NSString stringWithFormat:@"%d",840/[tites count]]];
        }
        [source.titles addObject:@"平均时间"];
        [ source.columnWidth addObject:@"80"];
        //查询
    if(initAndSelect==1){
        NSMutableArray *portName=[AvgPortPTimeDao getPortName:cStartTime :cEndTime];
        //循环港口名
        for (int i=0; i<[portName count]; i++) {
            NSMutableArray  *dateArray=[[NSMutableArray alloc] init];
            [dateArray addObject:@"3"];
            [dateArray addObject:[portName objectAtIndex:i] ];
            NSMutableDictionary *timeAndAvgTime=[[NSMutableDictionary alloc] init ];
            timeAndAvgTime=[AvgPortPTimeDao getTimeAndAvgTime:[portName objectAtIndex:i] :cStartTime :cEndTime];
            NSMutableArray *arrayKeys=[[  NSMutableArray alloc] init];
            for (NSObject* t in [timeAndAvgTime keyEnumerator]) {
                [arrayKeys addObject:t];
            }
            double sumTime=0;
            int a=0;
            for (int t=0; t<[tites count]; t++) {
                if ([arrayKeys containsObject:[tites objectAtIndex:t]]) {
                    [dateArray addObject:[timeAndAvgTime objectForKey:[tites objectAtIndex:t]] ];
                    a++;
                    sumTime=sumTime+[[timeAndAvgTime objectForKey:[tites objectAtIndex:t]] doubleValue];
                }else
                {
                    [dateArray addObject:@""];
                }
            }
            NSLog(@"总的平均时间：avgTime【%.2f】",sumTime/a);
            [dateArray addObject:[NSString stringWithFormat:@"%.2f",sumTime/a]];
            [source.data addObject:dateArray];
            [dateArray release];
            [arrayKeys release  ];
            [timeAndAvgTime release];
        }
        [portName release];
    }
    //初始化
    dc=[[DataGridComponent alloc] initWithFrame:CGRectMake(0, 0, 1024, 490) data:source];
    [dataQueryVC.listView   addSubview:dc];
    
    [dataQueryVC.labelView removeFromSuperview];
    
    [dataQueryVC.listTableview removeFromSuperview];
  
    [tites release];
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
    [pop release];
}

- (IBAction)Select:(id)sender {
    if (![startButton .titleLabel.text isEqualToString:@"开始时间"]) {
        startTime.text=startButton.titleLabel.text;
    }
    if (![endButton .titleLabel.text isEqualToString:@"结束时间"]) {
        endTime.text=endButton.titleLabel.text;
    }
    dataQueryVC.dataArray=[[NSMutableArray  alloc] init ];
    [ self  getDateSource:self.startTime.text :self.endTime.text :1];
}
- (IBAction)release:(id)sender {
    //获得当前月份和年份    
    [f setDateFormat:@"yyyy"];
    yeas=[f stringFromDate:[NSDate date]];
    [f setDateFormat:@"MM"];
    currentMonth=[[f stringFromDate:[NSDate date]] intValue];
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:currentMonth-1];
    [comp setDay:31];
    [comp setYear:[yeas intValue]];
    NSCalendar *myCal = [[NSCalendar alloc ]    initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *myDate1 = [myCal dateFromComponents:comp];

    self.startTime.text=[NSString stringWithFormat:@"%@-01",yeas];
    self.startTime.hidden=YES;
    [self.startButton setTitle:[NSString stringWithFormat:@"%@-01",yeas] forState:UIControlStateNormal];
    self.endTime.text=[NSString stringWithFormat:@"%@",[formater stringFromDate:myDate1]];
    self.endTime.hidden=YES;
    [self.endButton setTitle:[NSString stringWithFormat:@"%@",[formater stringFromDate:myDate1]]  forState:UIControlStateNormal];
    [comp release];
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
         [xmlParser getVbShiptrans];
          [xmlParser  getTfPort];
       
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
}
- (void)dealloc {
  
    if(formater){
        [formater release];
    }
    if(f){
        [f release];
    }
    if(dc){
        [dc release];
    }
    if(source){
    [source release];
    }
    if(dataQueryVC){
        [dataQueryVC release];
    }
    [startTime release];
    [endTime release];
    [startButton release];
    [endButton release];
    [activty release];
    [xmlParser release];
    [parentVC release];
    [monthVC release];
    [month   release];
    [chooseView release];
    [popover release];
    [reload release];
    [super dealloc];
}
#pragma  mark  poper delegate Method
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController   
{
    
    if (monthVC) {
        NSLog(@"monthCV 不为空。。。");
        self.month=monthVC.selectedDate;
    }
    return YES;
}
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController  
{
   // NSDateFormatter *formater=[[NSDateFormatter alloc] init];
   
    if (whichButton==1) {
        [startButton setTitle:[formater stringFromDate:month] forState:UIControlStateNormal ];
        whichButton=0;
    }else if (whichButton==2) {
        [endButton setTitle:[formater stringFromDate:month] forState:UIControlStateNormal ];
        whichButton=0;
    }
}

#pragma mark activety
-(void)runActivity
{
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
