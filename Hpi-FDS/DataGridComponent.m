//
//  DataGridComponent.m
//
//  Created by lee jory on 09-10-22.
//  Copyright 2009 Netgen. All rights reserved.
//

#import "DataGridComponent.h"

@implementation DataGridScrollView
@synthesize dataGridComponent;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *t = [touches anyObject];
	if([t tapCount] == 1){
		DataGridComponent *d = (DataGridComponent*)dataGridComponent;
		int idx = [t locationInView:self].y / d.cellHeight;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.65];
		for(int i=0;i<[d.dataSource.titles count];i++){
			UILabel *l = (UILabel*)[dataGridComponent viewWithTag:idx * d.cellHeight + i + 1000];
			l.alpha = .5;
		}
		for(int i=0;i<[d.dataSource.titles count];i++){
			UILabel *l = (UILabel*)[dataGridComponent viewWithTag:idx * d.cellHeight + i + 1000];
			l.alpha = 1.0;
		}		
		[UIView commitAnimations];
	}
}

@end

@implementation DataGridComponentDataSource
@synthesize titles,data,columnWidth;

- (void) dealloc
{
    [data release];
    [titles release];
    [columnWidth release];
  
	[super dealloc];
}

@end

//声明私有方法
@interface DataGridComponent(Private)

/**
 * 初始化各子视图
 */
-(void)layoutSubView:(CGRect)aRect;

/**
 * 用数据项填冲数据
 */
-(void)fillData;

@end


@implementation DataGridComponent
@synthesize dataSource,cellHeight,vRight,vLeft;

- (id)initWithFrame:(CGRect)aRect data:(DataGridComponentDataSource*)aDataSource{
	self = [super initWithFrame:aRect];
	if(self != nil){
        
		self.clipsToBounds = YES;
		//self.backgroundColor = [UIColor blackColor];
        self.backgroundColor = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
		self.dataSource = aDataSource;
        
		//初始显示视图及Cell的长宽高
		contentWidth = .0;
		cellHeight = 40.0;
        cellWidth = [[dataSource.columnWidth objectAtIndex:0] intValue];
		for(int i=1;i<[dataSource.columnWidth count];i++)
			contentWidth += [[dataSource.columnWidth objectAtIndex:i] intValue];
		contentHeight = [dataSource.data count] * cellHeight;		
		contentWidth = contentWidth + [[dataSource.columnWidth objectAtIndex:0] intValue]  < aRect.size.width 
        ? aRect.size.width : contentWidth;
        
        
      
        
		//初始化各视图
		[self layoutSubView:aRect];
		
		//填冲数据
		[self fillData];
        
	}
	return self;
}

-(void)layoutSubView:(CGRect)aRect{
	vLeftContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, contentHeight)];
	vRightContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aRect.size.width - cellWidth, contentHeight)];
	
	vLeftContent.opaque = YES;
	vRightContent.opaque = YES;
	
	
	//初始化各视图
	vTopLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight+2)];
	vLeft = [[DataGridScrollView alloc] initWithFrame:CGRectMake(0, cellHeight+2, aRect.size.width, aRect.size.height - cellHeight-2)];
	vRight = [[DataGridScrollView alloc] initWithFrame:CGRectMake(cellWidth, 0, aRect.size.width - cellWidth, contentHeight)];
	vTopRight = [[UIView alloc] initWithFrame:CGRectMake(cellWidth, 0, aRect.size.width - cellWidth, cellHeight+2)];
	
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
		float columnWidth = [[dataSource.columnWidth objectAtIndex:column] floatValue];
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
                float columnWidth = [[dataSource.columnWidth objectAtIndex:column-1] floatValue];
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 )];
                l.font = [UIFont systemFontOfSize:14.0f];
                l.text = [rowData objectAtIndex:column];
//                if(column==1)
//                { 
//                    l.textAlignment = UITextAlignmentLeft;
//                }
//                else {
//                    l.textAlignment = UITextAlignmentCenter;
//                }
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
	vRightContent.frame = CGRectMake(0, cellHeight - vLeft.contentOffset.y  , 
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

- (void) dealloc
{
    
	[vLeft release];
	[vRight release];
	[vRightContent release];
	[vLeftContent release];
	[vTopLeft release];
	[vTopRight release];
	[super dealloc];
}


@end
