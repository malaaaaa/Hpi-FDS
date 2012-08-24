//
//  NT_LatefeeTongjChVC.m
//  Hpi-FDS
//
//  Created by bin tang on 12-8-2.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "NT_LatefeeTongjChVC.h"
#import "DataQueryVC.h"
#import "AvgFactoryZXTimeDao.h"


@interface NT_LatefeeTongjChVC ()
{
    


}

@end

@implementation NT_LatefeeTongjChVC
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
//初始化 父视图
DataQueryVC *dataQueryVC;
static DataGridComponentDataSource *dataSource;
 static  int  whichButton=0;

NSDateFormatter *formater;

NSDateFormatter *formater1;



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
    //初始化
    month=[[NSDate alloc] init];
    formater=[[NSDateFormatter alloc] init];
    formater1=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    [formater1 setDateFormat:@"yyyy-01-01"];
    [formater stringFromDate:month];
   

    
    self.factoryCateLable.text=All_;
    self.startTime.text=[formater1 stringFromDate:[NSDate date] ];
    [self.startButton setTitle:[formater1 stringFromDate:[NSDate date] ] forState:UIControlStateNormal];
    
    self.endTime.text=[formater stringFromDate:[NSDate date]];
     [self.endButton setTitle:[formater stringFromDate:[NSDate date] ] forState:UIControlStateNormal];
    
    [activty removeFromSuperview];
    xmlParser=[[TBXMLParser alloc] init];
    self.factoryCateLable.hidden=YES;
    self.startTime.hidden=YES;
    self.endTime.hidden=YES;
    //初始化 父视图
    dataQueryVC=(DataQueryVC *)self.parentVC;
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
    dataSource.titles=[ NSArray arrayWithObjects:@"电厂",@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月", @"合计",nil];
    dataSource.columnWidth=[NSArray arrayWithObjects:@"80",@"72",@"72",@"72",@"72",@"72",@"72",@"72",@"72",@"72",@"72",@"72",@"72",@"100",nil];
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
    [self.popover presentPopoverFromRect:CGRectMake(587, 40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
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
    
    [self.popover presentPopoverFromRect:CGRectMake(842,40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

   // [monthVC release];
    [pop release];
    
}

- (IBAction)Select:(id)sender {
    if (![startButton .titleLabel.text isEqualToString:@"开始时间"]) {
        startTime.text=startButton.titleLabel.text;
    }
    if (![endButton .titleLabel.text isEqualToString:@"结束时间"]) {
        endTime.text=endButton.titleLabel.text;
    } 
    NSAutoreleasePool *looPool=[[NSAutoreleasePool   alloc] init];
    
 
   [self loadLatefeeTongjChVC];
         
   [dataQueryVC.listTableview   reloadData];
    
   [looPool drain];
}

-(void)loadLatefeeTongjChVC
{

    //没用
    dataQueryVC.dataArray=[NT_LatefeeTongjDao getNT_LatefeeTongj:factoryCateLable.text :startTime.text :endTime.text];
    
    NSLog(@"获得NT_LatefeeTongj[%d]",dataQueryVC.dataArray.count);
    //获得所有  不重复的额的电厂名   根据条件
    NSMutableArray *nameArray=[NT_LatefeeTongjDao getFactoryName:factoryCateLable.text:startTime.text :endTime.text];
    NSLog(@"获得电厂名【%d】",[nameArray count]);
    dataSource.data=[[NSMutableArray alloc] init];
    for (int i=0; i<[nameArray  count ]; i++) {
        
        NSMutableArray *dateArray=[[NSMutableArray   alloc] init];
        [dateArray addObject:@"3"];
        [dateArray addObject:[NSString stringWithFormat:@"%@",[nameArray objectAtIndex:i]]];
        
        NSMutableDictionary *monthAndLatefee=[NT_LatefeeTongjDao getMonthAndLatefee:@"factory":[nameArray objectAtIndex:i]:startTime.text:endTime.text ];
        NSLog(@"根据电厂名 和时间得到    该电厂【%@】的费用和月份",[nameArray objectAtIndex:i]);
        
        NSMutableArray *arrayKeys=[[  NSMutableArray alloc] init];
        for (NSObject* t in [monthAndLatefee keyEnumerator]) {
            [arrayKeys addObject:t];
        }
        double latefee=0;
        for (int i=1; i<13; i++) {
            if ([arrayKeys containsObject:[NSString stringWithFormat:@"%d",i]]) {
                
                latefee=latefee+[[monthAndLatefee objectForKey:[NSString stringWithFormat:@"%d",i]] doubleValue];
                
                [dateArray addObject: [NSString stringWithFormat:@"%.2f",[[monthAndLatefee objectForKey:[NSString stringWithFormat:@"%d",i]] doubleValue]]];
            }else {
                [dateArray addObject:@""];
            }
        }
        
        
      //  NSLog(@"电厂：latefee【%.2f】",latefee);
        [dateArray addObject:[NSString stringWithFormat:@"%.2f",latefee]];
       // NSLog(@"------------电厂：dateArray15:%d",[dateArray count]);
        [dataSource.data addObject:dateArray];
        
        // [dateArray release];
        //[monthAndLatefee release];
        //[arrayKeys release];
    }
    //[nameArray release];
    
    //最后一行总计
    NSMutableArray *totalArray=[[NSMutableArray alloc] init];
    [totalArray  addObject:@"3"];
    [totalArray addObject:@"总计"];
    double  allLatefee=0;
    //根据分类 来得到所有的  费用和月份   分组后的
    NSMutableDictionary  *allMonthAndLatefee=[NT_LatefeeTongjDao getMonthAndLatefee:@"cate":factoryCateLable.text:startTime.text :endTime.text ];
    NSMutableArray *allArrayKeys=[[  NSMutableArray alloc] init];
    for (NSObject* t in [allMonthAndLatefee keyEnumerator]) {
        
        [allArrayKeys addObject:t];
        
    }
   // NSLog(@"根据分类【%@】获得allMonthAndLatefee【%d】",factoryCateLable.text,[allMonthAndLatefee count]);
    for (int i=1; i<13; i++) {
        if ([allArrayKeys containsObject:[NSString stringWithFormat:@"%d",i]]) {
            allLatefee=allLatefee+[[allMonthAndLatefee objectForKey:[NSString stringWithFormat:@"%d",i] ] doubleValue];
            [totalArray addObject: [NSString stringWithFormat:@"%.2f",[[allMonthAndLatefee objectForKey:[NSString stringWithFormat:@"%d",i]]doubleValue]]];
        }else {
            [totalArray addObject:@""];
        }
    }
   // NSLog(@"分类:allLatefee:[%.2f]",allLatefee);
    [totalArray addObject:[NSString stringWithFormat:@"%.2f",allLatefee]];
    [dataSource.data addObject:totalArray];
   // NSLog(@"-----------合计15：totalArray：【%d】",[totalArray count]);
   // NSLog(@"加载 listTableView")  ;
    dataQueryVC.dataSource=dataSource;
  //  NSLog(@"--------------------dataQueryVC.dataSource.data[%d]",[dataQueryVC.dataSource.data count]);
}


- (IBAction)release:(id)sender {
    self.factoryCateLable.text=All_;
    self.factoryCateLable.hidden=YES;
    [self.factoryCateButton setTitle:@"电厂类别" forState:UIControlStateNormal];
     self.startTime.text=[formater1 stringFromDate:[NSDate date] ];
    self.startTime.hidden=YES;
        [self.startButton setTitle:[formater1 stringFromDate:[NSDate date] ] forState:UIControlStateNormal];
        self.endTime.text=[formater stringFromDate:[NSDate date]];
    self.endTime.hidden=YES;
   [self.endButton setTitle:[formater stringFromDate:[NSDate date] ] forState:UIControlStateNormal];
    
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
        [xmlParser  requestSOAP:@"Factory"];
       [xmlParser requestSOAP:@"LateFee"];//GetInfo
        [self runActivity];
    }
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
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
    
    
    [ formater release];
    [formater1 release];
    [super dealloc];
}
#pragma  mark  poper delegate Method
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController   
{
    
    if (monthVC) {
        //NSLog(@"monthCV 不为空。。。");
        self.month=monthVC.selectedDate;
    }
    
  //  NSLog(@"当前picket的日期为%@",monthVC.selectedDate);
    return YES;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController  
{
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    if (whichButton==1) {
        [startButton setTitle:[formater stringFromDate:month] forState:UIControlStateNormal ];
      //  NSLog(@"startButton:[%@]",[formater stringFromDate:month]);
        
        
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
    
   // NSLog(@"runActivity-----iSoapNum-[%d]",xmlParser.iSoapNum);
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
