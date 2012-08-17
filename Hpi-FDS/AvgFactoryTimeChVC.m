//
//  AvgFactoryTimeChVC.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-10.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

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
NSDateFormatter *df;


NSDateFormatter *formater;
NSDateFormatter *f; 
NSDateFormatter *f1;
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
    
   df =[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    
    
    month=[[NSDate alloc] init];
    formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
    f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-01"];

     [formater stringFromDate:month];
    
    f1=[[NSDateFormatter alloc] init];
    [f1 setDateFormat:@"yyyy"];
    yeas=[f1 stringFromDate:[NSDate date]] ;
    [f1 setDateFormat:@"MM"];
    currentMonth=[[f stringFromDate:[NSDate date]] intValue];
    
    
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
    
    /*
    NSLog(@"-----------------------------------初始化时间:%@",[NSDate date]);
    
    [self initDC];
    [source .titles addObject:@"电厂"];

         
    for (int i=1; i<=currentMonth; i++) {
        NSDateComponents *comp = [[NSDateComponents alloc]init];
        [comp setMonth:i];
        [comp setDay:31];
        [comp setYear:[yeas intValue]];
        NSCalendar *myCal = [[NSCalendar alloc ]    initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *myDate1 = [myCal dateFromComponents:comp];       
        [source.titles addObject:[formater stringFromDate:myDate1]];
        [comp    release];
    }
        
    
    for (int i=1; i<=8; i++) {
        [source.titles addObject:[NSString stringWithFormat:@"%@-%d",yeas,i]];
   
    }
    
    
    
    
    [source .titles addObject:@"平均"];
    source.splitTitle=[[NSMutableArray  alloc] initWithObjects:@"卸港",@"装港",@"总计(天)", nil];
   
     //source.columnWidth=[[NSMutableArray alloc] init ];
    [source.columnWidth addObject:@"70"];
    for (int i=1; i<[source.titles count]; i++) {
        [source .columnWidth addObject: @"210"];
    }

		
    dc=[[MultiTitleDataGridComponent alloc] initWithFrame:CGRectMake(0, 0, 1024, 490) data:source];
    [dataQueryVC.listView   addSubview:dc];
NSLog(@"-----------------------------------初始化时间:%@",[NSDate date]);*/
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
        // NSLog(@"dataQueryVC 为空。。初始......");
        //初始化 父视图
        dataQueryVC=(DataQueryVC *)self.parentVC;
    }
    
    if(source){
        [source release];
        source=[[MultiTitleDataSource alloc] init   ];
        source.titles=[[NSMutableArray alloc] init ];
        source.data=[[NSMutableArray alloc] init ];
        source.columnWidth=[[NSMutableArray alloc] init ];
    }else{
        source=[[MultiTitleDataSource alloc] init   ];
        source.titles=[[NSMutableArray alloc] init ];
        source.data=[[NSMutableArray alloc] init ];
        source.columnWidth=[[NSMutableArray alloc] init ];
    }

}




-(void)getDateSource:(NSString *)cStartTime:(NSString *)cEndTime:(NSString *)facotryCate:(NSInteger)initAndSelect
{
    [self initDC];
    NSMutableArray *factoryAvgZXtime=[[NSMutableArray alloc] init];
  if(initAndSelect==0)
    {
        source.titles=[AvgFactoryZXTimeDao getTimeTitle1:startTime.text :endTime.text:factoryCateLable.text];
   }
    
    if (initAndSelect==1) {
        
        NSLog(@"-----------------------------------初始临时表时间:%@",[df stringFromDate:[NSDate date] ]);
        
        
         [AvgFactoryZXTimeDao delete];      
        //  查询 临时表  NT_AvgFactoryZXTime
        factoryAvgZXtime=[AvgFactoryZXTimeDao getNT_AvgFactoryZXTime:startTime.text :endTime.text :factoryCateLable.text];
        //填充
        for (int i=0; i<[factoryAvgZXtime count]; i++) {
            AvgFactoryZXTime *avgF=[factoryAvgZXtime objectAtIndex:i];
            [AvgFactoryZXTimeDao insert:avgF];
        }
        // NSLog(@"临时表中 插入数据完毕。。。。。。。。。。。");
    NSLog(@"-----------------------------------初始临时表时间:%@",[df stringFromDate:[NSDate date] ]);
        
        
        source.titles=[AvgFactoryZXTimeDao getTimeTitle:startTime.text :endTime.text ];
    }
    
       
          
    //NSLog(@"----------------source.titles[%d]",[source.titles  count]);
   [source .titles addObject:@"平均"];
    source.splitTitle=[[NSMutableArray  alloc] initWithObjects:@"卸港",@"装港",@"总计(天)", nil];
   // source.columnWidth=[[NSMutableArray alloc] init ];
    [source.columnWidth addObject:@"70"];
    for (int i=1; i<[source.titles count]; i++) {
        [source .columnWidth addObject: @"210"];
    }
    
   
 

    if(initAndSelect==1){
        
         NSLog(@"-----------------------------------填充data 时间:%@",[df stringFromDate:[NSDate date] ]);
        NSMutableArray *FactoryN=[AvgFactoryZXTimeDao getFactoryName:startTime.text :endTime.text ];
        source .data=[[NSMutableArray alloc] init];
        for (int i=0; i<[FactoryN count]; i++) {
            NSMutableArray  *dateArray=[[NSMutableArray alloc] init];
            [dateArray addObject:@"3"];
            [dateArray addObject:[FactoryN objectAtIndex:i] ];
            
            
            
            NSMutableDictionary *date=[AvgFactoryZXTimeDao getFactoryDate:startTime.text :endTime.text :[FactoryN  objectAtIndex:i]];
            
            NSMutableArray *arrayKeys=[[  NSMutableArray alloc] init];
            for (NSObject* t in [date keyEnumerator]) {
                [arrayKeys addObject:t];
            }
            
            
            for (int t=1; t<[source .titles count]; t++) {
                
                if ([arrayKeys containsObject:[source .titles objectAtIndex:t]]) {
                    
                    NSMutableArray *a=[date objectForKey:[source.titles objectAtIndex:t]] ;
                    for (int i=0; i<[a count]; i++) {
                        [dateArray addObject:[a objectAtIndex:i]];
                    }
                    
                }else
                {
                    for (int i=0; i<3; i++) {
                        [dateArray addObject:@""];
                    }
                    
                }
                
            }
            [source.data addObject:dateArray];
            [dateArray release];
            [arrayKeys release]; 
            
        }
        [FactoryN    release];
         NSLog(@"-----------------------------------填充data 时间:%@",[df stringFromDate:[NSDate date] ]);
        
    }
    
   
 
    //初始化
    dc=[[MultiTitleDataGridComponent alloc] initWithFrame:CGRectMake(0, 0, 1024, 490) data:source];
    [dataQueryVC.listView   addSubview:dc];
  

    
    
    //   [factoryAvgZXtime release];
    
      
}
- (IBAction)Select:(id)sender {
  
    
    
    NSLog(@"-----------------------------------查询时间:%@",[df stringFromDate:[NSDate date] ]);
    startTime.text=startButton.titleLabel.text;
    endTime.text=endButton.titleLabel.text;
   NSLog(@"开始时间为：%@",startTime.text);
    NSLog(@"结束时间为：%@",endTime.text);
    NSLog(@"factoryCatelabel:[%@]",factoryCateLable.text);

    NSLog(@"电厂 查询。。。。。。。。。");
    
    [self initDC];
    
    [ self  getDateSource:self.startTime.text :self.endTime.text:factoryCateLable.text :1];
    
   NSLog(@"-----------------------------------查询时间:%@",[df stringFromDate:[NSDate date] ]);     
    
    
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
        
       // NSLog(@"释放  dc  视图");
        [dc release];
    }
    if(source){
        
       //NSLog(@"释放  dc  数据源source ");
        [source release];
    }
    if(dataQueryVC){
       //NSLog(@"释放 父视图 .。。。 ");
  
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
