//
//  FactoryWaitFootTable.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "FactoryWaitFootTable.h"
#import "TransPlanImplement.h"
#import "PMPeriod.h"

#import "TransPlanImplement.h"


@implementation FactoryWaitFootTable
MultiTitleDataSource *source;
TransPlanImplement *tpl;
NSMutableArray *columnWidth1;
PMCalendarController *pmCC;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/*
-(void)dealloc
{
    if (tpl) {
        [tpl release];
    }
    if(pmCC){
        [pmCC release];
    }
    
    [columnWidth1 release];
    [source release];
    [super dealloc];
}
*/



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)getColument
{
    columnWidth1=[[NSMutableArray alloc] init ];
 

     NSLog(@"[source.columnWidth count]%d",[source.columnWidth count]);
    int a=0;
    for (int i=1; i<[source.titles  count]; i++) {
        
        NSMutableArray  *subT=[source.splitTitle    objectAtIndex:i-1];
       int fWidth=0;
         NSLog(@"subT[%d]   ====%d",i,[subT count]);
        
        for ( int t=0; t<[subT count]; t++) {
            fWidth+=[[source.columnWidth objectAtIndex:(t+a)] integerValue    ];
        }
        [columnWidth1 addObject:[NSString stringWithFormat:@"%d",fWidth]];
        a+=[subT count];      
    }

}
-(void)layoutSubView:(CGRect)aRect{
    source=(MultiTitleDataSource *)dataSource;
    [self getColument];

	vLeftContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0,cellWidth, contentHeight)];
	vRightContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aRect.size.width - cellWidth, contentHeight)];
	
	vLeftContent.opaque = YES;
	vRightContent.opaque = YES;

	vTopLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, (cellHeight)*2+2)];
	vLeft = [[DataGridScrollView alloc] initWithFrame:CGRectMake(0, cellHeight*2+2, aRect.size.width, aRect.size.height - cellHeight*2-2)];
	vRight = [[DataGridScrollView alloc] initWithFrame:CGRectMake(cellWidth, 0, aRect.size.width - cellWidth, contentHeight+cellHeight*2+2)];
    //高度 *2     2层标题         当二层标题为0 或1 是  没有二层
	vTopRight = [[UIView alloc] initWithFrame:CGRectMake(cellWidth, 0, aRect.size.width - cellWidth, (cellHeight)*2+2)];
	vLeft.dataGridComponent = self;
	vRight.dataGridComponent = self;
	
	vLeft.opaque = YES;
	vRight.opaque = YES;
	vTopLeft.opaque = YES;
	vTopRight.opaque = YES;
	
	//设置ScrollView的显示内容
	vLeft.contentSize = CGSizeMake(aRect.size.width, contentHeight);
	vRight.contentSize = CGSizeMake(contentWidth,aRect.size.height - cellHeight);
	
	//设置ScrollView参数
	vRight.delegate = self;
	
    vTopRight.backgroundColor=[UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    vRight.backgroundColor=[UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    vTopLeft.backgroundColor=[UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
	//添加各视图
	[vRight addSubview:vRightContent];
	[vLeft addSubview:vLeftContent];
	[vLeft addSubview:vRight];
	[self addSubview:vTopLeft];
	[self addSubview:vLeft];
	
	[vLeft bringSubviewToFront:vRight];
	[self addSubview:vTopRight];
	[self bringSubviewToFront:vTopRight];
}


-(void)fillData{
    NSLog(@"source.columnWidth-----%d",[source.columnWidth count]);
    NSLog(@"columnWidth1-----%d",[columnWidth1 count]);
    NSLog(@"source.splitTitle--------%d",[source.splitTitle count]);
    NSLog(@"source.titles-----------%d",[source.titles count]);
    
  	float columnOffset = 0.0;
    //int iColorRed=0;
    float set=0.0;
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
    [vTopLeft addSubview:l2];
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
            [vTopRight addSubview:l];
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
                     
                     [vTopRight addSubview:l1];
                     set+=cdw;
                     [l1 release];
                     d++;
                   }
             columnOffset += fTitleWidth; 
        }
               
	//填冲数据内容
	for(int i = 0;i<[source.data count];i++){
		
		NSArray *rowData = [source.data objectAtIndex:i];
		columnOffset = 0.0;
		
		for(int column=0;column<[rowData count];column++){
         
                float columnWidth = [[source.columnWidth objectAtIndex:column] floatValue];
            
            if (column==[rowData count]-1&&!([[rowData objectAtIndex:[rowData count]-1] isEqualToString:@"合计"]||[[rowData objectAtIndex:[rowData count]-1] isEqualToString:@"共计"])) {
                UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom ];
                b.titleLabel.font=[UIFont systemFontOfSize:14.0f];
                
                
                b.frame = CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 );
                
                if(i % 2 == 0)
                    b.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                else
                    b.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];   
                    
                [b setTitle:@"日历" forState:UIControlStateNormal];
                b.titleLabel.textAlignment=UITextAlignmentCenter;
           
                [b addTarget:self  action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                
                
                
                [vRightContent addSubview:b];
                
                //[b release];
                
            }else
            {
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 )];
                l.font = [UIFont systemFontOfSize:14.0f];
                l.text = [rowData objectAtIndex:column];
                
                l.textAlignment = UITextAlignmentCenter;
                l.tag = i * cellHeight + column + 1000;
                if(i % 2 == 0)
                    l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                else
                    l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                
                
                if( 0 == column){
                    l.frame = CGRectMake(columnOffset,  i * cellHeight , columnWidth -1 , cellHeight -1 );
                    [vLeftContent addSubview:l];
                }
                else if(0 < column) {
                    [vRightContent addSubview:l];
                    columnOffset += columnWidth;
                }
                [l release];

            
            
            
            }
               
           
                      
            
            
            
      }
    }
		
		
    
    
}

-(void)butClick:(id)sender
{
    
     CGSize defaultSize = (CGSize){260, 200};
    NSLog(@"==============================");
    
    NSMutableArray *d=[[NSMutableArray alloc] initWithObjects:@"9" ,@"18",nil];
    
    
    tpl=[[TransPlanImplement alloc] init];
    pmCC = [[PMCalendarController alloc]init];
    
    [pmCC reinitializeWithSize:@"2012-09-20":defaultSize:d];
  
    
    pmCC.delegate = tpl;
    pmCC.mondayFirstDayOfWeek = YES;
    
    //[pmCC presentCalendarFromView:sender permittedArrowDirections:PMCalendarArrowDirectionAny     animated:YES];
       [pmCC presentCalendarFromRect:[sender frame]
     inView:[sender superview]
     permittedArrowDirections:PMCalendarArrowDirectionAny
     animated:YES];
    [tpl calendarController:pmCC didChangePeriod:pmCC.period];
    
    
    NSLog(@"初始日历....");
    
   
}

//-------------------------------以下为事件处发方法----------------------------------------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	scrollView.frame = CGRectMake(cellWidth, 0, scrollView.frame.size.width, self.frame.size.height);
    
    
    //-----会不会有问题
    
	vRightContent.frame = CGRectMake(0, cellHeight*2- vLeft.contentOffset.y  ,
									 vRight.contentSize.width , contentHeight);
    
	vTopRight.frame = CGRectMake(0, 0, vRight.contentSize.width, vTopRight.frame.size.height);
	vTopRight.bounds = CGRectMake(0, 0, vRight.contentSize.width, vTopRight.frame.size.height);
	[scrollView addSubview:vTopRight];
	[self addSubview:scrollView];
}














@end
