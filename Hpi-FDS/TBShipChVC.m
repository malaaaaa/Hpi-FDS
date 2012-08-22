//
//  TBShipChVC.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TBShipChVC.h"
#import "PubInfo.h"
#import "QueryViewController.h"
@interface TBShipChVC ()

@end

@implementation TBShipChVC
@synthesize dateButton;
@synthesize dateLabel;
@synthesize activity;
@synthesize reloadButton;
@synthesize comButton;
@synthesize comLabel;
@synthesize shipButton;
@synthesize shipLabel;
@synthesize portButton;
@synthesize portLabel;
@synthesize factoryButton;
@synthesize factoryLabel;
@synthesize statButton;
@synthesize statLabel;
@synthesize queryButton;
@synthesize resetButton;
@synthesize popover,chooseView,parentVC,xmlParser;

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
    // Do any additional setup after loading the view from its nib.]
    self.shipLabel.text =All_;
    self.comLabel.text=All_;
    self.portLabel.text=All_;
    self.factoryLabel.text=All_;
    self.statLabel.text=All_;
    [activity removeFromSuperview];
    self.shipLabel.hidden=YES;
    self.comLabel.hidden=YES;
    self.portLabel.hidden=YES;
    self.factoryLabel.hidden=YES;
    self.statLabel.hidden=YES;
}

- (void)viewDidUnload
{
    [self setComButton:nil];
    [self setComLabel:nil];
    [self setShipButton:nil];
    [self setShipLabel:nil];
    [self setPortButton:nil];
    [self setPortLabel:nil];
    [self setFactoryButton:nil];
    [self setFactoryLabel:nil];
    [self setStatButton:nil];
    [self setStatLabel:nil];
    [self setQueryButton:nil];
    [self setResetButton:nil];
    [self setDateButton:nil];
    [self setDateLabel:nil];
    [self setReloadButton:nil];
    [self setActivity:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    [factoryButton release];
    [factoryLabel release];
    [statButton release];
    [statLabel release];
    [queryButton release];
    [resetButton release];
    [popover release];
    [dateButton release];
    [dateLabel release];
    [reloadButton release];
    [activity release];
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
    [self.popover presentPopoverFromRect:CGRectMake(702, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
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
- (IBAction)statAction:(id)sender {
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
    chooseView.iDArray=[NSArray arrayWithObjects:All_,@"受载",@"在港",@"满载",@"在厂",@"结束",nil];
    chooseView.parentMapView=self;
    chooseView.type=kChSTAT;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(902, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
}

- (IBAction)dateAction:(id)sender {
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
    chooseView.iDArray=[NSArray arrayWithObjects:All_,@"受载",@"在港",@"满载",@"在厂",@"结束",nil];
    chooseView.parentMapView=self;
    chooseView.type=kChSTAT;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(860, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
}

- (IBAction)reloadAction:(id)sender {
    [self.view addSubview:activity];
    self.reloadButton.titleLabel.text=@"";
    [activity startAnimating];
    self.xmlParser=[[[XMLParser alloc]init] autorelease];
    [xmlParser setISoapNum:1];
    [xmlParser getVbShiptrans];
    [self runActivity];
}
- (IBAction)queryAction:(id)sender {
    NSLog(@"shipLabel=[%@]",shipLabel.text);
    NSLog(@"comLabel=[%@]",comLabel.text);
    NSLog(@"portLabel=[%@]",portLabel.text);
    NSLog(@"factoryLabel=[%@]",factoryLabel.text);
    NSLog(@"statLabel=[%@]",statLabel.text);
    NSLog(@"dateLabel=[%@]",dateLabel.text);
    
    NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc]init];
    QueryViewController *queryViewController=self.parentVC;
    queryViewController.dataArray=[VbShiptransDao getVbShiptrans:comLabel.text :shipLabel.text :portLabel.text :factoryLabel.text :statLabel.text];
    //NSLog(@"done %@",queryViewController.dataArray);
    [queryViewController loadViewData_vb];
    [loopPool drain];
}

- (IBAction)resetAction:(id)sender {
    
    self.shipLabel.text =All_;
    self.comLabel.text=All_;
    self.portLabel.text=All_;
    self.factoryLabel.text=All_;
    self.statLabel.text=All_;
    self.shipLabel.hidden=YES;
    self.comLabel.hidden=YES;
    self.portLabel.hidden=YES;
    self.factoryLabel.hidden=YES;
    self.statLabel.hidden=YES;
    
    [comButton setTitle:@"航运公司" forState:UIControlStateNormal];
    [statButton setTitle:@"状态" forState:UIControlStateNormal];
    [shipButton setTitle:@"船名" forState:UIControlStateNormal];
    [factoryButton setTitle:@"电厂" forState:UIControlStateNormal];
    [portButton setTitle:@"装运港" forState:UIControlStateNormal];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.dateLabel.text=[dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];

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
        self.reloadButton.titleLabel.text=@"同步数据";
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
        
        if (chooseView.type==kChSTAT) {
            
            self.statLabel.text =currentSelectValue;
            if (![self.statLabel.text isEqualToString:All_]) {
                self.statLabel.hidden=NO;
                [self.statButton setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                self.statLabel.hidden=YES;
                [self.statButton setTitle:@"状态" forState:UIControlStateNormal];
            }
            
            
            
        }
        

        
        
        
        
        
        
        
        
        
    }
        
    
    
    
    
    
    
    
}







@end
