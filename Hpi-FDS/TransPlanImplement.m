//
//  TransPlanImplement.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-11.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//dev_tangb

#import "TransPlanImplement.h"
#import "TransPlanImpDao.h"
#import "NT_TransPlanImpDao.h"
#import "TransPlanImpModel.h"

#import "PMPeriod.h"
#import "TfShipDao.h"
#import "TgPortDao.h"


@interface TransPlanImplement ()

@end

@implementation TransPlanImplement
@synthesize comLabel;
@synthesize comButton;
@synthesize shipLabel;
@synthesize shipButton;
@synthesize factoryLabel;
@synthesize factoryButton;
@synthesize portLabel;
@synthesize portButton;
@synthesize typeLabel;
@synthesize typeButton;
@synthesize coalTypeLabel;
@synthesize coalTypeButton;
@synthesize supLable;
@synthesize supButton;
@synthesize startTime;
@synthesize startButton;
@synthesize endTime;
@synthesize endButton;
@synthesize reload;
@synthesize active;

@synthesize xmlParser;
@synthesize month;
@synthesize monthCV;
@synthesize chooseView;
@synthesize poper;

@synthesize dcView;
@synthesize source;

@synthesize model;


@synthesize listTableview;
@synthesize listView;
@synthesize TitleView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }  
    return self;
}
static int  whichButton=0;
PMCalendarController *   pmCC;
NSMutableArray *columnWidth1;

int indexa=0;
int b=0;
int clickbutton=0;




static   NSMutableDictionary *datedic;//执行情况详细
static   NSMutableArray *days ;
static   NSMutableArray *date_p;//计划详细
//  getDataSource
static  NSMutableArray *dateArr;
static NSMutableArray *d;








- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.comLabel.text=All_;
    self.shipLabel.text=All_;
    self.factoryLabel.text=All_;
    self.portLabel.text=All_;
    self.coalTypeLabel.text=All_;
    self.typeLabel.text=All_;
    self.supLable.text=All_;
    self.startTime.text=All_;
    self.endTime.text=All_;
    
    [active removeFromSuperview];
    xmlParser=[[TBXMLParser alloc] init];
    self.portLabel.hidden=YES;
    self.coalTypeLabel.hidden=YES;
    self.comLabel.hidden=YES;
    self.shipLabel.hidden=YES;
    self.factoryLabel.hidden=YES;
    self.typeLabel.hidden=YES   ;
    self.supLable.hidden=YES;
    self.startTime.hidden=YES;
    self.endTime.hidden=YES;
    
 
    datedic=[[NSMutableDictionary  alloc] init];
    days=[[NSMutableArray alloc] init];
    date_p=[[NSMutableArray alloc] init];
    dateArr=[[NSMutableArray alloc] init];
    d=[[NSMutableArray alloc] init];
    
    //为视图增加边框
    dcView.layer.masksToBounds=YES;
    dcView.layer.cornerRadius=2.0;
    dcView.layer.borderWidth=2.0;
    dcView.layer.borderColor=[[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]CGColor];
    dcView.backgroundColor=[UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
    
    // dcView.center=CGPointMake(512,352);//修改
    
    TitleView.layer.masksToBounds=YES;
    TitleView.layer.cornerRadius=2.0;
    TitleView.layer.borderWidth=2.0;
    TitleView.layer.borderColor=[UIColor blackColor].CGColor;
    TitleView.backgroundColor=[UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    [listTableview setSeparatorColor:[UIColor clearColor]];
    listTableview.backgroundColor = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    
    
    //初始化
    month=[[NSDate alloc] init];
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
    [formater stringFromDate:month];
    [ formater release];
    
    

    [self fillTitle];
    
    
    
    
    
    
    
    
    //填充 临时表 数据
   [NT_TransPlanImpDao getNT_TransPlanImp];
    
    
}
int totalColument=0;
-(void)getColument
{
    columnWidth1=[[NSMutableArray alloc] init ];
    totalColument=[[source.columnWidth objectAtIndex:0] integerValue    ];
    int a=1;
    for (int i=1; i<[source.titles  count]; i++) {
        
        NSMutableArray  *subT=[source.splitTitle    objectAtIndex:i-1];
        int fWidth=0;
        for ( int t=0; t<[subT count]; t++) {   
            fWidth+=[[source.columnWidth objectAtIndex:(t+a)] integerValue    ];
            
        }
        [columnWidth1 addObject:[NSString stringWithFormat:@"%d",fWidth]];
        totalColument+=fWidth;
        a+=[subT count];
    }
   
}
-(void)fillTitle{
    [self initDC];
    
    [self getColument];
    
    [self.TitleView removeFromSuperview];
    
    
    int cellWidth=[[source.columnWidth objectAtIndex:0] integerValue];
    int cellHeight=40;
    float columnOffset = cellWidth;
    //int iColorRed=0;
    float set=cellWidth;
    int d=1;
    //-------------------填冲标题数据
    //第一个单元格   ---------高度  没有二层标题时   *1
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth-1, cellHeight*2-1 )];
    l2.font = [UIFont systemFontOfSize:16.0f];
    l2.text = [source.titles objectAtIndex:0];
    //l2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
    l2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
    l2.textColor = [UIColor whiteColor];
    l2.shadowColor = [UIColor blackColor];
    l2.shadowOffset = CGSizeMake(0, -0.5);
    l2.textAlignment = UITextAlignmentCenter;
    [TitleView addSubview:l2];
    [l2 release];
    //一层标题
    for(int column = 1;column < [source.titles count];column++){
        //父标题 宽度
        int fTitleWidth=[[columnWidth1 objectAtIndex:column-1] integerValue];
        UILabel *l;
        l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, fTitleWidth -1, cellHeight-1 )];
        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
        l.font = [UIFont systemFontOfSize:16.0f];
        l.text = [source.titles objectAtIndex:column];
        //l.backgroundColor = [UIColor colorWithRed:0.0/255 green:105.0/255 blue:186.0/255 alpha:1];
        l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(0, -0.5);
        l.textAlignment = UITextAlignmentCenter;
        [TitleView addSubview:l];
        [l release];
        
        //循环下一层标题
        NSMutableArray *subTitle=[source.splitTitle objectAtIndex:column-1];
        for (int i=0; i<[subTitle count]; i++) {
            int cdw=[[source.columnWidth objectAtIndex:d] integerValue];
            
            UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(set, cellHeight, cdw-1, cellHeight-1 )];
            l1.font = [UIFont systemFontOfSize:13.0f];
            l1.text =[subTitle objectAtIndex:i];
            l1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
            l1.textColor = [UIColor whiteColor];
            l1.shadowColor = [UIColor blackColor];
            l1.shadowOffset = CGSizeMake(0, -0.5);
            l1.textAlignment = UITextAlignmentCenter;
            
            [TitleView addSubview:l1];
            set+=cdw;
            [l1 release];
            d++;
        }
        columnOffset += fTitleWidth;
    }

    
    [self.dcView addSubview:self.TitleView];
    
    
    
}
  
-(void)initDC
{
    if(!source){
        source=[[MultiTitleDataSource alloc] init   ];
        source.data=[[NSMutableArray alloc] init ];
    }
    source.titles=[[NSMutableArray alloc] initWithObjects:@"计划月份",@"航运计划",@"航运计划执行情况", nil];
    source.columnWidth=[[NSMutableArray alloc] initWithObjects:@"85",@"85",@"70",@"75",@"85",@"85",@"85",@"75",@"120",@"85",@"100",@"75", nil];//       @"95",@"95",  ,@"预抵装港",@"预抵卸港"   ,@"85",@"75",@"75"  ,@"热值",@"硫分"  ,@"85"  ,@"备注"
    
    source.splitTitle=[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithObjects:@"船名",@"航次",@"流向",@"装运港",@"煤量(万吨)",@"供货方",@"类别",nil], nil];
    NSMutableArray *split2=[[NSMutableArray alloc] initWithObjects:@"船舶及装卸港更改",@"兑现量(万吨)",@"上月",@"装卸量详细", nil];
    [source.splitTitle addObject:split2];
    [split2 release];
    

   
}



-(NSMutableArray *)getSourceDate:(SearchModel *)Smodel
{
    NSMutableArray *date=[[[NSMutableArray alloc] init] autorelease];
    //临时表数据
    NSMutableArray *list=   [NT_TransPlanImpDao GetNT_TransPlanImpData:Smodel];
   NSLog(@"list====[%d]",[list count]);

    NSMutableArray *lstMonthFactory1=[[NSMutableArray alloc] init];
    NSMutableArray *lstMonthFactory2=[[NSMutableArray alloc] init];
     double dblTotal1 = 0.0;
     double dblCashTotal1 = 0.0;
     double dblAllTotal1 = 0.0;
     double dblAllCashTotal1 = 0.0;
   
        for (TransPlanImpModel *item in list) {

        NSMutableArray *rowdate=[[NSMutableArray alloc] init];
        NSString *strMonthFactory1=item.ST_FACTORYCODE;//去空白 
            NSString *strMonthFactory2=item.ST_PLANMONTH;
            //月合计
            if (![lstMonthFactory2 containsObject:strMonthFactory2]) {
                if (lstMonthFactory2.count > 0)
                {
                    //按月 合计
                    [rowdate addObject:@"月"];
                    //合并  6
                    [rowdate addObject:@""];
                    [rowdate addObject:@""];
                    [rowdate addObject:@""];
                    [rowdate addObject:@""];
                    [rowdate addObject:@""];
                    [rowdate addObject:@""];
                    [rowdate addObject:@""];
                    [rowdate addObject:@""];
                    [rowdate addObject:@""];
                    [rowdate addObject:@""];//上月
                    
                  //  NSLog(@"d ===月集合。。。。。。。。。。。。。。。==============[%d]",[d count]);
                    [rowdate addObject:d];
                    
        
                    
                                      
                    
                    
                    [d release  ];
                    d=[[NSMutableArray alloc] init];
                    
                    [date addObject:rowdate];
                    [rowdate    release];
                    rowdate=[[NSMutableArray alloc] init];
                }
                if (strMonthFactory2)
                    [lstMonthFactory2 addObject:strMonthFactory2];
                
            }         
        if (![lstMonthFactory1 containsObject:strMonthFactory1]) {
            if (lstMonthFactory1.count > 0)
            {
                //合计   每个电厂
                [rowdate addObject:@"合计"];
                //合并  6
                [rowdate addObject:@""];
                [rowdate addObject:@""];
                [rowdate addObject:@""];
                [rowdate addObject:@""];
                [rowdate addObject:[NSString stringWithFormat:@"%.2f",dblTotal1]];
                [rowdate addObject:@""];
                [rowdate addObject:@""];
                [rowdate addObject:@""];
                [rowdate addObject:[NSString stringWithFormat:@"%.2f",dblCashTotal1]];
                [rowdate addObject:@""];//上月
                NSMutableArray *d=[[NSMutableArray alloc] init];
                [rowdate addObject:d];
                [d release  ];

                
                [date addObject:rowdate];
                [rowdate    release];
               rowdate=[[NSMutableArray alloc] init];
            }
            if (strMonthFactory1)
            [lstMonthFactory1 addObject:strMonthFactory1];
            
            dblTotal1 = item.ST_ELW != 0 ?  item.ST_ELW / 10000.0  : 0.0;
            if ( [ item.S_STAGE  isEqualToString:@"2" ] ||  [ item.S_STAGE  isEqualToString:@"3" ] ||  [ item.S_STAGE  isEqualToString:@"4" ])
            {
                dblCashTotal1 = item.S_LW != 0 ? (item.S_LW / 10000.0) : 0.0;
            }
            else
            {
                dblCashTotal1 = 0.0;
            }
        }
        else
        {
            dblTotal1 += item.ST_ELW != 0? item.ST_ELW / 10000 : 0.0;
            if ( [ item.S_STAGE  isEqualToString:@"2" ] ||  [ item.S_STAGE  isEqualToString:@"3" ] ||  [ item.S_STAGE  isEqualToString:@"4" ])
            {
                dblCashTotal1 += item.S_LW != 0? item.S_LW / 10000 : 0.0;
            }
        }
            if (  [ item.S_PLANTYPE  isEqualToString:@"1" ])
            {
                //填充数据............
             //  NSLog(@"填充数据......");
                [rowdate  addObject:item.ST_PLANMONTH   ];
                [rowdate  addObject:[TfShipDao getShipName: item.ST_SHIPID]   ];
                 [rowdate  addObject:item.ST_TRIPNO  ];
                [rowdate  addObject:item.ST_FACTORYNAME   ];
                [rowdate  addObject:item.ST_PORTNAME  ];
                
                NSString *time1=@"";
                if (![item.ST_ARRIVETIME isEqualToString:@""]) {
                  time1=  [item.ST_ARRIVETIME  substringWithRange:NSMakeRange(0, 10)];   
                }
                NSString *time2=@"";
                if (![item.ST_LEAVETIME isEqualToString:@""]) {
                   time2= [item.ST_LEAVETIME  substringWithRange:NSMakeRange(0, 10)];
                   
                }

                
                NSString *timearr= [time1 isEqualToString:@"2000-01-01" ]||[time1 isEqualToString:@"0001-01-01" ] ?@"未知":time1;
                NSString *timeL= [time2 isEqualToString:@"2000-01-01" ]||[time2 isEqualToString:@"0001-01-01" ] ?@"未知":time2;
                [rowdate  addObject: [NSString stringWithFormat:@"%.2f", item.ST_ELW!=0?(item.ST_ELW/10000.0):0.00]  ];
                [rowdate  addObject:item.ST_SUPPLIER  ];
                [rowdate  addObject: item.ST_KEYNAME  ];
                if (  item.S_SHIPID==item.T_SHIPID && [(item.T_PORTCODE ==nil ? @"" : item.T_PORTCODE)  isEqualToString: item.S_PORTCODE  ]  )//code  去除两边空白
                {

                    /////--------------航运计划执行进度--------------------------
                    [rowdate  addObject:@""];
                    [rowdate  addObject: [NSString stringWithFormat:@"%.2f",([ item.S_STAGE  isEqualToString:@"2" ] ||  [ item.S_STAGE  isEqualToString:@"3" ] ||  [ item.S_STAGE  isEqualToString:@"4" ])?(item.S_LW != 0 ? (item.S_LW / 10000.0) : 0.00) :0.00  ]   ];
                    NSString * strShowDate = @"";
                    BOOL blnMonthFlag4 = false;
                    NSDateFormatter *f=[[NSDateFormatter alloc] init];
                      NSDateFormatter *f1=[[NSDateFormatter alloc] init];
                     [f1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *t=[f dateFromString:item.S_ARRIVETIME];
                   
                    [f setDateFormat:@"MM"];
                    
                    NSDate *tt=[[NSDate alloc] initWithTimeInterval:30*24*60*60 sinceDate:t];
                      //NSLog(@"============111111111111111111111======================");
                    NSString *m=[NSString stringWithFormat:@"%@",  [f stringFromDate:tt]] ;
                    
                   
                    [f setDateFormat:@"yyyy"];
                    NSString * yeas=[f stringFromDate:tt];
                    
                    NSString *monthY=yeas==nil?[NSString  stringWithFormat:@"%@",m]:[NSString  stringWithFormat:@"%@%@",yeas,m];
                       [f setDateFormat:@"dd"];
                    
                  //  NSLog(@"monthY======%@=========item.ST_PLANMONTH ========%@",monthY,item.ST_PLANMONTH);
                    
                    if ( [item.ST_PLANMONTH isEqualToString: monthY ]  )
                    {
                        //NSLog(@"==========================进入上月赋值====================================");
                        
                        strShowDate =[NSString stringWithFormat:@"%@日/%.2f",[f stringFromDate:t] ,(item.T_ELW != 0.0 ? (item.T_ELW / 10000.0): item.ST_ELW != 0? (item.ST_ELW / 10000.0) : 0.00)];
                        blnMonthFlag4 = true;
                        
                       // NSLog(@"strShowDate========%@",strShowDate);
                        
                    } 

                    [rowdate  addObject:strShowDate];//上月
                    int intArrive = 0;
                    int intLeave = 0;
                    NSString *Stime2=@"";
                    if (![item.S_LEAVETIME isEqualToString:@""]) {
                        Stime2= [item.S_LEAVETIME  substringWithRange:NSMakeRange(0, 10)];
                    }
                    NSString *Stime1=@"";
                    if (![item.S_ARRIVETIME isEqualToString:@""]) {
                        Stime1= [item.S_ARRIVETIME  substringWithRange:NSMakeRange(0, 10)];
                        
                    }
                    if ( ![Stime1 isEqualToString:@"0001-01-01"] &&![Stime1  isEqualToString:@"2000-01-01"]  && !blnMonthFlag4)
                    {
                        if (![item.S_ARRIVETIME isEqualToString:@""])
                        {
                            intArrive = [[item.S_ARRIVETIME substringWithRange:NSMakeRange(8, 2)] integerValue ];//f
                        }
                       // NSLog(@"intArrive==========================%d======================",intArrive);
                    }
                    
                    if (![Stime2 isEqualToString:@"2000-01-01"]&&![ Stime2 isEqualToString:@"0001-01-01"])
                    {
                        
                        if (![item.S_LEAVETIME isEqualToString:@""])
                        {
                            intLeave = [[item.S_LEAVETIME substringWithRange:NSMakeRange(8, 2)] integerValue ];//f
                        }
                     //   NSLog(@"intLeave==========================%d======================",intLeave);
                    }
                    
                 
                    [dateArr addObject:item.ST_PLANMONTH];
                     
                    NSMutableArray *dateArr1=[[NSMutableArray alloc] init];

                    for (int i = 1; i <= 31; i++)
                    {
                        if (i == intArrive)//计划煤量 
                        {
                            [dateArr1  addObject:[NSString stringWithFormat:@"%dP",i]];
                            
                            [dateArr1 addObject:[NSString  stringWithFormat:@"P%.2f", item.T_ELW != 0.0 ? (item.T_ELW / 10000.0) : item.ST_ELW != 0? (item.ST_ELW / 10000.0) : 0.00  ] ];
                              [dateArr1  addObject:[TfShipDao getShipName: item.ST_SHIPID] ];
          
                        }
                        //实际煤量
                        else if (i == intLeave)
                        {
                            [dateArr1  addObject:[NSString stringWithFormat:@"%dS",i]];

                            [dateArr1 addObject:[NSString stringWithFormat:@"S%.2f", item.S_LW != 0? (item.S_LW / 10000) : item.ST_ELW != 0? (item.ST_ELW / 10000) : 0.00]];
                              [dateArr1  addObject:[TfShipDao getShipName: item.ST_SHIPID] ];
                        }
                    }
                    
                    
                    NSMutableArray *dateArr2=[[NSMutableArray alloc] init];
                    
                    [dateArr2 addObject:[TfShipDao getShipName: item.ST_SHIPID]];
                    
                    
                    
                    [dateArr2 addObject:timearr ];
                    [dateArr2 addObject:timeL];
                    
                    
                    
                    [dateArr2 addObject:item.ST_COALTYPE];
                    [dateArr2 addObject:[NSString stringWithFormat:@"%@",item.T_HEATVALUE] ];
                    [dateArr2 addObject:[NSString stringWithFormat:@"%@",item.T_SULFUR ] ];
                    [dateArr2 addObject: item.T_DESCRIPTION];
                    [dateArr addObject:dateArr1];
                    [dateArr1 release];
                    [dateArr addObject:dateArr2];
                    [dateArr2 release];
                    [rowdate addObject:dateArr];
                    
                    
                    [d  addObject:dateArr   ];
                     [dateArr   release   ];
                dateArr=[[NSMutableArray alloc] init] ;
                    [f1 release];
                    [f release  ];
                //===================================一种情况  结束
                }else
                {
                    /////--------------航运计划执行进度--------------------------
                   NSString *strShowChange=[NSString stringWithFormat:@"%@",@""];
                    if (item.S_SHIPID!=item.T_SHIPID)
                    {
                     strShowChange= [ strShowChange   stringByAppendingFormat:@"%@", [TfShipDao getShipName: item.S_SHIPID]  ];
                    }
                    
                    if (! [(item.T_PORTCODE ==nil? @"" : item.T_PORTCODE)  isEqualToString: (item.S_PORTCODE)]  )//去空白
                    {                 
                        if (![strShowChange  isEqualToString:@"" ])
                        {   
                         strShowChange=   [ strShowChange   stringByAppendingFormat:@"/%@", item.S_PORTNAME  ];
                        }
                        else
                        {
                         strShowChange=   [ strShowChange   stringByAppendingFormat:@"%@", item.S_PORTNAME  ];
                            
                        }
                    }
                    [rowdate  addObject:strShowChange];
                    [rowdate  addObject:[NSString stringWithFormat:@"%.2f", ([ item.S_STAGE  isEqualToString:@"2" ] || [ item.S_STAGE  isEqualToString:@"3" ] ||  [ item.S_STAGE  isEqualToString:@"4" ])?(item.S_LW != 0 ? (item.S_LW / 10000.0) : 0.00) :0.00      ]    ];
                    NSString *strShowDate=@"";
                    BOOL blnMonthFlag5 = false;
                    NSDateFormatter *f=[[NSDateFormatter alloc] init];
                    NSDateFormatter *f1=[[NSDateFormatter alloc] init];
                    [f1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    
                    NSDate *t=[f dateFromString:item.S_ARRIVETIME];
                                       [f setDateFormat:@"MM"];
                    
                    NSDate *tt=[[NSDate alloc] initWithTimeInterval:30*24*60*60 sinceDate:t];
                    
                    
                    
                    NSString *m= [NSString stringWithFormat:@"%@",[f stringFromDate:tt] ] ;
                    [f setDateFormat:@"yyyy"];
                    NSString * yeas=[f stringFromDate:tt];


                    NSString *monthY=yeas==nil?[NSString  stringWithFormat:@"%@",m]:   [NSString  stringWithFormat:@"%@%@",yeas,m];
                    [f setDateFormat:@"dd"];
                   
                  //  NSLog(@"============22222222222222222222222222=====================");
                    
              //  NSLog(@"monthY======%@=========item.ST_PLANMONTH ========%@",monthY,item.ST_PLANMONTH);
                    if (  [item.ST_PLANMONTH isEqualToString:monthY]   )
                    {
                      /// NSLog(@"==========================进入上月赋值====================================");
                      
                        strShowDate =[NSString stringWithFormat:@"%@日/%.2f",[f stringFromDate:t] ,(item.T_ELW != 0 ? (item.T_ELW / 10000.0): item.ST_ELW != 0? (item.ST_ELW / 10000.0) : 0.00)];
                        blnMonthFlag5 = true;
                        
                       // NSLog(@"strShowDate========%@",strShowDate);
                    }
                 [rowdate  addObject:strShowDate];
                    int intArrive = 0;
                    int intLeave = 0;
         
                    
                    
                    NSString *Stime2=@"";
                    if (![item.S_LEAVETIME isEqualToString:@""]) {
                        Stime2= [item.S_LEAVETIME  substringWithRange:NSMakeRange(0, 10)];
                    }
                    NSString *Stime1=@"";
                    if (![item.S_ARRIVETIME isEqualToString:@""]) {
                        Stime1= [item.S_ARRIVETIME  substringWithRange:NSMakeRange(0, 10)];
                        
                    }
                    if ( ![Stime1 isEqualToString:@"0001-01-01"] &&![Stime1  isEqualToString:@"2000-01-01"]  && !blnMonthFlag5)
                    {
                        if (![item.S_ARRIVETIME isEqualToString:@""])
                        {
                            intArrive = [[item.S_ARRIVETIME substringWithRange:NSMakeRange(8, 2)] integerValue ];//f
                        }
                      //  NSLog(@"intArrive==========================%d======================",intArrive);
                    }
                    
                    
                    
                    if (![Stime2 isEqualToString:@"2000-01-01"]&&![ Stime2 isEqualToString:@"0001-01-01"])
                    {
                        
                        if (![item.S_LEAVETIME isEqualToString:@""])
                        {
                            intLeave = [[item.S_LEAVETIME substringWithRange:NSMakeRange(8, 2)] integerValue ];//f
                        }
                      // NSLog(@"intLeave==========================%d======================",intLeave);
                    }
                    
                    
                    
                    
                    
                   
                    [dateArr addObject:item.ST_PLANMONTH];
                   
                    NSMutableArray *dateArr1=[[NSMutableArray alloc] init];
                 
                    for (int i = 1; i <= 31; i++)
                    {
                        if (i == intArrive)
                        {
                            
                             [dateArr1  addObject:[NSString stringWithFormat:@"%dP",i]];
                            [dateArr1 addObject: [NSString  stringWithFormat:@"P%.2f", item.T_ELW != 0 ? (item.T_ELW / 10000.0) : item.ST_ELW != 0? (item.ST_ELW / 10000.0) : 0.00  ]   ];
                              [dateArr1  addObject:[TfShipDao getShipName: item.ST_SHIPID] ];
                        }
                        else if (i == intLeave)
                        {
                            
                             [dateArr1  addObject:[NSString stringWithFormat:@"%dS",i]];
                            [dateArr1 addObject:[NSString stringWithFormat:@"S%.2f", item.S_LW != 0? (item.S_LW / 10000.0) : item.ST_ELW != 0? (item.ST_ELW / 10000.0) : 0.00]  ];
                              [dateArr1  addObject:[TfShipDao getShipName: item.ST_SHIPID] ];
                        }
                        
                    }
                    
                    NSMutableArray *dateArr2=[[NSMutableArray alloc] init];
                    
                    [dateArr2 addObject:[TfShipDao getShipName: item.ST_SHIPID]];
                    [dateArr2 addObject:timearr];
                    [dateArr2 addObject:timeL];
                    [dateArr2 addObject:item.ST_COALTYPE];
                    [dateArr2 addObject:[NSString stringWithFormat:@"%@",item.T_HEATVALUE] ];
                    [dateArr2 addObject:[NSString stringWithFormat:@"%@",item.T_SULFUR  ] ];
                    [dateArr2 addObject: item.T_DESCRIPTION];
                    
                    
                    
                    
                    [dateArr addObject:dateArr1];
                    [dateArr1 release];
                    
                    
                    
                    [dateArr addObject:dateArr2];
                    [dateArr2 release];
                    
                    [rowdate addObject:dateArr];
                    
                     [d  addObject:dateArr   ];
                    [dateArr   release   ];
                    dateArr=[[NSMutableArray alloc] init] ;

                    [f1 release];
                    [f release  ];
                //=============else   end  
                }
               // NSLog(@"===========  rowdate ========【%d】",[rowdate count]);
                [date addObject:rowdate];
                [rowdate release];
            }else
            {
                //填充数据............
                [rowdate  addObject:item.ST_PLANMONTH   ];
                [rowdate  addObject:[TfShipDao getShipName: item.ST_SHIPID]   ];
                [rowdate  addObject:item.ST_TRIPNO  ];
                [rowdate  addObject:item.ST_FACTORYNAME   ];
                [rowdate  addObject:item.ST_PORTNAME  ];
                
                NSString *time1=@"";
                if (![item.ST_ARRIVETIME isEqualToString:@""]) {
                  time1=  [item.ST_ARRIVETIME  substringWithRange:NSMakeRange(0, 10)];
                }
                
                NSString *time2=@"";
                if (![item.ST_LEAVETIME isEqualToString:@""]) {
                    
                   time2= [item.ST_LEAVETIME  substringWithRange:NSMakeRange(0, 10)];
                }

                
                
                
                NSString *timearr= [time1 isEqualToString:@"2000-01-01" ]||[time1 isEqualToString:@"0001-01-01" ] ?@"未知":time1;
              
                NSString *timeL= [time2 isEqualToString:@"2000-01-01" ]||[time2 isEqualToString:@"0001-01-01" ] ?@"未知":time2;

                [rowdate  addObject: [NSString stringWithFormat:@"%.2f", item.ST_ELW!=0?(item.ST_ELW/10000.0):0.00]  ];
                [rowdate  addObject:item.ST_SUPPLIER  ];
                [rowdate  addObject: item.ST_KEYNAME  ];
                //=======航运计划执行情况-------------------=============
                [rowdate addObject:@""];
                
                [rowdate  addObject: [NSString stringWithFormat:@"%.2f",([ item.S_STAGE  isEqualToString:@"2" ] ||  [ item.S_STAGE  isEqualToString:@"3" ] ||  [ item.S_STAGE  isEqualToString:@"4" ])?(item.S_LW != 0 ? (item.S_LW / 10000.0) : 0.00) :0.00  ]   ];
                
                NSString *strShowDate=@"";
                     bool blnMonthFlag6 = false;
                
                NSDateFormatter *f=[[NSDateFormatter alloc] init];
                NSDateFormatter *f1=[[NSDateFormatter alloc] init];
                [f1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
                    NSDate *t=[f dateFromString:item.S_ARRIVETIME];
                   
                  [f setDateFormat:@"MM"];
                    NSDate *tt=[[NSDate alloc] initWithTimeInterval:30*24*60*60 sinceDate:t];
                
                
                NSString *m=[f stringFromDate:tt];
                [f setDateFormat:@"yyyy"];
                NSString * yeas=[f stringFromDate:tt];
                
                
                
                NSString *monthY=yeas==nil?[NSString  stringWithFormat:@"%@",m]:  [NSString  stringWithFormat:@"%@%@",yeas,m];
                    [f setDateFormat:@"dd"];
                   // NSLog(@"============333333333333333333333333333333=====================");
                    
                   // NSLog(@"monthY======%@=========item.ST_PLANMONTH ========%@",monthY,item.ST_PLANMONTH);
                    
                    if (  [item.ST_PLANMONTH isEqualToString:monthY]   )
                    {
                        
                       // NSLog(@"==========================进入上月赋值====================================");
                       // NSLog(@"t========[%@]",t);
                        strShowDate =[NSString stringWithFormat:@"%@日/%.2f",[f stringFromDate:t] ,item.ST_ELW != 0? (item.ST_ELW / 10000.0) : 0.00];
                        blnMonthFlag6 = true;
                        
                        //NSLog(@"strShowDate========%@",strShowDate);
                        
                    }

                    
                    
                
               [rowdate addObject:strShowDate];
                int intArrive = 0;
                int intLeave = 0;
                
                NSString *Stime2=@"";
                if (![item.S_LEAVETIME isEqualToString:@""]) {
                    Stime2= [item.S_LEAVETIME  substringWithRange:NSMakeRange(0, 10)]; 
                }
                NSString *Stime1=@"";
                if (![item.S_ARRIVETIME isEqualToString:@""]) {
                    Stime1= [item.S_ARRIVETIME  substringWithRange:NSMakeRange(0, 10)];
                    
                }
                if ( ![Stime1 isEqualToString:@"0001-01-01"] &&![Stime1  isEqualToString:@"2000-01-01"]  && !blnMonthFlag6)
                {
                    if (![item.S_ARRIVETIME isEqualToString:@""])
                    {
                        intArrive = [[item.S_ARRIVETIME substringWithRange:NSMakeRange(8, 2)] integerValue ];//f
                    }
                 //   NSLog(@"intArrive==========================%d======================",intArrive);
                }

                
               
                if (![Stime2 isEqualToString:@"2000-01-01"]&&![ Stime2 isEqualToString:@"0001-01-01"])
                {

                    if (![item.S_LEAVETIME isEqualToString:@""])
                    { 
                     intLeave = [[item.S_LEAVETIME substringWithRange:NSMakeRange(8, 2)] integerValue ];//f
                    }
               // NSLog(@"intLeave==========================%d======================",intLeave);
                }
                
                
                [dateArr addObject:item.ST_PLANMONTH];
              
                NSMutableArray *dateArr1=[[NSMutableArray alloc] init];
              
                for (int i = 1; i <= 31; i++)
                {
                    if (i == intArrive)
                    {
                         [dateArr1  addObject:[NSString stringWithFormat:@"%dP",i]];
                        [dateArr1 addObject:[NSString  stringWithFormat:@"P%.2f",item.ST_ELW != 0? (item.ST_ELW / 10000.0) : 0.00]   ];
                         [dateArr1  addObject:[TfShipDao getShipName: item.ST_SHIPID] ];
                        
                    }
                    else if (i == intLeave)
                    {
                        [dateArr1  addObject:[NSString stringWithFormat:@"%dS",i]];
                        [dateArr1 addObject:[NSString  stringWithFormat:@"S%.2f",item.ST_ELW !=0? (item.ST_ELW / 10000.0) : 0.00]  ];
                          [dateArr1  addObject:[TfShipDao getShipName: item.ST_SHIPID] ];
                    }
                }
                
                
                
                NSMutableArray *dateArr2=[[NSMutableArray alloc] init];
                [dateArr2 addObject:[TfShipDao getShipName: item.ST_SHIPID]];
                [dateArr2 addObject:timearr];
                [dateArr2 addObject:timeL];
                [dateArr2 addObject:item.ST_COALTYPE];
                [dateArr2 addObject:[NSString stringWithFormat:@"%@",item.S_HEATVALUE] ];
                [dateArr2 addObject:[NSString stringWithFormat:@"%@",item.S_SULFUR  ] ];
                [dateArr2 addObject: item.T_DESCRIPTION];
                [dateArr addObject:dateArr1];
                [dateArr1 release];
                [dateArr addObject:dateArr2];
                [dateArr2 release];
                [rowdate addObject:dateArr];
                
                 [d  addObject:dateArr   ];
                [dateArr   release   ];
                dateArr=[[NSMutableArray alloc] init] ;
                
                
                [f release  ];
                [f1 release];
                [date addObject:rowdate];
                [rowdate release];
           //else  结束
            }
            dblAllTotal1 += item.ST_ELW != 0? item.ST_ELW / 10000.0 : 0.0;
            if ( [ item.S_STAGE  isEqualToString:@"2" ] || [ item.S_STAGE  isEqualToString:@"3" ]  || [ item.S_STAGE  isEqualToString:@"4" ] )
            {
                dblAllCashTotal1 += item.S_LW !=0 ? (item.S_LW / 10000.0) : 0.0;
            }
            
       
     /////------循环结束
            
    }
    
    
   
    NSMutableArray *monthTotal=[[NSMutableArray alloc] init];
    //按月 合计
    [monthTotal addObject:@"月"];
    //合并  6
    [monthTotal addObject:@""];
    [monthTotal addObject:@""];
    [monthTotal addObject:@""];
    
    [monthTotal addObject:@""];
    [monthTotal addObject:@""];
    [monthTotal addObject:@""];
    [monthTotal addObject:@""];
    [monthTotal addObject:@""];
    [monthTotal addObject:@""];
    [monthTotal addObject:@""];//上月
    

    
    [monthTotal addObject:d];
   // NSLog(@"DDDDDDDD=ddddddddddddddddddddddddddddddddddddddddddddddddd======[%d]",[d count]);
    
    [d release  ];
    d=[[NSMutableArray alloc] init];
    
    
    
    [date addObject:monthTotal];
    
    [monthTotal    release];

    
    // 多加  两行    合计 和共计
    NSMutableArray *total=[[NSMutableArray alloc] init];
    //共计   每个电厂
    [total addObject:@"共计"];
    //合并  6
    [total addObject:@""];
    [total addObject:@""];
    [total addObject:@""];
    [total addObject:@""];
    [total addObject:[NSString stringWithFormat:@"%.2f",dblAllTotal1]];
    [total addObject:@""];
    [total addObject:@""];
    [total addObject:@""];
    [total addObject:[NSString stringWithFormat:@"%.2f",dblAllCashTotal1]];
    [total addObject:@""];//上月
    
    NSMutableArray *d4=[[NSMutableArray alloc] init];
    [total addObject:d4];
    [d4 release  ];
    [date addObject:total];
    [total release];
    [lstMonthFactory1 release];
     [lstMonthFactory2 release];
   NSLog(@"======----------===== date =====-----------===【%d】",[date count]); 
      return date;
}











- (IBAction)SelectDate:(id)sender {
    //每次查询都清空数据
      [date_p removeAllObjects];
   [datedic    removeAllObjects];
    
    
    
    /*
     NSLog(@"comLable:[%@]",comLabel.text);
     NSLog(@"shipLable   :[%@]",shipLabel.text);
     NSLog(@"factoryLable   :[%@]",factoryLabel.text);
     NSLog(@"portLabel   :[%@]",portLabel.text);
     NSLog(@"coalLable   :[%@]",coalTypeLabel.text);
     NSLog(@"typeLabel   :[%@]",typeLabel.text);
     NSLog(@"supLable   :[%@]",supLable .text);
     NSLog(@"startTime [%@] ",startTime.text );
     NSLog(@"endTime [%@] ",endTime   .text );*/

   
    
    
    model=[[SearchModel  alloc] init];
    model.shipName=shipLabel.text;
    model.FactoryName=factoryLabel.text;
    model.portName=portLabel.text;
    model.CoalType=coalTypeLabel.text;
    model.KeyV=typeLabel.text;
    model.Supplier=supLable .text;
    model.PlanMonthS= [startTime.text integerValue];
    model.PlanMonthE=[endTime.text integerValue];
    
    

    
  source.data=  [self getSourceDate:model];
    [self.listTableview reloadData  ];
     
    [model release];
    
}


#pragma mark -
#pragma mark tableview

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"listTableview  row[%d]",source.data .count);
    
	return [source.data count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
   [pmCC.view removeFromSuperview];
    
    NSMutableArray *rowDetail=[[NSMutableArray alloc] init];
    NSMutableArray *rowdate=[source.data    objectAtIndex:indexPath.row ];
    
    NSMutableArray *dateArr=[rowdate  objectAtIndex:[rowdate count]-1];
    
 
    
    if ([dateArr count]>2) {
        rowDetail=[dateArr objectAtIndex:2];
    }

    NSMutableArray *date_p1=[[NSMutableArray alloc] init];
    [date_p1 addObject:rowDetail];
    [rowDetail release];
    
     
    
    if ([date_p1 count]>0&&[[date_p1 objectAtIndex:0] count]==7) {
        
        int cellHeight=40;
        int totalHeight=0;
        int totalWight=545;
        int columOffset=0;
        
        totalHeight=([date_p1 count]+2)*cellHeight;
      
        UIViewController *detail=[[UIViewController alloc] init];
        UIView *detailView=[[UIView  alloc ] initWithFrame:CGRectMake(0, 0, totalWight, totalHeight)];
        
        NSMutableArray*title_p=[[NSMutableArray alloc] initWithObjects:@"航运计划",@"船名",@"预抵装港",@"预抵卸港" ,@"煤种",@"热值",@"硫分",@"备注",nil];
        NSMutableArray *wight_p=[[NSMutableArray alloc] initWithObjects:@"545",@"90",@"85",@"85",@"75",@"50" ,@"50" , @"110",nil];
        //计划 标题  填充
        //一层标题
        UILabel *l;
        l = [[UILabel alloc] initWithFrame:CGRectMake(columOffset, 0, totalWight-1, cellHeight-1 )];
        l.font = [UIFont systemFontOfSize:13.0f];
        l.text = [title_p objectAtIndex:0] ;
        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
        l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(0, -0.5);
        l.textAlignment = UITextAlignmentCenter;
        [detailView addSubview:l];
        [l release];
        //二层标题....
        for (int i=1; i<[title_p count]; i++) {
            int columnWidth=[[wight_p objectAtIndex:i] integerValue];
            l = [[UILabel alloc] initWithFrame:CGRectMake(columOffset, cellHeight, columnWidth-1, cellHeight-1 )];
            l.font = [UIFont systemFontOfSize:13.0f];
            l.text = [title_p objectAtIndex:i] ;
            l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
            l.textColor = [UIColor whiteColor];
            l.shadowColor = [UIColor blackColor];
            l.shadowOffset = CGSizeMake(0, -0.5);
            l.textAlignment = UITextAlignmentCenter;
            [detailView addSubview:l];
            [l release];
            
            columOffset+=columnWidth;
        }
        
        //数据填充
        columOffset=0;
        
        for (int i=0; i<[date_p1 count]; i++) {
            NSMutableArray *rowdate=[date_p1 objectAtIndex:i];
            for (int t=0; t<[rowdate count]; t++) {
                
                int columnWidth=[[wight_p objectAtIndex:t+1] integerValue];
                
                l = [[UILabel alloc] initWithFrame:CGRectMake(columOffset, i*cellHeight+cellHeight*2, columnWidth-1, cellHeight-1 )];
                l.font = [UIFont systemFontOfSize:13.0f];
                l.text = [rowdate objectAtIndex:t] ;
                
                //l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
                if(i % 2 == 0)
                    l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                else
                    l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                
                l.textColor = [UIColor whiteColor];
                l.shadowColor = [UIColor blackColor];
                l.shadowOffset = CGSizeMake(0, -0.5);
                l.textAlignment = UITextAlignmentCenter;
                [detailView addSubview:l];
                [l release];
                
                columOffset+=columnWidth;
            }
        }
        
        detail.view= detailView;
        //设置待显示控制器的范围
        [detail.view setFrame:CGRectMake(0,0, totalWight, totalHeight )];
        //设置待显示控制器视图的尺寸
        detail.contentSizeForViewInPopover = CGSizeMake(totalWight, totalHeight);
        //初始化弹出窗口
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:detail];
        self.poper = pop;
        self.poper.delegate = self;
        //设置弹出窗口尺寸
        self.poper.popoverContentSize = CGSizeMake(totalWight, totalHeight);
        //显示，其中坐标为箭头的坐标以及尺寸 0 可去掉箭头
        [self.poper presentPopoverFromRect:CGRectMake(512,420,0, 0) inView:self.view permittedArrowDirections:0 animated:YES];
        [detail  release];
        [pop release ];
        [detailView release];
        
        
        [wight_p release];
        [title_p     release];
       
        
    }
}




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
    
   CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    float columnOffset = 0.0;
    int cellHeight=40;
    NSArray *rowData = [source.data objectAtIndex:indexPath.row];
    NSString *strMonthFactory1=[rowData  objectAtIndex:0];
  
    
        for(int column=0;column<[rowData count];column++){
            
            float columnWidth = [[source.columnWidth objectAtIndex:column] floatValue];
            if (   column==[rowData count]-1  &&[[rowData  objectAtIndex:[rowData count]-1] count]!=0) {
                   NSMutableArray *dateArr=[rowData  objectAtIndex:[rowData count]-1];
                  
                
                       if ([strMonthFactory1 isEqualToString:[NSString stringWithFormat:@"%@",@"月"]]) {
                           NSLog(@"当前 cell行=====================================【%d】",indexPath.row);                           UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom ];
                           b.titleLabel.font=[UIFont systemFontOfSize:14.0f];
                           b.frame = CGRectMake(columnOffset, 0 , columnWidth-1, cellHeight -1 );
                           if(indexPath.row % 2 == 0)
                               b.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                           else
                               b.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                           
                           [b setTitle:@"月执行情况" forState:UIControlStateNormal];
                           b.titleLabel.textAlignment=UITextAlignmentCenter;

                           
                           
                                                    
                
                           
                           
                          //传递 键值
                          //======================能不能释放==========
                           NSMutableArray *date1=[[NSMutableArray alloc] init];
                           [date1 removeAllObjects];
                           
                           
                           
                          [date1   addObject:[NSString stringWithFormat:@"%f",cellRect.origin.y-[tableView contentOffset].y]];
                           
                         
                           
                           [date1 addObject:dateArr]; 
                           [b setTag: (int)date1 ];
                           [b addTarget:self  action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
                           [cell addSubview:b];
                            //======================能不能释放==========
                          // [b release];
                           
                           
                           
                       }else
                       {
                           
                           if ([[dateArr objectAtIndex:1] count]>0) {
                               
                             //  NSLog(@"日历........");
                               UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom ];
                               b.titleLabel.font=[UIFont systemFontOfSize:14.0f];
                               b.frame = CGRectMake(columnOffset, 0 , columnWidth-1, cellHeight -1 );
                               if(indexPath.row % 2 == 0)
                                   b.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                               else
                                   b.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                               [b setTitle:@"日历" forState:UIControlStateNormal];
                               b.titleLabel.textAlignment=UITextAlignmentCenter;
                               
                               //======================能不能释放==========
                              NSMutableArray *date1=[[NSMutableArray alloc] init];
                               
                               [date1   removeAllObjects];
                               
                              [date1   addObject:[NSString stringWithFormat:@"%f",cellRect.origin.y-[tableView contentOffset].y]];
                               
                            
                               
                               
                               [date1 addObject:dateArr];
                               [b setTag: (int) date1];
                               [b addTarget:self  action:@selector(butClick1:) forControlEvents:UIControlEventTouchUpInside];
                               [cell addSubview:b];
                               
                               //======================能不能释放==========
                             //  [b release];
                               
                           }else
                           {
                               
                               
                               UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0  , columnWidth-1, cellHeight -1 )];
                               l.font = [UIFont systemFontOfSize:14.0f];
                               l.text =@"";
                               l.textAlignment = UITextAlignmentCenter;
                               l.tag = indexPath.row * cellHeight + column + 1000;
                               if(indexPath.row % 2 == 0)
                                   l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                               else
                                   l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                               [cell addSubview:l];
                               [l release];
                           }
                       }
                       
                       columnOffset += columnWidth;
                
            }else
            {
                
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0  , columnWidth-1, cellHeight -1 )];
                l.font = [UIFont systemFontOfSize:14.0f];
            
                if (column==[rowData count]-1) {
                 l.text =@"";
                }
                else
                {
                    if ([[rowData objectAtIndex:0] isEqualToString:@"月"]) 
                         l.text =@"";
                    else
                   
                    l.text = [rowData objectAtIndex:column];
                    
                }

                l.textAlignment = UITextAlignmentCenter;
                l.tag = indexPath.row * cellHeight + column + 1000;
                if(indexPath.row % 2 == 0)
                    l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                else
                    l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                
                [cell addSubview:l];
                [l release];
                
            }
            columnOffset += columnWidth; 
        }
   

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:15.0/255 green:43.0/255 blue:64.0/255 alpha:1];
    
    
    
    
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}






-(void)butClick1:(id)sender
{
    
    [self.listTableview resignFirstResponder];
    
    
       NSMutableArray *dateArr;
      clickbutton=1;

    
    [date_p removeAllObjects ];
    [datedic removeAllObjects];
    [days removeAllObjects  ];

 NSLog(@"butClick1===============================");
 NSMutableArray *dateTag=(NSMutableArray *)[sender  tag];
    
    //float  y=[[dateTag objectAtIndex:0] integerValue];
    float  y=200;
    float x=642;
    
    
    //float x=[sender frame   ].origin.x;
    
    
    
    
    
    [pmCC.view removeFromSuperview];
    CGSize defaultSize = (CGSize){300, 250};
    //数据
    
  NSString * dateStr=[[dateTag objectAtIndex:1] objectAtIndex:0];
    
     //=================================计划详细 数据=======================================
    [date_p addObject:[[dateTag objectAtIndex:1] objectAtIndex:2]];
    [date_p addObject:[[dateTag objectAtIndex:1] objectAtIndex:0]];
   // NSLog(@"==============================计划详细 数据=======%d",[date_p count]);


 //=================================执行情况 数据=======================================
    NSMutableArray *sub=[[dateTag objectAtIndex:1] objectAtIndex:1];
    
    // NSLog(@"==============================执行情况 数据=======%d",[sub count]);
    [days addObject:@"H"];
    if([sub count]>0){
        if([sub count]==3){ 
            dateArr=[[NSMutableArray alloc] init];
            NSMutableArray *ddd=[[NSMutableArray alloc] init];
             [ddd addObject:[sub objectAtIndex:2]];
            if ([[[sub objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"P"]) {
                
                 [ddd addObject:[[sub    objectAtIndex:1] substringFromIndex:1] ];
                [ddd addObject:@"" ];
            }
            
            if ([[[sub objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"S"]) {
                
                [ddd addObject:@"" ];
                [ddd addObject:[[sub    objectAtIndex:1] substringFromIndex:1] ];
                
            }
            [dateArr addObject:ddd];
            [ddd release];
            
            [datedic setValue:dateArr forKey:[NSString stringWithFormat:@"%@",[[sub objectAtIndex:0] substringToIndex:[[sub objectAtIndex:0] length]-1]]];
            
        }
        if ([sub count]>3) {
            dateArr=[[NSMutableArray alloc] init];
            NSMutableArray *ddd=[[NSMutableArray alloc] init];
            [ddd addObject:[sub objectAtIndex:2]];
            
            
            if ([[[sub objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"S"]) {
                
                 [ddd addObject:[[sub    objectAtIndex:4] substringFromIndex:1] ];
                [ddd addObject:[[sub    objectAtIndex:1] substringFromIndex:1] ];
                
            }
            if ([[[sub objectAtIndex:1] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"P"]) {
                
               
                [ddd addObject:[[sub    objectAtIndex:1] substringFromIndex:1] ];
                 [ddd addObject:[[sub    objectAtIndex:4] substringFromIndex:1] ];
            }

            
            [dateArr addObject:ddd];
            [ddd release];
            
            [datedic setValue:dateArr forKey:[NSString stringWithFormat:@"%@",[[sub objectAtIndex:3] substringToIndex:[[sub objectAtIndex:3] length]-1]]];
            
            
            [datedic setValue:dateArr forKey:[NSString stringWithFormat:@"%@",[[sub objectAtIndex:0] substringToIndex:[[sub objectAtIndex:0] length]-1]]];
            
            
        }
         [dateArr release];
        for (int i=0; i<[sub count]; i++) {
            if ([sub count]>0) {
                if (i%3==0) {
                     [days addObject:[sub objectAtIndex:i]];
                }
                
            }
        }
    }
    

   
    
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyyMM01 00:00:00 +0000"];
    NSDate *a=[f dateFromString:dateStr];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    dateStr=  [f stringFromDate:[[NSDate alloc]initWithTimeInterval:8*60*60 sinceDate:a]];
     
    
    pmCC = [[PMCalendarController alloc]init];
    [pmCC reinitializeWithSize:dateStr:defaultSize:days];
    pmCC.delegate = self;
    pmCC.mondayFirstDayOfWeek = YES;
    
    [pmCC presentCalendarFromRect:CGRectMake(x,y, 0, 0)
                           inView:listView
         permittedArrowDirections:PMCalendarArrowDirectionAny
                         animated:YES];
    
    [f release];
   
}




-(void)butClick:(id)sender
{
 [days removeAllObjects];
    clickbutton=0;
    NSLog(@"butClick====================================================================");
    NSMutableArray *dateTag=(NSMutableArray *)[sender  tag];
   // NSLog(@"b   tag =============================[%d]",[[dateTag objectAtIndex:0] integerValue]);
   NSMutableSet *set=[[NSMutableSet alloc] init];
      NSString *dateStr1=@"";
    for (int i=0; i<[[dateTag objectAtIndex:1] count]; i++) {
        NSMutableArray *subM=[[[dateTag objectAtIndex:1]    objectAtIndex:i] objectAtIndex:1] ;      
         if ([subM count]>0) {
            for (int t=0; t<[subM count]; t++) {
                if (t%3==0) {
                   // NSLog(@"检索日期%@",[subM objectAtIndex:t]);
                    [set addObject:[subM objectAtIndex:t]];
                }
            }
             
             
         }
    }
     dateStr1=[[[dateTag objectAtIndex:1]    objectAtIndex:0] objectAtIndex:0];
  //  NSLog(@"dateStr1=======================================%@",dateStr1);
    
    [days addObject:@"T"];
    
    for (NSObject *obj in set) {
        [days addObject:obj];
       // NSLog(@"%@",obj);
    }

   //float  y=[[dateTag objectAtIndex:0] integerValue];
   //float x=[sender frame   ].origin.x;
    
    
    float  y=200;
    float x=642;
    
    
    
    [pmCC.view removeFromSuperview];
    CGSize defaultSize = (CGSize){300, 250};
    
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyyMM01 00:00:00 +0000"];
    NSDate *a=[f dateFromString:dateStr1];
    [f setDateFormat:@"yyyy-MM-dd"];
    dateStr1=  [f stringFromDate:[[NSDate alloc]initWithTimeInterval:8*60*60 sinceDate:a]];
    [f setDateFormat:@"MM"];
   if ([[dateStr1 substringWithRange:NSMakeRange(0, 7)] integerValue]==[[f stringFromDate:[NSDate date]] integerValue])
   {
       [f setDateFormat:@"yyyy-MM-dd"];
       dateStr1=[f stringFromDate:[NSDate date]];
   }
    
    
    
    
    
    
    
    pmCC = [[PMCalendarController alloc]init];
    [pmCC reinitializeWithSize:dateStr1:defaultSize:days];
    pmCC.delegate = self;
    pmCC.mondayFirstDayOfWeek = YES;
    
    [pmCC presentCalendarFromRect:CGRectMake(x,y, 0, 0)
                           inView:listView
         permittedArrowDirections:PMCalendarArrowDirectionAny
                         animated:YES];
    [f release];
     [set release];    
}












- (IBAction)ComSelect:(id)sender {
    
    if (self.poper.popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
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
    self.poper = pop;
    self.poper.delegate = self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper presentPopoverFromRect:CGRectMake(187, 32, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
}


- (IBAction)ShipSelect:(id)sender {
    if (self.poper.popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
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
    self.poper = pop;
    self.poper.delegate = self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper presentPopoverFromRect:CGRectMake(387, 32, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
}

- (IBAction)FacotorySelect:(id)sender {
    if (self.poper.popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
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
    self.poper = pop;
    self.poper.delegate = self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper presentPopoverFromRect:CGRectMake(587, 32, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
}


- (IBAction)PortSelect:(id)sender {
    if (self.poper.popoverVisible) {
        [self.poper   dismissPopoverAnimated:YES];
    }
    chooseView=[[ChooseView  alloc] init];
    [chooseView .view setFrame:CGRectMake(0, 0, 125, 400)  ];
    chooseView.contentSizeForViewInPopover=CGSizeMake(125, 400);
    UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:chooseView];
    chooseView.popover=pop;
    NSMutableArray *Array=[[NSMutableArray alloc] init];
    chooseView.iDArray=Array;
    [chooseView.iDArray addObject:All_];
    
    NSMutableArray *array=[TgPortDao getTgPort];
    for (int i=0; i<[array count]; i++) {
        TgPort *tgPort=[array objectAtIndex:i];
        [chooseView.iDArray addObject:tgPort.portName];
    }
    chooseView.parentMapView=self;
    chooseView.type=kPORT;
    self.poper=pop;
    self.poper.delegate=self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper presentPopoverFromRect:CGRectMake(787, 32, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
    
    
    
    
    
}


- (IBAction)SupSelect:(id)sender {
    if (self.poper.popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
    }
    
    //初始化多选控制器
    chooseView=[[ChooseView alloc]init];
    //设置待显示控制器的范围
    [chooseView.view setFrame:CGRectMake(0,0, 125, 400)];
    //设置待显示控制器视图的尺寸
    chooseView.contentSizeForViewInPopover = CGSizeMake(125, 400);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:chooseView];
    chooseView.popover = pop;
    NSMutableArray *SupplierArray=[[NSMutableArray alloc]init];
    chooseView.iDArray=SupplierArray;
    [chooseView.iDArray addObject:All_];
    NSMutableArray *array=[TfSupplierDao getTfSupplier];
    for(int i=0;i<[array count];i++){
        TfSupplier *tfSupplier=[array objectAtIndex:i];
        [chooseView.iDArray addObject:tfSupplier.SUPPLIER]; 
    }
    chooseView.parentMapView=self;
    chooseView.type=kSUPPLIER;
    self.poper = pop;
    self.poper.delegate = self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(125, 800);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper presentPopoverFromRect:CGRectMake(987, 32, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [SupplierArray release];
}


- (IBAction)CoalTypeSelect:(id)sender {
    if (self.poper .popoverVisible) {
        [self.poper  dismissPopoverAnimated:YES];
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
    self.poper  = pop;
    self.poper .delegate = self;
    //设置弹出窗口尺寸
    self.poper .popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper  presentPopoverFromRect:CGRectMake(187, 80, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];
    

}

- (IBAction)TypeSelect:(id)sender {
    if (self.poper.popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
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
    chooseView.type=kTypeValue;
    self.poper = pop;
    self.poper.delegate = self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(125, 400);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.poper presentPopoverFromRect:CGRectMake(387, 80, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];

}


- (IBAction)startMonth:(id)sender {
    whichButton=1;
    NSLog(@"startmonth。。。。。");
    if (self.poper .popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
    }
    if(!monthCV)
        monthCV=[[DateViewController alloc] init];
    [monthCV .view setFrame:CGRectMake(0, 0, 175, 216)];
    monthCV.contentSizeForViewInPopover=CGSizeMake(175, 216);
    UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:monthCV];
    monthCV.popover=pop;//没什么用？
    monthCV.selectedDate=self.month;//初始化  属性[[NSDate alloc] init];  也可以不用他来初始化
    self.poper=pop;
    self.poper.delegate=self;
    self.poper.popoverContentSize=CGSizeMake(175, 216);
    [self.poper presentPopoverFromRect:CGRectMake(587, 80, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [pop release];
}



- (IBAction)endMonth:(id)sender {
    whichButton=2;
    NSLog(@"endmonth。。。。。");
    if (self.poper .popoverVisible) {
        [self.poper dismissPopoverAnimated:YES];
    } 
    if(!monthCV)
        monthCV=[[DateViewController alloc] init];
    [monthCV .view setFrame:CGRectMake(0, 0, 175, 216)];
    monthCV.contentSizeForViewInPopover=CGSizeMake(175, 216);
    
    UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:monthCV];
    monthCV.popover=pop;//没什么用？
    monthCV.selectedDate=self.month;//初始化  属性[[NSDate alloc] init];  也可以不用他来初始化
    self.poper=pop;
    self.poper.delegate=self;
    self.poper.popoverContentSize=CGSizeMake(175, 216);
    [self.poper presentPopoverFromRect:CGRectMake(787, 80, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [pop release];

}




- (IBAction)realse:(id)sender {
    self.comLabel.text=All_;
    self.comLabel.hidden=YES;
    [self.comButton  setTitle:@"航运公司" forState:UIControlStateNormal ];
    
    self.shipLabel.text=All_;
    self.shipLabel.hidden=YES;
    [self.shipButton setTitle:@"船名" forState:UIControlStateNormal   ];
    
    self.factoryLabel.text=All_;
    self.factoryLabel.hidden=YES;
    [self.factoryButton  setTitle:@"流向" forState:UIControlStateNormal ];
    
    self.portLabel.text=All_;
    self.portLabel.hidden=YES;
    [self.portButton  setTitle:@"装运港" forState:UIControlStateNormal ];
    
    self.typeLabel.text=All_;
    self.typeLabel.hidden=YES;
    [self.typeButton setTitle:@"类型" forState:UIControlStateNormal    ];
    
    self.coalTypeLabel.text=All_;
    self.coalTypeLabel.hidden=YES;
    [self.coalTypeButton setTitle:@"煤种" forState:UIControlStateNormal    ];
    
    
    self.supLable.text=All_;
    self.supLable.hidden=YES;
    [self.supButton setTitle:@"供货方" forState:UIControlStateNormal   ];
    
    
    self.startTime.text=All_;
    self.startTime.hidden=YES;
    [self.startButton setTitle:@"开始时间" forState:UIControlStateNormal];
    
    self.endTime.text=All_;
    self.endTime.hidden=YES;
    [self.endButton setTitle:@"结束时间" forState:UIControlStateNormal];

}



- (IBAction)reloadData:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间"  delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步", nil];
    
    [alert show];
    [alert release];
    

}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==1) {
        [self.view addSubview:active];
        [reload setTitle:@"同步中...." forState:UIControlStateNormal];
        [active startAnimating];
   
        
        
        //解析入库
        [xmlParser setISoapNum:3];
        [xmlParser requestSOAP:@"ShipTrans"];
        [xmlParser requestSOAP:@"TransPlan"];
        [xmlParser requestSOAP:@"TfShip"];
        
        
        //
              //状态 
        [self runActivity];
       
    }
}







-(void)dealloc
{
    [model release];
    [comLabel release];
    [shipLabel release];
    [factoryLabel release];
    [typeLabel release];
    [supLable release];
    [startTime release];
    [endTime release];
    [comButton release];
    [shipButton release];
    [factoryButton release];
    [typeButton release];
    [supButton release];
    [startButton release];
    [endButton release];
    [reload release];
    [active release];
    [poper   release];
    [coalTypeButton release];
    [coalTypeLabel release];
    [portButton release];
    [portLabel release];
    [xmlParser release];
    [month release];
    [monthCV release];
    [chooseView  release];

    
    
    
    if (source) {
         [source release];
    }
    [listView release];
    [columnWidth1 release];
    if (pmCC) {
        [pmCC release];
    }

    
    
    
    if (d) 
        [d release];
    if (days) 
        [days release];
    if(dateArr)
        [dateArr release  ];
    if (date_p  )
        [date_p   release];
   
 
    if (datedic)
        [datedic release];
   

    
    [listTableview release];
    [TitleView release];
    [dcView release];
    [listView release];
    [super dealloc];
}




- (void)viewDidUnload
{
    [self setDcView:nil];
    [self setListView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
    [self setComLabel:nil];
    [self setShipLabel:nil];
    [self setFactoryLabel:nil];
    [self setPortLabel:nil];
    [self setCoalTypeLabel:nil];
    
    [self setTypeLabel:nil];
    [self setSupLable:nil];
    
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setComButton:nil];
    [self setShipButton:nil];
    [self setFactoryButton:nil];
    [self setCoalTypeButton:nil];
    [self setPortButton:nil];
    [self setTypeButton:nil];
    [self setSupButton:nil];
    [self setStartButton:nil];
    [self setEndButton:nil];
    [self setReload:nil];
    [self setActive:nil];
    
    
    [listTableview release];
    [TitleView release];
    
    [model release];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}





#pragma  mark  poper delegate Method
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    
    if (monthCV) {
        self.month=monthCV.selectedDate;
    }
    return YES;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy"];
    NSDateFormatter *formater1=[[NSDateFormatter alloc] init];
    [formater1 setDateFormat:@"MM"];
    if (whichButton==1) {
        startTime.text=   [NSString stringWithFormat:@"%@%@",[formater stringFromDate:month],[formater1 stringFromDate:month]];
        
        
        
        startTime.hidden=NO;
        [startButton setTitle:@"" forState:UIControlStateNormal ];
        whichButton=0;
    }else if (whichButton==2) {
        endTime.text= [NSString stringWithFormat:@"%@%@",[formater stringFromDate:month],[formater1 stringFromDate:month]];
        endTime.hidden=NO;
        [endButton setTitle:@"" forState:UIControlStateNormal ];
        whichButton=0;
    }
    [formater   release];
    [formater1   release];
}
#pragma mark activity
-(void)runActivity
{
    if ([xmlParser iSoapNum]==0) {
        [active stopAnimating];
        [active removeFromSuperview];
        [reload setTitle:@"网络同步" forState:UIControlStateNormal];
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
            self.comLabel.text=currentSelectValue;
            
            
            if (![self.comLabel.text isEqualToString:All_]) {
                self.comLabel.hidden=NO;
                [self.comButton setTitle:@"" forState:UIControlStateNormal];
                
            }else {
                self.comLabel.hidden=YES;
                [self.comButton setTitle:@"航运公司" forState:UIControlStateNormal];
            }
            
            
        }
        if (chooseView.type==kChSHIP) {
            self.shipLabel.text=currentSelectValue;
            if (![self.shipLabel.text isEqualToString:All_]) {
                self.shipLabel.hidden=NO;
                [self.shipButton setTitle:@"" forState:UIControlStateNormal];
                
                
                
            }else {
                self.shipLabel.hidden=YES;
                [self.shipButton setTitle:@"船名" forState:UIControlStateNormal];
            }
            
        }
        
        if (chooseView.type==kPORT) {
            self.portLabel.text=currentSelectValue;
            if (![self.portLabel.text isEqualToString:All_]) {
                self.portLabel.hidden=NO;
                [self.portButton setTitle:@"" forState:UIControlStateNormal]; 
            }else {
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
                [ self.factoryButton setTitle:@"流向" forState:UIControlStateNormal];
            }
        }
        if (chooseView.type==kTypeValue) {
            self.typeLabel.text=currentSelectValue;
            if (![self.typeLabel.text isEqualToString:All_]) {
                self.typeLabel.hidden=NO;
                [self.typeButton setTitle:@"" forState:UIControlStateNormal];
            }else {
                self.typeLabel.hidden=YES;
                [self.typeButton   setTitle:@"类型" forState:UIControlStateNormal];
            }
            
        }
        if (chooseView.type==kCOALTYPE) {
            self.coalTypeLabel.text=currentSelectValue;
            if (![self.coalTypeLabel.text isEqualToString:All_]) {
                self.coalTypeLabel.hidden=NO;
                [self.coalTypeButton setTitle:@"" forState:UIControlStateNormal];
                
                
            }else {
                self.coalTypeLabel.hidden=YES;
                [self.coalTypeButton   setTitle:@"煤种" forState:UIControlStateNormal];
            }
            
        }
        if (chooseView.type==kSUPPLIER) {
            self.supLable.text=currentSelectValue;
            if (![self.supLable.text isEqualToString:All_]) {
                self.supLable.hidden=NO;
                [self.supButton     setTitle:@"" forState:UIControlStateNormal];
            }else {
                self.supLable  .hidden=YES;
                [self.supButton setTitle:@"供货方" forState:UIControlStateNormal  ];
            }
            
        }

        
    }
}


#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    
    NSLog(@"clickbutton [%d]",clickbutton);
  
    if (clickbutton==1) {
 
        NSLog(@"  =======时间改变===a[]==== ");
        NSString *currentSelect=   [NSString stringWithFormat:@"%@"
                                    , [newPeriod.startDate dateStringWithFormat:@"yyyy-MM-dd"]
                                    ];
        NSInteger DD= [[currentSelect    substringFromIndex:8] integerValue];
        NSInteger mm=[[currentSelect substringWithRange:NSMakeRange(5, 2)] integerValue];
           
     NSMutableArray *   date=[datedic objectForKey:[NSString stringWithFormat:@"%d",DD]];
      //  NSLog(@"当前日期 共有======计划详细=======%d=============【%d】条数据==========%@",[[date_p objectAtIndex:0] count],[date_p count],[date_p objectAtIndex:1]);
        if ([date_p count]>0) {
            for (int  a=0; a<[[date_p objectAtIndex:0] count]; a++) {
                // NSLog(@"====================%@",[[date_p objectAtIndex:0] objectAtIndex:a]);
            }
        }
        
      //   NSLog(@"=======当前计划月份== 月===========%@",[date_p objectAtIndex:1] );
        
       int  Month=0;
        
        if ([date_p count]>1) {
            if ([[date_p objectAtIndex:1]length]>0) {
                Month=[[[date_p  objectAtIndex:1] substringFromIndex:5] integerValue];
                // NSLog(@"=======当前计划月份===Month==========%d",Month );
            }
        }
        
       // NSLog(@"=======mm====%d==========Month==%d",mm,Month);
        if ([date count]>0&&mm==Month&&mm!=0&&Month!=0) {   
        int cellHeight=40;
        int totalHeight=0;
        int totalWight=430;
        int columOffset=0;
            if ([date count]>0) {
                totalHeight=([date count]+([date_p count]-1)+4)*cellHeight;
            }else
            {
             totalHeight=(([date_p count]-1)+4)*cellHeight;
            }
        UIViewController *detail=[[UIViewController alloc] init];
        UIView *detailView=[[UIView  alloc ] initWithFrame:CGRectMake(0, 0, totalWight, totalHeight)];
         
  NSMutableArray*title_p=[[NSMutableArray alloc] initWithObjects:@"航运计划",@"船名",@"预抵装港",@"预抵卸港" ,@"煤种",@"热值",@"硫分",nil];
  NSMutableArray *wight_p=[[NSMutableArray alloc] initWithObjects:@"430",@"85",@"85",@"85",@"75",@"50" ,@"50"  , nil];
        //计划 标题  填充
        //一层标题
        UILabel *l;
        l = [[UILabel alloc] initWithFrame:CGRectMake(columOffset, 0, totalWight-1, cellHeight-1 )];
        l.font = [UIFont systemFontOfSize:13.0f];
        l.text = [title_p objectAtIndex:0] ;
        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
        l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(0, -0.5);
        l.textAlignment = UITextAlignmentCenter;
        [detailView addSubview:l];
        [l release];
        //二层标题....
        for (int i=1; i<[title_p count]; i++) {
            int columnWidth=[[wight_p objectAtIndex:i] integerValue];
            l = [[UILabel alloc] initWithFrame:CGRectMake(columOffset, cellHeight, columnWidth-1, cellHeight-1 )];
            l.font = [UIFont systemFontOfSize:13.0f];
            l.text = [title_p objectAtIndex:i] ;
            l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
            l.textColor = [UIColor whiteColor];
            l.shadowColor = [UIColor blackColor];
            l.shadowOffset = CGSizeMake(0, -0.5);
            l.textAlignment = UITextAlignmentCenter;
            [detailView addSubview:l];
            [l release];
            
            columOffset+=columnWidth;
        }
        
        //数据填充
        columOffset=0;
        
        for (int i=0; i<([date_p count]-1); i++) {
            NSMutableArray *rowdate=[date_p objectAtIndex:i];
            for (int t=0; t<[rowdate count]-1; t++) {
                
                int columnWidth=[[wight_p objectAtIndex:t+1] integerValue];
                
                l = [[UILabel alloc] initWithFrame:CGRectMake(columOffset, i*cellHeight+cellHeight*2, columnWidth-1, cellHeight-1 )];
                l.font = [UIFont systemFontOfSize:13.0f];
                l.text = [rowdate objectAtIndex:t] ;
                
                //l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
                if(i % 2 == 0)
                    l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                else
                    l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                
                
                l.textColor = [UIColor whiteColor];
                l.shadowColor = [UIColor blackColor];
                l.shadowOffset = CGSizeMake(0, -0.5);
                l.textAlignment = UITextAlignmentCenter;
                [detailView addSubview:l];
                [l release];
                
                columOffset+=columnWidth;
            }
        }

   //执行情况 数据 填充............
 
            if ([date  count]>0) {
                
                NSMutableArray*title=[[NSMutableArray alloc] initWithObjects:@"航运计划执行情况明细",@"船名",@"计划载量",@"实际载量", nil];
                NSMutableArray *wight=[[NSMutableArray alloc] initWithObjects:@"430",@"130",@"150",@"150", nil];
                int heightOffset=([date count]+2)*cellHeight;
                columOffset=0;
                //一层标题
                l = [[UILabel alloc] initWithFrame:CGRectMake(columOffset, heightOffset, totalWight-1, cellHeight-1 )];
                l.font = [UIFont systemFontOfSize:13.0f];
                l.text = [title objectAtIndex:0] ;
                l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
                l.textColor = [UIColor whiteColor];
                l.shadowColor = [UIColor blackColor];
                l.shadowOffset = CGSizeMake(0, -0.5);
                l.textAlignment = UITextAlignmentCenter;
                [detailView addSubview:l];
                [l release];
                //二层标题....
                for (int i=1; i<[title count]; i++) {
                    int columnWidth=[[wight objectAtIndex:i] integerValue];
                    
                    l = [[UILabel alloc] initWithFrame:CGRectMake(columOffset, heightOffset+cellHeight, columnWidth-1, cellHeight-1 )];
                    l.font = [UIFont systemFontOfSize:13.0f];
                    l.text = [title objectAtIndex:i] ;
                    l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
                    l.textColor = [UIColor whiteColor];
                    l.shadowColor = [UIColor blackColor];
                    l.shadowOffset = CGSizeMake(0, -0.5);
                    l.textAlignment = UITextAlignmentCenter;
                    [detailView addSubview:l];
                    [l release];
                    
                    columOffset+=columnWidth;
                }
                //数据填充
                columOffset=0;
                for (int i=0; i<[date count]; i++) {
                    NSMutableArray *rowdate=[date objectAtIndex:i];
                    for (int t=0; t<[rowdate count]; t++) {
                        
                        int columnWidth=[[wight objectAtIndex:t+1] integerValue];
                        
                        l = [[UILabel alloc] initWithFrame:CGRectMake(columOffset, i*cellHeight+heightOffset+cellHeight*2, columnWidth-1, cellHeight-1 )];
                        l.font = [UIFont systemFontOfSize:13.0f];
                        l.text = [rowdate objectAtIndex:t] ;
                        if(i % 2 == 0)
                            l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                        else
                            l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                        l.textColor = [UIColor whiteColor];
                        l.shadowColor = [UIColor blackColor];
                        l.shadowOffset = CGSizeMake(0, -0.5);
                        l.textAlignment = UITextAlignmentCenter;
                        [detailView addSubview:l];
                        [l release];
                        columOffset+=columnWidth;
                    }
                }
                
                // [date release];
                [wight release];
                [title release];
            }

        
           
    detail.view= detailView;
    //设置待显示控制器的范围
    [detail.view setFrame:CGRectMake(0,0, totalWight, totalHeight )];
    //设置待显示控制器视图的尺寸
    detail.contentSizeForViewInPopover = CGSizeMake(totalWight, totalHeight);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:detail];
    self.poper = pop;
    self.poper.delegate = self;
    //设置弹出窗口尺寸
    self.poper.popoverContentSize = CGSizeMake(totalWight, totalHeight);
    //显示，其中坐标为箭头的坐标以及尺寸 0 可去掉箭头
    [self.poper presentPopoverFromRect:CGRectMake(395,450,0, 0) inView:self.view permittedArrowDirections:0 animated:YES];
    [detail  release];
       [pop release ];
    [detailView release];     
        [wight_p release];
        [title_p     release];
      
    } 
        
    }
 
 }
    
@end
