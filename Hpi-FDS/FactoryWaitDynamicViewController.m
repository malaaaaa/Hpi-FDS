//
//  FactoryWaitDynamicViewController.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-27.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "FactoryWaitDynamicViewController.h"
#import "MultiTitleDataGridComponent.h"
#import "FactoryWaitHeadTable.h"
#import "FactoryWaitFootTable.h"
#import "TF_FACTORYCAPACITYDao.h"
#import "TF_FACTORYCAPACITY.h"
#import "FactoryWaitDynamicDao.h"
#import "TB_OFFLOADFACTORYDao.h"
#import "TB_OFFLOADSHIPDao.h"

#import "TfShipDao.h"
@interface FactoryWaitDynamicViewController ()

@end

@implementation FactoryWaitDynamicViewController
@synthesize scrool;
@synthesize dcView;


@synthesize activty;
@synthesize tbxmlParser;
@synthesize startButton;
@synthesize startTime;
@synthesize factoryButton;
@synthesize factoryLable;
@synthesize chooseView;
@synthesize month;
@synthesize monthVC;
@synthesize popover;
@synthesize reload;
@synthesize ds;
@synthesize listTableview;
@synthesize TitleView;
@synthesize source;   ;


NSMutableArray *data1;
NSMutableArray *columWidth1;

static  NSMutableArray *columnWidthFTitle;
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
    // Do any additional setup after loading the view from its nib.
    month=[[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter stringFromDate:month]; 
    self.factoryLable.text=@"玉环";
    [self.factoryButton setTitle:@"玉环" forState:UIControlStateNormal];
     self.startTime.text=[dateFormatter  stringFromDate:[NSDate date]];
    self.tbxmlParser=[[TBXMLParser alloc] init] ;
    [activty removeFromSuperview];
    self.factoryLable.hidden=YES;
    
   
    //为视图增加边框
    dcView.layer.masksToBounds=YES;
    dcView.layer.cornerRadius=2.0;
    dcView.layer.borderWidth=2.0;
    dcView.layer.borderColor=[[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]CGColor];
    dcView.backgroundColor=[UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
    
   // dcView.center=CGPointMake(512,352);//修改
    
    cView.layer.masksToBounds=YES;
    cView.layer.cornerRadius=2.0;
    cView.layer.borderWidth=2.0;
    cView.layer.borderColor=[UIColor blackColor].CGColor;
    cView.backgroundColor=[UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    [listTableview setSeparatorColor:[UIColor clearColor]];
    listTableview.backgroundColor = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    
    
    
    
    
    
   
   int totalWidth1=0; 
    //初始中间表格
    ds=[[DataGridScrollView alloc] initWithFrame:CGRectMake(0, 0, self.scrool.frame.size.width, self.scrool.frame.size.height)];
    ds.pagingEnabled=NO;
    ds.delegate=self;
    columWidth1=[[NSMutableArray alloc] initWithObjects:@"150",@"220",@"140",@"90",@"150",@"150",@"150",@"100",@"150",@"120", nil];
    for (int i=0; i<[columWidth1 count]; i++) {
        totalWidth1+=[[columWidth1    objectAtIndex:i] integerValue];
    }
    CGSize newSize=CGSizeMake(totalWidth1, self.scrool.frame.size.height);
    [ds setContentSize:newSize];

    data1=[[NSMutableArray alloc] initWithObjects:
           [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"", nil],
           [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",nil ],
           [[NSMutableArray alloc] initWithObjects:@"",@"",nil],
           [[NSMutableArray  alloc] initWithObjects:@"",nil],
           nil];
    [self getHeadTable:data1:columWidth1];
    
    
    [self.scrool addSubview:ds];
    /*********************************/
    [self fillTitle];
    [dateFormatter release];
    
}




-(NSMutableArray *)getDateList:(NSDate *)data1
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *minD=[[NSDate alloc] initWithTimeInterval:-(10*24*60*60) sinceDate:data1];
      NSDate *maxD=[[NSDate alloc] initWithTimeInterval:(30*24*60*60) sinceDate:data1]; 
    NSMutableArray *dateList=[[[NSMutableArray alloc] init ] autorelease];
    for (int i=0; i<41; i++) {
        
        NSDate *d;
        d=[[NSDate alloc] initWithTimeInterval:(i*24*60*60) sinceDate:minD];
        if ([d isEqualToDate:maxD]) {
            [dateList addObject:[df stringFromDate:d]];
            break;
        }
       [dateList addObject:[df stringFromDate:d]];
        [d release];
        
    }
    [df release];
    [maxD release];
    [minD release];
    return dateList;

}


-(void)initDC
{ 
    if(!source){
        source=[[MultiTitleDataSource alloc] init   ];
    }
    source.columnWidth=[[NSMutableArray alloc] initWithObjects:@"85",@"85",@"445",@"250",@"165", nil]; 
    source.splitTitle=[[NSMutableArray alloc] initWithObjects:
                       [[NSMutableArray   alloc] initWithObjects:@"潮位+最小水位",@"日耗量(万吨)",@"当日零点账面库存",@"存煤热值/硫分",@"可用天数(天)",nil],
                       [[NSMutableArray    alloc] initWithObjects:@"抵达长江口",@"锚地",@"靠卸",@"完货",@"离港",nil],
                       nil];
    source.titles=[[NSMutableArray alloc] initWithObjects:@"日期",@"计划抵厂船舶", @"电厂供货存情况",@"实际抵厂船舶",@"备注",nil];
}

-(void)fillTitle{
    [self initDC];
    [self  getColument];
    
    [self.TitleView removeFromSuperview];
    
    int cellWidth=[[source.columnWidth objectAtIndex:0] integerValue];
    int cellHeight=40; 
    float columnOffset = cellWidth;
        float set=cellWidth;
    int d=2;
    
    
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth-1, cellHeight*2-1 )];
    l2.font = [UIFont systemFontOfSize:13.0f];
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
        if (column==[source.titles count]-1) {//最后一个标题  备注 
            float columnWidth = [[source.columnWidth objectAtIndex:d] floatValue]; 
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth-1, cellHeight*2-1 )];
            
            l.font = [UIFont systemFontOfSize:13.0f];
            l.text = [source.titles objectAtIndex:column];
            //l.backgroundColor = [UIColor colorWithRed:0.0/255 green:105.0/255 blue:186.0/255 alpha:1];
            l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
            l.textColor = [UIColor whiteColor];
            l.shadowColor = [UIColor blackColor];
            l.shadowOffset = CGSizeMake(0, -0.5);
            l.textAlignment = UITextAlignmentCenter;
            
            [TitleView addSubview:l];
            [l release];
            
        }
        
        if (column!=[source.titles count]-1)
        {
            //父标题 宽度
            int fTitleWidth=[[columnWidthFTitle objectAtIndex:column-1] integerValue];
            UILabel *l;
            if (column==1) {
                l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, fTitleWidth -1, cellHeight*2-1 )];
                l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
                set+=fTitleWidth;
                
            }else
            {
                l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, fTitleWidth -1, cellHeight-1 )];
                l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
            }
            
            
            l.font = [UIFont systemFontOfSize:13.0f];
            l.text = [source.titles objectAtIndex:column];
            //l.backgroundColor = [UIColor colorWithRed:0.0/255 green:105.0/255 blue:186.0/255 alpha:1];
            
            l.textColor = [UIColor whiteColor];
            l.shadowColor = [UIColor blackColor];
            l.shadowOffset = CGSizeMake(0, -0.5);
            l.textAlignment = UITextAlignmentCenter;
            
            [TitleView addSubview:l];
            [l release];
            
            if ((column-2)>=0){
                //循环下一层标题
                NSMutableArray *subTitle=[source.splitTitle objectAtIndex:column-2];
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
                
            }
            columnOffset += fTitleWidth;
            
        }
    }
 
    [self.dcView addSubview:self.TitleView];
 
}







-(void)getColument
{
    NSMutableArray *subTitel=[[NSMutableArray alloc] init ];
   // NSMutableArray *columW=[[NSMutableArray alloc] init ];
    columnWidthFTitle=[[NSMutableArray alloc] init ];
    
    //拆分 成每个单元格的宽度
   // NSLog(@"%d",[source.columnWidth count]);
    
    
    
    for (int i=0; i<[source.columnWidth count]; i++) {
        
        if (i>1&&i!=[source.columnWidth count]-1) {
            //提取  父标题的宽度  数组columnWidth1
            [columnWidthFTitle addObject:[source.columnWidth objectAtIndex:i]];
            
            subTitel=[source.splitTitle objectAtIndex:i-2];
            
            //for (int a=0; a<[subTitel count]; a++) {
               // int cW=[[source.columnWidth objectAtIndex:i]integerValue]/[subTitel count];
               // [columW addObject:[NSString stringWithFormat:@"%d",cW]];
            //}
            
        }else{
            if (i==1) {
                [columnWidthFTitle addObject:[source.columnWidth objectAtIndex:i]];
            }
            
           // [columW addObject:[source.columnWidth objectAtIndex:i]];
        }
    }
   // source.columnWidth=columW;
    source.columnWidth=[[NSMutableArray alloc] initWithObjects:@"85",@"85",@"95",@"80",@"105",@"85",@"80",@"70",@"45",@"45",@"45",@"45",@"165", nil];
    
    
   // [columW release];
}




-(NSMutableArray *)getDcSourseData:(NSString *)factoryName
{
 
    NSMutableArray *date1=[[[NSMutableArray alloc] init ] autorelease];
    TB_OFFLOADFACTORY *tbFactory;//自动释放
    TbFactoryState *state;
    
    NSMutableArray *dateList=[self getDateList:month];
    for (int i=0; i<[dateList  count]; i++) {
        
      //     NSLog(@"--=====================------===========-----[%@]",[dateList objectAtIndex:i ]);
        NSMutableArray *Rowdate=[[NSMutableArray alloc] init];
        NSMutableArray * list_p = [[NSMutableArray alloc] init];
        NSMutableArray * list_a = [[NSMutableArray alloc] init];
        NSMutableArray * list_r =  [[NSMutableArray alloc] init];
        NSMutableArray * list_d = [[NSMutableArray alloc] init];
        NSMutableArray * list_c =  [[NSMutableArray alloc] init];
         //不能释放。。。。自动释放 。tbFactory的属性。。。
        NSMutableArray * list_Ship = [[NSMutableArray alloc] init];
        
        NSMutableArray * list_f =  [[NSMutableArray alloc] init];//完货
        
        NSString *dt=[dateList objectAtIndex:i];
        //添加数据
        [Rowdate addObject:dt];//
        
    
        tbFactory=[TB_OFFLOADFACTORYDao SelectFactoryByCode:factoryName:dt  ];
        state=[TbFactoryStateDao getStateMode:factoryName :dt];
        if (tbFactory.tbShipList!=nil) {
            list_Ship=tbFactory.tbShipList;
         //   NSLog(@"--------===========list_Ship[%d]",[list_Ship count]);
        }
        NSString* facRecode=[tbFactory.RECORDDATE substringWithRange:NSMakeRange(0, 10)];
        //NSLog(@"facRecode----[%@]",facRecode);
        
        if(![facRecode isEqualToString:dt]){
            tbFactory =nil;
        }
        
    for (int k = 0; k < list_Ship.count; k++)
    {
        
        TB_OFFLOADSHIP *ship = [list_Ship objectAtIndex:k];
       
        if ([ship.TYPE  isEqualToString:@"P"])
        {
          
            TB_OFFLOADSHIP *ship_p = [[TB_OFFLOADSHIP alloc] init];
            ship_p.SHIPID = ship.SHIPID;
            ship_p.LW = ship.LW;
            ship_p.HEATVALUE = ship.HEATVALUE;
            ship_p.SULFUR = ship.SULFUR;
            ship_p.DRAFT = ship.DRAFT;
            ship_p.ID = ship.ID;
            ship_p.SUPPLIER = ship.SUPPLIER;
            ship_p.TRADENAME = ship.TRADENAME;
            ship_p.COALTYPE = ship.COALTYPE;
            [list_p addObject:ship_p];
           [ship_p release];
        }
        else if ([ship.TYPE  isEqualToString:@"A"])
        {
            
            TB_OFFLOADSHIP *ship_a = [[TB_OFFLOADSHIP alloc] init];
            ship_a.SHIPID = ship.SHIPID;
            ship_a.LW = ship.LW;
            ship_a.EVENTTIME = ship.EVENTTIME;
            ship_a.ID = ship.ID;
           [list_a addObject:ship_a];
          [ship_a release];
        }
        else if ([ship.TYPE  isEqualToString:@"R"] )
        {
            TB_OFFLOADSHIP *ship_r = [[TB_OFFLOADSHIP alloc] init];
            ship_r.SHIPID = ship.SHIPID;
            ship_r.EVENTTIME = ship.EVENTTIME;
            ship_r.LW = ship.LW;
            ship_r.ID = ship.ID;
            [list_r addObject:ship_r];
           [ship_r release];
        }
        else if ( [ship.TYPE  isEqualToString:@"D"])
        {
             
            TB_OFFLOADSHIP *ship_d = [[TB_OFFLOADSHIP alloc] init];
            ship_d.SHIPID = ship.SHIPID;
            ship_d.EVENTTIME = ship.EVENTTIME;
            ship_d.LW = ship.LW;
            ship_d.ID = ship.ID;
            [list_d addObject:ship_d];
          [ship_d release];
        }
        else if ([ship.TYPE  isEqualToString:@"C"])
        {
              
            TB_OFFLOADSHIP *ship_c =[[TB_OFFLOADSHIP alloc] init];
            ship_c.SHIPID = ship.SHIPID;
            ship_c.EVENTTIME = ship.EVENTTIME;
            ship_c.LW = ship.LW;
            ship_c.ID = ship.ID;
            [list_c addObject:ship_c];
           [ship_c release];
        }
        else if ( [ship.TYPE  isEqualToString:@"F"] )//完货
        {
             
            TB_OFFLOADSHIP *ship_f = [[TB_OFFLOADSHIP alloc] init];
            ship_f.SHIPID = ship.SHIPID;
            ship_f.EVENTTIME = ship.EVENTTIME;
            ship_f.LW = ship.LW;
            ship_f.ID = ship.ID;
            [list_f addObject:ship_f];
            [ship_f release];
        } 
    }

    //取得最大明细行数
    NSMutableArray *arrCount=[[NSMutableArray alloc] init];
    [arrCount addObject:[NSString   stringWithFormat:@"%d", list_p.count] ];
    [arrCount addObject:[NSString   stringWithFormat:@"%d",list_a.count] ];
    [arrCount addObject:[NSString   stringWithFormat:@"%d",list_r.count]];
    [arrCount addObject:[NSString   stringWithFormat:@"%d",list_d.count] ];
    [arrCount addObject:[NSString   stringWithFormat:@"%d",list_c.count] ];
    [arrCount addObject:[NSString   stringWithFormat:@"%d",list_f.count] ];
    

    int maxValue = 0;
    for (int m = 0; m <arrCount.count; m++)
    {
        if ([[arrCount  objectAtIndex:m] integerValue] > maxValue)
        {
            maxValue =[[arrCount  objectAtIndex:m] integerValue] ;
        }
    }
  //  NSLog(@"--------maxValue【%d】",maxValue);
        int t=1;
   //每个大标题 初始一个数组
        NSMutableArray *ARR_P=[[NSMutableArray alloc] init];
          NSMutableArray *ARR_tbFactory=[[NSMutableArray alloc] init]; 
          NSMutableArray *ARR_c=[[NSMutableArray alloc] init];
          NSMutableArray *ARR_a=[[NSMutableArray alloc] init];
          NSMutableArray *ARR_r=[[NSMutableArray alloc] init];
          NSMutableArray *ARR_f=[[NSMutableArray alloc] init];
          NSMutableArray *ARR_d=[[NSMutableArray alloc] init];
         NSMutableArray *ARR_note=[[NSMutableArray alloc] init];//备注

    for (int v = 0; v <=maxValue; v++)
    {
        if (maxValue >= 2) {
            if (v == maxValue) {
                break;
            }
        }
      //  NSLog(@"计划  list_p.count[%d]",list_p.count);
        NSDateFormatter *f=[[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDateFormatter *f1=[[NSDateFormatter alloc] init];
        [f1 setDateFormat:@"MM-dd HH:mm"];
        
        
        
        //填充数据
        //计划
        if (list_p.count>v) {
            TB_OFFLOADSHIP *shipv=[list_p objectAtIndex:v]; 
            NSString *shipName=[TfShipDao getShipName: shipv.SHIPID ];
         //   NSLog(@"计划    shipName[%@]",shipName);
            float lw=shipv.LW/10000.00;
            


            NSString *hs=[NSString  stringWithFormat:@"%d/%.2f",shipv.HEATVALUE,shipv.SULFUR];
            
            NSString * tradeCoalStr =  [NSString stringWithFormat:@"%@/%@",shipv.TRADENAME,shipv.COALTYPE];

                
         
            
            NSMutableArray *arr_P=[[NSMutableArray alloc] initWithObjects:shipName, [NSString stringWithFormat:@"%.2f",lw],hs,[NSString stringWithFormat:@"%.2f",shipv.DRAFT],shipv.SUPPLIER,tradeCoalStr,nil];
            [ARR_P addObject:arr_P];
            [shipv release];
            [arr_P release];
        }
        //电厂
        if (tbFactory) {
            if (t<2) {
                
                [ARR_tbFactory addObject: [NSString stringWithFormat:@"%.2f",tbFactory.MINDEPTH]];
                [ARR_tbFactory addObject: state==nil?@"":[NSString stringWithFormat:@"%.2f", state.CONSUM/10000.00 ]];
                
                [ARR_tbFactory addObject: state==nil?@"":[NSString stringWithFormat:@"%.2f",state.STORAGE/10000.00 ]];
                //----------------------------

                [ARR_tbFactory addObject:  [NSString stringWithFormat:@"%d/%@",tbFactory.HEATVALUE,[NSString stringWithFormat:@"%.2f", tbFactory.SULFUR]  ]];
                
                [ARR_tbFactory addObject:   state==nil?@"":[NSString stringWithFormat:@"%d",state.AVALIABLE ]];  
            }
        }else
        {
             if (t<2) {
             [ARR_tbFactory addObject: @""];
             [ARR_tbFactory addObject: state==nil||state.CONSUM==0?@"":[NSString stringWithFormat:@"%.2f", state.CONSUM/10000.00 ]];
             [ARR_tbFactory addObject: state==nil||state.STORAGE==0?@"":[NSString stringWithFormat:@"%.2f",state.STORAGE/10000.00 ]];
             [ARR_tbFactory addObject:  @""];
             [ARR_tbFactory addObject: state==nil||state.AVALIABLE==0?@"":[NSString stringWithFormat:@"%d",state.AVALIABLE ]];
             }
        
        }
        
      //  NSLog(@" 抵达 长江口  list_c.count[%d]",list_c.count);
        // 抵达 长江口
        if (list_c.count>v) {//   查询  电厂名   
             TB_OFFLOADSHIP *shipv=[list_c objectAtIndex:v];
             NSString *shipName=[TfShipDao getShipName: shipv.SHIPID ];//shipNAME
           //  NSLog(@"抵达 长江口    shipName[%@]",shipName);
          
             NSDate *time2=[f dateFromString: shipv.EVENTTIME];
             NSString *time1=[shipv.EVENTTIME  substringWithRange:NSMakeRange(0, 10)] ;
             NSString *time= [time1  isEqualToString:@"2000-01-01" ] ?@"未知": [f1 stringFromDate:time2];
            
            float lw=shipv.LW/10000.00;
            
             
            NSMutableArray *arr_c=[[NSMutableArray alloc] initWithObjects:shipName, [NSString stringWithFormat:@"%.2f",lw],time,nil];
            [ARR_c addObject:arr_c];
            [ arr_c release];
            [shipv release];
          
        }
       // NSLog(@" 锚地  list_a .count[%d]",list_a .count);
        //锚地
        if (list_a .count>v) {
            TB_OFFLOADSHIP *shipv=[list_a objectAtIndex:v]; 
            NSString *shipName=[TfShipDao getShipName: shipv.SHIPID ];
          //  NSLog(@" 锚地 shipName[%@]",shipName);
          //
          
            NSDate *time2=[f dateFromString: shipv.EVENTTIME];
          //  NSLog(@"[f1  stringFromDate:  time2 ]===================[%@]",[f1  stringFromDate:  time2 ]);
            
            
            NSString *time1=[shipv.EVENTTIME  substringWithRange:NSMakeRange(0, 10)] ;
            NSString *time= [time1 isEqualToString:@"2000-01-01" ] ?@"未知":[f1  stringFromDate:  time2 ];
            
            
            NSMutableArray *arr_a=[[NSMutableArray alloc] initWithObjects:shipName, [NSString stringWithFormat:@"%.2f",shipv.LW/10000.00],time,nil];
            [ARR_a addObject:arr_a];
            [ arr_a release];
            [shipv release];
            
        }
        
        // NSLog(@" 靠卸 list_r.count[%d]",list_r.count);
        //靠卸
        if (list_r.count>v) {
            TB_OFFLOADSHIP *shipv=[list_r objectAtIndex:v];
            NSString *shipName=[TfShipDao getShipName: shipv.SHIPID ];
             // NSLog(@" 靠卸 shipName[%@]",shipName);
            
               NSDate *time2=[f dateFromString: shipv.EVENTTIME];
            NSString *time1=[shipv.EVENTTIME  substringWithRange:NSMakeRange(0, 10)] ;
            NSString *time= [time1 isEqualToString:@"2000-01-01" ] ?@"未知":[f1  stringFromDate:  time2 ];
            
            
            NSMutableArray *arr_r=[[NSMutableArray alloc] initWithObjects:shipName, [NSString stringWithFormat:@"%.2f",shipv.LW/10000.00],time,nil];
            [ARR_r addObject:arr_r];
            [ arr_r release];
            
            [shipv release];
            
        }
       // NSLog(@" 完货   list_f.count[%d]",list_f.count);
        //完货  
       if(list_f.count>v){
           TB_OFFLOADSHIP *shipv=[list_f objectAtIndex:v];
           NSString *shipName=[TfShipDao getShipName: shipv.SHIPID ];
          // NSLog(@" 完货  shipName[%@]",shipName);
           
           NSDate *time2=[f dateFromString: shipv.EVENTTIME];

            NSString *time1=[shipv.EVENTTIME  substringWithRange:NSMakeRange(0, 10)] ;
            NSString *time= [time1 isEqualToString:@"2000-01-01" ] ?@"未知":[f1  stringFromDate:  time2 ];
           
           
           NSMutableArray *arr_f=[[NSMutableArray alloc] initWithObjects:shipName, time,nil];
           [ARR_f addObject:arr_f];
           [ arr_f release];
           [shipv release];
       }
   // NSLog(@" 离港  ist_d.count[%d]",list_d.count);
      //离港
    if (list_d.count>v) {
      //  NSLog(@"进入 离港 赋值  .。。。");
        TB_OFFLOADSHIP *shipv=[list_d objectAtIndex:v];
        
        NSString *shipName=[TfShipDao getShipName: shipv.SHIPID ];
       // NSLog(@" 离港  shipName[%@]",shipName);
        
        
        NSDate *time2=[f dateFromString: shipv.EVENTTIME];
        NSString *time1=[shipv.EVENTTIME  substringWithRange:NSMakeRange(0, 10)] ;
        NSString *time= [time1 isEqualToString:@"2000-01-01" ] ?@"未知":[f1  stringFromDate:  time2 ];
        
        
        NSMutableArray *arr_d=[[NSMutableArray alloc] initWithObjects:shipName, time,nil];
        [ARR_d addObject:arr_d];
        [ arr_d release];
       [shipv release];
    }  //备注
     if(tbFactory){
         if (t<2) {
           
             [ARR_note addObject:tbFactory.NOTE==nil?@"":tbFactory.NOTE];
         }
         
      }else
      {
        if (t<2) {
            [ARR_note addObject:tbFactory.NOTE==nil?@"":tbFactory.NOTE];
        }
      }
        //   填充数据循环结束
        t++;
         
        [f1 release];
        [f release];  
   }
       
        NSMutableArray *ARR_cd=[[NSMutableArray alloc] init];
        [ARR_cd addObject:ARR_c];
        [ARR_cd addObject:ARR_a];
        [ARR_cd addObject:ARR_r];
        [ARR_cd addObject:ARR_f];
        [ARR_cd addObject:ARR_d]; 
       //填充行数据.................
             
        [Rowdate addObject:ARR_P];
        [Rowdate addObject:ARR_tbFactory];
        [Rowdate addObject:ARR_cd];
        [Rowdate addObject:ARR_note];
       //释放数组....................
        [ARR_cd release];
        [ARR_P release];
        [ARR_tbFactory release];
        [ARR_c release];
        [ARR_a release];
        [ARR_r release];
        [ARR_f release];
        [ARR_d release];
        [ARR_note release];
       //将rowdate  加入date
        [date1 addObject:Rowdate];
        
    //不能释放 
        //[list_a release];
        //[list_c release];
        //[list_d release];
       // [list_f release ];
       // [list_p release];
       // [list_r  release];
        
      [Rowdate release];
      [arrCount release];
    }
    return date1;
}








- (IBAction)selectAction:(id)sender {
    //中间表格
    [ds removeFromSuperview ];
    
 
    data1=[  FactoryWaitDynamicDao getMidDate:month :factoryLable.text];
   
      [self getHeadTable:data1:columWidth1];
     [self.scrool addSubview:ds];
    /****************************************/
  
    source.data=[self getDcSourseData:factoryLable.text];
    
    [listTableview reloadData];
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
     int maxVaule=0;  
    NSMutableArray *rowDate=[source.data objectAtIndex:indexPath.row]; 
    NSMutableArray *arr_P=[rowDate objectAtIndex:1];
   // NSLog(@"arr_P=[rowDate objectAtIndex:1][%d]",[arr_P count]);
    NSMutableArray *arr_sj=[rowDate objectAtIndex:3];
   // NSLog(@"arr_sj=[rowDate objectAtIndex:3][%d]",[arr_sj count]);
    // 实际
    for (int i=0; i<[arr_sj count];  i++) {
        NSMutableArray *sub=[arr_sj objectAtIndex:i];
        if (maxVaule<[sub count]) {
            maxVaule=[sub count];
        }
    }
    if ([arr_P count]!=0||maxVaule!=0) {
     //1  计划    7  实际
    int totalHeight=0;
    int cellHeight=30;
   
    NSMutableArray *Dataildate_p=[[NSMutableArray alloc] init];
    NSMutableArray *Dataildate_sj=[[NSMutableArray alloc] init];
    NSMutableArray *DatailWidth=[[NSMutableArray alloc] init];
    [Dataildate_p  addObject:[[NSMutableArray alloc] initWithObjects:@"计划抵厂船舶", nil]];
    [DatailWidth  addObject:[[NSMutableArray alloc] initWithObjects:@"910", nil]];
    [Dataildate_p  addObject:[[NSMutableArray alloc] initWithObjects:@"船名",@"载量(万吨)", @"热值/硫分",@"吃水(m)",@"供货方",@"煤种", nil]];
    [DatailWidth  addObject:[[NSMutableArray alloc] initWithObjects:@"160",@"100" ,@"180",@"155",@"155",@"160",nil]];
    //计划
    if ([arr_P count]>0) { 
        for (int i=0; i<[arr_P count]; i++) {  
            [Dataildate_p    addObject:[arr_P objectAtIndex:i]];   
        }   
    }
    [Dataildate_sj  addObject:[[NSMutableArray alloc] initWithObjects:@"实际抵厂船舶", nil]];
    [Dataildate_sj  addObject:[[NSMutableArray alloc] initWithObjects:@"抵达长江口",@"锚地",@"靠卸",@"完货",@"离港",nil]];
     [DatailWidth  addObject:[[NSMutableArray alloc] initWithObjects:@"198",@"198" ,@"198",@"158",@"158",nil]];
      [Dataildate_sj  addObject:[[NSMutableArray alloc] initWithObjects:@"船名",@"载重",@"时间",@"船名",@"载重",@"时间",@"船名",@"载重",@"时间",@"船名",@"时间",@"船名",@"时间",nil]];
      [DatailWidth  addObject:[[NSMutableArray alloc] initWithObjects:@"83",@"40" ,@"75",@"83",@"40" ,@"75",@"83",@"40" ,@"75",@"83",@"75",@"83",@"75",nil]]; 
 
    NSMutableArray *arr_c=[arr_sj objectAtIndex:0];
    NSMutableArray *arr_a=[arr_sj objectAtIndex:1];
    NSMutableArray *arr_r=[arr_sj objectAtIndex:2];
    NSMutableArray *arr_f=[arr_sj objectAtIndex:3];
    NSMutableArray *arr_d=[arr_sj objectAtIndex:4];
      //  NSLog(@" 实际初始标题..... ");
 //  NSLog(@"maxVaule【%d】 ",maxVaule);
  //初始实际   数据
    for (int i=0; i<maxVaule; i++) {
        
        NSMutableArray *arr_date=[[NSMutableArray alloc] init];
        //抵达长江口
         // NSLog(@"[arr_c  count]【%d】 ",[arr_c  count]);
        if (i<[arr_c  count]) {
             NSMutableArray *arr_sub=[arr_c objectAtIndex:i];
    
           for (int t=0; t<[arr_sub count]; t++) {
               [arr_date addObject:[arr_sub objectAtIndex:t]];
            }   
        }else
        {
           [arr_date addObject:@""]; 
           [arr_date addObject:@""];   
           [arr_date addObject:@""]; 
        }
        //  NSLog(@" 实际初始标题...抵达长江口.. ");
        
        //锚地
       //  NSLog(@" [arr_a  count]==========[%d] ",[arr_a  count]);
        
        if (i<[arr_a  count]) {
           NSMutableArray *arr_sub1=[arr_a objectAtIndex:i];
            
            for (int t=0; t<[arr_sub1 count]; t++) {
                [arr_date addObject:[arr_sub1 objectAtIndex:t]];
            }  
        }else
        {
           
            [arr_date addObject:@""];
            [arr_date addObject:@""];
            [arr_date addObject:@""];
        }
              //NSLog(@" 实际初始标题...锚地.. ");
         //靠卸
      
        if ([arr_r  count]>i) {
              NSMutableArray *arr_sub2=[arr_r objectAtIndex:i];
            for (int t=0; t<[arr_sub2 count]; t++) {
                [arr_date addObject:[arr_sub2 objectAtIndex:t]]; 
            } 
        }else
        {
           [arr_date addObject:@""]; 
           [arr_date addObject:@""]; 
           [arr_date addObject:@""]; 
        }
         //  NSLog(@" 实际初始标题...靠卸.. ");
       //完货  
      
        if (i<[arr_f  count]) {
              NSMutableArray *arr_sub3=[arr_f objectAtIndex:i];
            for (int t=0; t<[arr_sub3 count]; t++) {
                [arr_date addObject:[arr_sub3 objectAtIndex:t]];
             

            }
        }else
        {
            [arr_date addObject:@""]; 
                [arr_date addObject:@""]; 
           
        }
            //  NSLog(@" 实际初始标题...完货  .. ");
         //离港
      
        if (i<[arr_d  count]) {
              NSMutableArray *arr_sub4=[arr_d objectAtIndex:i];
            for (int t=0; t<[arr_sub4 count]; t++) {
                [arr_date addObject:[arr_sub4 objectAtIndex:t]];
            } 
        }else
        {
            [arr_date addObject:@""];

                [arr_date addObject:@""];
           
        }
            //  NSLog(@" 实际初始标题...离港  .. ");
        
             // NSLog(@"====================== arr_date[%d] ",[arr_date count]);
        [Dataildate_sj addObject:arr_date];
        [arr_date release];
    }
         // NSLog(@" 初始界面..... ");
  //数据初始完毕
        if ([arr_P count]==0) {
            totalHeight=[arr_P count]*cellHeight+maxVaule*cellHeight+3*cellHeight;
        }
        if (maxVaule==0) {
             totalHeight=[arr_P count]*cellHeight+maxVaule*cellHeight+2*cellHeight;
        }
        if (maxVaule!=0&&[arr_P count]!=0)
        {
         totalHeight=[arr_P count]*cellHeight+maxVaule*cellHeight+5*cellHeight;
        }
        
   
 
    UIViewController *detail=[[UIViewController alloc] init];
    UIView *detailView=[[UIView  alloc ] initWithFrame:CGRectMake(0, 0, 910, totalHeight)];
    /********再uiview 中  填充 内容*******************************/
       //计划 填充
    UILabel *l;    
    int height=0;
    if ([arr_P count]!=0){
        
        for (int i=0; i<[Dataildate_p count]; i++) {
            int a=0;
            if (i>1)
                a=1;
            else
                a=i;
            
            NSMutableArray *Pwidth=[DatailWidth objectAtIndex:a];
            NSMutableArray *Pdate=[Dataildate_p objectAtIndex:i];
            int widthSet=0;
            if(i==0){
                int  columnWidth=[[[DatailWidth objectAtIndex:0] objectAtIndex:0] integerValue];
                l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnWidth, cellHeight-1 )];
                l.font = [UIFont systemFontOfSize:13.0f];
                l.text = [Pdate objectAtIndex:0] ;
                l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
                l.textColor = [UIColor whiteColor];
                l.shadowColor = [UIColor blackColor];
                l.shadowOffset = CGSizeMake(0, -0.5);
                l.textAlignment = UITextAlignmentCenter;
                [detailView addSubview:l];
                [l release];
                
            }else
            {
                for (int t=0; t<[Pwidth count]; t++) {
                    int  columnWidth=[[Pwidth objectAtIndex:t ] integerValue];
                    l = [[UILabel alloc] initWithFrame:CGRectMake(widthSet, i*cellHeight, columnWidth-1, cellHeight-1 )];
                    l.font = [UIFont systemFontOfSize:13.0f];
                    l.text = [Pdate objectAtIndex:t] ;
                    if (i==1) {
                        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
                    }else
                    {
                        if(i % 2 == 0)
                            l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                        else
                            l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                    }
                    l.textColor = [UIColor whiteColor];
                    l.shadowColor = [UIColor blackColor];
                    l.shadowOffset = CGSizeMake(0, -0.5);
                    l.textAlignment = UITextAlignmentCenter;
                    [detailView addSubview:l];
                    [l release];
                    widthSet+=columnWidth;
                }
            }   
        }
        height=[Dataildate_p count];  
    }      
    [DatailWidth removeObjectAtIndex:1];
    if  (maxVaule!=0){
        //实际填充
        for (int i =0; i<[Dataildate_sj count]; i++) {
            int a=0;
            if (i>2)
                a=2;
            else
                a=i;
            NSMutableArray *Pwidth=[DatailWidth objectAtIndex:a];
            NSMutableArray *Pdate=[Dataildate_sj    objectAtIndex:i];
            int widthSet=0;
            if (i==0) {
                int  columnWidth=[[Pwidth objectAtIndex:0] integerValue];
                l = [[UILabel alloc] initWithFrame:CGRectMake(widthSet, (height+i)*cellHeight, columnWidth, cellHeight-1 )];
                l.font = [UIFont systemFontOfSize:13.0f];
                l.text = [Pdate objectAtIndex:0] ;
                l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
                l.textColor = [UIColor whiteColor];
                l.shadowColor = [UIColor blackColor];
                l.shadowOffset = CGSizeMake(0, -0.5);
                l.textAlignment = UITextAlignmentCenter;
                [detailView addSubview:l];
                [l release];
            }else{
                for (int t=0; t<[Pwidth count]; t++) {
                    int  columnWidth=[[Pwidth objectAtIndex:t ] integerValue];
                    
                    l = [[UILabel alloc] initWithFrame:CGRectMake(widthSet, (i+height)*cellHeight, columnWidth-1, cellHeight-1 )];
                    l.font = [UIFont systemFontOfSize:13.0f];
                    l.text = [Pdate objectAtIndex:t] ;
                    
                    
                    
                    if (i <=2) {
                        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbgd"]];
                    }else
                    {
                        if(i % 2 == 0)
                            l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                        else
                            l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                    }
                    
                    l.textColor = [UIColor whiteColor];
                    l.shadowColor = [UIColor blackColor];
                    l.shadowOffset = CGSizeMake(0, -0.5);
                    l.textAlignment = UITextAlignmentCenter;
                    [detailView addSubview:l];
                    [l release];
                    widthSet+=columnWidth; 
                }
            }
        } 

        
        
    }
        
       /********再uiview 中  填充 内容********完毕***********************/
    detail.view= detailView;
    //设置待显示控制器的范围
    [detail.view setFrame:CGRectMake(0,0, 910, totalHeight )];
    //设置待显示控制器视图的尺寸
    detail.contentSizeForViewInPopover = CGSizeMake(910, totalHeight);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:detail]; 
    self.popover = pop;
    self.popover.delegate = self;

    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(910, totalHeight);
    //显示，其中坐标为箭头的坐标以及尺寸 0 可去掉箭头
    [self.popover presentPopoverFromRect:CGRectMake(512,470, 1, 1) inView:self.view permittedArrowDirections:0 animated:YES];
    
    [detail  release];  
    [Dataildate_p release];
    [Dataildate_sj release];
    [DatailWidth release];   
        
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
    
    NSArray *rowData1 = [source.data objectAtIndex:indexPath.row];
    NSMutableArray *rowData=[[NSMutableArray alloc ] init   ];
      NSMutableArray *ARR_P=[rowData1 objectAtIndex:1];
    NSMutableArray *ARR_tbFactory=[rowData1 objectAtIndex:2];
    NSMutableArray *ARR_cd=[rowData1 objectAtIndex:3];
     NSMutableArray *ARR_note=[rowData1 objectAtIndex:4];
    [rowData    addObject:[rowData1 objectAtIndex:0]];
    if ([ARR_P count]>0) {
      
        //[rowData    addObject:[ NSString stringWithFormat:@"有数据【%d】",[ARR_P count   ]]];
        [rowData    addObject:@"YES"];
    }else
    {
        [rowData    addObject:@""];
    }
    
    for (int i=0; i<[ARR_tbFactory count]; i++) {
        [rowData    addObject:[ARR_tbFactory objectAtIndex:i]];
    }
    for (int i=0; i<[ARR_cd count]; i++) {
        NSMutableArray *sub=[ARR_cd objectAtIndex:i];
        if (sub.count >0) {
           // [rowData    addObject:[ NSString stringWithFormat:@"有数据【%d】",[sub count   ]]];
                    [rowData    addObject:@"YES"];
        }else
        {
            [rowData    addObject:@""];
        } 
    } 
    [rowData    addObject:[ARR_note objectAtIndex:0]]; 
    for(int column=0;column<[rowData count];column++){
       
            float columnWidth = [[source.columnWidth objectAtIndex:column] floatValue];;
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth-1, 40 -1 )];
            l.font = [UIFont systemFontOfSize:14.0f];
        
        if ( [[rowData objectAtIndex:column] isEqualToString:@"YES"] ) {
            UILabel *imageLabel;
            if (column==1){
             imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(-columnWidth/2, 0, columnWidth-1, 40 -1 )];
            }else
            {
             imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnWidth-1, 40 -1 )];
            }
            imageLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"xiangx"]];
            [l addSubview:imageLabel];
            [imageLabel release];
            l.text =@"";
        }else
            l.text =[rowData objectAtIndex:column];
        
        
            l.textAlignment = UITextAlignmentCenter;
            l.tag = 40 + column + 1000;
            if(indexPath.row % 2 == 0)
                l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
            else
                l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
        
            [cell addSubview:l];
            columnOffset += columnWidth;
            [l release];
        }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:15.0/255 green:43.0/255 blue:64.0/255 alpha:1];
    
    
    [rowData release];
   return cell;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


-(void)getHeadTable:(NSMutableArray *)data1:(NSMutableArray *)columWidth1
{
  float cellHeight=30.0;  
    NSMutableArray *data=[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithObjects:@"机组运行情况",@"机组台数(台)",@"机组构成(台*容量)",@"煤场最大储量(万吨)",@"码头最大吃水(米)", nil],[[NSMutableArray alloc]initWithObjects:@"日发电量(万千瓦时)",@"月累计调进量(万吨)",@"年累计调进量(万吨)",@"月累计耗用煤量(万吨)",@"年累计耗用煤量",nil ],[[NSMutableArray alloc] initWithObjects:@"预计十日后库存",@"封航情况",nil], [[NSMutableArray  alloc] initWithObjects:@"备注",nil],nil];
    
    int totalWidth=0;
    for (int i=0; i<[columWidth1 count]; i++) {
        totalWidth+=[[columWidth1    objectAtIndex:i] integerValue];
    }
    
        //填充
    for (int i=0; i<[data count]; i++) {
       NSArray *rowData = [data objectAtIndex:i];
        NSArray *date=[data1 objectAtIndex:i];
       // NSLog(@"[date count]===========%d",[date count]);
        if ([date count]>0) {
            
            float  columnOffset = 0.0;
            float columnWidth=0.0;
            int a=0;
            int b=0;
            UILabel *l;
            if (i<2) {
                for(int column=0;column<[columWidth1 count];column++){
                    if (column%2==0) {//计数列
                        columnWidth = [[columWidth1 objectAtIndex:column] floatValue];
                        l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 )];
                        l.font = [UIFont systemFontOfSize:15.0f];
                        l.text = [rowData objectAtIndex:a];
                        
                        l.backgroundColor=[UIColor blackColor];
                        l.textColor=[UIColor whiteColor];
                        l.shadowColor=[UIColor whiteColor   ];
                        l.lineBreakMode = UILineBreakModeCharacterWrap;
                        l.textAlignment = UITextAlignmentLeft;
                        a++;
                    }else
                    {
                        columnWidth = [[columWidth1 objectAtIndex:column] floatValue];
                        l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 )];
                        l.font = [UIFont systemFontOfSize:15.0f];
                        l.lineBreakMode = UILineBreakModeCharacterWrap;
                        l.backgroundColor=[UIColor blackColor];
                        l.textColor=[UIColor whiteColor];
                        l.shadowColor=[UIColor whiteColor   ];
                        l.lineBreakMode = UILineBreakModeCharacterWrap;
                        l.text =[date objectAtIndex:b]==NULL ?@"":[date objectAtIndex:b];
                        l.numberOfLines = 3;
                        l.textAlignment = UITextAlignmentLeft;
                        b++;
                    }
                    columnOffset += columnWidth;
                    [ds addSubview:l];
                    [l release];
                }
                
            }else//第3、4行
            {
                if (i==2) {
                    for (int d=0; d<4; d++) {
                        columnWidth = [[columWidth1 objectAtIndex:d] floatValue];
                        if (d%2==0) {
                            l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 )];
                            l.font = [UIFont systemFontOfSize:15.0f];
                            l.text = [rowData objectAtIndex:a];
                            
                            l.backgroundColor=[UIColor blackColor];
                            l.textColor=[UIColor whiteColor];
                            l.shadowColor=[UIColor whiteColor   ];
                            l.lineBreakMode = UILineBreakModeCharacterWrap;
                            l.textAlignment = UITextAlignmentLeft;
                            a++;
                        }else
                        {
                            if (d!=3) {
                                l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 )];
                                l.font = [UIFont systemFontOfSize:15.0f];
                                l.backgroundColor=[UIColor blackColor];
                                l.textColor=[UIColor whiteColor];
                                l.shadowColor=[UIColor whiteColor   ];
                                l.lineBreakMode = UILineBreakModeCharacterWrap;
                                
                                l.text =[date objectAtIndex:b]==nil?@"":[date objectAtIndex:b];
                                l.textAlignment = UITextAlignmentLeft;
                            }else
                            {
                                l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , (totalWidth-columnOffset)-1, cellHeight -1 )];
                                l.font = [UIFont systemFontOfSize:15.0f];
                                l.backgroundColor=[UIColor blackColor];
                                l.textColor=[UIColor whiteColor];
                                l.shadowColor=[UIColor whiteColor   ];
                                l.lineBreakMode = UILineBreakModeCharacterWrap;
                                l.text =[date objectAtIndex:b]==nil?@"":[date objectAtIndex:b];
                                l.textAlignment = UITextAlignmentLeft;
                            }
                            b++;
                        }
                        columnOffset += columnWidth;
                        [ds addSubview:l];
                        [l release];
                    }
                    
                }else//第四行
                {
                    columnWidth = [[columWidth1 objectAtIndex:0] floatValue];
                    l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 )];
                    l.font = [UIFont systemFontOfSize:15.0f];
                    l.text = [rowData objectAtIndex:a];
                    l.backgroundColor=[UIColor blackColor];
                    l.textColor=[UIColor whiteColor];
                    l.shadowColor=[UIColor whiteColor   ];
                    l.lineBreakMode = UILineBreakModeCharacterWrap;
                    l.textAlignment = UITextAlignmentLeft;
                    columnOffset += columnWidth;
                    [ds addSubview:l];
                    [l release];
                    
                    columnWidth = [[columWidth1 objectAtIndex:1] floatValue];
                    l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , (totalWidth-columnOffset)-1, cellHeight -1 )];
                    l.backgroundColor=[UIColor blackColor];
                    l.textColor=[UIColor redColor];
                    // l.shadowColor=[UIColor whiteColor   ];
                    l.lineBreakMode = UILineBreakModeCharacterWrap;
                    l.font = [UIFont systemFontOfSize:15.0f];
                    l.text =[date objectAtIndex:b]==nil?@"":[date objectAtIndex:b];
                    
                    
            //        NSLog(@"===========%@============%@",[date objectAtIndex:b],[date objectAtIndex:b]==@"*"?@"":[date objectAtIndex:b]);
                    
                    
                    l.textAlignment = UITextAlignmentLeft;
                    [ds addSubview:l];
                    [l release];
                    
                }
            }

        }
        
                [rowData release];
       // [date    release]; 不能释放。。
    }
    
  [data    release];
}


- (IBAction)timeAction:(id)sender {
    
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    if(!monthVC)//初始化待显示控制器
        monthVC=[[DateViewController alloc]init];
    //设置待显示控制器的范围
    [monthVC.view setFrame:CGRectMake(0,0, 280, 216)];
    //设置待显示控制器视图的尺寸
    monthVC.contentSizeForViewInPopover = CGSizeMake(280, 216);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:monthVC];
    monthVC.popover = pop;
    monthVC.selectedDate=self.month;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(280, 216);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(189, 38, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [pop release];   
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
    //[chooseView.iDArray addObject:All_];
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
    [self.popover presentPopoverFromRect:CGRectMake(420, 38, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [chooseView.tableView reloadData];
    [chooseView release];
    [pop release];
    [Array release];

}




- (IBAction)releaseLable:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];

    
    self.startTime.text=[dateFormatter  stringFromDate:[NSDate date]];
    
    self.factoryLable.text=@"玉环";
    self.factoryLable.hidden=YES;
    [self.factoryButton setTitle:@"玉环" forState:UIControlStateNormal];
    
    
    [dateFormatter release];
    
    
}

- (IBAction)reloadAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络同步需要等待一段时间" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"开始同步",nil];
	[alert show];
    [alert release];
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.view addSubview:activty];
        [reload setTitle:@"同步中..." forState:UIControlStateNormal];
        
        [activty startAnimating];
        
        [tbxmlParser setISoapNum:5];
    
       [tbxmlParser requestSOAP:@"FactoryState"];
       //电厂 
      [tbxmlParser requestSOAP:@"Factory"];
        
        //获取电厂机组运行信息    FactoryCapacity
      [tbxmlParser requestSOAP:@"FactoryCapacity"];
        
        
        
       [ tbxmlParser  requestSOAP:@"OffLoadShip"];
      [ tbxmlParser  requestSOAP:@"OffLoadFactory"];
   


        [self runActivity];
    }
	
}

- (void)viewDidUnload
{
   

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [ds release];
    [activty release]   ;
    [startButton release];
    [startTime release];
    [factoryButton release];
    [factoryLable    release];
  
    [scrool release];
    [dcView release];
    [popover release];
    [reload release];
    
    
    [listTableview   release];
    [TitleView release];
    [chooseView release];
    
    [cView release];
}

-(void)dealloc
{
    if (columnWidthFTitle) {
    [columnWidthFTitle release    ];
    columnWidthFTitle=nil ;
    }

    if (columWidth1) {
        [columWidth1 release    ];
        columWidth1=nil ;
    }
    if (data1){
        [data1 release  ];
        data1=nil;
    }
    if (source) {
        [source release];
        source=nil;
    }
 
    [monthVC release];
    [chooseView release];
    [ds release];
    [month release];
    [tbxmlParser release];
    [activty release]   ;
    [startButton release];
    [startTime release];
    [factoryButton release];
    [factoryLable    release];
    
    [scrool release];
    [dcView release];
    [popover release];
    [reload release];
   
    [cView release];
    [super dealloc  ];
}

/*
#pragma mark - UIScrollView delegate

// view已经停止滚动

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"1");
    
    
    
}
// 将要开始拖拽，手指已经放在view上并准备拖动的那一刻

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	scrollView.frame = CGRectMake(0, 0, scrollView.frame.size.width, self.scrool.frame.size.height);

    
    
    
    
    NSLog(@"2");

    
    NSLog(@"scrollView。x[%f]",scrollView.contentOffset. x);

    NSLog(@"scrollView。y:[%f]",scrollView.contentOffset.y)   ;
  



}
// 已经结束拖拽，手指刚离开view的那一刻

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

   if(!decelerate)
       NSLog(@"3");


 
}

//  view将要开始减速 view滑动之后有惯性
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    
    
    

}

*/

#pragma mark - popoverController
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    if (monthVC)
        self.month=monthVC.selectedDate;
    return  YES;
}

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissPopoverAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.startTime.text=[dateFormatter stringFromDate:month];
    [dateFormatter release];
}





#pragma mark activity
-(void)runActivity
{
    if ([tbxmlParser iSoapNum]==0) {
        [activty stopAnimating];
        [activty removeFromSuperview];
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
       
            if (chooseView.type==kChFACTORY) {
                self.factoryLable.text =currentSelectValue;
                if (![ self.factoryLable.text isEqualToString:All_]) {
                    self.factoryLable.hidden=NO;
                    [ self.factoryButton setTitle:@"" forState:UIControlStateNormal];
                }
                else {
                    self.factoryLable.hidden=YES;
                    [ self.factoryButton setTitle:@"电厂" forState:UIControlStateNormal];
                }
                
                
            }

    }
}
@end
