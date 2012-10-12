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
@synthesize  tbxmlParser;;
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
    NSCalendar *myCal = [[[NSCalendar alloc ]    initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    NSDate *myDate1 = [myCal dateFromComponents:comp] ;
    myDate1=[[NSDate alloc] initWithTimeInterval:8*60*60-30*24*60*60 sinceDate:myDate1];
    
    //NSLog(@"myDate1===================%@",myDate1);
    // NSLog(@"[formater stringFromDate:myDate1]===================%@",[formater stringFromDate:myDate1]);
    
    [self.endButton setTitle:[NSString stringWithFormat:@"%@",[formater stringFromDate:myDate1]] forState:UIControlStateNormal];
    self.endTime.text=[NSString stringWithFormat:@"%@",[formater stringFromDate:myDate1]];
    self.startTime.text=[NSString stringWithFormat:@"%@-01",yeas];
    [self.startButton setTitle:[NSString stringWithFormat:@"%@-01",yeas] forState:UIControlStateNormal];
    
    
    [activty removeFromSuperview];
    tbxmlParser=[[TBXMLParser alloc] init];
    self.startTime.hidden=YES;
    self.endTime.hidden=YES;
    
    [ self  getDateSource:self.startTime.text :self.endTime.text :0];
    
    [comp    release];
}

-(void)initDC
{
    
    if(!source){
        source=[[DataGridComponentDataSource alloc] init   ];
        source.columnWidth=[[NSMutableArray alloc] init ] ;
    }
}


-(void)getDateSource:(NSString *)cStartTime:(NSString *)cEndTime:(NSInteger)initAndSelect
{
    [self initDC];
    
    source.titles=[AvgPortPTimeDao getTime:cStartTime :cEndTime];
    //  NSLog(@"----------source.titles[%d]",[source.titles count]);
    [source.columnWidth addObject:@"90"];
    //tites count  不为0
    for (int t=0; t<[source.titles count]-2; t++) {
        
        [ source.columnWidth addObject:[NSString stringWithFormat:@"%d",860/([source.titles count]-2)]];
    }
    [ source.columnWidth addObject:@"80"];
    
    //查询
    if(initAndSelect==1){
        source.data=[AvgPortPTimeDao getAvgPortDate:startTime.text:endTime.text :source.titles];
        
        //  NSLog(@"source.data[%d]",[source.data  count]);
        
    }
    //初始化
    dc=[[DataGridComponent alloc] initWithFrame:CGRectMake(0, 0, 1024, 530) data:source];
    
    [source release];
    dataQueryVC=(DataQueryVC *)self.parentVC;
    [dataQueryVC.listView   addSubview:dc];
    [dc release];
    
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
      
        
        
        startTime.text=[startButton.titleLabel.text    stringByAppendingString:@"-01"];
    }
    if (![endButton .titleLabel.text isEqualToString:@"结束时间"]) {
        
        NSDateFormatter *f=[[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
        NSDate *end=[f dateFromString:[endButton.titleLabel.text stringByAppendingString:@"-01"]];
        end=[[NSDate alloc] initWithTimeInterval:8*24*60*60 sinceDate:end];
        
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:end];
        NSUInteger numberOfDaysInMonth = range.length;
 
         
        
        
        endTime.text=   [endButton.titleLabel.text stringByAppendingString:[NSString stringWithFormat:@"-%d",numberOfDaysInMonth    ]];
        [calendar release];
        
        
    }
    
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
    NSCalendar *myCal = [[[NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDate *myDate1 = [myCal dateFromComponents:comp];
    self.endTime.text=[NSString stringWithFormat:@"%@",[formater stringFromDate:myDate1]];
    [self.endButton setTitle:[NSString stringWithFormat:@"%@",[formater stringFromDate:myDate1]]  forState:UIControlStateNormal];
    self.startTime.text=[NSString stringWithFormat:@"%@-01",yeas];
    self.startTime.hidden=YES;
    [self.startButton setTitle:[NSString stringWithFormat:@"%@-01",yeas] forState:UIControlStateNormal];
    
    self.endTime.hidden=YES;
    
    [comp release];
}
- (IBAction)reload:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间"  delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步", nil];
    [alert show];
    [alert  release];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.view addSubview:activty];
        [reload setTitle:@"同步中...." forState:UIControlStateNormal];
        [activty startAnimating];
        //解析入库
        [tbxmlParser setISoapNum:1];
        [tbxmlParser requestSOAP:@"ShipTrans"];
        
        
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
    [tbxmlParser release];
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
    if (tbxmlParser.iSoapNum==0) {
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
