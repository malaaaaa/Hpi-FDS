//
//  DataQueryVC.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-24.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "DataQueryVC.h"
#import "VBFactoryTransVC.h"
#import "TH_ShipTrans.h"
#import "TH_ShipTransChVC.h"
#import "TH_ShipTransDao.h"
#import "TH_ShipTransDetailCV.h"

@interface DataQueryVC ()

@end

@implementation DataQueryVC
@synthesize segment,chooseView,listView,dataArray;
@synthesize tbShipChVC;
@synthesize vbShipChVC;
@synthesize vbTransChVC;
@synthesize vbFactoryTransVC;
@synthesize listTableview;
@synthesize labelView;
@synthesize popover;
@synthesize detailArray;
@synthesize thShipTransVC;




@synthesize dataSource;

//static DataGridComponentDataSource *dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"数据查询", @"5th");
        self.tabBarItem.image = [UIImage imageNamed:@"query"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.vbShipChVC =[[ VBShipChVC alloc ]initWithNibName:@"VBShipChVC" bundle:nil];
    vbShipChVC.parentVC=self;
    vbShipChVC.view.center = CGPointMake(512, 90);
    [self.chooseView addSubview:vbShipChVC.view];
    
    self.vbTransChVC =[[ VBTransChVC alloc ]initWithNibName:@"VBTransChVC" bundle:nil];
    vbTransChVC.parentVC=self;
    vbTransChVC.view.center = CGPointMake(512, 90);
    [self.chooseView addSubview:vbTransChVC.view];
    
    //    self.tbShipChVC =[[ TBShipChVC alloc ]initWithNibName:@"TBShipChVC" bundle:nil];
    //    tbShipChVC.parentVC=self;
    //    tbShipChVC.view.center = CGPointMake(512, 60);
    //    [self.chooseView addSubview:tbShipChVC.view];
    
 
    [self.chooseView bringSubviewToFront:vbShipChVC.view];
    chooseView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1];
    
    //为视图增加边框      
    listView.layer.masksToBounds=YES;      
    listView.layer.cornerRadius=10.0;      
    listView.layer.borderWidth=10.0;      
    listView.layer.borderColor=[[UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1]CGColor];
    listView.backgroundColor=[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
    
    listView.center=CGPointMake(512,462);
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    [listTableview setSeparatorColor:[UIColor clearColor]];
    listTableview.backgroundColor = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    
    self.dataArray=[VbShiptransDao getVbShiptrans:tbShipChVC.comLabel.text :tbShipChVC.shipLabel.text :tbShipChVC.portLabel.text :tbShipChVC.factoryLabel.text :tbShipChVC.statLabel.text];
    dataSource = [[DataGridComponentDataSource alloc] init];
    //(20.20.985.42)
    dataSource.columnWidth = [NSArray arrayWithObjects:@"80",@"105",@"80",@"100",@"95",@"150",@"70",@"70",@"90",@"70",@"75",nil];
    dataSource.titles = [NSArray arrayWithObjects:@"航运公司",@"船名",@"航次",@"流向",@"装港",@"供货方",@"性质",@"煤质",@"贸易性质",@"煤种",@"状态",nil];
    NSLog(@"查询 %d条记录",[dataArray count]);
    float columnOffset = 0.0;
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
        [self.labelView addSubview:l];
		[l release];
        columnOffset += columnWidth;
	}
    [self loadViewData_vb];
}

- (void)viewDidUnload
{
    [segment release];
    segment = nil;
    [chooseView release];
    chooseView = nil;
    [listView release];
    listView = nil;
    [listTableview release];
    listTableview = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [segment release];
    [chooseView release];
    [listView release];
    [listTableview release];
       
    [thShipTransVC  release];
    
    //
    [dataSource  release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-( void )viewDidAppear:( BOOL )animated
{
    
}
#pragma mark -
#pragma mark - 刷新各个查询页面
-(void)loadViewData_tb
{
    /*   使用表  VBTRANSCHVC   */
    dataSource.data=[[NSMutableArray alloc]init];
    
    NSLog(@"获得transPlan：%d",dataArray.count  );
    
    
    for (int i=0;i<[dataArray count];i++) {
        VbTransplan *transplan=[dataArray objectAtIndex:i];
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
                                    transplan.eTaf,
                                    [NSString stringWithFormat:@"%d",transplan.eLw],
                                    transplan.coalType,
                                    transplan.supplier,
                                    transplan.keyName,
                                    nil ]];
        
        
        
    }
    [listTableview reloadData];
    
}
-(void)loadViewData_vb
{
    dataSource.data=[[NSMutableArray alloc]init];
    for (int i=0;i<[dataArray count];i++) {
        VbShiptrans *vbShiptrans=[dataArray objectAtIndex:i];
        
        [dataSource.data addObject:[NSArray arrayWithObjects:
                                    ([vbShiptrans.stage isEqualToString:@"0"])?kGREEN:(([vbShiptrans.stage isEqualToString:@"2"])?kRED:kBLACK),
                                    vbShiptrans.shipCompany,
                                    ([vbShiptrans.schedule isEqualToString:@"1"])?vbShiptrans.shipName:[NSString stringWithFormat:@"*%@",vbShiptrans.shipName],
                                    vbShiptrans.tripNo,
                                    vbShiptrans.factoryName,
                                    vbShiptrans.portName,
                                    vbShiptrans.supplier,
                                    vbShiptrans.keyName,
                                    [NSString stringWithFormat:@"%d",vbShiptrans.heatValue],
                                    vbShiptrans.tradeName,
                                    vbShiptrans.coalType,
                                    vbShiptrans.stateName,
                                    nil]];
        
    }
    [listTableview reloadData];
}

#pragma mark - segment
//根据选择，显示不同类型的坐标点
-(void)segmentChanged:(id) sender
{
    if (!dataSource) {
        [dataSource release];
        dataSource=nil;
    }
    
    [dataArray removeAllObjects];
    [listTableview reloadData];
    
    if(segment.selectedSegmentIndex==0)
    {
        NSLog(@"实时船舶查询");
        [self.vbFactoryTransVC.view removeFromSuperview];
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.endProgress = 1;
        animation.removedOnCompletion = NO;
        animation.type = @"cube";
        [self.chooseView.layer addAnimation:animation forKey:@"animation"];
        [self.chooseView bringSubviewToFront:vbShipChVC.view];
        
        float columnOffset = 0.0;
        NSLog(@"查询 %d条记录",[dataArray count]);
        dataSource = [[DataGridComponentDataSource alloc] init];
        //(20.20.985.42)
        dataSource.columnWidth = [NSArray arrayWithObjects:@"80",@"105",@"80",@"100",@"95",@"150",@"70",@"70",@"90",@"70",@"75",nil];
        dataSource.titles = [NSArray arrayWithObjects:@"航运公司",@"船名",@"航次",@"流向",@"装港",@"供货方",@"性质",@"煤质",@"贸易性质",@"煤种",@"状态",nil];
        NSLog(@"查询 %d条记录",[dataArray count]);
        
        animation.type = @"oglFlip";
        [self.labelView.layer addAnimation:animation forKey:@"animation"];
        [labelView removeFromSuperview];
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
            [self.labelView addSubview:l];
            [l release];
            columnOffset += columnWidth;
        }
        [self.listView addSubview:labelView];
        
    }
    else if (segment.selectedSegmentIndex==1)
    {
        NSLog(@"船运计划");
        [self.vbFactoryTransVC.view removeFromSuperview];

        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.endProgress = 1;
        animation.removedOnCompletion = NO;
        animation.type = @"cube";
        [self.chooseView.layer addAnimation:animation forKey:@"animation"];
        
        [self.chooseView bringSubviewToFront:vbTransChVC.view];
        
        float columnOffset = 0.0;
        NSLog(@"查询 %d条记录",[dataArray count]);
        dataSource = [[DataGridComponentDataSource alloc] init];
        //(20.20.985.42)
        dataSource.columnWidth = [NSArray arrayWithObjects:@"90",@"80",@"80",@"85",@"80",@"95",@"85",@"85",@"85",@"70",@"75",@"75",nil];
        dataSource.titles = [NSArray arrayWithObjects:@"计划号",@"计划月份",@"船名",@"流向",@"航次",@"装运港",@"预抵装港",@"预抵卸港",@"预计载煤量",@"煤种",@"供货方",@"类别",nil];
        NSLog(@"查询 %d条记录",[dataArray count]);
        
        animation.type = @"oglFlip";
        [self.labelView.layer addAnimation:animation forKey:@"animation"];
        [labelView removeFromSuperview];
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
            [self.labelView addSubview:l];
            [l release];
            columnOffset += columnWidth;
        }
        [self.listView addSubview:labelView];
    }
    else if (segment.selectedSegmentIndex==2)
    {
        self.vbFactoryTransVC =[[ VBFactoryTransVC alloc ]initWithNibName:@"VBFactoryTransVC" bundle:nil];
        vbFactoryTransVC.parentVC=self;
        //vbFactoryTransVC.view.center = CGPointMake(512, 320);
        vbFactoryTransVC.view.frame=CGRectMake(0, 30, 1024, 661);
        [self.view addSubview:vbFactoryTransVC.view];
        [self.view bringSubviewToFront:vbFactoryTransVC.view];
        
               
        NSLog(@"电厂动态");

    }else if (segment.selectedSegmentIndex==3) { 
        
        //在下一个   视图显示时   移除上一个   视图
      
        [self.vbFactoryTransVC.view removeFromSuperview ];
        [self.vbShipChVC.view removeFromSuperview];
        [self.vbTransChVC.view removeFromSuperview  ];
               //新添  调度日志查询
        self.thShipTransVC=[[TH_ShipTransChVC alloc] initWithNibName:@"TH_ShipTransChVC" bundle:nil];
        thShipTransVC.parentVC=self;
        thShipTransVC.view.center=CGPointMake(512, 120);
        thShipTransVC.view.frame=CGRectMake(0, 0, 1024, 180);
        [self.chooseView addSubview:thShipTransVC.view];
        
        chooseView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1];
        
        
        
        //[self.view addSubview:thShipTransVC.view];
        //[self.view bringSubviewToFront:thShipTransVC.view];
        
        NSLog(@"调度日志.............");
        
        
    }
    

}

#pragma mark -
#pragma mark tableview
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"listTableview  row[%d]",dataSource.data .count);
    
    
	return [dataSource.data count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(segment.selectedSegmentIndex==0)
    {
        VbShiptrans *vbShiptrans=[dataArray objectAtIndex:indexPath.row];
        //初始化待显示控制器
        VBShipDetailController *vbShipDetailController=[[VBShipDetailController alloc]init];
        //设置待显示控制器的范围
        [vbShipDetailController.view setFrame:CGRectMake(0,0, 600, 280 )];
        //设置待显示控制器视图的尺寸
        vbShipDetailController.contentSizeForViewInPopover = CGSizeMake(600, 280);
        //初始化弹出窗口
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:vbShipDetailController];
        vbShipDetailController.popover = pop;
        
        vbShipDetailController.p_AnchorageTime.text = vbShiptrans.p_AnchorageTime;
        vbShipDetailController.p_Handle.text = vbShiptrans.p_Handle;
        vbShipDetailController.p_ArrivalTime.text = vbShiptrans.p_ArrivalTime;
        vbShipDetailController.lw.text =[NSString stringWithFormat:@"%d", vbShiptrans.lw];
        vbShipDetailController.p_DepartTime.text =vbShiptrans.p_DepartTime;
        vbShipDetailController.p_Note.text =[self formatInfoDate:vbShiptrans.p_AnchorageTime :vbShiptrans.p_DepartTime];
        vbShipDetailController.f_AnchorageTime.text = vbShiptrans.f_AnchorageTime;
        vbShipDetailController.f_ArrivalTime.text = vbShiptrans. f_ArrivalTime;
        vbShipDetailController.f_DepartTime.text = vbShiptrans.f_DepartTime;
        vbShipDetailController.f_Note.text =[self formatInfoDate:vbShiptrans.f_AnchorageTime :vbShiptrans.f_DepartTime];
        vbShipDetailController.lateFee.text = [NSString stringWithFormat:@"%d", vbShiptrans.lateFee];
        vbShipDetailController.offEfficiency.text = [NSString stringWithFormat:@"%d", vbShiptrans.offEfficiency];
        self.popover = pop;
        self.popover.delegate = self;
        //设置弹出窗口尺寸
        self.popover.popoverContentSize = CGSizeMake(600, 280);
        //显示，其中坐标为箭头的坐标以及尺寸 0 可去掉箭头
        [self.popover presentPopoverFromRect:CGRectMake(512, 430, 0, 0) inView:self.view permittedArrowDirections:0 animated:YES];
        [VBShipDetailController release];
        [pop release];
    }
    
    //新添   调度日志
  if (segment.selectedSegmentIndex==3){
      TH_ShipTrans *thshiptrans=[dataArray objectAtIndex:indexPath.row];
      NSLog(@"%@",thshiptrans.P_ANCHORAGETIME );
      NSLog(@"%@",thshiptrans.P_ARRIVALTIME );
      NSLog(@"%@",thshiptrans.P_HANDLE );
      NSLog(@"%@",thshiptrans.NOTE );
      
      
      TH_ShipTransDetailCV *thShipTransDetail=[[TH_ShipTransDetailCV alloc] init];
      //初始化大小
      
      [thShipTransDetail.view setFrame:CGRectMake(0, 0, 600, 280)];
      
      thShipTransDetail.contentSizeForViewInPopover=CGSizeMake(600, 280);
      
      
      UIPopoverController *pop=[[UIPopoverController  alloc] initWithContentViewController:thShipTransDetail];
      
      
      thShipTransDetail.pop=pop;//没什么用
       
    
      [thShipTransDetail setLable:thshiptrans];
      self.popover=pop;
      self.popover.delegate=self;
      self.popover.popoverContentSize=CGSizeMake(600, 280);
      
      [self.popover presentPopoverFromRect:CGRectMake(512,430 , 0.5,0.5) inView:self.view   permittedArrowDirections:0 animated:YES];
      [TH_ShipTransDetailCV release];
      [pop release];
       //不能释放  thshiptrans
      
      //[thshiptrans release];
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
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlag = NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlag fromDate:date1 toDate:date2 options:0];
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
    NSString *MyIdentifier = [NSString stringWithString:@"UITableViewCell"];
    
    
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
            
            [cell addSubview:l];
            columnOffset += columnWidth;
            [l release];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:15.0/255 green:43.0/255 blue:64.0/255 alpha:1];
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return 40;
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
@end

