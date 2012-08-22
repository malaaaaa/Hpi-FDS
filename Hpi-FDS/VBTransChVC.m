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
@synthesize popover,chooseView,parentVC,xmlParser,month,monthCV;
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
    //初始化  xmlparser
    self.xmlParser=[[[XMLParser   alloc] init] autorelease];
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
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
        
        [xmlParser setISoapNum:1];
        [xmlParser getVbTransplan];
        //同步煤种
        [xmlParser getTfCoalType];
        
        [self runActivity];
    }
	
}

- (IBAction)queryAction:(id)sender {
    
    
    NSLog(@"comLabel=[%@]",comLabel.text);
    NSLog(@"shipLabel=[%@]",shipLabel.text);
    NSLog(@"portLabel=[%@]",portLabel.text);
    NSLog(@"typeLabel=[%@]",typeLabel.text);
    NSLog(@"factoryLabel=[%@]",factoryLabel.text);
  

    
    
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
      NSAutoreleasePool *loopPool = [[[NSAutoreleasePool alloc]init] autorelease];
    
      DataQueryVC *dataQueryVC=self.parentVC;
    dataQueryVC.dataArray=[VbTransplanDao getVbTransplan:comLabel.text :shipLabel.text :portLabel.text :typeLabel.text :factoryLabel.text :monthLabel.text:codeTextField.text];
    
    
    
    [dataQueryVC loadViewData_tb];
    [loopPool drain];

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
    if ([xmlParser iSoapNum]==0) {
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
