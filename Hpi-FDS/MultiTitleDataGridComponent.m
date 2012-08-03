//
//  MultiTitleDataGridComponent.m
//  Hpi-FDS
//  继承自DataGridComponent,改进标题显示模式，能够显示2层的交叉表
//  举例如下：
//  |---------------|
//  |TitleAA|TitleBB| <---表头
//  |-------|-------|
//  |ti1|ti2|ti3|ti4| <---表头
//  |---|---|---|---|
//  |111|222|333|444| <---内容
//  |---------------|
//  Created by 馬文培 on 12-8-2.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//
 
#import "MultiTitleDataGridComponent.h"

@implementation MultiTitleDataGridComponent

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)layoutSubView:(CGRect)aRect{
	vLeftContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, contentHeight)];
	vRightContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aRect.size.width - cellWidth, contentHeight)];
	
	vLeftContent.opaque = YES;
	vRightContent.opaque = YES;
	NSLog(@"layoutsubView");
	
	//初始化各视图
	vTopLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight*2+2)];
	vLeft = [[DataGridScrollView alloc] initWithFrame:CGRectMake(0, cellHeight+2, aRect.size.width, aRect.size.height - cellHeight-2)];
	vRight = [[DataGridScrollView alloc] initWithFrame:CGRectMake(cellWidth, 0, aRect.size.width - cellWidth, contentHeight)];
	vTopRight = [[UIView alloc] initWithFrame:CGRectMake(cellWidth, 0, aRect.size.width - cellWidth, cellHeight*2+2)];
	
	vLeft.dataGridComponent = self;
	vRight.dataGridComponent = self;
	
	vLeft.opaque = YES;
	vRight.opaque = YES;
	vTopLeft.opaque = YES;
	vTopRight.opaque = YES;
	
	//设置ScrollView的显示内容
	vLeft.contentSize = CGSizeMake(aRect.size.width, contentHeight);
	vRight.contentSize = CGSizeMake(contentWidth,aRect.size.height - cellHeight*2);
	
	//设置ScrollView参数
	vRight.delegate = self;
	
    vTopRight.backgroundColor=[UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    vRight.backgroundColor=[UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    vTopLeft.backgroundColor=[UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
    //vTopRight.backgroundColor = [UIColor blackColor];
	//vRight.backgroundColor = [UIColor blackColor];
	//vTopLeft.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1];
	
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
	//填冲标题数据
	for(int column = 0;column < [dataSource.titles count];column++){
		float columnWidth = [[dataSource.columnWidth objectAtIndex:column] floatValue]*2;
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth -1, cellHeight+2 )];
		l.font = [UIFont systemFontOfSize:16.0f];
		l.text = [dataSource.titles objectAtIndex:column];
		//l.backgroundColor = [UIColor colorWithRed:0.0/255 green:105.0/255 blue:186.0/255 alpha:1];
        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
		l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(0, -0.5);
		l.textAlignment = UITextAlignmentCenter;
        
        
        if( 0 == column){
            l.text = @"";
            [vTopLeft addSubview:l];
        }
        else{
            [vTopRight addSubview:l];
            columnOffset += columnWidth;
        }
        
		[l release];
	}
    columnOffset = 0.0;
    for(int column = 0;column < ([dataSource.titles count]*2-1);column++){

		float columnWidth = [[dataSource.columnWidth objectAtIndex:column] floatValue];
        NSLog(@"cellheight=%f",cellHeight);
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, cellHeight+1, columnWidth -1, cellHeight+1 )];
		l.font = [UIFont systemFontOfSize:16.0f];
		l.text = [dataSource.splitTitle objectAtIndex:(column+1)%2 ];
		//l.backgroundColor = [UIColor colorWithRed:0.0/255 green:105.0/255 blue:186.0/255 alpha:1];
        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
		l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(0, -0.5);
		l.textAlignment = UITextAlignmentCenter;
        
        
        if( 0 == column){
            l.text = @"月份";

            [vTopLeft addSubview:l];
        }
        else{
            [vTopRight addSubview:l];
            columnOffset += columnWidth;
        }
        
		[l release];
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
                float columnWidth = [[dataSource.columnWidth objectAtIndex:column-1] floatValue];;
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, (i+1) * cellHeight  , columnWidth-1, cellHeight -1 )];
                l.font = [UIFont systemFontOfSize:14.0f];
                l.text = [rowData objectAtIndex:column];
     
                l.textAlignment = UITextAlignmentCenter;
                l.tag = (i+1) * cellHeight + column + 1000;
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
                    l.frame = CGRectMake(columnOffset,  (i +1)* cellHeight , columnWidth -1 , cellHeight -1 );
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
	NSLog(@"scrollViewDidEndDecelerating");
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
    NSLog(@"scrollViewWillBeginDragging");

	scrollView.frame = CGRectMake(cellWidth, 0, scrollView.frame.size.width, self.frame.size.height);
	vRightContent.frame = CGRectMake(0, cellHeight - vLeft.contentOffset.y  ,
									 vRight.contentSize.width , contentHeight);
	
	vTopRight.frame = CGRectMake(0, 0, vRight.contentSize.width, vTopRight.frame.size.height);
	vTopRight.bounds = CGRectMake(0, 0, vRight.contentSize.width, vTopRight.frame.size.height);
	[scrollView addSubview:vTopRight];
	[self addSubview:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");

	if(!decelerate)
		[self scrollViewDidEndDecelerating:scrollView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
