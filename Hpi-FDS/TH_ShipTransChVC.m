//
//  TH_ShipTransChVC.m
//  Hpi-FDS
//
//  Created by bin tang on 12-7-20.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TH_ShipTransChVC.h"
#import "PubInfo.h"
#import "QueryViewController.h"
#import "DataQueryVC.h"
#import "TH_ShipTransDao.h"
#import "DataGridComponent.h"

@interface TH_ShipTransChVC ()

@end

@implementation TH_ShipTransChVC
@synthesize queryButton,resetButton,reloadButton,portButton,monthButton,stageButton;
@synthesize activity;
@synthesize stageLabel,monthLabel,portLabel;
@synthesize popover;
@synthesize chooseView;
@synthesize xmlParser;
@synthesize monthCV;
@synthesize parentVC;
@synthesize month;


static DataGridComponentDataSource *dataSource;

//初始化 父视图
DataQueryVC *dataQueryVC;


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
    
    self.portLabel.text=All_;
    self.monthLabel.text=All_;
    self.stageLabel.text=All_;
    
  
    
    [activity removeFromSuperview];
    self.xmlParser=[[XMLParser alloc] init];
    
    self.portLabel.hidden=YES;
    self.stageLabel.hidden=YES;
    self.monthLabel.hidden=YES;
    
    self.month=[[NSDate alloc] init];
    
    
    //初始化 父视图
   
    dataQueryVC=(DataQueryVC *)self.parentVC;
   
    
    
    //初始化调度日志  视图标题   
    
    //动画
    CATransition *animation=[CATransition animation];
    animation.delegate=self;
    animation.duration=0.5f;
    animation.timingFunction=UIViewAnimationCurveEaseInOut;
    animation.fillMode=kCAFillModeForwards;
    animation.endProgress=1;
    animation.removedOnCompletion =NO;
    animation.type=@"cube";
    
   
    
   [dataQueryVC.chooseView.layer addAnimation:animation forKey:@"animation"];
    //-------------------------
   [dataQueryVC.chooseView bringSubviewToFront:self.view];
    
    
    
    
    float columnOffset = 0.0;
    dataSource=[[DataGridComponentDataSource alloc] init];
    
    dataSource.titles=[ NSArray arrayWithObjects:@"状态",@"港口",@"船名",@"航次",@"航线",@"供货方",@"煤种",@"配载",@"下次航运计划", nil];
    
    dataSource.columnWidth=[NSArray arrayWithObjects:@"75",@"80",@"90",@"90",@"80",@"100",@"80",@"80",@"305",nil];
    
    
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
    
    
    
    
    
    NSDateFormatter *dateFormate=[[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"yyyy-MM-dd"];
    
    [dateFormate stringFromDate:month];
    [dateFormate release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self setPopover:nil];
    [self setPortButton:nil];
    [self setPortLabel:nil];
    [self setActivity:nil];
    [self setMonthButton:nil];
    [self setMonthLabel:nil];

    [self setStageButton:nil];
    [self setStageLabel:nil];
    [self setQueryButton:nil];
    [self setReloadButton:nil];
    [self setResetButton:nil    ];
   
    
    
}
-(void)dealloc
{

    [popover release];
    [portButton release];
    [portLabel release];
    [month release  ];
    [monthButton    release];
    [monthLabel release ];
    [stageLabel release];
    [stageButton release    ];
    [activity   release];
    [queryButton release];
    [resetButton  release];
    [reloadButton   release];
    
    
       [xmlParser   release];
    
    [dataSource release];
    [dataQueryVC release    ];
   
    [super dealloc];
}

- (IBAction)portSelect:(id)sender {
    if (self.popover.popoverVisible) {
        //消失pop
        [self.popover   dismissPopoverAnimated:YES];
    }
 chooseView=[[ChooseView  alloc] init];
    //初始化  显示大小
 [chooseView .view setFrame:CGRectMake(0, 0, 125, 400)  ];
//初始化  在pop种显示的大小
    chooseView.contentSizeForViewInPopover=CGSizeMake(125, 400);
    //初始化弹出窗口
    UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:chooseView];
    chooseView.popover=pop;
    
    
    
    // 初始化一个数组（内存，地址）   将该数组的内存和地址  赋给 chooseView.iDArray 来初始化这个属性
    NSMutableArray *Array=[[NSMutableArray alloc] init];
    chooseView.iDArray=Array;
    [chooseView.iDArray addObject:All_];
    
    NSMutableArray *array=[TgPortDao getTgPort];
    for (int i=0; i<[array count]; i++) {
        TgPort *tgPort=[array objectAtIndex:i];
        [chooseView.iDArray addObject:tgPort.portName];
    }
    chooseView.parentMapView=self;
    
        
    chooseView.type=kChPORT;
    
    
    
    
    self.popover=pop;
    self.popover.delegate=self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(315, 38, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    
    [chooseView.tableView reloadData];
    
    
    
    [chooseView release];
    [pop release];
    [Array release];
    
}


- (IBAction)stageSelect:(id)sender {
    NSLog(@"stage。。。。。");
    if (self.popover .popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
chooseView=[[ChooseView alloc] init];
[chooseView.view setFrame:CGRectMake(0, 0, 125, 400)];
chooseView. contentSizeForViewInPopover=CGSizeMake(125, 400);    

UIPopoverController *pop=[[UIPopoverController   alloc] initWithContentViewController:chooseView];
chooseView.popover=pop;

//状态
    NSMutableArray *Array=[[NSMutableArray alloc] init];
    chooseView.iDArray=Array;

    
  chooseView.iDArray=[NSMutableArray arrayWithObjects:All_,@"受载在途",@"在港待办",@"在港待靠",@"在港在装",@"满载在途",@"卸港待办",@"卸港待靠",@"卸港在卸", nil];

   chooseView.parentMapView=self;

    
    //类型
    
    chooseView.type=kshiptransStage;
    
    
    
   self.popover=pop;
self.popover.delegate=self;
//设置弹出窗口尺寸
self.popover.popoverContentSize = CGSizeMake(125, 400);
//显示，其中坐标为箭头的坐标以及尺寸
[self.popover presentPopoverFromRect:CGRectMake(587, 38, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

    
    NSLog(@"加载  tabelview");
    
    
    
[chooseView.tableView reloadData];
[chooseView release];
[pop release];
[Array  release];

}

- (IBAction)dateSelect:(id)sender {
    NSLog(@"month。。。。。");
    if (self.popover .popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }


    monthCV=[[DateViewController alloc] init];
    [monthCV .view setFrame:CGRectMake(0, 0, 195, 216)];
    monthCV.contentSizeForViewInPopover=CGSizeMake(195, 216);
    
    UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:monthCV];
    monthCV.popover=pop;//没什么用？
    monthCV.selectedDate=self.month;//初始化  属性[[NSDate alloc] init];  也可以不用他来初始化
    
    self.popover=pop;
    self.popover.delegate=self;
    
    self.popover.popoverContentSize=CGSizeMake(195, 216);
    
    [self.popover presentPopoverFromRect:CGRectMake(859, 38, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    
    
    
    
    [monthCV release];
    [pop release];
    


    
}



- (IBAction)query:(id)sender {
    
    NSLog(@"stagelabel:[%@]",stageLabel.text);

    NSLog(@"monthlable:[%@]",monthLabel.text);
    
    NSLog(@"portlabel:[%@]",portLabel.text);
    
    NSDateFormatter *formater=[[NSDateFormatter  alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd'T'00:00:00"];

    
    
    if (![monthButton.titleLabel.text  isEqualToString:@"日期"]) {
        monthLabel.text=monthButton.titleLabel.text;
    }
    
    if (monthLabel.text!=All_) {
        monthLabel.text=[formater stringFromDate:month];
        [formater release];
    }
    
    
    
    
    
NSAutoreleasePool *looPool=[[NSAutoreleasePool   alloc] init];
    
    
    
   dataQueryVC.dataArray=[TH_ShipTransDao getTH_ShipTrans:portLabel.text :monthLabel.text:stageLabel.text];

    
    dataSource.data=[[NSMutableArray alloc] init];
    NSLog(@"获得Th_ShipTrans[%d]",dataQueryVC.dataArray.count);
    
    for (int i=0; i<[dataQueryVC.dataArray  count ]; i++) {
        TH_ShipTrans *shipTrans=[dataQueryVC.dataArray objectAtIndex:i];
        [dataSource.data addObject:[NSArray arrayWithObjects:@"3",
                                    
                                    //列表表题所用字段
                                    shipTrans.STATENAME,
                                    shipTrans.PORTNAME,
                                    shipTrans.SHIPNAME,
                                    shipTrans.TRIPNO,
                                    shipTrans.FACTORYNAME,
                                    shipTrans.SUPPLIER,
                                    shipTrans.COALTYPE,
                                    [NSString stringWithFormat:@"%d",shipTrans.LW],
                                    @"",
                                     nil]];
     }
    NSLog(@"加载 listTableView");
    dataQueryVC.dataSource=dataSource;
      [dataQueryVC.listTableview   reloadData];
    
   [looPool drain];    
}

- (IBAction)reset:(id)sender {
    self.stageLabel.text=All_;
    self.monthLabel.text=All_;
    self.portLabel.text=All_;
    
    self.stageLabel.hidden=YES;
    self.portLabel.hidden=YES;
    self.monthLabel.hidden=YES;
    
    [stageButton setTitle:@"状态" forState:UIControlStateNormal   ];
    
    [monthButton    setTitle:@"日期" forState:UIControlStateNormal];
    [portButton setTitle:@"港口"forState:UIControlStateNormal];
    
    
    
    
    
}



//同步
- (IBAction)reload:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间"  delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步", nil];
    
    [alert show];
       
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==1) {
        [self.view addSubview:activity];
      [reloadButton setTitle:@"同步中...." forState:UIControlStateNormal];
        [activity startAnimating];
               
       //解析入库
        [xmlParser setISoapNum:1];
        [xmlParser getTHShipTrans];
        //港口
        [xmlParser getTgPort];
        
        //状态
      [self runActivety];
    }
}


#pragma mark  pop method

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController   
{
    if (monthCV) {
        self.month=monthCV.selectedDate;
    }
    
    
    return  YES;

}
//pop 消失时的操作
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController  
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [monthButton setTitle:[dateFormatter stringFromDate:month] forState:UIControlStateNormal];
    [dateFormatter release];

}
#pragma  mark activety

-(void)runActivety
{

    if (xmlParser.iSoapNum==0) {
        [activity stopAnimating];
        
        [activity removeFromSuperview];
        
        [reloadButton setTitle:@"网络同步" forState:UIControlStateNormal];
        
        return;
        
        
    }else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runActivety) userInfo:NULL repeats:NO];
        
    }
    
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark setSelectValue  Method
-(void)setLableValue:(NSString *)currentSelectValue
{

    if (chooseView) {
        if (chooseView.type==kChPORT) {
            
            self.portLabel.text =currentSelectValue;
            if (![self.portLabel.text isEqualToString:All_]) {
               self.portLabel.hidden=NO;
                [self.portButton setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                self.portLabel.hidden=YES;
                [self.portButton setTitle:@"装运港" forState:UIControlStateNormal];
            }

           }
        if (chooseView.type==kshiptransStage) {
            self.stageLabel.text=currentSelectValue;
            if (![self.stageLabel.text isEqualToString:All_]) {
               self.stageLabel.hidden=NO;
                [self.stageButton setTitle:@"" forState:UIControlStateNormal   ];
            }else {
                self.stageLabel.hidden=YES;
                [self.stageButton setTitle:@"状态" forState:UIControlStateNormal ];
            }

        }
        
        
     
    }
NSLog(@"chooseView为空");



}
@end
