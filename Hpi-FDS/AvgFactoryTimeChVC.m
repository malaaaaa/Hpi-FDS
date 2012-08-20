//
//  AvgFactoryTimeChVC.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-10.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//
<<<<<<< HEAD




//dev_tangb 

//	


=======
//MyLoca_Bh
>>>>>>> 914be559acfb3f72e5437bb32eda74890524f115
#import "AvgFactoryTimeChVC.h"
#import "DataQueryVC.h"
#import "AvgFactoryZXTimeDao.h"
#import "MultiTitleDataGridComponent.h"
@interface AvgFactoryTimeChVC ()

@end

@implementation AvgFactoryTimeChVC
@synthesize factoryCateButton;
@synthesize factoryCateLable;
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

static  int  whichButton=0;

DataQueryVC *dataQueryVC;
static   MultiTitleDataSource *source;



NSDateFormatter *formater;
NSDateFormatter *f; 


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
    f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-01"];
    [formater stringFromDate:month];
    
 
     self.factoryCateLable.text=All_;
     self.factoryCateLable.hidden=YES;
    self.startTime.text=[f   stringFromDate:[NSDate date]];
     [self.startButton setTitle:[f   stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    self.endTime.text=[formater   stringFromDate:[NSDate date]];
    [self.endButton setTitle:[formater   stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    [activty removeFromSuperview];
    xmlParser=[[XMLParser alloc] init];
    self.startTime.hidden=YES;
    self.endTime.hidden=YES;
   [ self  getDateSource:self.startTime.text :self.endTime.text:All_ :0];
    
}
-(void)initDC
{
    if(dc){
        [dc removeFromSuperview];
        [dc release];
        dc=[[MultiTitleDataGridComponent alloc ] init];
    }else
    {
        dc=[[MultiTitleDataGridComponent alloc ] init];
    }
    if(!dataQueryVC){
        NSLog(@"dataQueryVC 为空。。初始......");
        //初始化 父视图
        dataQueryVC=(DataQueryVC *)self.parentVC;
  
    }
    
    if(source){
    
        [source release];
       source=[[MultiTitleDataSource alloc] init   ];
        source.titles=[[[NSMutableArray alloc] init ] autorelease];
        source.data=[[[NSMutableArray alloc] init ] autorelease];
       source.columnWidth=[[[NSMutableArray alloc] init ] autorelease];
    }else{
        source=[[MultiTitleDataSource alloc] init   ];
        source.titles=[[[NSMutableArray alloc] init ] autorelease];
        source.data=[[[NSMutableArray alloc] init ] autorelease];
        source.columnWidth=[[[NSMutableArray alloc] init ] autorelease];
    }

}




-(void)getDateSource:(NSString *)cStartTime:(NSString *)cEndTime:(NSString *)facotryCate:(NSInteger)initAndSelect
{
    [self initDC];
    source.titles=[AvgFactoryZXTimeDao getTimeTitle1:startTime.text :endTime.text:All_];
 
   // NSLog(@"----------------source.titles[%d]",[source.titles  count]);
<<<<<<< HEAD

    source.splitTitle=[[[NSMutableArray  alloc] initWithObjects:@"卸港",@"装港",@"总计(天)", nil] autorelease  ];

=======
 
    source.splitTitle=[[[NSMutableArray  alloc] initWithObjects:@"卸港",@"装港",@"总计(天)", nil] autorelease  ];
>>>>>>> 914be559acfb3f72e5437bb32eda74890524f115
    
    [source.columnWidth addObject:@"70"];
    for (int i=1; i<[source.titles count]; i++) {
        [source .columnWidth addObject: @"210"];
    }
    if(initAndSelect==1){
        source.data=[AvgFactoryZXTimeDao getAvgFactoryDate:startTime.text:endTime.text:factoryCateLable.text:source.titles ];
    }
    //初始化
    dc=[[MultiTitleDataGridComponent alloc] initWithFrame:CGRectMake(0, 0, 1024, 490) data:source];
    [dataQueryVC.listView   addSubview:dc];

   
<<<<<<< HEAD

=======
    
    
>>>>>>> 914be559acfb3f72e5437bb32eda74890524f115
}
- (IBAction)Select:(id)sender {
startTime.text=startButton.titleLabel.text;
endTime.text=endButton.titleLabel.text;
  // NSLog(@"开始时间为：%@",startTime.text);
   // NSLog(@"结束时间为：%@",endTime.text);
   // NSLog(@"factoryCatelabel:[%@]",factoryCateLable.text);
<<<<<<< HEAD

 //   NSLog(@"电厂 查询。。。。。。。。。");

    
    [self initDC];
    
    [ self  getDateSource:self.startTime.text :self.endTime.text:factoryCateLable.text :1];

=======

 //   NSLog(@"电厂 查询。。。。。。。。。");
 
    NSAutoreleasePool *poll=[[NSAutoreleasePool alloc ] init];
    [ self  getDateSource:self.startTime.text :self.endTime.text:factoryCateLable.text :1];
      [poll drain];
>>>>>>> 914be559acfb3f72e5437bb32eda74890524f115
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
    
    [self.popover presentPopoverFromRect:CGRectMake(842,40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    // [monthVC release];
    [pop release];

    
}
- (IBAction)startTimeSelect:(id)sender {
    whichButton=1;
   // NSLog(@"startmonth。。。。。");
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
    [self.popover presentPopoverFromRect:CGRectMake(587, 40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    //不能释放
    //[monthVC release];
    [pop release];
    
}

- (IBAction)factoryCateSelect:(id)sender {
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    //初始化待显示控制器
    chooseView=[[ChooseView alloc]init];
    //设置待显示控制器的范围
    [chooseView.view setFrame:CGRectMake(0,0, 125, 400)];
    //设置待显示控制器视图的尺寸
    chooseView.contentSizeForViewInPopover = CGSizeMake(125, 400);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:chooseView];
    chooseView.popover = pop;
    chooseView.iDArray=[NSArray arrayWithObjects:All_,@"直供",@"海进江",@"山东",@"海南",nil];
    chooseView.parentMapView=self;
    chooseView.type=kfactoryCate;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(332, 40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    

    
    
}
- (IBAction)release:(id)sender {

    self.startTime.text=[f   stringFromDate:[NSDate date]];
    
    [self.startButton setTitle:[f   stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    self.endTime.text=[formater   stringFromDate:[NSDate date]];
    
    [self.endButton setTitle:[formater   stringFromDate:[NSDate date]] forState:UIControlStateNormal];

    
    self.factoryCateLable.text=All_ ;
    
    [self.factoryCateButton setTitle:@"电厂分类" forState:UIControlStateNormal];
    
    self.factoryCateLable.hidden=YES;
    self.startTime.hidden=YES;
    self.endTime.hidden=YES;
    
    
}

- (IBAction)reload:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间"  delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步", nil];
    
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.view addSubview:activty];
        [reload setTitle:@"同步中...." forState:UIControlStateNormal];
        [activty startAnimating];
        //解析入库
        [xmlParser setISoapNum:1];
        
        [xmlParser getTfFactory];
        [xmlParser getVbShiptrans];
        
        
        
        [self runActivity];
    }
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

    [factoryCateLable release];
    [startTime release];
    [endTime release];
    [startButton release];
    [endButton release];
    [factoryCateButton release];
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

- (void)viewDidUnload
{
    [self setFactoryCateLable:nil];
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setStartButton:nil];
    [self setEndButton:nil];
    [self setEndButton:nil];
    [self setFactoryCateButton:nil];
    [self setActivty:nil];
    [self setPopover:nil];
    [self setChooseView:nil];
    [self setMonthVC:nil];
    [reload release];
    reload = nil;
    [super viewDidUnload];    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma  mark  poper delegate Method
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    
    if (monthVC) {
       // NSLog(@"monthCV 不为空。。。");
        self.month=monthVC.selectedDate;
    }
    
    //NSLog(@"当前picket的日期为%@",monthVC.selectedDate);
    return YES;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
    if (whichButton==1) {
        [startButton setTitle:[formater stringFromDate:month] forState:UIControlStateNormal ];
     //   NSLog(@"startButton:[%@]",[formater stringFromDate:month]);
        
        
        whichButton=0;
    }else if (whichButton==2) {
        [endButton setTitle:[formater stringFromDate:month] forState:UIControlStateNormal ];
       // NSLog(@"endButton:[%@]",[formater stringFromDate:month]);
        whichButton=0;
        
    }
    
    [formater   release];
    
}




#pragma mark activety
-(void)runActivity
{
    
    //NSLog(@"runActivity-----iSoapNum-[%d]",xmlParser.iSoapNum);
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
    if (chooseView) {
        if (chooseView.type==kfactoryCate) {

            self.factoryCateLable.text=currentSelectValue;
            if (![self .factoryCateLable.text isEqualToString:All_]) {
                self.factoryCateLable.hidden=NO;
                [self.factoryCateButton setTitle:@"" forState:UIControlStateNormal];
            }else {
                self.factoryCateLable.hidden=YES;
                [self.factoryCateButton setTitle:@"电厂类别" forState:UIControlStateNormal];
            }
            
            
            
        }
    }
    
    
    
    
}





@end
