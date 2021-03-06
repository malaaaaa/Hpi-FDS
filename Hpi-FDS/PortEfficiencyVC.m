//
//  PortEfficiencyVC.m
//  Hpi-FDS
//  卸港效率统计
//  Created by 馬文培 on 12-8-7.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "PortEfficiencyVC.h"

@interface PortEfficiencyVC ()

@end

@implementation PortEfficiencyVC

@synthesize typeButton=typeButton;
@synthesize typeLabel=typeLabel;
@synthesize scheduleButton=scheduleButton;
@synthesize scheduleLabel=scheduleLabel;
@synthesize comButton=comButton;
@synthesize comLabel=comLabel;
@synthesize parentVC=parentVC;
@synthesize chooseView=chooseView;

static BOOL ShipCompanyPop=NO;
static  NSMutableArray *ShipCompanyArray;
static WSChart *electionChart=nil;


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
    self.comLabel.text=All_;
    self.typeLabel.text=All_;
    self.scheduleLabel.text=All_;
    [self.activity removeFromSuperview];

    self.comLabel.hidden=YES;
    self.typeLabel.hidden=YES;
    self.scheduleLabel.hidden=YES;
    [self.comButton setTitle:@"航运公司" forState:UIControlStateNormal];
    [self.scheduleButton setTitle:@"班轮" forState:UIControlStateNormal];
    
    self.endDay = [[[NSDate alloc] init] autorelease];
    //本年度的第一天
    NSDateComponents *comp = [[[NSDateComponents alloc]init] autorelease];
    [comp setMonth:1];
    NSDateFormatter *yearFormatter =[[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"yyyy"];
    [comp setYear:[[yearFormatter stringFromDate:[NSDate date]] integerValue]];
    [comp setMonth:1];
    [comp setDay:1];
    NSCalendar *myCal = [[[NSCalendar alloc ]    initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    [yearFormatter release];
    self.startDay=[myCal dateFromComponents:comp] ;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [_endButton setTitle:[dateFormatter stringFromDate:_endDay] forState:UIControlStateNormal];
    [_startButton setTitle:[dateFormatter stringFromDate:_startDay] forState:UIControlStateNormal];
    [dateFormatter release];
    
    self.tbxmlParser =[[TBXMLParser alloc] init];

    
    _buttonView.layer.masksToBounds=YES;
    _buttonView.layer.cornerRadius=2.0;
    _buttonView.layer.borderWidth=2.0;
    _buttonView.layer.borderColor=[UIColor blackColor].CGColor;
    _buttonView.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];
    
    _chartView.layer.masksToBounds=YES;
    _chartView.layer.cornerRadius=2.0;
    _chartView.layer.borderWidth=2.0;
    _chartView.layer.borderColor=[[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]CGColor];
    _chartView.backgroundColor=[UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.startDay=nil;
    self.endDay=nil;
    self.startDateCV=nil;
    self.endDateCV=nil;
    self.startButton=nil;
    self.endButton=nil;
    self.reloadButton=nil;
    self.comButton=nil;
    self.comLabel=nil;
    self.scheduleButton=nil;
    self.scheduleLabel=nil;
    self.typeButton=nil;
    self.typeLabel=nil;
    self.activity=nil;
    self.tbxmlParser =nil;

    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    
    [_popover release];
    [_startButton release];
    [_endButton release];
    [_startDateCV release];
    [_endDateCV release];
    [comButton release];
    [comLabel release];
    [typeButton release];
    [typeLabel release];
    [scheduleLabel release];
    [scheduleButton release];
    
    if (ShipCompanyPop==YES) {
        [ShipCompanyArray release];
    }
    
    [_activity release];
    [_reloadButton release];
    self.tbxmlParser =nil;

    [super dealloc];
    //[factoryArray release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
-(IBAction)startDate:(id)sender
{
    NSLog(@"startDate");
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    if(!_startDateCV)//初始化待显示控制器
        _startDateCV=[[DateViewController alloc]init];
    //设置待显示控制器的范围
    [_startDateCV.view setFrame:CGRectMake(0,0, 260, 216)];
    //设置待显示控制器视图的尺寸
    _startDateCV.contentSizeForViewInPopover = CGSizeMake(260, 216);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:_startDateCV];
    _startDateCV.popover = pop;
    _startDateCV.selectedDate=self.startDay;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(260, 216);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(_startButton.frame.origin.x+85, _startButton.frame.origin.y+25, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [pop release];
}
-(IBAction)endDate:(id)sender
{
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化待显示控制器
    if(!_endDateCV){
        _endDateCV=[[DateViewController alloc]init];
    }
    else {
        _endDateCV.selectedDate=self.endDay;
    }
    //设置待显示控制器的范围
    [_endDateCV.view setFrame:CGRectMake(0,0, 260, 216)];
    //设置待显示控制器视图的尺寸
    _endDateCV.contentSizeForViewInPopover = CGSizeMake(260, 216);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:_endDateCV];
    _endDateCV.popover = pop;
    _endDateCV.selectedDate=self.endDay;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(260, 216);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(_endButton.frame.origin.x+85, _endButton.frame.origin.y+25, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [pop release];
}
- (IBAction)shipCompanyAction:(id)sender {
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化多选控制器
    _multipleSelectView=[[MultipleSelectView alloc]init];
    //设置待显示控制器的范围
    [_multipleSelectView.view setFrame:CGRectMake(0,0, 125, 400)];
    //设置待显示控制器视图的尺寸
    _multipleSelectView.contentSizeForViewInPopover = CGSizeMake(125, 400);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:_multipleSelectView];
    _multipleSelectView.popover = pop;
    
    
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
    _multipleSelectView.iDArray=ShipCompanyArray;
    
    _multipleSelectView.parentMapView=self;
    _multipleSelectView.type=kSHIPCOMPANY;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(comButton.frame.origin.x+85, comButton.frame.origin.y+25, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [_multipleSelectView.tableView reloadData];
    [_multipleSelectView release];
    [pop release];
    
}
- (IBAction)scheduleAction:(id)sender {
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
    chooseView.iDArray=[NSArray arrayWithObjects:All_,@"否",@"是",nil];
    chooseView.parentMapView=self;
    chooseView.type=kSCHEDULE;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 150);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(scheduleButton.frame.origin.x+85, scheduleButton.frame.origin.y+25, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
}
//电厂类型
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
    chooseView.iDArray=[NSArray arrayWithObjects:All_,@"直供",@"海进江",@"山东",@"海南",nil];
    chooseView.parentMapView=self;
    chooseView.type=kTYPE;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 250);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(typeButton.frame.origin.x+85, typeButton.frame.origin.y+25, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
}
#pragma mark - popoverController
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"popoverControllerShouldDismissPopover");
    if (_startDateCV){
        self.startDay=_startDateCV.selectedDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSLog(@"startDay=%@",[dateFormatter stringFromDate:self.startDay]);
        [dateFormatter release];
    }
    if (_endDateCV){
        self.endDay=_endDateCV.selectedDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSLog(@"endDay=%@",[dateFormatter stringFromDate:self.endDay]);
        [dateFormatter release];
    }
    
    return  YES;
}

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissPopoverAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"popoverControllerDidDismissPopover");
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [_startButton setTitle:[dateFormatter stringFromDate:_startDay] forState:UIControlStateNormal];
    [_endButton setTitle:[dateFormatter stringFromDate:_endDay] forState:UIControlStateNormal];
    
    NSLog(@"startdate=%@",[dateFormatter stringFromDate:_startDay]);
    [dateFormatter release];
}
-(IBAction)queryData:(id)sender
{
    [self generateGraphDate];
    //增加判断，如果Y轴数据全部为0，组件WSChart崩溃，所以不显示
    if ([PortEfficiencyDao isNoData]) {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询结果为空！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [alertView show];
        [alertView release];
        if (electionChart) {
            [electionChart removeFromSuperview];
            electionChart=nil;
        }
    }
    else{
        [self loadHpiGraphView];
    }
    [_activity stopAnimating];
    [_activity removeFromSuperview];
}

- (IBAction)touchDownAction:(id)sender
{
    [self.view addSubview:_activity];
    [_activity startAnimating];
}

- (IBAction)reloadAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步",nil];
	[alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"aaa");
    if (buttonIndex == 1) {
        NSLog(@"bbb");
        [self.view addSubview:_activity];
        [_reloadButton setTitle:@"同步中..." forState:UIControlStateNormal];
        [_activity startAnimating];
        [_tbxmlParser setISoapNum:1];
        
        [_tbxmlParser requestSOAP:@"ShipTrans"];
        [self runActivity];
    }
	
}
#pragma mark activity
-(void)runActivity
{
    if ([_tbxmlParser iSoapNum]==0) {
        [_activity stopAnimating];
        [_activity removeFromSuperview];
        [_reloadButton setTitle:@"网络同步" forState:UIControlStateNormal];
        return;
    }
    else if (_tbxmlParser.iSoapDone==3)
    {
        if (_activity) {
            [_activity stopAnimating];
            [_activity removeFromSuperview];
            [_reloadButton setTitle:@"网络同步" forState:UIControlStateNormal];
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
-(void)generateGraphDate{
    NSLog(@"_scheduleLabel=%@",scheduleLabel.text);
    NSLog(@"_typeLabel=%@",typeLabel.text);
    NSLog(@"count=%d", [ShipCompanyArray count]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"startDay=%@",[dateFormatter stringFromDate:self.startDay]);
    
    [PortEfficiencyDao InsertByCompany:ShipCompanyArray Schedule:scheduleLabel.text Category:typeLabel.text StartDate:[dateFormatter stringFromDate:self.startDay] EndDate:[dateFormatter stringFromDate:self.endDay]];
    
    [dateFormatter release];
}
-(void)loadHpiGraphView{
    
    WSData *barData = [[self getData] indexedData];
    // Create and configure a bar plot.
    electionChart = [WSChart barPlotWithFrame:[self.chartView bounds]
                                                  data:barData
                                                 style:kChartBarPlain
                                           colorScheme:kColor_FDS_Gray];
    [electionChart scaleAllAxisYD:NARangeMake(-300, 1400)];
    [electionChart scaleAllAxisXD:NARangeMake(-3, 30)];
    [electionChart setAllAxisLocationXD:-1];
    [electionChart setAllAxisLocationYD:0];
    
    
    WSPlotAxis *axis = [electionChart firstPlotAxis];
    [[axis ticksX] setTicksStyle:kTicksLabelsSlanted];
    [[axis ticksY] setTicksStyle:kTicksLabels];
    [[axis ticksY] ticksWithNumbers:[NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0],
                                     [NSNumber numberWithFloat:400],
                                     [NSNumber numberWithFloat:800],
                                     [NSNumber numberWithFloat:1200],
                                     nil]
                             labels:[NSArray arrayWithObjects:@"",
                                     @"400", @"800", @"1200", nil]];
    [electionChart setChartTitle:NSLocalizedString(@"卸港效率统计(吨小时)", @"")];
    [electionChart setChartTitleColor:[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1]];//词句无效，不知为何
    
    electionChart.autoresizingMask = 63;
    [self.chartView addSubview:electionChart];
}

- (WSData *)getData {
    
    NSMutableArray *array = [PortEfficiencyDao getPortEfficiency];
    NSMutableArray *arrayX = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *arrayY = [[[NSMutableArray alloc] init] autorelease];
    
    for (int i=0; i<[array count]; i++) {
        PortEfficiency *portEfficiency= [array objectAtIndex:i];
        //        NSLog(@"factory=%@",portEfficiency.factory);
        [arrayX addObject:portEfficiency.factory];
        [arrayY addObject:[NSNumber numberWithInteger:portEfficiency.efficiency]];
    }
    NSLog(@"arrayYcount=%d",[arrayY count]);
    return [WSData dataWithValues:arrayY
                      annotations:arrayX];
}
#pragma mark SetSelectValue  Method
-(void)setLableValue:(NSString *)currentSelectValue
{
    if (chooseView) {
        if (chooseView.type==kSCHEDULE) {
            
            self.scheduleLabel.text =currentSelectValue;
            if (![self.scheduleLabel.text isEqualToString:All_]) {
                self.scheduleLabel.hidden=NO;
                [self.scheduleButton setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                self.scheduleLabel.hidden=YES;
                [self.scheduleButton setTitle:@"班轮" forState:UIControlStateNormal];
            }
        }
        if (chooseView.type==kTYPE) {
            
            self.typeLabel.text =currentSelectValue;
            self.typeLabel.textAlignment=NSTextAlignmentCenter;
            if (![self.typeLabel.text isEqualToString:All_]) {
                self.typeLabel.hidden=NO;
                [self.typeButton setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                self.typeLabel.hidden=YES;
                [self.typeButton setTitle:@"    电厂类别" forState:UIControlStateNormal];
            }
        }
        
    }
}

#pragma mark multipleSelectViewdidSelectRow Delegate Method
-(void)multipleSelectViewdidSelectRow:(NSInteger)indexPathRow
{
    if (_multipleSelectView) {
        if (_multipleSelectView.type==kSHIPCOMPANY) {
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
    }
}
@end
