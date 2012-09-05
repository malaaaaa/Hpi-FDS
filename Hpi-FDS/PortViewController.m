//
//  PortViewController.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "PortViewController.h"

@interface PortViewController ()

@end

@implementation PortViewController
@synthesize portLabel;
@synthesize segment,popover,endDateCV,startDateCV;
@synthesize endDay,startDay,portButton,endButton,startButton;
@synthesize reloadButton,queryButton,activity,tbxmlParser,graphView,chooseView,marketOneController;

static NSString *stringType=@"GKDJL";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"港口信息", @"4th");
        self.tabBarItem.image = [UIImage imageNamed:@"gk"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    //    [portButton setTitle:@"港  口" forState:UIControlStateNormal];
    portLabel.text=@"秦皇岛港";
    self.endDay = [[[NSDate alloc] init] autorelease];
    //self.startDay = [[NSDate alloc] init];
    self.startDay = [[[NSDate alloc] initWithTimeIntervalSinceNow: - 24*60*60*366] autorelease];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [endButton setTitle:[dateFormatter stringFromDate:endDay] forState:UIControlStateNormal];
    [startButton setTitle:[dateFormatter stringFromDate:startDay] forState:UIControlStateNormal];
    [dateFormatter release];
    
    [activity removeFromSuperview];
    self.tbxmlParser =[[TBXMLParser alloc] init];
    
    _listView.layer.masksToBounds=YES;
    _listView.layer.cornerRadius=2.0;
    _listView.layer.borderWidth=2.0;
    _listView.layer.borderColor=[[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]CGColor];
    _listView.backgroundColor=[UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
    
    _buttonView.layer.masksToBounds=YES;
    _buttonView.layer.cornerRadius=2.0;
    _buttonView.layer.borderWidth=2.0;
    _buttonView.layer.borderColor=[UIColor blackColor].CGColor;
    _buttonView.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];
}

- (void)viewDidUnload
{
    [segment release];
    segment = nil;
    [portButton release];
    portButton = nil;
    [portLabel release];
    portLabel = nil;
    [endButton release];
    endButton = nil;
    [startButton release];
    startButton = nil;
    [reloadButton release];
    reloadButton = nil;
    [queryButton release];
    queryButton = nil;
    [activity release];
    activity = nil;
    self.tbxmlParser=nil;
    
    [graphView release];
    graphView=nil;
    [self setPortLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)dealloc {
    [activity release];
    [segment release];
    [portButton release];
    [startButton release];
    [endButton release];
    [startDay release];
    [endDay release];
    [reloadButton release];
    [queryButton release];
    self.tbxmlParser=nil;
    [graphView release];
    [portLabel release];
    [marketOneController release];
    [super dealloc];
}
-(void)loadHpiGraphView{
    NSDate *maxDate=[endDay laterDate:startDay];
    NSDate *minDate=[endDay earlierDate:startDay];
    HpiGraphData *graphData=[[HpiGraphData alloc] init];
    graphData.pointArray = [[NSMutableArray alloc]init] ;
    graphData.pointArray2 = [[NSMutableArray alloc]init] ;
    graphData.pointArray3 = [[NSMutableArray alloc]init] ;
    graphData.xtitles = [[NSMutableArray alloc]init] ;
    graphData.ytitles = [[NSMutableArray alloc]init] ;
    NSDate *date=minDate;
    int minY = 0;
    int maxY = 1000;
    if([stringType isEqualToString: @"GKDJL"])
    {
        minY = 0;
        maxY = 180;
        NSLog(@"max=[%d] min=[%d]",maxY,minY);
        graphData.yNum=maxY-minY;
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
    }
    if([stringType isEqualToString: @"GKDCL"])
    {
        minY = 0;
        maxY = 180;
        NSLog(@"max=[%d] min=[%d]",maxY,minY);
        graphData.yNum=maxY-minY;
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
    }
    if([stringType isEqualToString: @"GKCML"])
    {
        minY = 0;
        maxY = 1000;
        NSLog(@"max=[%d] min=[%d]",maxY,minY);
        graphData.yNum=maxY-minY;
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
    }
    if([stringType isEqualToString: @"ZGCS"])
    {
        minY = 0;
        maxY = 500;
        NSLog(@"max=[%d] min=[%d]",maxY,minY);
        graphData.yNum=maxY-minY;
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
    }
    
    //    NSLog(@"max=[%d] min=[%d]",10000000,0);
    //    graphData.yNum=10000000-0;
    //    for(int i=0;i<6;i++)
    //    {
    //        NSLog(@"tmdefine.miniMum+(tmdefine.maxiMum-tmdefine.miniMum)*(i+1)/6) [%d]",0+(10000000-0)*i/5);
    //        if (i==0) {
    //            [graphData.ytitles addObject:[NSString stringWithFormat:@"%d",0]];
    //        }
    //        else {
    //            [graphData.ytitles addObject:[NSString stringWithFormat:@"%d",0+(10000000-0)*i/5]];
    //        }
    //    }
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease    ];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:minDate  toDate:maxDate  options:0];
    graphData.xNum = [comps day]+1;
    
    int a,b,c;
    a=graphData.xNum/9;
    b=graphData.xNum%9;
    NSLog(@"graphData.xNum/9 [%d] graphData.xNum 求余 9  [%d]",a,b);
    if (a==0) {
        c=1;
        graphData.xNum=b;
    }
    else if (a>0 && b>0){
        c=a+1;
        graphData.xNum=(a+1)*9;
    }
    else {
        c=a;
        graphData.xNum=a*9;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    for(int i=1;i<=graphData.xNum;i++)
    {
        if (i==1) {
            [graphData.xtitles addObject:[dateFormatter stringFromDate:date]];
        }
        if(i%c==0)
        {
            [graphData.xtitles addObject:[dateFormatter stringFromDate:date]];
        }
        date = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*60*60)] autorelease];
    }
    [dateFormatter release];
    
    NSMutableArray *array=[TgPortDao getTgPortByPortName:portLabel.text];
    
    NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
    if ([array count]>0) {
        
        TgPort *tgPort=(TgPort *)[array objectAtIndex:0];
        date=minDate;
        if([stringType isEqualToString: @"GKDJL"])
        {
            for ( int i = 0 ; i < graphData.xNum ; i++ ) {
                //NSLog(@"date %@",date);
                TmCoalinfo *tmCoalinfo=[TmCoalinfoDao getTmCoalinfoOne :tgPort.portCode:date];
                if(tmCoalinfo == nil){
                }
                else{
                    HpiPoint *point=[[[HpiPoint alloc]init] autorelease];
                    point.x=i;
                    point.y=tmCoalinfo.import/10000-minY;
                    [graphData.pointArray  addObject:point];
                }
                date = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*60*60)] autorelease];
            }
        }
        
        date=minDate;
        if([stringType isEqualToString: @"GKDCL"])
        {
            for ( int i = 0 ; i < graphData.xNum ; i++ ) {
                //NSLog(@"date %@",date);
                TmCoalinfo *tmCoalinfo=[TmCoalinfoDao getTmCoalinfoOne :tgPort.portCode:date];
                if(tmCoalinfo == nil){
                }
                else{
                    HpiPoint *point=[[[HpiPoint alloc]init] autorelease];
                    point.x=i;
                    point.y=tmCoalinfo.Export/10000-minY;
                    [graphData.pointArray  addObject:point];
                }
                date = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*60*60)] autorelease];
            }
        }
        
        date=minDate;
        if([stringType isEqualToString: @"GKCML"])
        {
            for ( int i = 0 ; i < graphData.xNum ; i++ ) {
                //NSLog(@"date %@",date);
                TmCoalinfo *tmCoalinfo=[TmCoalinfoDao getTmCoalinfoOne :tgPort.portCode:date];
                if(tmCoalinfo == nil){
                }
                else{
                    HpiPoint *point=[[[HpiPoint alloc]init] autorelease];
                    point.x=i;
                    point.y=tmCoalinfo.storage/10000-minY;
                    [graphData.pointArray  addObject:point];
                }
                date = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*60*60)] autorelease];
            }
        }
        
        date=minDate;
        if([stringType isEqualToString: @"ZGCS"])
        {
            for ( int i = 0 ; i < graphData.xNum ; i++ ) {
                //NSLog(@"date %@",date);
                TmShipinfo *tmShipinfo=[TmShipinfoDao getTmShipinfoOne :tgPort.portCode:date];
                if(tmShipinfo == nil){
                }
                else{
                    HpiPoint *point=[[[HpiPoint alloc]init] autorelease];
                    point.x=i;
                    point.y=tmShipinfo.waitShip-minY;
                    [graphData.pointArray  addObject:point];
                }
                date = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*60*60)] autorelease];
            }
        }
    }
    if (graphView) {
        [graphView removeFromSuperview];
        [graphView release];
        graphView =nil;
    }
    //NSLog(@"graphView $$$$$$$$ %d",[graphView retainCount]);
    self.graphView=[[[HpiGraphView alloc] initWithFrame:CGRectMake(50, 15, 924, 550) :graphData] autorelease];
    if([stringType isEqualToString:@"GKDJL"]){
        graphView.titleLabel.text=@"港口调进量(万吨)";
    }
    else if([stringType isEqualToString:@"GKDCL"]){
        graphView.titleLabel.text=@"港口调出量(万吨)";
    }
    else if([stringType isEqualToString:@"GKCML"]){
        graphView.titleLabel.text=@"港口存煤量(万吨)";
    }
    else if([stringType isEqualToString:@"ZGCS"]){
        graphView.titleLabel.text=@"在港船数";
    }
    
    //    graphView.titleLabel.text=stringType;
    graphView.marginRight=60;
    graphView.marginBottom=60;
    graphView.marginLeft=60;
    graphView.marginTop=80;
    [graphView setNeedsDisplay];
    [self.listView addSubview:graphView];
    [graphData release];
    [stringType release];
}
#pragma mark -
#pragma mark buttion action
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
    NSMutableArray *array=[TgPortDao getTgPort];
    for(int i=0;i<[array count];i++){
        TgPort *tgPort=[array objectAtIndex:i];
        [chooseView.iDArray addObject:tgPort.portName];
    }
    chooseView.parentMapView=self;
    chooseView.type=kPORTBUTTON;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(100, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
}
-(IBAction)startDate:(id)sender
{
    NSLog(@"startDate");
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    if(!startDateCV)//初始化待显示控制器
        startDateCV=[[DateViewController alloc]init];
    //设置待显示控制器的范围
    [startDateCV.view setFrame:CGRectMake(0,0, 320, 216)];
    //设置待显示控制器视图的尺寸
    startDateCV.contentSizeForViewInPopover = CGSizeMake(320, 216);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:startDateCV];
    startDateCV.popover = pop;
    startDateCV.selectedDate=self.startDay;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(320, 216);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(350, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];    [pop release];
}
-(IBAction)endDate:(id)sender
{
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化待显示控制器
    if(!endDateCV){
        endDateCV=[[DateViewController alloc]init];
    }
    else {
        endDateCV.selectedDate=self.endDay;
    }
    //设置待显示控制器的范围
    [endDateCV.view setFrame:CGRectMake(0,0, 320, 216)];
    //设置待显示控制器视图的尺寸
    endDateCV.contentSizeForViewInPopover = CGSizeMake(320, 216);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:endDateCV];
    endDateCV.popover = pop;
    endDateCV.selectedDate=self.endDay;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(320, 216);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(610, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [pop release];
}
-(IBAction)queryData:(id)sender
{
    [self loadHpiGraphView];
}

-(IBAction)dataTable:(id)sender
{
    NSMutableArray *array=[TgPortDao getTgPortByPortName:portLabel.text];
    NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
    TgPort *tgPort=(TgPort *)[array objectAtIndex:0];
    
    //初始化待显示控制器
    marketOneController=[[MarketOneController alloc]init];
    //设置待显示控制器的范围
    [marketOneController.view setFrame:CGRectMake(0,0, 600, 350)];
    //设置待显示控制器视图的尺寸
    marketOneController.contentSizeForViewInPopover = CGSizeMake(600, 350);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:marketOneController];
    marketOneController.popover = pop;
    //    NSLog(@"stringType:%@  portCode:%@",stringType,tgPort.portCode);
    [marketOneController loadViewData :stringType :startDay :endDay :tgPort.portCode];
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(600, 350);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(512, 410, 0, 0) inView:self.view permittedArrowDirections:0 animated:YES];
    [marketOneController release];
    [pop release];
    
    
}

-(IBAction)reloadData:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步",nil];
	[alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.view addSubview:activity];
        [reloadButton setTitle:@"同步中..." forState:UIControlStateNormal];
        [activity startAnimating];
        [tbxmlParser setISoapNum:2];
        
        [tbxmlParser requestSOAP:@"Coal"];
        [tbxmlParser requestSOAP:@"Ship"];
        [self runActivity];
    }
	
}

#pragma mark - popoverController
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    if (startDateCV)
        self.startDay=startDateCV.selectedDate;
    if (endDateCV)
        self.endDay=endDateCV.selectedDate;
    return  YES;
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [endButton setTitle:[dateFormatter stringFromDate:endDay] forState:UIControlStateNormal];
    [startButton setTitle:[dateFormatter stringFromDate:startDay] forState:UIControlStateNormal];
    [dateFormatter release];
}

#pragma mark - segment
//根据选择，显示不同类型的坐标点
-(void)segmentChanged:(id) sender
{
    //BSPI
    if(segment.selectedSegmentIndex==0)
    {
        NSLog(@"GKDJL");
        stringType=@"GKDJL";
    }
    else if (segment.selectedSegmentIndex==1)
    {
        NSLog(@"GKDCL");
        stringType=@"GKDCL";
    }
    else if (segment.selectedSegmentIndex==2)
    {
        NSLog(@"GKCML");
        stringType=@"GKCML";
    }
    else if (segment.selectedSegmentIndex==3)
    {
        NSLog(@"ZGCS");
        stringType=@"ZGCS";
    }
    
    [self loadHpiGraphView];
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
        if (chooseView.type==kPORTBUTTON) {
            self.portLabel.text =currentSelectValue;
            if (![self.portLabel.text isEqualToString:NULL]) {
                self.portLabel.hidden=NO;
                [self.portButton setTitle:@"" forState:UIControlStateNormal];
            }
            
        }
    }
    
}



@end
