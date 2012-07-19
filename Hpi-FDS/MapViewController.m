//
//  MapViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-3-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MapViewController.h"
#import "PubInfo.h"
#import "hpiAnnotation.h"
#import "ChooseView.h"
#import "XMLParser.h"
#import "CSLabelAnnotationView.h"

@implementation MapViewController
@synthesize mapView,mapViewBig,activity,closeButton,switchMap,shipButton,factoryButton,portButton,updateButton;
@synthesize shipIDArray,portIDArray,factoryIDArray;
@synthesize shipCoordinateArray,portCoordinateArray,factoryCoordinateArray;
@synthesize infoPortVewController,popover,infoTextViewController,infoFactoryViewController,shipInfoViewController,infoShipViewController,summaryInfoViewController;
@synthesize chooseView,curID,curName,curTextViewinfo;
@synthesize xmlParser;

static int iCloseOpen=0;
static int iPopX=0,iPopy=0;
static int iDisplay=0;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"地图", @"1th");
        self.tabBarItem.image = [UIImage imageNamed:@"map"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mapView release];
    [mapViewBig release];
    [switchMap release];
    [closeButton release];
    [updateButton release];
    [shipButton release];
    [portButton release];
    [factoryButton release];
    [portCoordinateArray release];
    [portIDArray release];
    [factoryCoordinateArray release];
    [factoryIDArray release];
    [shipCoordinateArray release];
    [shipIDArray release];
    [chooseView release];
    [curName release];
    [curID release];
    [curTextViewinfo release];
    [infoFactoryViewController release];
    [infoPortVewController release];
    [infoTextViewController release];
    [shipInfoViewController release];
    [infoShipViewController release];
    [summaryInfoViewController release];
    if (activity) {
        [activity release];
    }
    if (xmlParser) {
        [xmlParser release];
    }
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([PubInfo.autoUpdate isEqualToString:kYES])
    {
        [self.view addSubview:activity];
        [updateButton setTitle:@"同步中..." forState:UIControlStateNormal];
        [activity startAnimating];
        self.xmlParser=[[XMLParser alloc]init];
        [xmlParser setISoapNum:6];
        [xmlParser getTsFileinfo];
        [xmlParser getTgPort];
        [xmlParser getTmIndexinfo];
        [xmlParser getTgShip];
        [xmlParser getVbShiptrans];
        [xmlParser getTgFactory];
        [xmlParser getTiListinfo];
        [self runActivity];
    }
    else {
        [self.view addSubview:activity];
        [activity startAnimating];
        [activity stopAnimating];
        [activity removeFromSuperview];
    }
    
    self.shipIDArray = [[NSMutableArray alloc]init];
	self.portIDArray = [[NSMutableArray alloc]init];
    self.factoryIDArray = [[NSMutableArray alloc]init];
    [shipIDArray addObject:All_SHIP];
    [portIDArray addObject:All_PORT];
    [factoryIDArray addObject:All_FCTRY];
    self.shipCoordinateArray = [[NSMutableArray alloc]init];
	self.portCoordinateArray = [[NSMutableArray alloc]init];
    self.factoryCoordinateArray = [[NSMutableArray alloc]init];
    
    
    // Do any additional setup after loading the view from its nib.
    
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude=29.6955667121; //纬度  
    theCoordinate.longitude=122.0461133192; //经度  
    MKCoordinateSpan theSpan = MKCoordinateSpanMake(17,17);//显示比例
    //定义显示范围 
    //定义一个区域（使用设置的经度纬度加上一个范围）  
    MKCoordinateRegion theRegion;  
    theRegion.center=theCoordinate;  
    theRegion.span=theSpan; 
    [mapView setRegion:theRegion];  
    [mapView setMapType:MKMapTypeHybrid];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    mapViewBig.layer.borderColor = [[UIColor colorWithRed:1 green:0.8 blue:0.02 alpha:1] CGColor];
    mapViewBig.layer.borderWidth = 1.5f;
    mapViewBig.layer.shadowRadius =0.5;
    mapViewBig.layer.shadowColor =[UIColor blackColor].CGColor;
    
    CLLocationCoordinate2D theCoordinate1;
    theCoordinate1.latitude=2.6955667122; //纬度  
    theCoordinate1.longitude=111.0461133190; //经度 
    MKCoordinateRegion theRegion1;  
    theRegion1.center=theCoordinate1;  
    MKCoordinateSpan theSpan1 = MKCoordinateSpanMake(60,60);//显示比例
    theRegion1.span=theSpan1;
    //定义显示范围
    //定义一个区域（使用设置的经度纬度加上一个范围)
    [mapViewBig setRegion:theRegion1];
    [mapViewBig setMapType:MKMapTypeSatellite];
    [mapViewBig addSubview:closeButton];
    mapViewBig.delegate = self;
    [mapView addSubview:mapViewBig];
    
    [switchMap addTarget:self action:@selector(switchPress:) forControlEvents:UIControlEventValueChanged];
    [mapView addSubview:switchMap];

    if([PubInfo.autoUpdate isEqualToString:kNO])
    {
        [self getFactoryCoordinateArray];
        [self getShipCoordinateArray];
        [self getPortCoordinateArray];
    }
    self.shipButton.titleLabel.text=All_SHIP;
    self.portButton.titleLabel.text=All_PORT;
    self.factoryButton.titleLabel.text=All_FCTRY;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}

#pragma mark -
#pragma mark Actions
- (IBAction)closeOpenMapview:(id)sender
{
    if (iCloseOpen==0) {
        [closeButton setImage:[UIImage imageNamed:@"jia.png"] forState:UIControlStateNormal];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeBackwards;
        //animation.endProgress = 0.8;
        //animation.removedOnCompletion = NO;
        animation.type = @"rippleEffect";
        [self.mapViewBig.layer addAnimation:animation forKey:@"animation"];
        
        self.mapViewBig.frame =CGRectMake(720+270,395+270,30, 30);
        self.closeButton.frame =CGRectMake(0,0,30, 30);
        iCloseOpen=1;
        
    }
    else
    {
        [closeButton setImage:[UIImage imageNamed:@"jian.png"] forState:UIControlStateNormal];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeBackwards;
        //animation.endProgress = 0.8;
        //animation.removedOnCompletion = NO;
        animation.type = @"rippleEffect";
        self.mapViewBig.frame =CGRectMake(720,395,300, 300);
        self.closeButton.frame =CGRectMake(267,3,30, 30);
        [self.mapViewBig.layer addAnimation:animation forKey:@"animation"];
        iCloseOpen=0;
    }
}
- (IBAction)choosePort:(id)sender
{
    NSLog(@"[popover retainCount] = %d",[popover retainCount]);
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
    chooseView.iDArray=portIDArray;
    chooseView.parentMapView=self;
    chooseView.type=kPORT;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(100, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];

}
- (IBAction)chooseFactory:(id)sender
{
    NSLog(@"[popover retainCount] = %d",[popover retainCount]);
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
    chooseView.iDArray=factoryIDArray;
    self.popover = pop;
    chooseView.type=kFACTORY;
    chooseView.parentMapView=self;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(300, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
}
- (IBAction)chooseShip:(id)sender
{
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
    chooseView.iDArray=shipIDArray;
    self.popover = pop;
    chooseView.type=kSHIP;
    chooseView.parentMapView=self;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(500, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];

}

- (IBAction)SummaryInfoView:(id)sender
{
    
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化待显示控制器
    summaryInfoViewController=[[SummaryInfoViewController alloc]init]; 
    //设置待显示控制器的范围
    [summaryInfoViewController.view setFrame:CGRectMake(0,0, 960, 300)];
    //设置待显示控制器视图的尺寸
    summaryInfoViewController.contentSizeForViewInPopover = CGSizeMake(960, 300);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:summaryInfoViewController];
    summaryInfoViewController.popover = pop;
    self.popover = pop;
    self.popover.delegate = self;
    [summaryInfoViewController loadViewData];
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(960, 300);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(880, 40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [summaryInfoViewController release];
    [pop release];
    
    
}

- (IBAction)listInfoView:(id)sender
{
    NSLog(@"ship %@  factory %@ port %@",shipButton.titleLabel.text,factoryButton.titleLabel.text,portButton.titleLabel.text);

    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化待显示控制器
    shipInfoViewController=[[ShipInfoViewController alloc]init]; 
    //设置待显示控制器的范围
    [shipInfoViewController.view setFrame:CGRectMake(0,0, 600, 500)];
    //设置待显示控制器视图的尺寸
    shipInfoViewController.contentSizeForViewInPopover = CGSizeMake(600, 500);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:shipInfoViewController];
    shipInfoViewController.popover = pop;
    shipInfoViewController.infoLabel.text=@"在途船舶";
    shipInfoViewController.array = [TgShipDao getTgShipZTPort:shipButton.titleLabel.text :factoryButton.titleLabel.text :portButton.titleLabel.text];
    self.popover = pop;
    self.popover.delegate = self;
    [shipInfoViewController loadViewData];
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(600, 500);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(980, 40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [shipInfoViewController release];
    [pop release];

    
}
- (IBAction)updateData:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步",nil];
	[alert show];
    
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.view addSubview:activity];
        [updateButton setTitle:@"同步中..." forState:UIControlStateNormal];
        [activity startAnimating];
        self.xmlParser=[[XMLParser alloc]init];
        [xmlParser setISoapNum:3];
        [xmlParser getTgPort];
        [xmlParser getTgShip];
        [xmlParser getTgFactory];
        [xmlParser getTiListinfo];
        [self runActivity];
    }
	
}

-(void)switchPress:(UISwitch*)inSwitch
{
	if(inSwitch.on == NO)
	{
		[mapView setMapType:MKMapTypeStandard];
        [mapViewBig setMapType:MKMapTypeStandard];
	}
	else {
        [mapView setMapType:MKMapTypeHybrid];
        [mapViewBig setMapType:MKMapTypeHybrid];
	}
}

//-(void)showInfo:(id)sender
-(void)showInfo
{
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    //初始化待显示控制器
    infoTextViewController=[[InfoTextViewController alloc]init]; 
    //设置待显示控制器的范围
    [infoTextViewController.view setFrame:CGRectMake(0,0, 150, 200)];
    //设置待显示控制器视图的尺寸
    infoTextViewController.contentSizeForViewInPopover = CGSizeMake(150, 200);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:infoTextViewController];
    infoTextViewController.popover = pop;
    infoTextViewController.textView.text=curTextViewinfo;
    infoTextViewController.infoLabel.text=curName;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(150, 200);
    //显示，其中坐标为箭头的坐标以及尺寸
    if(iPopy<=200.0){
        [self.popover presentPopoverFromRect:CGRectMake(iPopX, iPopy, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }else {
        [self.popover presentPopoverFromRect:CGRectMake(iPopX, iPopy, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    [infoTextViewController release];
    [pop release];
}
//-(void)showDetails:(id)sender
-(void)showDetails:(hpiAnnotation *)newAnnotation
{
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    if(newAnnotation.iAnnotationType==kPORT)
    {
        //初始化待显示控制器
        infoPortVewController=[[InfoPortVewController alloc]init];
        //设置待显示控制器的范围
        [infoPortVewController.view setFrame:CGRectMake(0,0, 600, 436)];
        //设置待显示控制器视图的尺寸
        infoPortVewController.contentSizeForViewInPopover = CGSizeMake(600, 436);
        //初始化弹出窗口
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:infoPortVewController];
        infoPortVewController.popover = pop;
        infoPortVewController.infoLabel.text=[NSString stringWithFormat:@"%@ 在港船舶信息",curName];
        infoPortVewController.portName=curName;
        [infoPortVewController loadViewData];
        self.popover = pop;
        self.popover.delegate = self;
        //设置弹出窗口尺寸
        self.popover.popoverContentSize = CGSizeMake(600, 436);
        //显示，其中坐标为箭头的坐标以及尺寸
        [self.popover presentPopoverFromRect:CGRectMake(512, 550, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        [infoPortVewController release];
        [pop release];
    }
    else if(newAnnotation.iAnnotationType==kFACTORY)
    {
        //初始化待显示控制器
        infoFactoryViewController=[[InfoFactoryViewController alloc]init];
        //设置待显示控制器的范围
        [infoFactoryViewController.view setFrame:CGRectMake(0,0, 600, 210)];
        //设置待显示控制器视图的尺寸
        infoFactoryViewController.contentSizeForViewInPopover = CGSizeMake(600, 210);
        //初始化弹出窗口
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:infoFactoryViewController];
        infoFactoryViewController.popover = pop;
        infoFactoryViewController.infoLabel.text=[NSString stringWithFormat:@"%@ 在厂船舶信息",curName];
        infoFactoryViewController.factoryName=curName;
        [infoFactoryViewController loadViewData];
        self.popover = pop;
        self.popover.delegate = self;
        //设置弹出窗口尺寸
        self.popover.popoverContentSize = CGSizeMake(600, 210);
        //显示，其中坐标为箭头的坐标以及尺寸
        [self.popover presentPopoverFromRect:CGRectMake(512, 450, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        [infoFactoryViewController release];
        [pop release];
    }
    else//kSHIP
    {
        NSLog(@"iAnnotationType=kSHIP");
        //初始化待显示控制器
        infoShipViewController=[[InfoShipViewController alloc]init];
        //设置待显示控制器的范围
        [infoShipViewController.view setFrame:CGRectMake(0,0, 600, 400)];
        //设置待显示控制器视图的尺寸
        infoShipViewController.contentSizeForViewInPopover = CGSizeMake(600, 400);
        //初始化弹出窗口
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:infoShipViewController];
        infoShipViewController.popover = pop;
        NSLog(@"iAnnotationType=kSHIP  %@",curName);
        infoShipViewController.infoLabel.text=[NSString stringWithFormat:@"%@ 船舶信息",curName];
        infoShipViewController.shipName=curName;
        [infoShipViewController loadViewData];
        self.popover = pop;
        self.popover.delegate = self;
        //设置弹出窗口尺寸
        self.popover.popoverContentSize = CGSizeMake(600, 400);
        //显示，其中坐标为箭头的坐标以及尺寸
        [self.popover presentPopoverFromRect:CGRectMake(512, 450, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        [infoShipViewController release];
        [pop release];
    }
}

#pragma mark -
#pragma mark 数据库取坐标 CoordinateArray
-(void)getPortCoordinateArray
{
    int i;
    NSMutableArray *array=[TgPortDao getTgPort];
    NSLog(@"港口数量 =%d",[array count]);
    [self.mapView removeAnnotations:portCoordinateArray];
    [self.mapViewBig removeAnnotations:portCoordinateArray];
    [portCoordinateArray removeAllObjects];
    [portIDArray removeAllObjects];
    [portIDArray addObject:All_PORT];
    //self.choosePort=@"全部港口";
    for(i=0;i<[array count];i++){
        TgPort *tgPort=(TgPort *)[array objectAtIndex:i];
//        NSLog(@"portCode=%@", tgPort.portCode);
//        NSLog(@"shipNum=%d", tgPort.shipNum);
//        NSLog(@"handleShip=%d", tgPort.handleShip);
//        NSLog(@"loadShip=%d", tgPort.loadShip);
//        NSLog(@"transactShip=%d", tgPort.transactShip);
//        NSLog(@"waitShip=%d", tgPort.waitShip);
//        NSLog(@"portName=%@", tgPort.portName);
//        NSLog(@"lon=%@", tgPort.lon);
//        NSLog(@"lat=%@", tgPort.lat);
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [tgPort.lat doubleValue]; //纬度  
        coordinate.longitude = [tgPort.lon doubleValue]; //经度
        hpiAnnotation *port=[[hpiAnnotation alloc]initWithCoords:coordinate];
        port.title=[tgPort.portName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        port.topImage=[UIImage imageNamed:@"gangkou1"];
        port.subtitle=[NSString stringWithFormat:@"%@",tgPort.portCode];
        port.subtitle2=[NSString stringWithFormat:@"在港数 %d\n已办手续 %d\n在装数 %d\n待靠数 %d\n待办数 %d\n",tgPort.shipNum,tgPort.handleShip,tgPort.loadShip,tgPort.transactShip,tgPort.waitShip];
        port.iAnnotationType=kPORT;
        [portCoordinateArray addObject:port];
        [portIDArray addObject:tgPort.portName];
        [port release];
    }
    //[array release];
    [self displayPort];
}

-(void)getFactoryCoordinateArray
{
    int i;
    NSMutableArray *array=[TgFactoryDao getTgFactory];
    NSLog(@"电厂数量 =%d",[array count]);
    [self.mapView removeAnnotations:factoryCoordinateArray];
    [self.mapViewBig removeAnnotations:factoryCoordinateArray];
    [factoryCoordinateArray removeAllObjects];
    [factoryIDArray removeAllObjects];
    [factoryIDArray addObject:All_FCTRY];
    //self.chooseFactory=@"全部电厂";
    for(i=0;i<[array count];i++){
        TgFactory *tgFactory=(TgFactory *)[array objectAtIndex:i];
//        NSLog(@"factoryCode=%@", tgFactory.factoryCode);
//        NSLog(@"factoryName=%@", tgFactory.factoryName);
//        NSLog(@"capacitySum=%d", tgFactory.capacitySum);
//        NSLog(@"description=%@", tgFactory.description);
//        NSLog(@"impOrt=%d", tgFactory.impOrt);
//        NSLog(@"impMonth=%d", tgFactory.impMonth);
//        NSLog(@"impYear=%d", tgFactory.impYear);
//        NSLog(@"storage=%d", tgFactory.storage);
//        NSLog(@"conSum=%d", tgFactory.conSum);
//        NSLog(@"conMonth=%d", tgFactory.conMonth);
//        NSLog(@"conYear=%d", tgFactory.conYear);
//        NSLog(@"lon=%@", tgFactory.lon);
//        NSLog(@"lat=%@", tgFactory.lat);
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [tgFactory.lat doubleValue]; //纬度  
        coordinate.longitude = [tgFactory.lon doubleValue]; //经度
        hpiAnnotation *port=[[hpiAnnotation alloc]initWithCoords:coordinate];
        port.title=[tgFactory.factoryName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        port.topImage=[UIImage imageNamed:@"dianchang1"];
        port.subtitle=[NSString stringWithFormat:@"%@",tgFactory.factoryCode];
        port.subtitle2=[NSString stringWithFormat:@"机组情况 %@\n总装机 %d\n库存 %d\n日调进 %d\n日耗煤 %d\n月调进 %d\n月耗煤 %d\n年调用 %d\n年耗媒 %d\n",tgFactory.description,tgFactory.capacitySum,tgFactory.storage,tgFactory.impOrt,tgFactory.conSum,tgFactory.impMonth,tgFactory.conMonth,tgFactory.impYear,tgFactory.conYear];
        //NSLog(@"subtitle[%@]",port.subtitle);
        //NSLog(@"subtitle2[%@]",port.subtitle2);
        port.iAnnotationType=kFACTORY;
        [factoryCoordinateArray addObject:port];
        [factoryIDArray addObject:tgFactory.factoryName];
        [port release];
    }
    //[array release];
    [self displayFactory];
}

-(void)getShipCoordinateArray
{
    int i;
    NSMutableArray *array=[TgShipDao getTgShip];
    NSLog(@"船舶数量 =%d",[array count]);
    [self.mapView removeAnnotations:shipCoordinateArray];
    [self.mapViewBig removeAnnotations:shipCoordinateArray];
    [shipCoordinateArray removeAllObjects];
    [shipIDArray removeAllObjects];
    [shipIDArray addObject:All_SHIP];
    //self.chooseShip=@"全部船舶";
    for(i=0;i<[array count];i++){
        TgShip *tgShip=[array objectAtIndex:i];
//        NSLog(@"shipID=%d", tgShip.shipID);
//        NSLog(@"shipName=%@", tgShip.shipName);
//        NSLog(@"comID=%d", tgShip.comID);
//        NSLog(@"company=%@", tgShip.company);
//        NSLog(@"portCode=%@", tgShip.portCode);
//        NSLog(@"portName=%@", tgShip.portName);
//        NSLog(@"factoryCode=%@", tgShip.factoryCode);
//        NSLog(@"factoryName=%@", tgShip.factoryName);
//        NSLog(@"tripNo=%@", tgShip.tripNo);
//        NSLog(@"supID=%d", tgShip.supID);
//        NSLog(@"supplier=%@", tgShip.supplier);
//        NSLog(@"heatValue=%d", tgShip.heatValue);
//        NSLog(@"lw=%d", tgShip.lw);
//        NSLog(@"length=%@", tgShip.length);
//        NSLog(@"width=%@", tgShip.width);
//        NSLog(@"draft=%@", tgShip.draft);
//        NSLog(@"eta=%@", tgShip.eta);
//        NSLog(@"lat=%@", tgShip.lat);
//        NSLog(@"lon=%@", tgShip.lon);
//        NSLog(@"sog=%@", tgShip.sog);
//        NSLog(@"destination=%@", tgShip.destination);
//        NSLog(@"infoTime=%@", tgShip.infoTime);
//        NSLog(@"naviStat=%@", tgShip.naviStat);
//        NSLog(@"online=%@", tgShip.online);
//        NSLog(@"stage=%@", tgShip.stage);
//        NSLog(@"stageName=%@", tgShip.stageName);
//        NSLog(@"statCode=%@", tgShip.statCode);
//        NSLog(@"statName=%@", tgShip.statName);
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [tgShip.lat doubleValue]; //纬度  
        coordinate.longitude = [tgShip.lon doubleValue]; //经度
        hpiAnnotation *port=[[hpiAnnotation alloc]initWithCoords:coordinate];
        port.title=[tgShip.shipName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //port.topTitle=port.title;
        port.shipStat=tgShip.statCode;
        port.shipStage=tgShip.stage;
        
        if ([port.shipStage isEqualToString:@"2"]) {
            port.topImage = [UIImage imageNamed:@"chuanx1.png"];
        }
        else if([port.shipStat isEqualToString:@"8"]) {
            port.topImage = [UIImage imageNamed:@"chuanx1.png"];
        }
        else
            port.topImage = [UIImage imageNamed:@"chuanxk1.png"];

        port.subtitle=[NSString stringWithFormat:@"%d",tgShip.shipID];
        port.subtitle2=[NSString stringWithFormat:@"航运公司 %@\n装运港 %@\n流向电厂 %@\n航次 %@\n供货方 %@\n热值 %d\n载煤量 %d\n船厂 %@\n船宽 %@\n吃水 %@\n预计抵港 %@\n纬度 %@\n经度 %@\n对地速度 %@\n目的地 %@\n接收时间 %@\n",tgShip.company,tgShip.portName,tgShip.factoryName,tgShip.tripNo,tgShip.supplier,tgShip.heatValue,tgShip.lw,tgShip.length,tgShip.width,tgShip.draft,tgShip.eta,tgShip.lat,tgShip.lon,tgShip.sog,tgShip.destination,tgShip.infoTime];
        port.port=tgShip.portName;
        port.factory=tgShip.factoryName;
        port.iAnnotationType=kSHIP;
        [shipCoordinateArray addObject:port];
        [shipIDArray addObject:tgShip.shipName];
        [port release];
    }
    //[array release];
    [self displayShip];
}

-(void)getShipCoordinateByChoose:(NSString *)shipName :(NSString *)portName :(NSString *)factoryName
{
    int i;
    int a=0;
    int b=0;
    int c=0;
    NSLog(@"搜索的船舶 shipName[%@]portName[%@]factoryName[%@]",shipName,portName,factoryName);
    NSLog(@"地图船舶数量 =%d",[shipCoordinateArray count]);
    
    if ([shipName isEqualToString:All_SHIP]){
        a=1;
    }
    if ([portName isEqualToString:All_PORT]){
        b=1;
    }
    if ([factoryName isEqualToString:All_FCTRY]){
        c=1;
    }
    NSLog(@"搜索船舶abc shipName[%d]portName[%d]factoryName[%d]",a,b,c);
    if(a==1 && b==1 && c==1)
    {
        [self displayShip];
    }
    else
    {
        [self.mapView removeAnnotations:shipCoordinateArray];
        [self.mapViewBig removeAnnotations:shipCoordinateArray];
        for(i=0;i<[shipCoordinateArray count];i++)
        {
            hpiAnnotation *port=[shipCoordinateArray objectAtIndex:i];
            NSLog(@"shipName[%@]",port.title);
            NSLog(@"port[%@]",port.port);
            NSLog(@"factory[%@]",port.factory);
            if(a==0)
            {
                if(![shipName isEqualToString:port.title])
                {
                    continue;
                }
            }
            if(b==0)
            {
                if(![portName isEqualToString:port.port])
                {
                    continue;
                }
            }
            if (c==0)
            {
                if(![factoryName isEqualToString:port.factory])
                {
                    continue;
                }
            }
            [mapView addAnnotation:port];
            [mapViewBig addAnnotation:port];
            if (a==0)
            {
                if([shipName isEqualToString:port.title])
                {
                    //mapview移动到以当前点作为中心点的位置
                    MKCoordinateRegion theRegion;
                    MKCoordinateSpan theSpan = MKCoordinateSpanMake(6,6);//显示比例
                    theRegion.center=port.coordinate;  
                    theRegion.span=theSpan; 
                    [self.mapView setRegion:theRegion];
                    return;
                }
            }
        }
    }
}

#pragma mark - display 坐标
- (void)chooseUpdateView
{
    [self getShipCoordinateByChoose:shipButton.titleLabel.text :portButton.titleLabel.text :factoryButton.titleLabel.text];
}
- (void)displayPort
{
    [self.mapView removeAnnotations:portCoordinateArray];
    [self.mapViewBig removeAnnotations:portCoordinateArray];
    NSLog(@"portCoordinateArray [%d]",[portCoordinateArray count]);
    [self.mapView addAnnotations:portCoordinateArray];
    [self.mapViewBig addAnnotations:portCoordinateArray];

}

- (void)displayFactory
{
    [self.mapView removeAnnotations:factoryCoordinateArray];
    [self.mapViewBig removeAnnotations:factoryCoordinateArray];
    NSLog(@"factoryCoordinateArray [%d]",[factoryCoordinateArray count]);
    [self.mapView addAnnotations:factoryCoordinateArray];
    [self.mapViewBig addAnnotations:factoryCoordinateArray];
}

- (void)displayShip
{
    [self.mapView removeAnnotations:shipCoordinateArray];
    [self.mapViewBig removeAnnotations:shipCoordinateArray];
    NSLog(@"shipCoordinateArray [%d]",[shipCoordinateArray count]);
    [self.mapViewBig addAnnotations:shipCoordinateArray];
    [self.mapView addAnnotations:shipCoordinateArray];
}
#pragma mark - MapView viewForAnnotation
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	//方法二：using the image as a PlaceMarker to display on map
    if ([annotation isKindOfClass:[MKUserLocation class]])  
        return nil;  
    // 处理我们自定义的Annotation 
    if ([annotation isKindOfClass:[hpiAnnotation class]]) {
        hpiAnnotation *myAnnototion= annotation;
        CSLabelAnnotationView *newAnnotation=[[[CSLabelAnnotationView alloc] initWithAnnotation:myAnnototion reuseIdentifier:@"CSLabelAnnotationView"] autorelease];
        
        newAnnotation.canShowCallout=YES;

        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];  
//        [rightButton addTarget:self  
//                        action:@selector(showDetails:)//点击右边的按钮之后，显示另外一个页面  
//              forControlEvents:UIControlEventTouchUpInside];
        newAnnotation.rightCalloutAccessoryView = rightButton;
        
        
        UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];  
        newAnnotation.leftCalloutAccessoryView = leftButton;         
        return newAnnotation;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    hpiAnnotation *newAnnotation = (hpiAnnotation *)view.annotation;
    //NSLog(@"button clicked on annotation title[%@] id[%@] control[%@]]", newAnnotation.title,newAnnotation.subtitle2,control);
    
    //获得当前坐地图标对应的view坐标
    CGPoint annPoint = [self.mapView convertCoordinate:newAnnotation.coordinate 
                                         toPointToView:self.mapView];
    //NSLog(@"%@ Coordinate: %f %f", newAnnotation.title, annPoint.x, annPoint.y);
    iPopX= (int) annPoint.x;
    iPopy= (int) annPoint.y;
    //NSLog(@"%@ Coordinate: %d %d", newAnnotation.title, iPopX, iPopy);
    self.curTextViewinfo=newAnnotation.subtitle2;
    self.curID=newAnnotation.subtitle;
    self.curName=newAnnotation.title;		
    
    if (control.frame.origin.x>20) {
        NSLog(@"button clicked on annotation right");
        [self showDetails:newAnnotation];
        
    }
    else
    {
       // NSLog(@"button clicked on annotation left");
        [self showInfo];
    }
//    
//    
//    //mapview移动到以当前点作为中心点的位置
//    MKCoordinateRegion theRegion=[self.mapView convertRect:self.mapView.frame toRegionFromView:self.mapView];
//    theRegion.center=newAnnotation.coordinate;  
//    theRegion.span=theRegion.span; 
//    [self.mapView setRegion:theRegion];
}

//地图自动缩放。用于在设置过MapAnnotation地标后，执行次函数，就会自动的缩放地图到合适的大小。
-(void)zoomToFitMapAnnotations:(MKMapView*)mapView1
{
    
}

- (void)mapView:(MKMapView *)mapView1 regionDidChangeAnimated:(BOOL)animated  
{
    NSLog(@"self.mapView.region.span %f + %f" ,mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
    if((mapView.region.span.longitudeDelta<10.0) && (mapView.region.span.longitudeDelta>0.3) && (iDisplay != 1))
    {
        for (hpiAnnotation *myannotation in portCoordinateArray) {
            myannotation.topImage=[UIImage imageNamed:@"gangkou"];
        }
        for (hpiAnnotation *myannotation in factoryCoordinateArray) {
            myannotation.topImage=[UIImage imageNamed:@"dianchang"];
        }
        for (hpiAnnotation *myannotation in shipCoordinateArray) {
            
            if ([myannotation.shipStage isEqualToString:@"2"]) {
                myannotation.topImage = [UIImage imageNamed:@"chuanx.png"];
            }
            else if([myannotation.shipStat isEqualToString:@"8"]) {
                myannotation.topImage = [UIImage imageNamed:@"chuanx.png"];
            }
            else
                myannotation.topImage = [UIImage imageNamed:@"chuanxk.png"];
            myannotation.topTitle=myannotation.title;
        }
        [self.mapView removeAnnotations:shipCoordinateArray];
        [self.mapView addAnnotations:shipCoordinateArray];
        [self.mapView removeAnnotations:factoryCoordinateArray];
        [self.mapView addAnnotations:factoryCoordinateArray];
        [self.mapView removeAnnotations:portCoordinateArray];
        [self.mapView addAnnotations:portCoordinateArray];
        
        iDisplay=1;
    }
    if((mapView.region.span.longitudeDelta>=10.0) && (iDisplay != 0))
    {
        for (hpiAnnotation *myannotation in portCoordinateArray) {
            myannotation.topImage=[UIImage imageNamed:@"gangkou1"];
        }
        for (hpiAnnotation *myannotation in factoryCoordinateArray) {
            myannotation.topImage=[UIImage imageNamed:@"dianchang1"];
        }
        for (hpiAnnotation *myannotation in shipCoordinateArray) {
            
            if ([myannotation.shipStage isEqualToString:@"2"]) {
                myannotation.topImage = [UIImage imageNamed:@"chuanx1.png"];
            }
            else if([myannotation.shipStat isEqualToString:@"8"]) {
                myannotation.topImage = [UIImage imageNamed:@"chuanx1.png"];
            }
            else
                myannotation.topImage = [UIImage imageNamed:@"chuanxk1.png"];
            myannotation.topTitle=@"";
        }
        [self.mapView removeAnnotations:shipCoordinateArray];
        [self.mapView addAnnotations:shipCoordinateArray];
        [self.mapView removeAnnotations:factoryCoordinateArray];
        [self.mapView addAnnotations:factoryCoordinateArray];
        [self.mapView removeAnnotations:portCoordinateArray];
        [self.mapView addAnnotations:portCoordinateArray];
        iDisplay=0;
    }
    if((mapView.region.span.longitudeDelta<=0.3) && (iDisplay != 2))
    {
        for (hpiAnnotation *myannotation in portCoordinateArray) {
            myannotation.topImage=[UIImage imageNamed:@"gangkou3"];
        }
        for (hpiAnnotation *myannotation in factoryCoordinateArray) {
            myannotation.topImage=[UIImage imageNamed:@"dianchang3"];
        }
        for (hpiAnnotation *myannotation in shipCoordinateArray) {
            
            if ([myannotation.shipStage isEqualToString:@"2"]) {
                myannotation.topImage = [UIImage imageNamed:@"chuanx3.png"];
            }
            else if([myannotation.shipStat isEqualToString:@"8"]) {
                myannotation.topImage = [UIImage imageNamed:@"chuanx3.png"];
            }
            else
                myannotation.topImage = [UIImage imageNamed:@"chuanxk3.png"];
            myannotation.topTitle=myannotation.title;
        }
        [self.mapView removeAnnotations:shipCoordinateArray];
        [self.mapView addAnnotations:shipCoordinateArray];
        [self.mapView removeAnnotations:factoryCoordinateArray];
        [self.mapView addAnnotations:factoryCoordinateArray];
        [self.mapView removeAnnotations:portCoordinateArray];
        [self.mapView addAnnotations:portCoordinateArray];
        iDisplay=2;
    }


}

#pragma mark - popoverController
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"popoverControllerShouldDismissPopover");
    return  YES;
}

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissPopoverAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"popoverControllerDidDismissPopover");
}

#pragma mark activity
-(void)runActivity
{
    if ([xmlParser iSoapNum]==0) {
        [activity stopAnimating];
        [activity removeFromSuperview];
        [updateButton setTitle:@"网络同步" forState:UIControlStateNormal];
        [self getFactoryCoordinateArray];
        [self getShipCoordinateArray];
        [self getPortCoordinateArray];
        return;
    }
    else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runActivity) userInfo:NULL repeats:NO];
    }
}

@end
