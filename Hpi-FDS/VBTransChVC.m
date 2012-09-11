//
//  VBTransChVC.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VBTransChVC.h"
#import "PubInfo.h"
#import "QueryViewController.h"
#import "DataQueryVC.h"
#import "TfCoalTypeDao.h"



@interface VBTransChVC ()

@end

@implementation VBTransChVC
@synthesize activity;
@synthesize reloadButton;
@synthesize comButton;
@synthesize comLabel;
@synthesize shipButton;
@synthesize shipLabel;
@synthesize portButton;
@synthesize portLabel;
@synthesize typeButton;
@synthesize typeLabel;
@synthesize factoryButton;
@synthesize factoryLabel;
@synthesize monthButton;
@synthesize monthLabel;
@synthesize codeTextField;
@synthesize queryButton;
@synthesize resetButton;
@synthesize popover,chooseView,parentVC,month,monthCV;
@synthesize tbxmlParser;


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
	// Do any additional setup after loading the view.
    self.shipLabel.text =All_;
    self.comLabel.text=All_;
    self.portLabel.text=All_;
    self.typeLabel.text=All_;
    self.factoryLabel.text=All_;
    self.monthLabel.text=All_;
    [activity removeFromSuperview];
    //初始化  tbxmlparser
    self.tbxmlParser =[[TBXMLParser alloc] init];
    
    self.shipLabel.hidden=YES;
    self.comLabel.hidden=YES;
    self.portLabel.hidden=YES;
    self.typeLabel.hidden=YES;
    self.factoryLabel.hidden=YES;
    self.monthLabel.hidden=YES;
    
    NSDate *date=[[NSDate alloc]init];
    self.month=date;
    [date release];
    //[self setMonth:[[NSDate alloc] init]];
    month=[[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    [dateFormatter stringFromDate:month];
    [dateFormatter release];
    
    
    dataQueryVC=self.parentVC;
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1;
    animation.removedOnCompletion = NO;
    animation.type = @"cube";
    [dataQueryVC.chooseView.layer addAnimation:animation forKey:@"animation"];
    
    [dataQueryVC.chooseView bringSubviewToFront:self.view];
    
    float columnOffset = 0.0;

    [self initSource];
    
    animation.type = @"oglFlip";
    [dataQueryVC.labelView.layer addAnimation:animation forKey:@"animation"];
    [dataQueryVC.labelView removeFromSuperview];
    //填冲标题数据
    for(int column = 0;column < [dataSource.titles count];column++){
        float columnWidth = [[dataSource.columnWidth objectAtIndex:column] floatValue];
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
    if(dataSource){
        dataSource=nil;
        [dataSource release];
    }
 
    
}
-(void)initSource
{
    if (!dataSource) {
        
         dataSource = [[DataGridComponentDataSource alloc] init];
        
        dataSource.columnWidth = [NSArray arrayWithObjects:@"115",@"75",@"85",@"85",@"80",@"100",@"90",@"90",@"85",@"70",@"75",@"75",nil];
        dataSource.titles = [NSArray arrayWithObjects:@"计划号",@"计划月份",@"船名",@"流向",@"航次",@"装运港",@"预抵装港",@"预抵卸港",@"预计载煤量",@"煤种",@"供货方",@"类别",nil];
    }
}

- (void)viewDidUnload
{
    [self setComButton:nil];
    [self setComLabel:nil];
    [self setShipButton:nil];
    [self setShipLabel:nil];
    [self setPortButton:nil];
    [self setPortLabel:nil];
    [self setTypeButton:nil];
    [self setTypeLabel:nil];
    [self setFactoryButton:nil];
    [self setFactoryLabel:nil];
    [self setMonthButton:nil];
    [self setMonthLabel:nil];
    [self setCodeTextField:nil];
    [self setQueryButton:nil];
    [self setResetButton:nil];
    [self setReloadButton:nil];
    [self setActivity:nil];
    self.tbxmlParser =nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    if(dataSource){
        [dataSource release];
    }
    if(dataQueryVC){
        [dataQueryVC release];
    }
    
    
    [comButton release];
    [comLabel release];
    [shipButton release];
    [shipLabel release];
    [portButton release];
    [portLabel release];
    [typeButton release];
    [typeLabel release];
    [factoryButton release];
    [factoryLabel release];
    [monthButton release];
    [monthLabel release];
    [codeTextField release];
    [queryButton release];
    [resetButton release];
    [popover release];
    [reloadButton release];
    [activity release];
    [month release];
    self.tbxmlParser =nil;

    [super dealloc];
}

- (IBAction)comAction:(id)sender {
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
    chooseView.iDArray=[NSArray arrayWithObjects:All_,@"时代",@"瑞宁",@"华鲁",@"其它",@"福轮总",nil];
    chooseView.parentMapView=self;
    chooseView.type=kChCOM;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(94, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
}

- (IBAction)shipAction:(id)sender {
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
    NSMutableArray *array=[TgShipDao getTgShip];
    NSMutableArray *Array=[[NSMutableArray alloc]init];
    chooseView.iDArray=Array;
    [chooseView.iDArray addObject:All_];
    for(int i=0;i<[array count];i++){
        TgShip *tgShip=[array objectAtIndex:i];
        [chooseView.iDArray addObject:tgShip.shipName];
    }
    chooseView.parentMapView=self;
    chooseView.type=kChSHIP;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(295, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
}

- (IBAction)portAction:(id)sender {
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
    NSMutableArray *Array=[[NSMutableArray alloc]init];
    chooseView.iDArray=Array;
    [chooseView.iDArray addObject:All_];
    NSMutableArray *array=[TgPortDao getTgPort];
    for(int i=0;i<[array count];i++){
        TgPort *tgPort=[array objectAtIndex:i];
        [chooseView.iDArray addObject:tgPort.portName];
    }
    chooseView.parentMapView=self;
    chooseView.type=kChPORT;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(498, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
}
- (IBAction)typeAction:(id)sender {
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
    NSMutableArray *Array=[[NSMutableArray alloc]init];
    chooseView.iDArray=Array;
    [chooseView.iDArray addObject:All_];
    //获得煤种数据源
    NSMutableArray *array=[TfCoalTypeDao getTfCoalType];
    for(int i=0;i<[array count];i++){
        TfCoalType *tfcoal=[array objectAtIndex:i];
        
        [chooseView.iDArray addObject:tfcoal.COALTYPE];
    } 
    chooseView.parentMapView=self;
    chooseView.type=kCOALTYPE;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(708, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
}

- (IBAction)factoryAction:(id)sender {
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
    NSMutableArray *Array=[[NSMutableArray alloc]init];
    chooseView.iDArray=Array;
    [chooseView.iDArray addObject:All_];
    NSMutableArray *array=[TgFactoryDao getTgFactory];
    for(int i=0;i<[array count];i++){
        TgFactory *tgFactory=[array objectAtIndex:i];
        [chooseView.iDArray addObject:tgFactory.factoryName];
    }
    chooseView.parentMapView=self;
    chooseView.type=kChFACTORY;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(904, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
}
-(IBAction)monthButton:(id)sender
{
    NSLog(@"month");
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    if(!monthCV)//初始化待显示控制器
        monthCV=[[DateViewController alloc]init]; 
    //设置待显示控制器的范围
    [monthCV.view setFrame:CGRectMake(0,0, 195, 216)];
    //设置待显示控制器视图的尺寸
    monthCV.contentSizeForViewInPopover = CGSizeMake(195, 216);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:monthCV];
    monthCV.popover = pop;
    monthCV.selectedDate=self.month;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(195, 216);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(110, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];    
    [pop release];
}

- (IBAction)reloadAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步",nil];
	[alert show];
    [alert release];
 
}




- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.view addSubview:activity];
        [reloadButton setTitle:@"同步中..." forState:UIControlStateNormal];
        
        [activity startAnimating];
        
        [tbxmlParser setISoapNum:1];

       [tbxmlParser requestSOAP:@"TransPlan"];
        //同步煤种
       [tbxmlParser requestSOAP:@"CoalType"];//GetInfo
        
        [self runActivity];
    }
	
}

- (IBAction)queryAction:(id)sender {
    

    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyyMM"];
    
    if (![monthButton.titleLabel.text isEqualToString:@"月份"]) {
        monthLabel.text=monthButton.titleLabel.text;
    }

    NSLog(@"monthLabel.text=[%@]",monthLabel.text);
    NSLog(@"monthButton=[%@]",monthButton.titleLabel.text);
    NSLog(@"取时间用month=[%@]",[f stringFromDate:self.month]);
    
    
    
    NSLog(@"codeTextField=[%@]",codeTextField.text);
    if (monthLabel.text!=All_) {
        monthLabel.text=[f stringFromDate:self.month];
      
    }
     [f release];
    
    
      NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc]init];
    
      [self initSource];
    dataQueryVC.dataArray=[VbTransplanDao getVbTransplan:comLabel.text :shipLabel.text :portLabel.text :typeLabel.text :factoryLabel.text :monthLabel.text:codeTextField.text];
  
    
    dataSource.data=[[[NSMutableArray alloc]init] autorelease];
    
    for (int i=0;i<[dataQueryVC.dataArray count];i++) {
        VbTransplan *transplan=[dataQueryVC.dataArray objectAtIndex:i];
        //船运计划和 电厂动态  没有 状态  stage
        [dataSource.data addObject:[NSArray arrayWithObjects:
                                    @"3",
                                    
                                    transplan.planCode,
                                    transplan.planMonth,
                                    transplan.shipName,
                                    transplan.factoryName,
                                    transplan.tripNo,
                                    transplan.portName,
                                    
                                   transplan.eTap,
                                    //格式化时间  [PubInfo formaDateTime:transplan.eTap FormateString:@"yyyy-MM-dd"]  ,
                                   transplan.eTaf,
                                    
                                    //格式化时间   [PubInfo formaDateTime:transplan.eTaf FormateString:@"yyyy-MM-dd"]  ,
                                    
                                    
                                    [NSString stringWithFormat:@"%d",transplan.eLw],
                                    transplan.coalType,
                                    transplan.supplier,
                                    transplan.keyName,
                                    nil ]];
        
        
        
    }

     dataQueryVC.dataSource=dataSource;
    
    [dataSource release];
    [dataQueryVC.listTableview reloadData];
      [loopPool drain];

    if(dataSource){
        dataSource=nil;
        [dataSource release];
    }

    
    
}

- (IBAction)resetAction:(id)sender {
    
    
    self.comLabel.text=All_;
    self.shipLabel.text =All_;
    self.portLabel.text=All_;
    self.typeLabel.text=All_;
    self.factoryLabel.text=All_;
    self.monthLabel.text=All_;
    self.comLabel.hidden=YES;
    self.shipLabel.hidden=YES;
    self.portLabel.hidden=YES;
    self.typeLabel.hidden=YES;
    self.factoryLabel.hidden=YES;
    self.monthLabel.hidden=YES;
    
    [comButton setTitle:@"航运公司" forState:UIControlStateNormal];
    [shipButton setTitle:@"船名" forState:UIControlStateNormal];
    [portButton setTitle:@"装运港" forState:UIControlStateNormal];
    [typeButton setTitle:@"煤种" forState:UIControlStateNormal];
    [factoryButton setTitle:@"流向" forState:UIControlStateNormal];
    [monthButton setTitle:@"月份" forState:UIControlStateNormal];
    [codeTextField setText:@""];
    
}

#pragma mark - popoverController
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    if (monthCV)
        self.month=monthCV.selectedDate;
    return  YES;
}

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissPopoverAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    [monthButton setTitle:[dateFormatter stringFromDate:month] forState:UIControlStateNormal];
    [dateFormatter release];
}

#pragma mark activity
-(void)runActivity
{
    if ([tbxmlParser iSoapNum]==0) {
        [activity stopAnimating];
        [activity removeFromSuperview];
        [reloadButton setTitle:@"网络同步" forState:UIControlStateNormal];
        return;
    }
    else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runActivity) userInfo:NULL repeats:NO];
    }
}


#pragma mark SetSelectValue  Method
-(void)setLableValue:(NSString *)currentSelectValue
{
    
    if (chooseView) {
        if (chooseView.type==kChCOM) {
            
            
            self.comLabel.text =currentSelectValue;
            if (![self.comLabel.text isEqualToString:All_]) {
                self.comLabel.hidden=NO;
                [self.comButton setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                self.comLabel.hidden=YES;
                [self.comButton setTitle:@"航运公司" forState:UIControlStateNormal];
            }
            
          }
        
        if (chooseView.type==kChSHIP) {
            self.shipLabel.text =currentSelectValue;
            if (![self.shipLabel.text isEqualToString:All_]) {
                self.shipLabel.hidden=NO;
                [self.shipButton setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                self.shipLabel.hidden=YES;
                [self.shipButton setTitle:@"船名" forState:UIControlStateNormal];
            }

        }
    
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
        
        if (chooseView.type==kCOALTYPE) {
            self.typeLabel.text=currentSelectValue;
            if (![self.typeLabel.text isEqualToString:All_]) {
                self.typeLabel.hidden=NO;
                [self.typeButton setTitle:@"" forState:UIControlStateNormal];
                
                
            }else {
                self.typeLabel.hidden=YES;
                [self.typeButton   setTitle:@"煤种" forState:UIControlStateNormal];
            }

        
        }
         if (chooseView.type==kChFACTORY) {
            self.factoryLabel.text =currentSelectValue;
             if (![ self.factoryLabel.text isEqualToString:All_]) {
                  self.factoryLabel.hidden=NO;
                 [ self.factoryButton setTitle:@"" forState:UIControlStateNormal];
             }
             else {
                 self.factoryLabel.hidden=YES;
                 [ self.factoryButton setTitle:@"流向电厂" forState:UIControlStateNormal];
             }

             
         }
    
        
    }
    
 
}



@end



