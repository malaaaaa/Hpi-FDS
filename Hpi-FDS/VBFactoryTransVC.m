//
//  VBFactoryTransVC.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-3.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VBFactoryTransVC.h"
#import "PubInfo.h"
#import "QueryViewController.h"
#import "DataQueryVC.h"

#import "TbFactoryStateDao.h"

@interface VBFactoryTransVC ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation VBFactoryTransVC

@synthesize activity;
@synthesize reloadButton;
@synthesize factoryButton;
@synthesize factoryLabel;
@synthesize comButton;
@synthesize comLabel;
@synthesize shipButton;
@synthesize shipLabel;
@synthesize typeButton;
@synthesize typeLabel;
@synthesize keyValueButton;
@synthesize keyValueLabel;
@synthesize tradeButton;
@synthesize tradeLabel;
@synthesize statButton;
@synthesize statLabel;
@synthesize supButton;
@synthesize supLabel;
//@synthesize dateButton;
@synthesize dateLabel;
@synthesize queryButton;
@synthesize resetButton;
@synthesize popover,chooseView,multipleSelectView,parentVC;
@synthesize listTableview;
@synthesize labelView;
@synthesize detailArray;
@synthesize listArray;
@synthesize factorytransDeitail;
@synthesize listView;
@synthesize startDateCV;

@synthesize startDay;

@synthesize tbxmlParser;
@synthesize buttonView;

static DataGridComponentDataSource *dataSource;
static BOOL FactoryPop=NO;
static BOOL ShipCompanyPop=NO;
static BOOL ShipPop=NO;
static BOOL SupplierPop=NO;
static BOOL CoalTypePop=NO;
static BOOL ShipStagePop=NO;

static  NSMutableArray *FactoryArray;
static  NSMutableArray *ShipCompanyArray;
static  NSMutableArray *ShipArray;
static  NSMutableArray *SupplierArray;
static  NSMutableArray *CoalTypeArray;
static  NSMutableArray *ShipStageArray;



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
    self.factoryLabel.text=All_;
    self.shipLabel.text =All_;
    self.comLabel.text=All_;
    self.typeLabel.text=All_;
    self.keyValueLabel.text=All_;
    self.tradeLabel.text=All_;
    self.statLabel.text=All_;
    self.supLabel.text=All_;
    //只查当天数据..
    
    self.startDay = [NSDate date];//[[NSDate alloc] initWithTimeInterval:-5*24*60*60 sinceDate:[NSDate date]];
//    self.startDay = [[NSDate alloc] initWithTimeInterval:-1*24*60*60 sinceDate:[NSDate date]];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       [dateFormatter setDateFormat:@"yyyy-MM-dd"];
       self.dateLabel.text=[dateFormatter stringFromDate:    self.startDay];
       [dateFormatter release];
    
    
    
      //测试 日期
    
    
    
    
    self.factoryLabel.hidden=YES;
    self.shipLabel.hidden=YES;
    self.comLabel.hidden=YES;
    self.keyValueLabel.hidden=YES;
    self.tradeLabel.hidden=YES;
    self.statLabel.hidden=YES;
    self.supLabel.hidden=YES;
    self.typeLabel.hidden=YES;
    [activity removeFromSuperview];
    
    self.tbxmlParser =[[TBXMLParser alloc] init];
    

    
    //factoryArray= [[NSMutableArray alloc] init];
    
//    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
//    animation.duration = 0.5f;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.fillMode = kCAFillModeForwa rds;
//    animation.endProgress = 1;
//    animation.removedOnCompletion = NO;
//    animation.type = @"cube";
//    [self.view.layer addAnimation:animation forKey:@"animation"];
    // [self.chooseView bringSubviewToFront:vbFactoryTransVC.view];
    
    float columnOffset = 0.0;
    
    
    dataSource = [[DataGridComponentDataSource alloc] init];
    //(20.20.985.42)
    dataSource.columnWidth = [NSArray arrayWithObjects:@"100",@"100",@"100",@"50",@"50",@"70",@"100",@"100",@"295",@"50",@"2",nil];
    dataSource.titles = [NSArray arrayWithObjects:@"厂名",@"机组容量",@"日耗",@"库存",@"较前日",@"可用天数",@"当月调进量",@"年调进量",@"备注",@"船舶",@"factorycode",nil];
    
//    animation.type = @"oglFlip";
//    [self.labelView.layer addAnimation:animation forKey:@"animation"];
    //  [labelView removeFromSuperview];
    //填冲标题数据
    for(int column = 0;column < [dataSource.titles count];column++){
        float columnWidth = [[dataSource.columnWidth objectAtIndex:column] floatValue];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth-1, 40+2 )];
        l.font = [UIFont systemFontOfSize:16.0f];
        l.text = [dataSource.titles objectAtIndex:column];
        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
        l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(0, -0.5);
        l.textAlignment = UITextAlignmentCenter;
        [self.labelView addSubview:l];
        [l release];
        columnOffset += columnWidth;
    }
    dataSource.data=[[[NSMutableArray alloc]init] autorelease];
    
    listView.layer.masksToBounds=YES;
    listView.layer.cornerRadius=2.0;
    listView.layer.borderWidth=2.0;
    listView.layer.borderColor=[[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]CGColor];
    listView.backgroundColor=[UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
    
//    listView.center=CGPointMake(512,442);
    
    
    [listTableview setSeparatorColor:[UIColor clearColor]];
    listTableview.backgroundColor = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    
    buttonView.layer.masksToBounds=YES;
    buttonView.layer.cornerRadius=2.0;
    buttonView.layer.borderWidth=2.0;
    buttonView.layer.borderColor=[UIColor blackColor].CGColor;
    buttonView.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];
    
    // [self.view addSubview:labelView];
    
  
   // NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   // [dateFormatter setDateFormat:@"yyyy-MM-dd"];
   // [dateButton setTitle:[dateFormatter stringFromDate:startDay] forState:UIControlStateNormal];
  //  [dateFormatter release];
    
    
}

- (IBAction)touchDownAction:(id)sender
{
    [self.view addSubview:activity];
    [activity startAnimating];
}
- (void)viewDidUnload
{
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setFactoryButton:nil];
    [self setFactoryLabel:nil];
    [self setComButton:nil];
    [self setComLabel:nil];
    [self setShipButton:nil];
    [self setShipLabel:nil];
    [self setTypeButton:nil];
    [self setTypeLabel:nil];
    [self setKeyValueButton:nil];
    [self setKeyValueLabel:nil];
    [self setTradeButton:nil];
    [self setTradeLabel:nil];
    [self setStatButton:nil];
    [self setStatLabel:nil];
    [self setSupButton:nil];
    [self setSupLabel:nil];
   // [self setDateButton:nil];
    [self setDateLabel:nil];
    [self setQueryButton:nil];
    [self setResetButton:nil];
    [self setReloadButton:nil];
    [self setActivity:nil];
    [dataSource release];
    self.tbxmlParser=nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void)dealloc {
    [factoryButton release];
    [factoryLabel release];
    [comButton release];
    [comLabel release];
    [shipButton release];
    [shipLabel release];
    [typeButton release];
    [typeLabel release];
    [keyValueButton release];
    [keyValueLabel release];
    [tradeButton release];
    [tradeLabel release];
    [statButton release];
    [statLabel release];
    [supButton release];
    [supLabel release];
  // [dateButton release];
    [dateLabel release];
    [queryButton release];
    [resetButton release];
    [popover release];
    [reloadButton release];
    [activity release];
    [dataSource release];

    //[factoryArray release];
    if (FactoryPop==YES) {
        [FactoryArray release];
    }
    if (ShipCompanyPop==YES) {
        [ShipCompanyArray release];
    }
    if (SupplierPop==YES) {
        [SupplierArray release];
    }
    if (CoalTypePop==YES) {
        [CoalTypeArray release];
    }
    if (ShipStagePop==YES) {
        [ShipStageArray release];
    }
    self.tbxmlParser=nil;
    [super dealloc];
}



/*
-(IBAction)startDate:(id)sender
{
    NSLog(@"startDate");
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    if(!startDateCV)//初始化待显示控制器
        startDateCV=[[DateViewController alloc]init];
    //设置待显示控制器的范围
    [startDateCV.view setFrame:CGRectMake(0,0, 270, 216)];

    //设置待显示控制器视图的尺寸
    startDateCV.contentSizeForViewInPopover = CGSizeMake(270, 216);

    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:startDateCV];
    startDateCV.popover = pop;
    startDateCV.selectedDate=self.startDay;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(270, 216);

    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(730, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [pop release];
}*/
- (IBAction)factoryAction:(id)sender {
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化多选控制器
    multipleSelectView=[[MultipleSelectView alloc]init];
    //设置待显示控制器的范围
    [multipleSelectView.view setFrame:CGRectMake(0,0, 125, 400)];
    //设置待显示控制器视图的尺寸
    multipleSelectView.contentSizeForViewInPopover = CGSizeMake(125, 400);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:multipleSelectView];
    multipleSelectView.popover = pop;
    
    
    if ( FactoryPop==NO) {
        FactoryArray=[[NSMutableArray alloc]init];
        TgFactory *allFactory =  [[TgFactory alloc] init];
        allFactory.factoryCode = All_;
        allFactory.factoryName =All_;
        [FactoryArray addObject:allFactory];
        [allFactory release];
        NSMutableArray *array=[TgFactoryDao getTgFactory];
        for(int i=0;i<[array count];i++){
            TgFactory *tgFactory=[array objectAtIndex:i];
            [FactoryArray addObject:tgFactory];
            
        }
        FactoryPop=YES;
        
    }
    multipleSelectView.iDArray=FactoryArray;
    
    multipleSelectView.parentMapView=self;
    multipleSelectView.type=kChFACTORY;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(150, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [multipleSelectView.tableView reloadData];
    [multipleSelectView release];
    [pop release];
    
}
- (IBAction)shipCompanyAction:(id)sender {
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化多选控制器
    multipleSelectView=[[MultipleSelectView alloc]init];
    //设置待显示控制器的范围
    [multipleSelectView.view setFrame:CGRectMake(0,0, 125, 400)];
    //设置待显示控制器视图的尺寸
    multipleSelectView.contentSizeForViewInPopover = CGSizeMake(125, 400);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:multipleSelectView];
    multipleSelectView.popover = pop;
    
    
    if ( ShipCompanyPop==NO) {
        ShipCompanyArray=[[NSMutableArray alloc]init];
        TfShipCompany *allShipCompany =  [[ TfShipCompany alloc] init];
        allShipCompany.comid=0;
        allShipCompany.company=All_;
        [ShipCompanyArray addObject:allShipCompany];
        [allShipCompany release];
        NSMutableArray *array=[TfShipCompanyDao getTfShipCompany];
        for(int i=0;i<[array count];i++){
            TfShipCompany *tfShipCompany=[array objectAtIndex:i];
            [ShipCompanyArray addObject:tfShipCompany];
            
        }
        ShipCompanyPop=YES;
        
    }
    multipleSelectView.iDArray=ShipCompanyArray;
    
    multipleSelectView.parentMapView=self;
    multipleSelectView.type=kSHIPCOMPANY;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(300, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [multipleSelectView.tableView reloadData];
    [multipleSelectView release];
    [pop release];
    
}
- (IBAction)shipAction:(id)sender {
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化多选控制器
    multipleSelectView=[[MultipleSelectView alloc]init];
    //设置待显示控制器的范围
    [multipleSelectView.view setFrame:CGRectMake(0,0, 125, 400)];
    //设置待显示控制器视图的尺寸
    multipleSelectView.contentSizeForViewInPopover = CGSizeMake(125, 400);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:multipleSelectView];
    multipleSelectView.popover = pop;
    
    
    if ( ShipPop==NO) {
        ShipArray=[[NSMutableArray alloc]init];
        TgShip *allShip =  [[ TgShip alloc] init];
        allShip.shipID=0;
        allShip.shipName=All_;
        [ShipArray addObject:allShip];
        [allShip release];
        NSMutableArray *array=[TgShipDao getTgShip];
        for(int i=0;i<[array count];i++){
            TgShip *tgShip=[array objectAtIndex:i];
            [ShipArray addObject:tgShip];
            
        }
        ShipPop=YES;
        
    }
    multipleSelectView.iDArray=ShipArray;
    
    multipleSelectView.parentMapView=self;
    multipleSelectView.type=kSHIP;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 800);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(550, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [multipleSelectView.tableView reloadData];
    [multipleSelectView release];
    [pop release];
    
}
//供货方
- (IBAction)supplierAction:(id)sender {
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化多选控制器
    multipleSelectView=[[MultipleSelectView alloc]init];
    //设置待显示控制器的范围
    [multipleSelectView.view setFrame:CGRectMake(0,0, 200, 400)];
    //设置待显示控制器视图的尺寸
    multipleSelectView.contentSizeForViewInPopover = CGSizeMake(200, 400);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:multipleSelectView];
    multipleSelectView.popover = pop;
    
    
    if ( SupplierPop==NO) {
        SupplierArray=[[NSMutableArray alloc]init];
        TfSupplier *allSupplier =  [[ TfSupplier alloc] init];
        allSupplier.SUPID=0;
        allSupplier.SUPPLIER=All_;
        [SupplierArray addObject:allSupplier];
        [allSupplier release];
        NSMutableArray *array=[TfSupplierDao getTfSupplier];
        for(int i=0;i<[array count];i++){
            TfSupplier *tfSupplier=[array objectAtIndex:i];
            [SupplierArray addObject:tfSupplier];
            
        }
        SupplierPop=YES;
    }
    multipleSelectView.iDArray=SupplierArray;
    
    multipleSelectView.parentMapView=self;
    multipleSelectView.type=kSUPPLIER;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(200, 800);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(750, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [multipleSelectView.tableView reloadData];
    [multipleSelectView release];
    [pop release];
    
}
//煤种
- (IBAction)coalTypeAction:(id)sender {
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化多选控制器
    multipleSelectView=[[MultipleSelectView alloc]init];
    //设置待显示控制器的范围
    [multipleSelectView.view setFrame:CGRectMake(0,0, 125, 400)];
    //设置待显示控制器视图的尺寸
    multipleSelectView.contentSizeForViewInPopover = CGSizeMake(125, 400);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:multipleSelectView];
    multipleSelectView.popover = pop;
    
    
    if ( CoalTypePop==NO) {
        CoalTypeArray=[[NSMutableArray alloc]init];
        TfCoalType *allCoalType =  [[ TfCoalType alloc] init];
        allCoalType.TYPEID=0;
        allCoalType.COALTYPE=All_;
        [CoalTypeArray addObject:allCoalType];
        [allCoalType release];
        NSMutableArray *array=[TfCoalTypeDao getTfCoalType];
        for(int i=0;i<[array count];i++){
            TfCoalType *tfCoalType=[array objectAtIndex:i];
            [CoalTypeArray addObject:tfCoalType];
            
        }
        CoalTypePop=YES;
    }
    multipleSelectView.iDArray=CoalTypeArray;
    
    multipleSelectView.parentMapView=self;
    multipleSelectView.type=kCOALTYPE;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 800);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(950, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [multipleSelectView.tableView reloadData];
    [multipleSelectView release];
    [pop release];
    
}
//性质
- (IBAction)keyValueAction:(id)sender {
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
    chooseView.iDArray=[NSArray arrayWithObjects:All_,@"重点",@"非重点",nil];
    chooseView.parentMapView=self;
    chooseView.type=kKEYVALUE;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 150);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(110, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
}
//贸易性质
- (IBAction)tradeAction:(id)sender {
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
    chooseView.iDArray=[NSArray arrayWithObjects:All_,@"内贸",@"进口",nil];
    chooseView.parentMapView=self;
    chooseView.type=kTRADE;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 150);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(320, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
}

//状态
- (IBAction)shipStageAction:(id)sender {
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化多选控制器
    multipleSelectView=[[MultipleSelectView alloc]init];
    //设置待显示控制器的范围
    [multipleSelectView.view setFrame:CGRectMake(0,0, 125, 300)];
    //设置待显示控制器视图的尺寸
    multipleSelectView.contentSizeForViewInPopover = CGSizeMake(125, 300);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:multipleSelectView];
    multipleSelectView.popover = pop;
    
    
    if ( ShipStagePop==NO) {
        ShipStageArray=[[NSMutableArray alloc]init];
        TsShipStage *allShipStage =  [[ TsShipStage alloc] init];
        allShipStage.STAGE=All_;
        allShipStage.STAGENAME=All_;
        [ShipStageArray addObject:allShipStage];
        [allShipStage release];
        NSMutableArray *array=[TsShipStageDao getTsShipStage];
        for(int i=0;i<[array count];i++){
            TsShipStage *tsShipStage=[array objectAtIndex:i];
            [ShipStageArray addObject:tsShipStage];
            
        }
        ShipStagePop=YES;
    }
    multipleSelectView.iDArray=ShipStageArray;
    
    multipleSelectView.parentMapView=self;
    multipleSelectView.type=kSHIPSTAGE;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 300);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(550, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [multipleSelectView.tableView reloadData];
    [multipleSelectView release];
    [pop release];
    
}

- (IBAction)reloadAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步",nil];
	[alert show];
    [alert  release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.view addSubview:activity];
        [reloadButton setTitle:@"同步中..." forState:UIControlStateNormal];
        [activity startAnimating];
        [tbxmlParser setISoapNum:3];
        
   [tbxmlParser requestSOAP:@"FactoryState"];
     [tbxmlParser requestSOAP:@"FactoryTrans"];
       [tbxmlParser requestSOAP:@"ThShipTranS"];
//       [tbxmlParser test];
        
        
        [self runActivity];
    }
	
}

- (IBAction)queryAction:(id)sender {
    
   // NSLog(@"%@",self.startDay);
    
    
    
    [dataSource.data removeAllObjects];
    listArray=[VbFactoryTransDao getVbFactoryTransState:FactoryArray
                                                       :self.startDay
                                                       :ShipCompanyArray
                                                       :ShipArray
                                                       :SupplierArray
                                                       :CoalTypeArray
                                                       :keyValueLabel.text
                                                       :tradeLabel.text
                                                       :ShipStageArray];
    
    for (int i=0;i<[listArray count];i++) {
        VbFactoryTrans *vbFactoryTrans = [listArray objectAtIndex:i];
        [dataSource.data addObject:[NSArray arrayWithObjects:
                                    kBLACK,
                                    vbFactoryTrans.FACTORYNAME,
                                   [NSString stringWithFormat:@"%@",vbFactoryTrans.CAPACITYSUM]   ,
                                    [NSString stringWithFormat:@"%.2f",vbFactoryTrans.CONSUM/10000.0],
                                    [NSString stringWithFormat:@"%.2f",vbFactoryTrans.STORAGE/10000.0],
                                    
                                    /*
                                    (vbFactoryTrans.COMPARE>0) ? [NSString stringWithFormat:@"+%.2f",vbFactoryTrans.COMPARE/10000.0]: (vbFactoryTrans.COMPARE<0 ? [NSString stringWithFormat:@"%.2f",vbFactoryTrans.COMPARE/10000.0]:@"0.0"),*/
                                   [[NSString stringWithFormat:@"%.2f",vbFactoryTrans.COMPARE/10000.0]isEqualToString:@"0.00" ]?@"-":[NSString stringWithFormat:@"%.2f",vbFactoryTrans.COMPARE/10000.0]  ,//直接得出  较前日
                                    
                                    
                                    [NSString stringWithFormat:@"%d",vbFactoryTrans.AVALIABLE],
                                    
                                    
                                    /* float monthP=[TbFactoryStateDao GetMonthPort:date :vbFactoryTrans.FACTORYNAME ];
                                     float yeasP=[TbFactoryStateDao GetYearPort:date :vbFactoryTrans.FACTORYNAME ];
                                     
                                     NSLog(@"monthP=======%f",monthP);
                                     NSLog(@"yeasP=====%f",yeasP);*/
                                    
                                    // //月调尽量  年调进量  数据矫正 
                                    [NSString stringWithFormat:@"%.2f",[TbFactoryStateDao GetMonthPort:self.startDay :vbFactoryTrans.FACTORYNAME ]/10000.0],
                                    [NSString stringWithFormat:@"%.2f",[TbFactoryStateDao GetYearPort:self.startDay :vbFactoryTrans.FACTORYNAME ]/10000.0],
                                    
                                    
                                    
                                    
                                    
                                    vbFactoryTrans.DESCRIPTION,
                                    [NSString stringWithFormat:@"%d",vbFactoryTrans.SHIPNUM],
                                    vbFactoryTrans.FACTORYCODE,
                                    nil]];
        
    }
    [listTableview reloadData];
    [activity stopAnimating];
    [activity removeFromSuperview];
    
}

- (IBAction)resetAction:(id)sender {
    
//    self.factoryLabel.text=All_;
//    self.shipLabel.text =All_;
//    self.comLabel.text=All_;
//    self.typeLabel.text=All_;
//    self.statLabel.text=All_;
//    self.supLabel.text=All_;
    
    self.keyValueLabel.text=All_;
    self.tradeLabel.text=All_;

    self.factoryLabel.hidden=YES;
    self.shipLabel.hidden=YES;
    self.comLabel.hidden=YES;
    self.keyValueLabel.hidden=YES;
    self.tradeLabel.hidden=YES;
    self.statLabel.hidden=YES;
    self.supLabel.hidden=YES;
    self.typeLabel.hidden=YES;
    
    [self resetArray];
    
    self.startDay = [NSDate date];
   // NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   // [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  //  [dateButton setTitle:[dateFormatter stringFromDate:startDay] forState:UIControlStateNormal];
    //[dateFormatter release];
    
    [factoryButton setTitle:@"电厂" forState:UIControlStateNormal];
    [comButton setTitle:@"航运公司" forState:UIControlStateNormal];
    [shipButton setTitle:@"船名" forState:UIControlStateNormal];
    [statButton setTitle:@"状态" forState:UIControlStateNormal];
    [typeButton setTitle:@"煤种" forState:UIControlStateNormal];
    [keyValueButton setTitle:@"性质" forState:UIControlStateNormal];
    [tradeButton setTitle:@"贸易性质" forState:UIControlStateNormal];
    [supButton setTitle:@"供货商" forState:UIControlStateNormal];
}
- (void)resetArray
{

    for (int i=0; i<[FactoryArray count]; i++) {
        TgFactory *factory = [FactoryArray objectAtIndex:i];
        factory.didSelected=NO;
    }
    for (int i=0; i<[ShipCompanyArray count]; i++) {
        TfShipCompany *shipcompany = [ShipCompanyArray objectAtIndex:i];
        shipcompany.didSelected=NO;
    }
    for (int i=0; i<[ShipArray count]; i++) {
        TgShip *ship = [ShipArray objectAtIndex:i];
        ship.didSelected=NO;
    }
    for (int i=0; i<[SupplierArray count]; i++) {
        TfSupplier *supplier= [SupplierArray objectAtIndex:i];
        supplier.didSelected=NO;
    }
    for (int i=0; i<[CoalTypeArray count]; i++) {
         TfCoalType *coalType= [CoalTypeArray objectAtIndex:i];
        coalType.didSelected=NO;
    }
    for (int i=0; i<[ShipStageArray count]; i++) {
        TsShipStage *shipStage= [ShipStageArray objectAtIndex:i];
        shipStage.didSelected=NO;
    }
}
#pragma mark - popoverController
/*

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"popoverControllerShouldDismissPopover");
    if (startDateCV){
        self.startDay=startDateCV.selectedDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSLog(@"startDay=%@",[dateFormatter stringFromDate:self.startDay]);
        [dateFormatter release];
    }
    return  YES;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateButton setTitle:[dateFormatter stringFromDate:startDay] forState:UIControlStateNormal];
    [dateFormatter release];
    NSLog(@"popoverControllerDidDismissPopover");
}
*/
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];


}


#pragma mark activity
-(void)runActivity
{
    if ([tbxmlParser iSoapNum]==0) {
        NSLog(@"_tbxmlParser iSoapNum===============%d=",tbxmlParser. iSoapNum);

        
        [activity stopAnimating];
        [activity removeFromSuperview];
        [reloadButton setTitle:@"网络同步" forState:UIControlStateNormal];
        return;
    }
 
    else if (tbxmlParser.iSoapDone==3)
    {
        NSLog(@"_tbxmlParser.iSoapDone============%d====",tbxmlParser.iSoapDone);
        
        if (activity) {
            [activity stopAnimating];
            [activity removeFromSuperview];
            [reloadButton setTitle:@"网络同步" forState:UIControlStateNormal];
        }
       
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"服务器连接失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];

        [alert  release];
        return;
 
    }
    else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runActivity) userInfo:NULL repeats:NO];
    }
}

#pragma mark -
#pragma mark tableview
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataSource.data count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger shipNum = [[[dataSource.data objectAtIndex:[indexPath row]] objectAtIndex:10] integerValue];
    //有船舶动态才进入下一层
    if (shipNum>0) {
        detailArray = [[NSMutableArray alloc] init];
        NSString *factoryCode = [[dataSource.data objectAtIndex:[indexPath row]] objectAtIndex:11];
        detailArray= [TH_SHIPTRANS_ORIDAO   getVbFactoryTransDetail:factoryCode
                                                                 :ShipCompanyArray
                                                                 :ShipArray
                                                                 :SupplierArray
                                                                 :CoalTypeArray
                                                                 :keyValueLabel.text
                                                                 :tradeLabel.text
                                                                 :ShipStageArray
                                                                 :self.startDay];
        
        factorytransDeitail = [[VBFactoryTransDetailVC alloc]init];
        factorytransDeitail.iDArray=detailArray;
        
        [factorytransDeitail.view setFrame:CGRectMake(0,0, 125, 650)];
        factorytransDeitail.contentSizeForViewInPopover = CGSizeMake(125, 650);

        factorytransDeitail.parentView = self;
        
        //初始化弹出窗口
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:factorytransDeitail];
        
        factorytransDeitail.popover = pop;
        
        pop.popoverContentSize=CGSizeMake(650, 40+shipNum*40);
        [pop  presentPopoverFromRect:CGRectMake(500, 470, 5, 5) inView:self.view permittedArrowDirections:0 animated:YES];
        
        
        [pop release];
        [factorytransDeitail release];
        [detailArray release];
        
    }
    
    
}

- (NSString *)formatInfoDate:(NSString *)string1 :(NSString *)string2 {
    NSLog(@"string date1: %@", string1);
    NSLog(@"string date1: %@", string2);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date1 = [formatter dateFromString:string1];
    NSDate *date2 = [formatter dateFromString:string2];
    NSLog(@"date1: %@", [formatter stringFromDate:date1]);
    NSLog(@"date2: %@", [formatter stringFromDate:date2]);
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    unsigned int unitFlag = NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlag fromDate:date1 toDate:date2 options:0] ;
    int days    = [components day];
    int hours   = [components hour];
    int minutes = [components minute];
    [formatter release];
    NSString * str;
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


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *MyIdentifier = @"UITableViewCell";
    UITableViewCell *cell=(UITableViewCell*)[listTableview dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell==nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier] autorelease];
    }
    for (UIView *v in cell.subviews) {
        [v removeFromSuperview];
    }
    float columnOffset = 0.0;
    int iColorRed=0;
    //NSLog(@"rowData  count %d  at %d",[dataSource.data count],indexPath.row);
    NSArray *rowData = [dataSource.data objectAtIndex:indexPath.row];
    for(int column=0;column<[rowData count];column++){
        //第1个字段表示是否显示红色字体
        if(column==0)
        {
            if([[rowData objectAtIndex:0] intValue] == 1)
            {
                iColorRed=1;
            }
            else if([[rowData objectAtIndex:0] intValue] == 2)
            {
                iColorRed=2;
            }
            else
                iColorRed=0;
            
        }
        else
        {
            float columnWidth = [[dataSource.columnWidth objectAtIndex:column-1] floatValue];;
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth-1, 40 -1 )];
            l.font = [UIFont systemFontOfSize:14.0f];
            l.text = [rowData objectAtIndex:column];
            l.textAlignment = UITextAlignmentCenter;
            l.tag = 40 + column + 1000;
            if(indexPath.row % 2 == 0)
                l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
            else
                l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
            if (iColorRed==1)
            {
                l.textColor=[UIColor redColor];
            }
            if (iColorRed==2)
            {
                l.textColor=[UIColor colorWithRed:0.0/255 green:180.0/255 blue:90.0/255 alpha:1];
            }
            if (iColorRed==0)
            {
                l.textColor=[UIColor whiteColor];
            }
            //shipnum字段大于0，显示标示，可以进入下一层
            if (column==[rowData count]-2) {
                l.text=@"";
                if ([[rowData objectAtIndex:column] integerValue]>0) {
                    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnWidth-10, 40 -1 )];
                     imageLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"chuanxk"]];
                    [l addSubview:imageLabel];
                    [imageLabel release];

                }
            }
            
            [cell addSubview:l];
            columnOffset += columnWidth;
            [l release];
        }
        
    }
    [cell setSelectionStyle:UITableViewCellAccessoryNone];

//    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
//    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:15.0/255 green:43.0/255 blue:64.0/255 alpha:1];
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
#pragma mark SetSelectValue  Method
-(void)setLableValue:(NSString *)currentSelectValue
{
    if (chooseView) {
        if (chooseView.type==kKEYVALUE) {
            
            self.keyValueLabel.text =currentSelectValue;
            if (![self.keyValueLabel.text isEqualToString:All_]) {
                self.keyValueLabel.hidden=NO;
                [self.keyValueButton setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                self.keyValueLabel.hidden=YES;
                [self.keyValueButton setTitle:@"性质" forState:UIControlStateNormal];
            }
            
        }
        if (chooseView.type==kTRADE) {
            
            self.tradeLabel.text =currentSelectValue;
            if (![self.tradeLabel.text isEqualToString:All_]) {
                self.tradeLabel.hidden=NO;
                [self.tradeButton setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                self.tradeLabel.hidden=YES;
                [self.tradeButton setTitle:@"贸易性质" forState:UIControlStateNormal];
            }
            
        }
    }
    
}

#pragma mark multipleSelectViewdidSelectRow Delegate Method
-(void)multipleSelectViewdidSelectRow:(NSInteger)indexPathRow
{
    if (multipleSelectView) {
        
        if (multipleSelectView.type==kChFACTORY) {
            NSInteger count = 0;
            TgFactory *shipCompany = [FactoryArray objectAtIndex:indexPathRow];
            if ([shipCompany.factoryName isEqualToString:All_]) {
                if(shipCompany.didSelected==YES){
                    for (int i=0; i<[FactoryArray count]; i++) {
                        ((TgFactory *)[FactoryArray objectAtIndex:i]).didSelected=NO;
                    }
                }
                else {
                    for (int i=0; i<[FactoryArray count]; i++) {
                        ((TgFactory *)[FactoryArray objectAtIndex:i]).didSelected=YES;
                    }
                }
            }
            else{
                if(shipCompany.didSelected==YES){
                    ((TgFactory *)[FactoryArray objectAtIndex:indexPathRow]).didSelected=NO;
                    for (int i=0; i<[FactoryArray count]; i++) {
                        if(((TgFactory *)[FactoryArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    ((TgFactory *)[FactoryArray objectAtIndex:0]).didSelected=NO;
                }
                else{
                    ((TgFactory *)[FactoryArray objectAtIndex:indexPathRow]).didSelected=YES;
                    for (int i=0; i<[FactoryArray count]; i++) {
                        if(((TgFactory *)[FactoryArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    if (count>=[FactoryArray count]-1) {
                        ((TgFactory *)[FactoryArray objectAtIndex:0]).didSelected=YES;
                    }

                }
            }
          
            //只要有条件选中，附加星号标示
            if (count>0) {
                [self.factoryButton setTitle:@"电厂(*)" forState:UIControlStateNormal];
            }
            else{
                [self.factoryButton setTitle:@"电厂" forState:UIControlStateNormal];
                
            }
        }
        
        
        if (multipleSelectView.type==kSHIPCOMPANY) {
            NSInteger count = 0;
            TfShipCompany *shipCompany = [ShipCompanyArray objectAtIndex:indexPathRow];
            if ([shipCompany.company isEqualToString:All_]) {
                if(shipCompany.didSelected==YES){
                    for (int i=0; i<[ShipCompanyArray count]; i++) {
                        ((TfShipCompany *)[ShipCompanyArray objectAtIndex:i]).didSelected=NO;
                    }
                }
                else {
                    for (int i=0; i<[ShipCompanyArray count]; i++) {
                        ((TfShipCompany *)[ShipCompanyArray objectAtIndex:i]).didSelected=YES;
                    }
                }
            }
            else{
                if(shipCompany.didSelected==YES){
                    ((TfShipCompany *)[ShipCompanyArray objectAtIndex:indexPathRow]).didSelected=NO;
                    for (int i=0; i<[ShipCompanyArray count]; i++) {
                        if(((TfShipCompany *)[ShipCompanyArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    ((TfShipCompany *)[ShipCompanyArray objectAtIndex:0]).didSelected=NO;
                }
                else{
                    ((TfShipCompany *)[ShipCompanyArray objectAtIndex:indexPathRow]).didSelected=YES;
                    for (int i=0; i<[ShipCompanyArray count]; i++) {
                        if(((TfShipCompany *)[ShipCompanyArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    if (count>=[ShipCompanyArray count]-1) {
                        ((TfShipCompany *)[ShipCompanyArray objectAtIndex:0]).didSelected=YES;
                    }

                }
            }
                      //只要有条件选中，附加星号标示
            if (count>0) {
                [self.comButton setTitle:@"航运公司(*)" forState:UIControlStateNormal];
            }
            else{
                [self.comButton setTitle:@"航运公司" forState:UIControlStateNormal];
                
            }
        }
        
        if (multipleSelectView.type==kSHIP) {
            NSInteger count = 0;
            TgShip *ship = [ShipArray objectAtIndex:indexPathRow];
            if ([ship.shipName isEqualToString:All_]) {
                if(ship.didSelected==YES){
                    for (int i=0; i<[ShipArray count]; i++) {
                        ((TgShip *)[ShipArray objectAtIndex:i]).didSelected=NO;
                    }
                }
                else {
                    for (int i=0; i<[ShipArray count]; i++) {
                        ((TgShip *)[ShipArray objectAtIndex:i]).didSelected=YES;
                    }
                }
            }
            else{
                if(ship.didSelected==YES){
                    ((TgShip *)[ShipArray objectAtIndex:indexPathRow]).didSelected=NO;
                    for (int i=0; i<[ShipArray count]; i++) {
                        if(((TgShip *)[ShipArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    ((TgShip *)[ShipArray objectAtIndex:0]).didSelected=NO;

                }
                else{
                    ((TgShip *)[ShipArray objectAtIndex:indexPathRow]).didSelected=YES;
                    for (int i=0; i<[ShipArray count]; i++) {
                        if(((TgShip *)[ShipArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    if (count>=[ShipArray count]-1) {
                        ((TgShip *)[ShipArray objectAtIndex:0]).didSelected=YES;
                    }

                }
            }
   
            //只要有条件选中，附加星号标示
            if (count>0) {
                [self.shipButton setTitle:@"船名(*)" forState:UIControlStateNormal];
            }
            else{
                [self.shipButton setTitle:@"船名" forState:UIControlStateNormal];
                
            }
        }
        
        if (multipleSelectView.type==kSUPPLIER) {
            NSInteger count = 0;
            TfSupplier *supplier = [SupplierArray objectAtIndex:indexPathRow];
            if ([supplier.SUPPLIER isEqualToString:All_]) {
                if(supplier.didSelected==YES){
                    for (int i=0; i<[SupplierArray count]; i++) {
                        ((TfSupplier *)[SupplierArray objectAtIndex:i]).didSelected=NO;
                    }
                }
                else {
                    for (int i=0; i<[SupplierArray count]; i++) {
                        ((TfSupplier *)[SupplierArray objectAtIndex:i]).didSelected=YES;
                    }
                }
            }
            else{
                if(supplier.didSelected==YES){
                    ((TfSupplier *)[SupplierArray objectAtIndex:indexPathRow]).didSelected=NO;
                    for (int i=0; i<[SupplierArray count]; i++) {
                        if(((TfSupplier *)[SupplierArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    ((TfSupplier *)[SupplierArray objectAtIndex:0]).didSelected=NO;
                }
                else{
                    ((TfSupplier *)[SupplierArray objectAtIndex:indexPathRow]).didSelected=YES;
                    for (int i=0; i<[SupplierArray count]; i++) {
                        if(((TfSupplier *)[SupplierArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    if (count>=[SupplierArray count]-1) {
                        ((TfSupplier *)[SupplierArray objectAtIndex:0]).didSelected=YES;
                    }

                }
            }
           
            //只要有条件选中，附加星号标示
            if (count>0) {
                [self.supButton setTitle:@"供货商(*)" forState:UIControlStateNormal];
            }
            else{
                [self.supButton setTitle:@"供货商" forState:UIControlStateNormal];
                
            }
        }
        
        if (multipleSelectView.type==kCOALTYPE) {
            NSInteger count = 0;
            TfCoalType *coalType = [CoalTypeArray objectAtIndex:indexPathRow];
            if ([coalType.COALTYPE isEqualToString:All_]) {
                if(coalType.didSelected==YES){
                    for (int i=0; i<[CoalTypeArray count]; i++) {
                        ((TfCoalType *)[CoalTypeArray objectAtIndex:i]).didSelected=NO;
                    }
                }
                else {
                    for (int i=0; i<[CoalTypeArray count]; i++) {
                        ((TfCoalType *)[CoalTypeArray objectAtIndex:i]).didSelected=YES;
                    }
                }
            }
            else{
                if(coalType.didSelected==YES){
                    ((TfCoalType *)[CoalTypeArray objectAtIndex:indexPathRow]).didSelected=NO;
                    for (int i=0; i<[CoalTypeArray count]; i++) {
                        if(((TfCoalType *)[CoalTypeArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    ((TfCoalType *)[CoalTypeArray objectAtIndex:0]).didSelected=NO;
                }
                else{
                    ((TfCoalType *)[CoalTypeArray objectAtIndex:indexPathRow]).didSelected=YES;
                    for (int i=0; i<[CoalTypeArray count]; i++) {
                        if(((TfCoalType *)[CoalTypeArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    if (count>=[CoalTypeArray count]-1) {
                        ((TfCoalType *)[CoalTypeArray objectAtIndex:0]).didSelected=YES;
                    }

                }
            }
       
            //只要有条件选中，附加星号标示
            if (count>0) {
                [self.typeButton setTitle:@"煤种(*)" forState:UIControlStateNormal];
            }
            else{
                [self.typeButton setTitle:@"煤种" forState:UIControlStateNormal];
                
            }
        }
        
        if (multipleSelectView.type==kSHIPSTAGE) {
            NSInteger count = 0;
            TsShipStage *shipStage = [ShipStageArray objectAtIndex:indexPathRow];
            if ([shipStage.STAGENAME isEqualToString:All_]) {
                if(shipStage.didSelected==YES){
                    for (int i=0; i<[ShipStageArray count]; i++) {
                        ((TsShipStage *)[ShipStageArray objectAtIndex:i]).didSelected=NO;
                    }
                }
                else {
                    for (int i=0; i<[ShipStageArray count]; i++) {
                        ((TsShipStage *)[ShipStageArray objectAtIndex:i]).didSelected=YES;
                    }
                }
            }
            else{
                if(shipStage.didSelected==YES){
                    ((TsShipStage *)[ShipStageArray objectAtIndex:indexPathRow]).didSelected=NO;
                    for (int i=0; i<[ShipStageArray count]; i++) {
                        if(((TsShipStage *)[ShipStageArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    ((TsShipStage *)[ShipStageArray objectAtIndex:0]).didSelected=NO;
                }
                else{
                    ((TsShipStage *)[ShipStageArray objectAtIndex:indexPathRow]).didSelected=YES;
                    for (int i=0; i<[ShipStageArray count]; i++) {
                        if(((TsShipStage *)[ShipStageArray objectAtIndex:i]).didSelected==YES)
                        {
                            count++;
                        }
                        
                    }
                    if (count>=[ShipStageArray count]-1) {
                        ((TsShipStage *)[ShipStageArray objectAtIndex:0]).didSelected=YES;
                    }

                }
            }
 
            //只要有条件选中，附加星号标示
            if (count>0) {
                [self.statButton setTitle:@"状态(*)" forState:UIControlStateNormal];
            }
            else{
                [self.statButton setTitle:@"状态" forState:UIControlStateNormal];
                
            }
        }
        
        
    }
}
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
