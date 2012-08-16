//
//  MultiTitleDataGridComponent.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-15.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "MultiTitleDataGridComponent.h"

@implementation MultiTitleDataSource

@synthesize splitTitle;

-(void)dealloc
{
    
    
    [splitTitle release];
    
    [super dealloc];
}


@end




@implementation MultiTitleDataGridComponent
MultiTitleDataSource *source;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

int cCount=1;
int count=1;

-(void)getColument
{
    NSMutableArray *d=[[NSMutableArray alloc] init];
    
    [d addObject:[source.columnWidth objectAtIndex:0]];
    
    for (int i=1; i<[source.columnWidth count]; i++) {
        for (int t=0; t<[source.splitTitle count]; t++) {
            
            [d addObject:[NSString stringWithFormat:@"%d",[[source.columnWidth objectAtIndex:i] intValue]/[source.splitTitle count]]]   ;
        }
    }
    source.columnWidth=d;
    [d release];
    
  //  NSLog(@"source.columnWidth[%d]",[source.columnWidth count]);
    
}

-(void)layoutSubView:(CGRect)aRect{
    source=(MultiTitleDataSource *)dataSource;
    [self getColument];
  //  NSLog(@"-----source.splitTitle-------%d", [source.splitTitle count]) ;
   // NSLog(@"-----source.data-------%d", [source.data count]) ;
  // NSLog(@"-----source.columnWidth-------%d", [source.columnWidth  count]) ;
  // NSLog(@"-----source.titles -------%d", [source.titles  count]) ;
    
    
    if ([source.splitTitle count]>1) {
        //最多两层
        cCount=2;
        count=[source.splitTitle count];
        
    }
	vLeftContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0,cellWidth, contentHeight)];
	vRightContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aRect.size.width - cellWidth, contentHeight)];
	
	vLeftContent.opaque = YES;
	vRightContent.opaque = YES;
	//--------当二层标题为0 或1 是  没有二层--------------------初始化各视图       高度＊2   2层标题
	vTopLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, (cellHeight)*cCount+2)];
	vLeft = [[DataGridScrollView alloc] initWithFrame:CGRectMake(0, cellHeight*cCount+2, aRect.size.width, aRect.size.height - cellHeight*cCount-2)];
	vRight = [[DataGridScrollView alloc] initWithFrame:CGRectMake(cellWidth, 0, aRect.size.width - cellWidth, contentHeight+cellHeight*cCount+2)];
    //高度 *2     2层标题         当二层标题为0 或1 是  没有二层
	vTopRight = [[UIView alloc] initWithFrame:CGRectMake(cellWidth, 0, aRect.size.width - cellWidth, (cellHeight)*cCount+2)];
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
 	float columnOffset = 0.0;
    int iColorRed=0;
    float set=0.0;
	//-------------------填冲标题数据
    //第一个单元格   ---------高度  没有二层标题时   *1
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth-1, cellHeight*cCount-1 )];
    l2.font = [UIFont systemFontOfSize:16.0f];
    l2.text = [source.titles objectAtIndex:0];
    //l2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
    
    
    
    l2.backgroundColor=[UIColor blueColor];
    
    
    
    
    l2.textColor = [UIColor whiteColor];
    l2.shadowColor = [UIColor blackColor];
    l2.shadowOffset = CGSizeMake(0, -0.5);
    l2.textAlignment = UITextAlignmentCenter;
    [vTopLeft addSubview:l2];
    [l2 release];
    

	for(int column = 1;column < [source.titles count];column++){
		float columnWidth = [[source.columnWidth objectAtIndex:column] floatValue];
        
        //第一行标题   宽度＊3      ------宽度＊二层标题  数   columnOffset*3    columnWidth*3 -1
        
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset*count, 0, columnWidth*count -1, cellHeight-1 )];
        
		l.font = [UIFont systemFontOfSize:16.0f];
		l.text = [source.titles objectAtIndex:column];
		//l.backgroundColor = [UIColor colorWithRed:0.0/255 green:105.0/255 blue:186.0/255 alpha:1];
        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
		l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(0, -0.5);
		l.textAlignment = UITextAlignmentCenter;
        
        [vTopRight addSubview:l];
        [l release];
        
        //判断
        
        //  循环  二层标题  数组
        for (int i=0; i<[source .splitTitle  count ]; i++) {
            
            
            UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(set, cellHeight, columnWidth-1, cellHeight-1 )];
            l1.font = [UIFont systemFontOfSize:16.0f];
            
            l1.text =[source.splitTitle objectAtIndex:i];
            
            
            l1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
            l1.textColor = [UIColor whiteColor];
            l1.shadowColor = [UIColor blackColor];
            l1.shadowOffset = CGSizeMake(0, -0.5);
            l1.textAlignment = UITextAlignmentCenter;
            
            [vTopRight addSubview:l1];
            set+=columnWidth;
            [l1 release];
        }
        
        columnOffset += columnWidth;
	}
    

	//填冲数据内容
	for(int i = 0;i<[dataSource.data count];i++){
		
		NSArray *rowData = [dataSource.data objectAtIndex:i];
		columnOffset = 0.0;
		
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
                float columnWidth = [[dataSource.columnWidth objectAtIndex:column-1] floatValue];
         
                
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 )];
                l.font = [UIFont systemFontOfSize:14.0f];
                l.text = [rowData objectAtIndex:column];
                l.textAlignment = UITextAlignmentCenter;
                l.tag = i * cellHeight + column + 1000;
                if(i % 2 == 0)
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
                if( 1 == column){
                    l.frame = CGRectMake(columnOffset,  i * cellHeight , columnWidth -1 , cellHeight -1 );
                    [vLeftContent addSubview:l];
                }
                else if( 1 < column) {
                    [vRightContent addSubview:l];
                    columnOffset += columnWidth;
                }
                [l release];
            }
		}
	}
}

//-------------------------------以下为事件处发方法----------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
  //  NSLog(@"bbbbbbbbbb");
	vTopRight.frame = CGRectMake(cellWidth, 0, vRight.contentSize.width, vTopRight.frame.size.height);
    
    
	vTopRight.bounds = CGRectMake(scrollView.contentOffset.x, 0, vTopRight.frame.size.width, vTopRight.frame.size.height);
	vTopRight.clipsToBounds = YES;
	vRightContent.frame = CGRectMake(0, 0  ,
									 vRight.contentSize.width , contentHeight);
    
	[self addSubview:vTopRight];
	vRight.frame =CGRectMake(cellWidth, 0, self.frame.size.width - cellWidth, vLeft.contentSize.height);
	[vLeft addSubview:scrollView];
	
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	scrollView.frame = CGRectMake(cellWidth, 0, scrollView.frame.size.width, self.frame.size.height);
    
    
    //-----会不会有问题
    
	vRightContent.frame = CGRectMake(0, cellHeight*cCount- vLeft.contentOffset.y  ,
									 vRight.contentSize.width , contentHeight);
    
    
    
    
    
    
    
	
	vTopRight.frame = CGRectMake(0, 0, vRight.contentSize.width, vTopRight.frame.size.height);
	vTopRight.bounds = CGRectMake(0, 0, vRight.contentSize.width, vTopRight.frame.size.height);
	[scrollView addSubview:vTopRight];
	[self addSubview:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(!decelerate)
		[self scrollViewDidEndDecelerating:scrollView];
}
@end
