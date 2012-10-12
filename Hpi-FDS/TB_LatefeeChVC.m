//
//  TB_LatefeeChVC.m
//  Hpi-FDS
//
//  Created by bin tang on 12-7-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TB_LatefeeChVC.h"
#import "DataQueryVC.h"
#import "QueryViewController.h"
#import "PubInfo.h"
#import "TB_LatefeeDao.h"


@interface TB_LatefeeChVC ()

@end

@implementation TB_LatefeeChVC
@synthesize comLabel;
@synthesize comButton;
@synthesize shipLabel;
@synthesize shipButton;
@synthesize factoryLabel;
@synthesize factoryButton;
@synthesize typeLabel;
@synthesize typeButton;
@synthesize supLable;
@synthesize supButton;
@synthesize startTime;
@synthesize startButton;
@synthesize endTime;
@synthesize endButton;
@synthesize reload;
@synthesize active;
@synthesize parentVC;
@synthesize xmlParser;
@synthesize month;
@synthesize monthCV;
@synthesize chooseView;
@synthesize poper;


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

static int  whichButton=0;



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.comLabel.text=All_;
    self.shipLabel.text=All_;
    self.factoryLabel.text=All_;
    self.typeLabel.text=All_;
    self.supLable.text=All_;
   self.startTime.text=All_;
    self.endTime.text=All_;
    
    [active removeFromSuperview];
    
    xmlParser=[[TBXMLParser alloc] init];
    self.comLabel.hidden=YES;
    self.shipLabel.hidden=YES;
    self.factoryLabel.hidden=YES;
    self.typeLabel.hidden=YES   ;
    self.supLable.hidden=YES;
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
    animation.removedOnCompletion =NO;
    animation.type=@"cube";
    
    [dataQueryVC.chooseView.layer addAnimation:animation forKey:@"animation"];
    
    //-------------------------
    [dataQueryVC.chooseView bringSubviewToFront:self.view];
    float columnOffset = 0.0;
    dataSource=[[DataGridComponentDataSource alloc] init];
    dataSource.titles=[ NSArray arrayWithObjects:@"航运公司",@"船名",@"航次",@"港口",@"流向",@"供货方",@"数量",@"交货时间",@"滞期费", nil];
    
    dataSource.columnWidth=[NSArray arrayWithObjects:@"100",@"110",@"100",@"115",@"115",@"120",@"90",@"150",@"130",nil];
    animation.type= @"oglFlip"; 
    [dataQueryVC.labelView.layer addAnimation:animation forKey:@"animation"];
    [dataQueryVC.labelView removeFromSuperview  ];
    //清空数据源。。。。。
    
    //填充 标题数据
    for(int column = 0;column < [dataSource.titles count];column++){
        float columnWidth=[[dataSource.columnWidth objectAtIndex:column ] floatValue];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth-1 , 40+2 )];
        
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
    //初始化
    month=[[NSDate alloc] init];
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    
    [formater stringFromDate:month];
    [ formater release];
   
}

- (IBAction)comButtonSelect:(id)sender {
    
    if (self.poper.popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
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
    chooseView.iDArray=[NSArray arrayWithObjects:All_, [[NSMutableArray alloc] initWithObjects:@"时代", @"4",nil] ,[[NSMutableArray alloc] initWithObjects:@"瑞宁", @"5",nil],[[NSMutableArray alloc] initWithObjects:@"华鲁", @"6",nil],[[NSMutableArray alloc] initWithObjects:@"其它", @"7",nil],[[NSMutableArray alloc] initWithObjects:@"福轮总", @"9",nil],nil];
    chooseView.parentMapView=self;
    chooseView.type=kChCOM_Latefee;
    self.poper = pop;
    self.poper.delegate = self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper presentPopoverFromRect:CGRectMake(187, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
}

- (IBAction)shipNameSelect:(id)sender {
    if (self.poper.popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
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
    NSMutableArray *array=[TgShipDao getTgShip];
    NSMutableArray *Array=[[NSMutableArray alloc]init];
    chooseView.iDArray=Array;
    [chooseView.iDArray addObject:All_];
    for(int i=0;i<[array count];i++){
        TgShip *tgShip=[array objectAtIndex:i];
        
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        [arr addObject:tgShip.shipName];
        [arr addObject:[NSString stringWithFormat:@"%d",tgShip.shipID]];
        [chooseView.iDArray addObject:arr];
        [arr  release];
        
        
    }
    chooseView.parentMapView=self;
    chooseView.type=kchship_Latefee;
    self.poper = pop;
    self.poper.delegate = self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper presentPopoverFromRect:CGRectMake(387, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
    
       
}
- (IBAction)factoryButtonSelect:(id)sender {
    if (self.poper.popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
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
    NSMutableArray *Array=[[NSMutableArray alloc]init];
    chooseView.iDArray=Array;
    [chooseView.iDArray addObject:All_];
    NSMutableArray *array=[TgFactoryDao getTgFactory];
    for(int i=0;i<[array count];i++){
        TgFactory *tgFactory=[array objectAtIndex:i];
        
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        [arr addObject:tgFactory.factoryName];
         [arr addObject:tgFactory.factoryCode];
        
        [chooseView.iDArray addObject:arr];
        
        [arr release];
        
    }
    chooseView.parentMapView=self;
    chooseView.type=kChFACTORY_Latefee;
    self.poper = pop;
    self.poper.delegate = self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper presentPopoverFromRect:CGRectMake(587, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
    
    
    
    
    
    
    
}
- (IBAction)coalButtonSelect:(id)sender {
    if (self.poper .popoverVisible) {
        [self.poper  dismissPopoverAnimated:YES];
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
    NSMutableArray *Array=[[NSMutableArray alloc]init];
    chooseView.iDArray=Array;
    [chooseView.iDArray addObject:All_];
    
    
    
    
    
    //获得煤种数据源
    NSMutableArray *array=[TfCoalTypeDao getTfCoalType];
    for(int i=0;i<[array count];i++){
        TfCoalType *tfcoal=[array objectAtIndex:i];
        
        
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        [arr addObject:tfcoal.COALTYPE];
        [arr addObject:[NSString stringWithFormat:@"%d",tfcoal.TYPEID]];
        
        [chooseView.iDArray addObject:arr];
        [arr release];
    }
    
    
    
    
    
    chooseView.parentMapView=self;
    chooseView.type=kCOALTYPE_Latefee;
    self.poper  = pop;
    self.poper .delegate = self;
    //设置弹出窗口尺寸
    self.poper .popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper  presentPopoverFromRect:CGRectMake(787, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
    
    
}
- (IBAction)supButtonSelect:(id)sender {
    if (self.poper.popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
    }
    
    //初始化多选控制器
    chooseView=[[ChooseView alloc]init]; 
    //设置待显示控制器的范围
    [chooseView.view setFrame:CGRectMake(0,0, 125, 400)];
    //设置待显示控制器视图的尺寸
    chooseView.contentSizeForViewInPopover = CGSizeMake(125, 400);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:chooseView];
    chooseView.popover = pop;
    
    
    NSMutableArray *SupplierArray=[[NSMutableArray alloc]init];
    
    chooseView.iDArray=SupplierArray;
    [chooseView.iDArray addObject:All_];
    
    NSMutableArray *array=[TfSupplierDao getTfSupplier];

    for(int i=0;i<[array count];i++){
            TfSupplier *tfSupplier=[array objectAtIndex:i];
        
        
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        [arr addObject:tfSupplier.SUPPLIER  ];
        [arr addObject:[NSString stringWithFormat:@"%d",tfSupplier.SUPID ]];
        
        
            [chooseView.iDArray addObject:arr];
        [arr release];
            
        }

   
    
    
   chooseView.parentMapView=self;
    
    
    chooseView.type=kSUPPLIER_Latefee;
    
    
    
    self.poper = pop;
    self.poper.delegate = self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(125, 800);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper presentPopoverFromRect:CGRectMake(987, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [SupplierArray release];
    
    
    
    
    
    
    
}

- (IBAction)startTimeSelect:(id)sender {
    whichButton=1;
    NSLog(@"startmonth。。。。。");
    if (self.poper .popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
    }
    
    
    if(!monthCV)
    monthCV=[[DateViewController alloc] init];
    [monthCV .view setFrame:CGRectMake(0, 0, 195, 216)];
    monthCV.contentSizeForViewInPopover=CGSizeMake(195, 216);
    
    UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:monthCV];
    monthCV.popover=pop;//没什么用？
    monthCV.selectedDate=self.month;//初始化  属性[[NSDate alloc] init];  也可以不用他来初始化
    
    self.poper=pop;
    self.poper.delegate=self;
    
    self.poper.popoverContentSize=CGSizeMake(195, 216);
    
    [self.poper presentPopoverFromRect:CGRectMake(187, 76, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    
    
    
     //不能释放
    //[monthCV release];
    [pop release];
    

    
}



- (IBAction)endTimeSelect:(id)sender {
    whichButton=2;
    NSLog(@"endmonth。。。。。");
    if (self.poper .popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
    }
    
    if(!monthCV)
    monthCV=[[DateViewController alloc] init];
    [monthCV .view setFrame:CGRectMake(0, 0, 195, 216)];
    monthCV.contentSizeForViewInPopover=CGSizeMake(195, 216);
    
    UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:monthCV];
    monthCV.popover=pop;//没什么用？
    monthCV.selectedDate=self.month;//初始化  属性[[NSDate alloc] init];  也可以不用他来初始化
    
    self.poper=pop;
    self.poper.delegate=self;
    
    self.poper.popoverContentSize=CGSizeMake(195, 216);
    
    [self.poper presentPopoverFromRect:CGRectMake(387, 76, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    
    
    
    
    //[monthCV release];
    [pop release];
}



- (IBAction)release:(id)sender {
    self.comLabel.text=All_;
    self.comLabel.hidden=YES;
    [self.comButton  setTitle:@"航运公司" forState:UIControlStateNormal ];
    
    self.shipLabel.text=All_;
    self.shipLabel.hidden=YES;
    [self.shipButton setTitle:@"船名" forState:UIControlStateNormal   ];
    
    self.factoryLabel.text=All_;
    self.factoryLabel.hidden=YES;
    [self.factoryButton  setTitle:@"流向电厂" forState:UIControlStateNormal ];
    
    
    self.typeLabel.text=All_;
    self.typeLabel.hidden=YES;
    [self.typeButton setTitle:@"煤种" forState:UIControlStateNormal    ];
    
    
    self.supLable.text=All_;
    self.supLable.hidden=YES;
    [self.supButton setTitle:@"供货方" forState:UIControlStateNormal   ];
    
    
    self.startTime.text=All_;
    self.startTime.hidden=YES;
    [self.startButton setTitle:@"开始时间" forState:UIControlStateNormal];
    
    self.endTime.text=All_;
    self.endTime.hidden=YES;
    [self.endButton setTitle:@"结束时间" forState:UIControlStateNormal];
    
}


- (IBAction)query:(id)sender {
   /*
    NSLog(@"comLable:[%@]",comLabel.text);
    NSLog(@"comButton==================%@",comButton.titleLabel.text);
    NSLog(@"shipLable   :[%@]",shipLabel.text);
    NSLog(@"shipButton.titleLabel.text==================%@",shipButton.titleLabel.text);
    NSLog(@"factoryLable   :[%@]",factoryLabel.text);
        NSLog(@"factoryButton==================%@",factoryButton.titleLabel.text);
    NSLog(@"coalLable   :[%@]",typeLabel.text);
       NSLog(@"typeButton==================%@",typeButton.titleLabel.text);
    NSLog(@"supLable   :[%@]",supLable .text);
     NSLog(@"supButton==================%@",supButton.titleLabel.text);*/
    
    if (![startButton .titleLabel.text isEqualToString:@"开始时间"]) {
        startTime.text=startButton.titleLabel.text;
    }
    if (![endButton .titleLabel.text isEqualToString:@"结束时间"]) {
        endTime.text=endButton.titleLabel.text;
    }
    
 
    
    
 //   NSLog(@"开始时间为：%@",startTime.text);
  //  NSLog(@"结束时间为：%@",endTime.text);

    dataQueryVC.dataArray=[TB_LatefeeDao getTB_LateFee:comLabel.text :shipLabel.text :factoryLabel.text :typeLabel.text  :supLable.text :startTime.text :endTime.text] ;
    
    //[VB_LatefeeDao getVB_LateFee:comLabel.text :shipLabel.text :factoryLabel.text :typeLabel.text  :supLable.text :startTime.text :endTime.text] ;
    
    
    dataSource.data=[[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<[dataQueryVC.dataArray  count ]; i++) {
       TB_Latefee *tblatefee=[dataQueryVC.dataArray objectAtIndex:i];
        
        [dataSource.data addObject:[NSArray arrayWithObjects:@"3",
                                    
                                    //列表表题所用字段
                                    [NSString stringWithFormat:@"%@",tblatefee.COMPANY],                               
                                   
                                    [NSString stringWithFormat:@"%@",tblatefee.SHIPNAME],
                                    
                                    tblatefee.TRIPNO,
                                    tblatefee.PORTNAME,
                                    
                                    
                                    tblatefee.FACTORYNAME,
                                    [NSString stringWithFormat:@"%@",tblatefee.SUPPLIER],
                                    
                                    [NSString stringWithFormat:@"%d",tblatefee.LW],
                                    [PubInfo    formaDateTime:tblatefee.TRADETIME FormateString:@"yyyy/MM/dd HH:mm:ss"]  ,//完活时间 取记录时间
                                  
                                    tblatefee.LATEFEE,
                                                                        
                                    nil]];
        
  
    }
    
    NSLog(@"加载 listTableView");
    dataQueryVC.dataSource=dataSource;
    [dataQueryVC.listTableview   reloadData];
    
   }

- (IBAction)reload:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间"  delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步", nil];
    
    [alert show];
    [alert release];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.view addSubview:active];
        [reload setTitle:@"同步中...." forState:UIControlStateNormal];
        [active startAnimating];
        //解析入库
        [xmlParser setISoapNum:1];
        [xmlParser requestSOAP:@"LateFee"];
         
        
        
        

        //状态
        [self runActivity];
    }
}
- (void)viewDidUnload
{
    [self setComLabel:nil];
    [self setShipLabel:nil];
    [self setFactoryLabel:nil];
    [self setTypeLabel:nil];
    [self setSupLable:nil];
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setComButton:nil];
    [self setShipButton:nil];
    [self setFactoryButton:nil];
    [self setTypeButton:nil];
    [self setSupButton:nil];
    [self setStartButton:nil];
    [self setEndButton:nil];
    [self setReload:nil];
    [self setActive:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    [comLabel release];
    [shipLabel release];
    [factoryLabel release];
    [typeLabel release];
    [supLable release];
    [startTime release];
    [endTime release];
    [comButton release];
    [shipButton release];
    [factoryButton release];
    [typeButton release];
    [supButton release];
    [startButton release];
    [endButton release];
    [reload release];
    [active release];
    [poper   release];
    
    [parentVC release];
    [xmlParser release];
    [month release];
    [monthCV release];
    [chooseView  release];
    
   
    
    
    [super dealloc];
}


#pragma  mark  poper delegate Method
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController   
{

    if (monthCV) {
        NSLog(@"monthCV 不为空。。。");
       self.month=monthCV.selectedDate;
    }
    
    NSLog(@"当前picket的日期为%@",monthCV.selectedDate);
    return YES;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController  
{
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
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

    if (xmlParser.iSoapNum==0) {
        [active stopAnimating];
        
        [active removeFromSuperview];
        
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
         
        if (chooseView.type==kChCOM_Latefee) {
            self.comLabel.text=currentSelectValue;  
            
            
            if (![self.comLabel.text isEqualToString:All_]) {
                
                NSArray *chunks = [currentSelectValue componentsSeparatedByString: @","];
                self.comLabel.text=[chunks objectAtIndex:1];
                self.comLabel.hidden=YES    ;
                [self.comButton setTitle:[NSString stringWithFormat:@"%@",[chunks objectAtIndex:0]] forState:UIControlStateNormal];
                
            }else {
                self.comLabel.hidden=YES;
                [self.comButton setTitle:@"航运公司" forState:UIControlStateNormal];
            }
            
            
        }
        if (chooseView.type==kchship_Latefee) {
            self.shipLabel.text=currentSelectValue;
            if (![self.shipLabel.text isEqualToString:All_]) {
                 NSArray *chunks = [currentSelectValue componentsSeparatedByString: @","];
                
                self.shipLabel.text=[chunks objectAtIndex:1];
                
                self.shipLabel.hidden=YES;
                [self.shipButton setTitle:[NSString stringWithFormat:@"%@",[chunks objectAtIndex:0]] forState:UIControlStateNormal];
                
                
                
            }else {
                self.shipLabel.hidden=YES;
                [self.shipButton setTitle:@"船名" forState:UIControlStateNormal];
            }
          
        }
        
        
        
    if (chooseView.type==kChFACTORY_Latefee) {
        self.factoryLabel.text=currentSelectValue;
        if (![self.factoryLabel.text isEqualToString:All_]) {
              NSArray *chunks = [currentSelectValue componentsSeparatedByString: @","];
             self.factoryLabel.text=[chunks objectAtIndex:1];
            self.factoryLabel.hidden=YES;
            [self.factoryButton setTitle:[NSString stringWithFormat:@"%@",[chunks objectAtIndex:0]] forState:UIControlStateNormal];
        }else {
            self.factoryLabel.hidden=YES;
            [self.factoryButton setTitle:@"流向电厂" forState:UIControlStateNormal];
        }
       
     }
        
    if (chooseView.type==kCOALTYPE_Latefee) {
        self.typeLabel.text=currentSelectValue;
        if (![self.typeLabel.text isEqualToString:All_]) {
             NSArray *chunks = [currentSelectValue componentsSeparatedByString: @","];
            self.typeLabel.text=[chunks objectAtIndex:1];
            self.typeLabel.hidden=YES   ;
            [self.typeButton setTitle:[NSString stringWithFormat:@"%@",[chunks objectAtIndex:0]]  forState:UIControlStateNormal];
            
            
        }else {
            self.typeLabel.hidden=YES;
            [self.typeButton   setTitle:@"煤种" forState:UIControlStateNormal];
        }

    }
    
    
    if (chooseView.type==kSUPPLIER_Latefee) {
        self.supLable.text=currentSelectValue;
        if (![self.supLable.text isEqualToString:All_]) {
             NSArray *chunks = [currentSelectValue componentsSeparatedByString: @","];
            self.supLable.text=[chunks objectAtIndex:1];
            self.supLable.hidden=YES    ;
            [self.supButton     setTitle:[NSString stringWithFormat:@"%@",[chunks objectAtIndex:0]]   forState:UIControlStateNormal];
        }else {
            self.supLable  .hidden=YES;
            [self.supButton setTitle:@"供货方" forState:UIControlStateNormal  ];
        }

    }
 
    
    
  
   }
    
    
    
  }







@end
