//
//  MarketViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-7.
//  Copyright (c) 2012年 Landscape.All rights reserved.
//

#import "MarketViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HpiGraphView.h"
@interface MarketViewController ()

@end

@implementation MarketViewController
@synthesize segment,popover,endDateCV,startDateCV;
@synthesize endDay,startDay,endButton,startButton,dataButton;
@synthesize reloadButton,queryButton,activity,graphView,marketOneController;
@synthesize tbxmlParser;



static NSString *stringType=@"BSPI";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"市场信息", @"3th");
        self.tabBarItem.image = [UIImage imageNamed:@"market"];
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.endDay = [[NSDate alloc] init] ;
    //self.startDay = [[NSDate alloc] init];
    self.startDay = [[NSDate alloc] initWithTimeIntervalSinceNow: - 24*60*60*366] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [endButton setTitle:[dateFormatter stringFromDate:endDay] forState:UIControlStateNormal];
    [startButton setTitle:[dateFormatter stringFromDate:startDay] forState:UIControlStateNormal];
    [dateFormatter release];
    
    
    [activity removeFromSuperview];

    self.tbxmlParser =[[TBXMLParser alloc] init] ;
    
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
    [endButton release];
    endButton = nil;
    [startButton release];
    startButton = nil;
    [reloadButton release];
    reloadButton = nil;
    [queryButton release];
    queryButton = nil;
    [dataButton release];
    dataButton = nil;
    [activity release];
    activity = nil;
//    self.tbxmlParser=nil;
    [tbxmlParser release];
    tbxmlParser=nil;
    NSLog(@"mawp didunload");
    [graphView release];
    graphView=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
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
    [startButton release];
    [endButton release];
    [startDay release];
    [endDay release];
    [reloadButton release];
    [queryButton release];
    [dataButton release];
    self.tbxmlParser=nil;
    [graphView release];
    [marketOneController release];
    [super dealloc];
}
-(void)loadHpiGraphView{
    TmIndexdefine *tmdefine;
    NSDate *maxDate=[endDay laterDate:startDay];
    NSDate *minDate=[endDay earlierDate:startDay];
    HpiGraphData *graphData=[[HpiGraphData alloc] init];
    graphData.pointArray = [[NSMutableArray alloc] init] ;
    graphData.pointArray2 = [[NSMutableArray alloc] init] ;
    graphData.pointArray3 = [[NSMutableArray alloc] init];
    graphData.xtitles = [[NSMutableArray alloc] init];
    graphData.ytitles = [[NSMutableArray alloc] init];

//    graphData.pointArray = [[[NSMutableArray alloc]init] autorelease];
//    graphData.pointArray2 = [[[NSMutableArray alloc]init] autorelease];
//    graphData.pointArray3 = [[[NSMutableArray alloc]init] autorelease];
//    graphData.xtitles = [[[NSMutableArray alloc]init] autorelease];
//    graphData.ytitles = [[[NSMutableArray alloc]init] autorelease];
    NSDate *date=minDate;
    NSMutableArray *array=[TmIndexdefineDao getTmIndexdefineByName:stringType];
    NSLog(@"查询[%d]",[array count]);
    if ([array count]>0) {
        tmdefine=(TmIndexdefine *)[array objectAtIndex:0];
        NSLog(@"max=[%d] min=[%d]",tmdefine.maxiMum,tmdefine.miniMum);
        
        
        
        if(tmdefine.maxiMum==0)
            tmdefine.maxiMum=tmdefine.miniMum*2.5;
        
       
        
               
        
        
        
        if ([stringType isEqualToString: @"BDI"]) {
            
            tmdefine.miniMum=0;
        }
        if ([stringType isEqualToString:@"BJ_PRICE"]) {
              tmdefine.miniMum=0;
            tmdefine.maxiMum=600;
        }
        
        if ([stringType isEqualToString:@"QHD_GZ"]) {
            tmdefine.miniMum=0;
            tmdefine.maxiMum=50;

        }
        
        if ([stringType isEqualToString:@"WTI"]) {
            tmdefine.miniMum=0;
            tmdefine.maxiMum=150;
        }
        if ([stringType isEqualToString:@"HPI4500"]) {
        
        }
       
        graphData.yNum=tmdefine.maxiMum-tmdefine.miniMum;      
        
      //NSLog(@"max=[%d] min=[%d]",tmdefine.maxiMum,tmdefine.miniMum);
        
        
         
        
        
        
        for(int i=0;i<6;i++)
        {
            //NSLog(@"tmdefine.miniMum+(tmdefine.maxiMum-tmdefine.miniMum)*i/5 [%d]",tmdefine.miniMum+(tmdefine.maxiMum-tmdefine.miniMum)*i/5);
            if (i==0) {
                [graphData.ytitles addObject:[NSString stringWithFormat:@"%d",tmdefine.miniMum]];
            }
            else {
                [graphData.ytitles addObject:[NSString stringWithFormat:@"%d",tmdefine.miniMum+(tmdefine.maxiMum-tmdefine.miniMum)*i/5]];
            }
        }

        
        
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlags = NSDayCalendarUnit;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:minDate  toDate:maxDate  options:0];
        graphData.xNum = [comps day]+1;
        [gregorian release];
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
    }
    else{
        [graphData release];
        
        return;
    }
    NSLog(@"%@ 统计共%d天",stringType,graphData.xNum);
    date=minDate;
    for ( int i = 0 ; i < graphData.xNum ; i++ ) {
        //NSLog(@"date %@",date);
        TmIndexinfo *tminfo=[TmIndexinfoDao getTmIndexinfoOne:stringType:date];
        if(tminfo == nil){
        }
        else{
            HpiPoint *point=[[HpiPoint alloc]init];
            point.x=i;
            point.y=[tminfo.infoValue floatValue]-tmdefine.miniMum;
            [graphData.pointArray  addObject:point];
            [point release];
        }
        date = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*60*60)] autorelease];
    }
    date=minDate;
    if([stringType isEqualToString: @"BJ_PRICE"])
    {
        for ( int i = 0 ; i < graphData.xNum ; i++ ) {
           // NSLog(@"date %@",date);
            TmIndexinfo *tminfo=[TmIndexinfoDao getTmIndexinfoOne:@"BJ_INDEX":date];
            if(tminfo == nil){
            }
            else{
                HpiPoint *point=[[HpiPoint alloc]init];
                point.x=i;
                point.y=[tminfo.infoValue floatValue]-tmdefine.miniMum;
                [graphData.pointArray2  addObject:point];
                [point release];

            }
            date = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*60*60)] autorelease];
        }
    }
    
    
    
    
    
    date=minDate;
    if([stringType isEqualToString: @"QHD_GZ"])
    {
        for ( int i = 0 ; i < graphData.xNum ; i++ ) {
            //NSLog(@"date %@",date);
            TmIndexinfo *tminfo=[TmIndexinfoDao getTmIndexinfoOne:@"QHD_SH":date];
            if(tminfo == nil){
            }
            else{
                HpiPoint *point=[[HpiPoint alloc]init];
                point.x=i;
                point.y=[tminfo.infoValue floatValue]-tmdefine.miniMum;
                [graphData.pointArray2  addObject:point];
                [point release];

            }
            date = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*60*60)] autorelease];
        }
    }
    date=minDate;
    if([stringType isEqualToString: @"HPI4500"]){
        for ( int i = 0 ; i < graphData.xNum ; i++ ) {
            //NSLog(@"date %@",date);
            TmIndexinfo *tminfo=[TmIndexinfoDao getTmIndexinfoOne:@"HPI5000":date];
            if(tminfo == nil){
            }
            else{
                HpiPoint *point=[[HpiPoint alloc]init];
                point.x=i;
                point.y=[tminfo.infoValue floatValue]-tmdefine.miniMum;
                [graphData.pointArray2  addObject:point];
                [point release];

            }
            date = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*60*60)] autorelease];
        }
    }
    date=minDate;
    if([stringType isEqualToString: @"HPI4500"]){
        for ( int i = 0 ; i < graphData.xNum ; i++ ) {
            //NSLog(@"date %@",date);
            TmIndexinfo *tminfo=[TmIndexinfoDao getTmIndexinfoOne:@"HPI5500":date];
            if(tminfo == nil){
            }
            else{
                HpiPoint *point=[[HpiPoint alloc]init];
                point.x=i;
                point.y=[tminfo.infoValue floatValue]-tmdefine.miniMum;
                [graphData.pointArray3  addObject:point];
                [point release];

            }
            date = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*60*60)] autorelease];
        }
    }
    if (graphView) {
        [graphView removeFromSuperview];
        [graphView release];
        graphView =nil;
    }
    //NSLog(@"graphView $$$$$$$$ %d",[graphView retainCount]);
    self.graphView=[[HpiGraphView alloc] initWithFrame:CGRectMake(50, 15, 924, 550) :graphData];
    if([stringType isEqualToString:@"BSPI"]){
        graphView.titleLabel.text=@"环渤海价格指数";
    }
    else if([stringType isEqualToString:@"BDI"]){
        graphView.titleLabel.text=@"国际波罗的海综合运费指数";
    }
    else if([stringType isEqualToString:@"BJ_PRICE"]){
        graphView.titleLabel.text=@"国际煤价指数 [ 红:价格 绿:指数 ]";
    }
    else if([stringType isEqualToString:@"QHD_GZ"]){
        graphView.titleLabel.text=@"国内沿海煤炭运价指数 [ 红:秦皇岛-广州 绿:秦皇岛-上海 ]";
    }
    else if([stringType isEqualToString:@"WTI"]){
        graphView.titleLabel.text=@"原油价格指数";
    }
    else if([stringType isEqualToString:@"HPI4500"]){
        graphView.titleLabel.text=@"华能采购指导价 [ 红:4500大卡 绿:5000大卡 蓝:5500大卡 ]";
    }
    else if([stringType isEqualToString:@"NEWC"]){
        graphView.titleLabel.text=@"纽卡斯尔港煤炭指数";
    }
    else if([stringType isEqualToString:@"RB"]){
        graphView.titleLabel.text=@"南非理查德港指数";
    }
    else if([stringType isEqualToString:@"DESARA"]){
        graphView.titleLabel.text=@"欧洲ARA煤炭市场指数";
    }
    
    //    graphView.titleLabel.text=stringType;
    graphView.marginRight=60;
    graphView.marginBottom=60;
    graphView.marginLeft=60;
    graphView.marginTop=80;
    [graphView setNeedsDisplay];
    [self.listView addSubview:graphView];
    [graphData release];
}
#pragma mark -
#pragma mark buttion action
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
    [self.popover presentPopoverFromRect:CGRectMake(240, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];    [pop release];
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
    [self.popover presentPopoverFromRect:CGRectMake(560, 90, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [pop release];
}
-(IBAction)queryData:(id)sender
{
    [self loadHpiGraphView];
    [activity stopAnimating];
    [activity removeFromSuperview];
}
- (IBAction)touchDownAction:(id)sender
{
    [self.view addSubview:activity];
    [activity startAnimating];
}
-(IBAction)dataTable:(id)sender
{
    //初始化待显示控制器
    marketOneController=[[MarketOneController alloc]init];
    //设置待显示控制器的范围
    [marketOneController.view setFrame:CGRectMake(0,0, 600, 350)];
    //设置待显示控制器视图的尺寸
    marketOneController.contentSizeForViewInPopover = CGSizeMake(600, 350);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:marketOneController];
    marketOneController.popover = pop;
    
    
    [marketOneController loadViewData :stringType :startDay :endDay :NULL];
    
    
    
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
        [activity setFrame:CGRectMake(967, 45, 37, 37)];
        [self.view addSubview:activity];
        [reloadButton setTitle:@"同步中..." forState:UIControlStateNormal];
        [activity startAnimating];
        [tbxmlParser setISoapNum:3];
        
        [tbxmlParser requestSOAP:@"TmIndex"];
        
        [tbxmlParser requestSOAP:@"TmIndexDefine"];
        [tbxmlParser requestSOAP:@"TmIndexType"];
        
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
        NSLog(@"BSPI");
        stringType=@"BSPI";
    }
    else if (segment.selectedSegmentIndex==1)
    {
        NSLog(@"BDI");
        stringType=@"BDI";
    }
    else if (segment.selectedSegmentIndex==2)
    {
        NSLog(@"BJ");
        stringType=@"BJ_PRICE";
    }
    else if (segment.selectedSegmentIndex==3)
    {
        NSLog(@"CCBFI");
        stringType=@"QHD_GZ";
    }
    else if (segment.selectedSegmentIndex==4)
    {
        NSLog(@"WTI");
        stringType=@"WTI";
    }
    
    /*  去掉*/
    /*
    else if (segment.selectedSegmentIndex==5)
    {
        NSLog(@"华能指导价");
        stringType=@"HPI4500";
    }
    else if (segment.selectedSegmentIndex==6)
    {
        NSLog(@"NEWC");
        stringType=@"NEWC";
    }
    else if (segment.selectedSegmentIndex==7)
    {
        NSLog(@"RB");
        stringType=@"RB";
    }
    else if (segment.selectedSegmentIndex==8)
    {
        NSLog(@"DESARA");
        stringType=@"DESARA";
    }*/
    
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
@end
