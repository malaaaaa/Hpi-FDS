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


#import "TB_Latefee.h"
#import "TB_LatefeeChDial.h"
#import "TB_LatefeeDao.h"

#import "VBTransChVCDetail.h"
#import "DataGridComponent.h"



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
@synthesize shipCompanyTrnasShareVC;
@synthesize thShipTransVC;
@synthesize tblatefeeVC;
@synthesize latefeeTj;
@synthesize avgTimePort;
@synthesize avgTimeZXFactory;
@synthesize factoryFreightVolumeVC;
@synthesize portEfficiencyVC;
@synthesize dataSource;
@synthesize noteLabel;

//static DataGridComponentDataSource *dataSource;

static NSInteger menuIndex;



static NSInteger menuSection;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"查询统计", @"5th");
        self.tabBarItem.image = [UIImage imageNamed:@"query"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  // NSLog(@"实时船舶查询");
    [self removeSubView];
    //为视图增加边框
    listView.layer.masksToBounds=YES;
    listView.layer.cornerRadius=2.0;
    listView.layer.borderWidth=2.0;
    listView.layer.borderColor=[[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]CGColor];
    listView.backgroundColor=[UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
        
    listView.center=CGPointMake(512,396);//修改
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    chooseView.layer.masksToBounds=YES;
    chooseView.layer.cornerRadius=2.0;
    chooseView.layer.borderWidth=2.0;
    chooseView.layer.borderColor=[UIColor blackColor].CGColor;
    chooseView.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];

    [listTableview setSeparatorColor:[UIColor clearColor]];
    listTableview.backgroundColor = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    
    /*   初始船舶动态查询    注释掉会出现问题-----------*/   
//    self.vbShipChVC=[[VBShipChVC alloc] init]  ;//不能autorelease
//    vbShipChVC.parentVC=self;
//    vbShipChVC.view.center=CGPointMake(512, 60);//120
//    vbShipChVC.view.frame=CGRectMake(0, 0, 1024, 121);
//    
//    [self.chooseView addSubview:vbShipChVC.view];
//    self.chooseView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1];
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
    self.vbShipChVC=nil;
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
    
    
    
    //新添  子视图释放
    [ shipCompanyTrnasShareVC release];
    [vbShipChVC release];
    [tbShipChVC release];
    [vbTransChVC release];
    [tblatefeeVC release];
    [vbFactoryTransVC release];
    [latefeeTj release];
    [avgTimePort release];
    [avgTimeZXFactory release   ];
    
    
    
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
#pragma mark tableview
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@"listTableview  row[%d]",dataSource.data .count);

	return [dataSource.data count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 //    if(segment.selectedSegmentIndex==0)
    if(menuIndex==kMenuSSCBCX&&menuSection==kMenuSelect)

    {
        TH_SHIPTRANS_ORI *vbShiptrans=[dataArray objectAtIndex:indexPath.row];
        //初始化待显示控制器
        VBShipDetailController *vbShipDetailController=[[VBShipDetailController alloc]init];
        //设置待显示控制器的范围
        [vbShipDetailController.view setFrame:CGRectMake(0,0, 600, 280 )];
        //设置待显示控制器视图的尺寸
        vbShipDetailController.contentSizeForViewInPopover = CGSizeMake(600, 280);
        //初始化弹出窗口
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:vbShipDetailController];
        vbShipDetailController.popover = pop;
        
//        vbShipDetailController.p_AnchorageTime.text = vbShiptrans.P_ANCHORAGETIME;
        vbShipDetailController.p_AnchorageTime.text = ([vbShiptrans.P_ANCHORAGETIME isEqualToString:@"2000-01-01T00:00:00"])?@"未知":vbShiptrans.P_ANCHORAGETIME;
//        vbShipDetailController.p_Handle.text = vbShiptrans.P_HANDLE;
        vbShipDetailController.p_Handle.text = ([vbShiptrans.P_HANDLE isEqualToString:@"2000-01-01T00:00:00"])?@"未知":vbShiptrans.P_HANDLE;
//        vbShipDetailController.p_ArrivalTime.text = vbShiptrans.P_ARRIVALTIME;
        vbShipDetailController.p_ArrivalTime.text = ([vbShiptrans.P_ARRIVALTIME isEqualToString:@"2000-01-01T00:00:00"])?@"未知":vbShiptrans.P_ARRIVALTIME;
        vbShipDetailController.lw.text =[NSString stringWithFormat:@"%d", vbShiptrans.LW];
//        vbShipDetailController.p_DepartTime.text =vbShiptrans.P_DEPARTTIME;
        vbShipDetailController.p_DepartTime.text = ([vbShiptrans.P_DEPARTTIME isEqualToString:@"2000-01-01T00:00:00"])?@"未知":vbShiptrans.P_DEPARTTIME;
        vbShipDetailController.p_Note.text =[self formatInfoDate:vbShiptrans.P_ANCHORAGETIME :vbShiptrans.P_DEPARTTIME];
//        vbShipDetailController.f_AnchorageTime.text = vbShiptrans.F_ANCHORAGETIME;
        vbShipDetailController.f_AnchorageTime.text = ([vbShiptrans.F_ANCHORAGETIME isEqualToString:@"2000-01-01T00:00:00"])?@"未知":vbShiptrans.F_ANCHORAGETIME;
//        vbShipDetailController.f_ArrivalTime.text = vbShiptrans. F_ARRIVALTIME;
        
        vbShipDetailController.f_ArrivalTime.text = ([vbShiptrans.F_ARRIVALTIME isEqualToString:@"2000-01-01T00:00:00"])?@"未知":(([vbShiptrans.F_ARRIVALTIME isEqualToString:@"0001-01-01T00:00:00"])?@"未知":vbShiptrans.F_ARRIVALTIME);
//        vbShipDetailController.f_DepartTime.text = vbShiptrans.F_DEPARTTIME;
        vbShipDetailController.f_DepartTime.text = ([vbShiptrans.F_DEPARTTIME isEqualToString:@"2000-01-01T00:00:00"])?@"未知":vbShiptrans.F_DEPARTTIME;
        vbShipDetailController.f_Note.text =[self formatInfoDate:vbShiptrans.F_ANCHORAGETIME :vbShiptrans.F_DEPARTTIME];

//        vbShipDetailController.f_Note.text =([[self formatInfoDate:vbShiptrans.F_ANCHORAGETIME :vbShiptrans.F_DEPARTTIME] isEqualToString:@"2000-01-01T00:00:00"])?@"未知":[self formatInfoDate:vbShiptrans.F_ANCHORAGETIME :vbShiptrans.F_DEPARTTIME];
        vbShipDetailController.lateFee.text = vbShiptrans.LATEFEE;
        vbShipDetailController.offEfficiency.text = [NSString stringWithFormat:@"%d", vbShiptrans.OFFEFFICIENCY];
        self.popover = pop;
        self.popover.delegate = self;
        //设置弹出窗口尺寸
        self.popover.popoverContentSize = CGSizeMake(600, 280);
        //显示，其中坐标为箭头的坐标以及尺寸 0 可去掉箭头
        [self.popover presentPopoverFromRect:CGRectMake(512, 430, 0, 0) inView:self.view permittedArrowDirections:0 animated:YES];
        [vbShipDetailController release];
        [pop release];
    }
    
    //新添   调度日志
    /*
        if (menuIndex==kMenuDDRZCX&&menuSection==kMenuTJ ){
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
        [thShipTransDetail release];
        [pop release];
    }
    
    */
    
    
       if (menuIndex==kMenuZQFMXCX&&menuSection==kMenuLatefee) {
         double  t=0;
        //滞期费合计
        for (int i=0; i<[dataArray count]; i++) {
            t+=[[(TB_Latefee *)[dataArray  objectAtIndex:i]  LATEFEE] doubleValue];
        }
        TB_Latefee *tblatefee=[dataArray objectAtIndex:indexPath.row];
        TB_LatefeeChDial *tblatefeeDial=[[TB_LatefeeChDial alloc] init]; 
        tblatefeeDial.totalLatefee= [NSString stringWithFormat:@"%.2f",t];
        tblatefeeDial.tblatefee=tblatefee;
        [tblatefeeDial.view setFrame:CGRectMake(0,0,600,140)];
        tblatefeeDial.contentSizeForViewInPopover=CGSizeMake(600, 140);
        UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:tblatefeeDial];
        tblatefeeDial.pop=pop;
        self.popover=pop;
        self.popover.delegate=self;
        self.popover.popoverContentSize=CGSizeMake(600, 140);
        //设置箭头方向
        [self.popover presentPopoverFromRect:CGRectMake(512,430 , 0.5,0.5) inView:self.view   permittedArrowDirections:0 animated:YES];
        [tblatefeeDial release];
        [pop release];
    }
    //航运计划
      if (menuIndex==kMenuCYJH&&menuSection==kMenuSelect) {
          NSLog(@"航运计划..........详细");
          
          
          VbTransplan *vbtrans=[dataArray objectAtIndex:indexPath.row];
          
        //  NSLog(@"%@",vbtrans.eTap);
          
          VBTransChVCDetail *vbtransDetail=[[VBTransChVCDetail alloc] init];
          vbtransDetail.vbtrans=vbtrans;
          
          [vbtransDetail.view setFrame:CGRectMake(0,0,600,34)];
          vbtransDetail.contentSizeForViewInPopover=CGSizeMake(600, 34);
          UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:vbtransDetail];
          vbtransDetail.pop=pop;
          self.popover=pop;
          self.popover.delegate=self;
          self.popover.popoverContentSize=CGSizeMake(600, 34);
          //设置箭头方向
          [self.popover presentPopoverFromRect:CGRectMake(512,430 , 0.5,0.5) inView:self.view   permittedArrowDirections:0 animated:YES];
          [vbtransDetail release];
          [pop release];

          
          
      }
}
/**/
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
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:15.0/255 green:43.0/255 blue:64.0/255 alpha:0.1];

    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
#pragma mark - popoverController
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
   // NSLog(@"popoverControllerShouldDismissPopover");
    return  YES;
}

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissPopoverAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
   // NSLog(@"popoverControllerDidDismissPopover");
}

//删除segment控件，模拟segmentChanged
-(void)setSegmentIndex:(NSInteger) index:(NSInteger )section
{
    menuIndex=index;
    menuSection=section;
    if (dataSource) {
        NSLog(@"dataSource不为空 ，清空。。。。。。。。。。。。。。。");
        [dataSource release];
        dataSource=nil;
    }
    
    [dataArray removeAllObjects];
    [listTableview reloadData];
    
    if(index==kMenuSSCBCX&&section==kMenuSelect)
    {
      [self removeSubView];

        self.vbShipChVC=[[VBShipChVC alloc] init] ;//不能autorelease
        vbShipChVC.parentVC=self;
        vbShipChVC.view.center=CGPointMake(512, 60);
        vbShipChVC.view.frame=CGRectMake(0, 0, 1024, 121);
        //设置样色  
        vbShipChVC.view.layer.masksToBounds=YES;
        vbShipChVC.view.layer.cornerRadius=2.0;
        vbShipChVC.view.layer.borderWidth=2.0;
        vbShipChVC.view.layer.borderColor=[UIColor blackColor].CGColor;
       vbShipChVC.view.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];

        [self.chooseView addSubview:vbShipChVC.view];
        noteLabel.text=@"备注：①红色表示满载在途；②绿色表示受载在途；③黑色表示其他；④*表示班轮";
        noteLabel.font=[UIFont fontWithName:@"Arial" size:12];
        listTableview.frame=CGRectMake(0, 50, 1024, 440);
         NSLog(@"--------实时船舶查询--");
    }
    else if (index==kMenuCYJH&&section==kMenuSelect)
    {
        NSLog(@"船运计划");
        [self removeSubView];
        
        self.vbTransChVC=[[VBTransChVC alloc] init];
        vbTransChVC.parentVC=self;
        vbTransChVC.view.center=CGPointMake(512,60);
        vbTransChVC.view.frame=CGRectMake(0, 0, 1024, 121);
        
        //设置样色
        vbTransChVC.view.layer.masksToBounds=YES;
        vbTransChVC.view.layer.cornerRadius=2.0;
        vbTransChVC.view.layer.borderWidth=2.0;
        vbTransChVC.view.layer.borderColor=[UIColor blackColor].CGColor;
        vbTransChVC.view.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];
        
        [self.chooseView addSubview:vbTransChVC.view];
          NSLog(@"--------初始船运计划页面--");
          }
    /*
    else if (index==kMenuDDRZCX&&section==kMenuTJ) {
        [self removeSubView];
        //新添  调度日志查询
        self.thShipTransVC=[[[TH_ShipTransChVC alloc] initWithNibName:@"TH_ShipTransChVC" bundle:nil] autorelease];
        thShipTransVC.parentVC=self;
        thShipTransVC.view.center=CGPointMake(512, 60);
        thShipTransVC.view.frame=CGRectMake(0, 0, 1024, 121);

        //设置样色
        thShipTransVC.view.layer.masksToBounds=YES;
        thShipTransVC.view.layer.cornerRadius=2.0;
        thShipTransVC.view.layer.borderWidth=2.0;
        thShipTransVC.view.layer.borderColor=[UIColor blackColor].CGColor;
        thShipTransVC.view.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1]; 
        [self.chooseView addSubview:thShipTransVC.view];
        NSLog(@"调度日志.............");
    }
     */
    //新添 滞期费查询
    else if (index==kMenuZQFMXCX&&section==kMenuLatefee) {
       [self removeSubView];
        self.tblatefeeVC=[[[TB_LatefeeChVC alloc] init] autorelease ];
        tblatefeeVC.parentVC=self;
        tblatefeeVC.view.center=CGPointMake(512, 60);
        tblatefeeVC.view.frame=CGRectMake(0, 0, 1024, 121);
        
        
        //设置样色
        tblatefeeVC.view.layer.masksToBounds=YES;
        tblatefeeVC.view.layer.cornerRadius=2.0;
        tblatefeeVC.view.layer.borderWidth=2.0;
        tblatefeeVC.view.layer.borderColor=[UIColor blackColor].CGColor;
        tblatefeeVC.view.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];
         
        [self.chooseView addSubview:tblatefeeVC.view];
        NSLog(@"滞期费查询.............");
       
    }
    
    //滞期费  统计
    else if (index==kMenuZQFTJ&&section==kMenuLatefee) {
      [self removeSubView];
        self.latefeeTj=[[[NT_LatefeeTongjChVC alloc] init] autorelease];
        latefeeTj.parentVC=self;
        latefeeTj.view.center=CGPointMake(512, 60);
        latefeeTj.view.frame=CGRectMake(0, 0, 1024, 121);
        
        //设置样色
        latefeeTj.view.layer.masksToBounds=YES;
        latefeeTj.view.layer.cornerRadius=2.0;
        latefeeTj.view.layer.borderWidth=2.0;
        latefeeTj.view.layer.borderColor=[UIColor blackColor].CGColor;
        latefeeTj.view.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];
        [self.chooseView addSubview:latefeeTj.view];
        NSLog(@"滞期费统计查询.............");
        
    }
    //港口平均装港时间统计
    
    else if (index==kMenuGKMJZGSJ&&section==kMenuTJ) {
       [self removeSubView];
        self.avgTimePort=[[[AvgPortPTimeChVC alloc] init] autorelease];
        avgTimePort.parentVC=self;
        avgTimePort.view.center=CGPointMake(512, 60);
        avgTimePort.view.frame=CGRectMake(0, 0, 1024, 121);
        
        //设置样色
        avgTimePort.view.layer.masksToBounds=YES;
        avgTimePort.view.layer.cornerRadius=2.0;
        avgTimePort.view.layer.borderWidth=2.0;
        avgTimePort.view.layer.borderColor=[UIColor blackColor].CGColor;
        avgTimePort.view.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];
        [self.chooseView addSubview:avgTimePort.view];
            NSLog(@"港口平均装港时间统计查询.............");
        
    }
    //电厂装卸港时间统计
    else if (index==kMenuFcAvgZXTime&&section==kMenuTJ) {
   [self removeSubView];
        self.avgTimeZXFactory=[[[AvgFactoryTimeChVC alloc] init] autorelease];
        avgTimeZXFactory.parentVC=self;
        avgTimeZXFactory.view.center=CGPointMake(512, 60);
        avgTimeZXFactory.view.frame=CGRectMake(0, 0, 1024, 121);
        
        //设置样色
        avgTimeZXFactory.view.layer.masksToBounds=YES;
        avgTimeZXFactory.view.layer.cornerRadius=2.0;
        avgTimeZXFactory.view.layer.borderWidth=2.0;
        avgTimeZXFactory.view.layer.borderColor=[UIColor blackColor].CGColor;
        avgTimeZXFactory.view.backgroundColor=[UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];
        [self.chooseView addSubview:avgTimeZXFactory.view];
         NSLog(@"电厂平均装XIE港时间统计查询............."); 
    }
    
   
    
    
    
    
    
    
    
    
    
    
    
    
}

-(void)removeSubView
{
    if (self.vbShipChVC) {
        [vbShipChVC.view removeFromSuperview];
        [vbShipChVC release];
    }
    if (self.vbTransChVC) {
        [vbTransChVC.view    removeFromSuperview];
        [vbTransChVC release];
    }
    if(self.thShipTransVC   ){
        [thShipTransVC.view removeFromSuperview];
        [thShipTransVC   release    ];
     }
    if(self.tblatefeeVC){
        [tblatefeeVC.view removeFromSuperview];
        [tblatefeeVC   release    ];
     }
    if(self.latefeeTj){
    [latefeeTj.view removeFromSuperview];
    [latefeeTj   release    ];
     }
     if(self.avgTimePort){
       [avgTimePort.view removeFromSuperview];
        [avgTimePort   release    ];
      }
     if(self.avgTimeZXFactory){
       [avgTimeZXFactory.view removeFromSuperview];
       [avgTimeZXFactory   release    ];
    
      }
}


@end

