//
//  ShipCompanyTransShareVC.m
//  Hpi-FDS
//  船运公司份额统计
//  Created by 马 文培 on 12-7-20.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "ShipCompanyTransShareVC.h"

@interface ShipCompanyTransShareVC ()

@end

@implementation ShipCompanyTransShareVC
@synthesize popover=_popover;
@synthesize startDateCV=_startDateCV;
@synthesize endDateCV=_endDateCV;
@synthesize startDay=_startDay;
@synthesize endDay=_endDay;
@synthesize portButton=_portButton;
@synthesize portLabel=_portLabel;
@synthesize queryButton=_queryButton;
@synthesize startButton=_startButton;
@synthesize endButton=_endButton;
@synthesize reloadButton=_reloadButton;
@synthesize legendButton=_legendButton;
@synthesize activity=_activity;
@synthesize xmlParser=_xmlParser;
@synthesize graphView=_graphView;
@synthesize multipleSelectView=_multipleSelectView;
@synthesize parentVC;
@synthesize legendView=_legendView;

static BOOL PortPop=NO;
static  NSMutableArray *PortArray;
static  NSMutableArray *LegendArray;


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
    
    self.portLabel.hidden=NO;
    [_activity removeFromSuperview];
    self.xmlParser=[[XMLParser alloc]init];
    
    [self.portButton setTitle:@"港口" forState:UIControlStateNormal];

    
    self.endDay = [[NSDate alloc] init];
    self.startDay = [[NSDate alloc] initWithTimeIntervalSinceNow: - 24*60*60*366];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    [_endButton setTitle:[dateFormatter stringFromDate:_endDay] forState:UIControlStateNormal];
    [_startButton setTitle:[dateFormatter stringFromDate:_startDay] forState:UIControlStateNormal];
    [dateFormatter release];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setActivity:nil];
    self.startDay=nil;
    self.endDay=nil;
    self.startDateCV=nil;
    self.endDateCV=nil;
    self.startButton=nil;
    self.endButton=nil;
    self.portButton=nil;
    self.reloadButton=nil;
    self.xmlParser=nil;
    self.legendButton=nil;
    //    _xmlParser=nil;
    //    [_xmlParser release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    
    [_popover release];
    [_reloadButton release];
    [_activity release];
    [_xmlParser release];
    [super dealloc];
    //[factoryArray release];
    if (PortPop==YES) {
        [PortArray release];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
#pragma mark -
#pragma mark buttion action
- (IBAction)portAction:(id)sender {
    
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
    
    
    if ( PortPop==NO) { 
        PortArray=[[NSMutableArray alloc]init];
        TgPort *allPort =  [[TgPort alloc] init];
        allPort.portCode=All_;
        allPort.portName=All_;
        
        [PortArray addObject:allPort];
        [allPort release];
        NSMutableArray *array=[TgPortDao getTgPort];
        for(int i=0;i<[array count];i++){
            TgPort *tgPort=[array objectAtIndex:i];
            [PortArray addObject:tgPort];
            
        }
        PortPop=YES;
        
    }
    _multipleSelectView.iDArray=PortArray;
    
    _multipleSelectView.parentMapView=self;
    _multipleSelectView.type=kPORT;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(150, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [_multipleSelectView.tableView reloadData];
    [_multipleSelectView release];
    [pop release];
    
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
    [_startDateCV.view setFrame:CGRectMake(0,0, 320, 216)];
    //设置待显示控制器视图的尺寸
    _startDateCV.contentSizeForViewInPopover = CGSizeMake(320, 216);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:_startDateCV];
    _startDateCV.popover = pop;
    _startDateCV.selectedDate=self.startDay;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(320, 216);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(350, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];   
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
    [_endDateCV.view setFrame:CGRectMake(0,0, 320, 216)];
    //设置待显示控制器视图的尺寸
    _endDateCV.contentSizeForViewInPopover = CGSizeMake(320, 216);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:_endDateCV];
    _endDateCV.popover = pop;
    _endDateCV.selectedDate=self.endDay;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(320, 216);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(610, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [pop release];
}
- (IBAction)legendAction:(id)sender {

    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化多选控制器
    _legendView=[[BrokenLineLegendVC alloc]init];
    //设置待显示控制器的范围
    [_legendView.view setFrame:CGRectMake(0,0, 125, 400)];
    //设置待显示控制器视图的尺寸
    _legendView.contentSizeForViewInPopover = CGSizeMake(125, 400);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:_legendView];
    _legendView.popover = pop;
    LegendArray = [NTColorConfigDao getNTColorConfigByType:@"COMID"]
    ;

    _legendView.iDArray=LegendArray;
    
    _legendView.parentMapView=self;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 120);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(850, 40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [_legendView.tableView reloadData];
    [_legendView release];
    [pop release];
}
- (IBAction)reloadAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步",nil];
	[alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.view addSubview:_activity];
        [_reloadButton setTitle:@"同步中..." forState:UIControlStateNormal];
        [_activity startAnimating];
        [_xmlParser setISoapNum:1];
        [NTShipCompanyTranShareDao deleteAll];
        [_xmlParser getNtShipCompanyTranShare];
        
        [self runActivity];
    }
	
}
#pragma mark - popoverController
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"popoverControllerShouldDismissPopover");
    if (_startDateCV){
        self.startDay=_startDateCV.selectedDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSLog(@"startDay=%@",[dateFormatter stringFromDate:self.startDay]);
        [dateFormatter release];
    }
    if (_endDateCV){
        self.endDay=_endDateCV.selectedDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
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
    [dateFormatter setDateFormat:@"yyyy-MM"];
    [_startButton setTitle:[dateFormatter stringFromDate:_startDay] forState:UIControlStateNormal];
    [_endButton setTitle:[dateFormatter stringFromDate:_endDay] forState:UIControlStateNormal];
    [dateFormatter release];
}

#pragma mark activity
-(void)runActivity
{
    if ([_xmlParser iSoapNum]==0) {
        [_activity stopAnimating];
        [_activity removeFromSuperview];
        [_reloadButton setTitle:@"网络同步" forState:UIControlStateNormal];
        return;
    }
    else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runActivity) userInfo:NULL repeats:NO];
    }
}
-(IBAction)queryData:(id)sender
{    
    [self generateGraphDate];
    [self loadHpiGraphView];
}

-(void)generateGraphDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMM"];
    [NTShipCompanyTranShareDao InsertByPortCode:PortArray :[dateFormatter stringFromDate:_startDay] :[dateFormatter stringFromDate:_endDay]];
    [dateFormatter release];  
}
-(void)loadHpiGraphView{
    NSDate *maxDate=_endDay;
    NSDate *minDate=_startDay;
    BrokenLineGraphData *graphData=[[BrokenLineGraphData alloc] init];
    graphData.pointArray = [[NSMutableArray alloc]init];
    graphData.xtitles = [[NSMutableArray alloc]init];
    graphData.ytitles = [[NSMutableArray alloc]init];
    int minY = 0;
    int maxY = 100;
    
    graphData.yNum=(maxY-minY)*10;
    for(int i=0;i<6;i++)
    {
        NSLog(@"minY+(maxY-minY)*(i+1)/6) [%d]",minY+(maxY-minY)*i/5);
        if (i==0) {
            [graphData.ytitles addObject:[NSString stringWithFormat:@"%d",minY]];
        }
        else {
            [graphData.ytitles addObject:[NSString stringWithFormat:@"%d",minY+(maxY-minY)*i/5]];
        }
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:minDate  toDate:maxDate  options:0];
    graphData.xNum = [comps month]+1;
    NSLog(@"xnum=%d",graphData.xNum);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *nextMonth=_startDay;
    for(int i=1;i<=graphData.xNum;i++){
        [dateFormatter setDateFormat:@"yyyy/MM"];   
        [graphData.xtitles addObject:[dateFormatter stringFromDate:nextMonth]];
        
        //计算下一个月
        NSDateComponents *offsetComponents= [[NSDateComponents alloc] init];
        [offsetComponents setMonth:1];
        nextMonth= [gregorian dateByAddingComponents:offsetComponents toDate:nextMonth options:0];
        [offsetComponents release];
        
    }
    
    NSMutableArray *CompanyColorArray = [NTColorConfigDao getNTColorConfigByType:@"COMID"];
    for (int i =0; i< [CompanyColorArray count]; i++) {
        NTColorConfig *colorConfig= [CompanyColorArray objectAtIndex:i];
        NSDate *nextMonth=_startDay;
        
        LineArray   *line =[[LineArray alloc]init];
        line.pointArray = [[NSMutableArray alloc] init ];
        for(int i=1;i<=graphData.xNum;i++)
        {   
            
            //计算坐标值
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *year = [dateFormatter stringFromDate:nextMonth];
            [dateFormatter setDateFormat:@"MM"];
            NSString *month = [dateFormatter stringFromDate:nextMonth];
            
            NSInteger comid= [colorConfig.ID integerValue];
//            NTShipCompanyTranShare *TransShare=[NTShipCompanyTranShareDao getTransShareByComid:comid  Year:year Month:month];
             BrokenLineGraphPoint *point=[[BrokenLineGraphPoint alloc]init] ;
                point.companyShare=[NTShipCompanyTranShareDao getTransShareByComid:comid  Year:year Month:month];
            
            if (point.companyShare==nil) {
                
            }
            else {
               
                point.x=i-1;
                NSLog(@"TransShare%@",point.companyShare.PERCENT);
                point.y=([point.companyShare.PERCENT floatValue]-minY)*10;
                NSLog(@"point.x%d",point.x);
                NSLog(@"point.y%d",point.y);
                
                [line.pointArray  addObject:point];
                
            }
            [point release];
            //计算下一个月
            NSDateComponents *offsetComponents= [[NSDateComponents alloc] init];
            [offsetComponents setMonth:1];
            nextMonth= [gregorian dateByAddingComponents:offsetComponents toDate:nextMonth options:0];
            [offsetComponents release];
            
        }
        NSLog(@"graphData.pointArray000.count=%d",[line.pointArray count]);
        
        line.red=[colorConfig.RED floatValue];
        line.green=[colorConfig.GREEN floatValue];
        line.blue=[colorConfig.BLUE floatValue];
        NSLog(@"blue%f",line.blue);
        [graphData.pointArray addObject:line];
        
        [line.pointArray release];
        [line release];
        
    }    
    
    [dateFormatter release]; 
    
    NSLog(@"graphData.pointArray111.count=%d",[graphData.pointArray count]);
    
    if (_graphView) {
        [_graphView removeFromSuperview];
        self.graphView=nil;

    }
    self.graphView=[[BrokenLineGraphView alloc] initWithFrame:CGRectMake(50, 120, 924, 550) :graphData];
    _graphView.titleLabel.text=@"航运公司份额统计";
    
    _graphView.marginRight=60;
    _graphView.marginBottom=60;
    _graphView.marginLeft=60;
    _graphView.marginTop=80;
    
    [_graphView setNeedsDisplay];
    
    [self.view addSubview:_graphView];
    
    [graphData.pointArray  release];
    [graphData.xtitles release];
    [graphData.ytitles release];
    [graphData release];  
    NSLog(@"HHHHH");
    
}

#pragma mark multipleSelectViewdidSelectRow Delegate Method
-(void)multipleSelectViewdidSelectRow:(NSInteger)indexPathRow
{
    if (_multipleSelectView) {
        
        if (_multipleSelectView.type==kPORT) {
            NSInteger count = 0;
            TgPort *tgPort = [PortArray objectAtIndex:indexPathRow];
            if ([tgPort.portName isEqualToString:All_]) {
                if(tgPort.didSelected==YES){
                    for (int i=0; i<[PortArray count]; i++) {
                        ((TgPort *)[PortArray objectAtIndex:i]).didSelected=NO;
                    }
                }
                else {
                    for (int i=0; i<[PortArray count]; i++) {
                        ((TgPort *)[PortArray objectAtIndex:i]).didSelected=YES;
                    }
                }
            }
            else{
                if(tgPort.didSelected==YES){
                    ((TgPort *)[PortArray objectAtIndex:indexPathRow]).didSelected=NO;
                }
                else{
                    ((TgPort *)[PortArray objectAtIndex:indexPathRow]).didSelected=YES;
                }
            }
            for (int i=0; i<[PortArray count]; i++) {
                if(((TgPort *)[PortArray objectAtIndex:i]).didSelected==YES)
                {
                    count++;
                }
            }
            //只要有条件选中，附加星号标示
            if (count>0) {
                [self.portButton setTitle:@"港口(*)" forState:UIControlStateNormal];
            }
            else{
                [self.portButton setTitle:@"港口" forState:UIControlStateNormal];
                
            }
        }
        
    }
}

@end
