//
//  FactoryWaitHeadTable.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-29.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "FactoryWaitHeadTable.h"

@implementation FactoryWaitHeadTable

- (id)initWithFrame:(CGRect)aRect data:(DataGridComponentDataSource*)aDataSource{

    self = [super initWithFrame:aRect];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
		//self.backgroundColor = [UIColor blackColor];
        self.backgroundColor = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:71.0/255 alpha:1];
		self.dataSource = aDataSource;
        
		//初始显示视图及Cell的长宽高
		contentWidth = .0;
		cellHeight = 30.0;
        cellWidth = [[dataSource.columnWidth objectAtIndex:0] intValue];
		for(int i=1;i<[dataSource.columnWidth count];i++)
			contentWidth += [[dataSource.columnWidth objectAtIndex:i] intValue];
		contentHeight = [dataSource.titles count]* cellHeight;//
		contentWidth = contentWidth + [[dataSource.columnWidth objectAtIndex:0] intValue]  < aRect.size.width
        ? aRect.size.width : contentWidth;
        
		//初始化各视图
		[self layoutSubView:aRect];
		
		//填冲数据
		[self fillData];

   
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

-(void)layoutSubView:(CGRect)aRect
{
    vLeftContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, contentHeight)];
	vRightContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aRect.size.width - cellWidth, contentHeight)];//
   
	vLeftContent.opaque = YES;
	vRightContent.opaque = YES;
	
	
	//初始化各视图
	vTopLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
	vLeft = [[DataGridScrollView alloc] initWithFrame:CGRectMake(0, cellHeight, aRect.size.width, aRect.size.height - cellHeight)];
	vRight = [[DataGridScrollView alloc] initWithFrame:CGRectMake(cellWidth, 0, aRect.size.width - cellWidth, contentHeight)];
	vTopRight = [[UIView alloc] initWithFrame:CGRectMake(cellWidth, 0, aRect.size.width - cellWidth, cellHeight)];
	
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

-(void)fillData
{
    
   
    float columnOffset = 0.0;
    //int iColorRed=0;
    int a=0;
    UILabel *l;
	//填冲标题数据
	for(int column = 0;column < [dataSource.columnWidth count];column++){
		float columnWidth = [[dataSource.columnWidth objectAtIndex:column] floatValue];
        
        if (column%2==0) {//计数列
            l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth -1, cellHeight-1 )];
            l.font = [UIFont systemFontOfSize:15.0f];
            l.text = [[dataSource.titles objectAtIndex:0] objectAtIndex:a];
            
            l.lineBreakMode = NSLineBreakByCharWrapping;
            
            l.backgroundColor=[UIColor blackColor];
            l.textColor=[UIColor whiteColor];
            l.shadowColor=[UIColor whiteColor   ];

            l.textAlignment = NSTextAlignmentLeft;

             a++;
            
        }else
        {
            l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0  , columnWidth-1, cellHeight -1 )];
            l.font = [UIFont systemFontOfSize:15.0f];
            l.lineBreakMode = NSLineBreakByCharWrapping;
            
            l.backgroundColor=[UIColor blackColor];
            l.textColor=[UIColor whiteColor];
            l.shadowColor=[UIColor whiteColor   ];
          
            
            l.text =@"2＃机组 （7/16） 备用";
            l.numberOfLines = 3;
            
            l.textAlignment = NSTextAlignmentCenter;
        }

        if( 0 == column){
            [vTopLeft addSubview:l];
        }
        else{
            
            [vTopRight addSubview:l];
            columnOffset += columnWidth;
        }
        
		[l release];
	}	

  

    //填冲数据  内容
	for (int i=1; i<[dataSource.titles count]; i++) {
        columnOffset = 0.0;
        a=0;
        NSArray *rowData = [dataSource.titles objectAtIndex:i];
          float  columnWidth = 0.0;
        
        if (i==1) {
            for(int column=0;column<[dataSource.columnWidth count];column++){
                
                 columnWidth = [[dataSource.columnWidth objectAtIndex:column] floatValue];
                if (column%2==0) {//计数列 
                    l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0 , columnWidth-1, cellHeight -1 )];
                    l.font = [UIFont systemFontOfSize:15.0f];
                    l.text = [rowData objectAtIndex:a];
                    
                    l.backgroundColor=[UIColor blackColor];
                    l.textColor=[UIColor whiteColor];
                    l.shadowColor=[UIColor whiteColor   ];
                    l.lineBreakMode = NSLineBreakByCharWrapping;
                    

                    l.textAlignment = NSTextAlignmentLeft;
                    a++;
                }else
                {
                   
                   
                    l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset,0, columnWidth-1, cellHeight -1 )];
                    l.font = [UIFont systemFontOfSize:15.0f];
                    l.lineBreakMode = NSLineBreakByCharWrapping;
                    
                    l.backgroundColor=[UIColor blackColor];
                    l.textColor=[UIColor whiteColor];
                    l.shadowColor=[UIColor whiteColor   ];
                    l.lineBreakMode = NSLineBreakByCharWrapping;
                    
                    l.text =@"备用";
                    l.numberOfLines = 3;
                    
                    l.textAlignment = NSTextAlignmentCenter;
                   
                }
                if( 0 == column){
                    [vLeftContent addSubview:l];
                    [l release];
                }
                else if( 0< column) {
                     NSLog(@"column[%d]", column);
                    [vRightContent addSubview:l];
                    
                    
                    columnOffset += columnWidth;
                    [l release];
                    
                   
                }
                
            }
       
        }
        
        //
        
        else//第3、4行
        {
           
            if (i==2) {
                for (int d=0; d<4; d++) {
                    columnWidth = [[dataSource.columnWidth objectAtIndex:d] floatValue];
                    if (d%2==0) {
                        l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, (i-1) * cellHeight  , columnWidth-1, cellHeight -1 )];
                        l.font = [UIFont systemFontOfSize:15.0f];
                        l.text = [rowData objectAtIndex:a];
                        
                        l.backgroundColor=[UIColor blackColor];
                        l.textColor=[UIColor whiteColor];
                        l.shadowColor=[UIColor whiteColor   ];
                        l.lineBreakMode = NSLineBreakByCharWrapping;
                        l.textAlignment = NSTextAlignmentCenter;
                        a++;
                    }else
                    {
                        if (d!=3) {
                            l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, (i-1)  * cellHeight  , columnWidth-1, cellHeight -1 )];
                            l.font = [UIFont systemFontOfSize:15.0f];
                            l.backgroundColor=[UIColor blackColor];
                            l.textColor=[UIColor whiteColor];
                            l.shadowColor=[UIColor whiteColor   ];
                            l.lineBreakMode = NSLineBreakByCharWrapping;
                            
                            l.text =@"暂无";
                            l.textAlignment = NSTextAlignmentCenter;
                        }else
                        {
                            l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, (i-1)  * cellHeight  , (contentWidth-columnOffset)-1, cellHeight -1 )];
                            l.font = [UIFont systemFontOfSize:15.0f];
                            
                            l.backgroundColor=[UIColor blackColor];
                            l.textColor=[UIColor whiteColor];
                            l.shadowColor=[UIColor whiteColor   ];
                            l.lineBreakMode = NSLineBreakByCharWrapping;
                            
                            l.text =@"暂无";
                            l.textAlignment = NSTextAlignmentCenter;
                        }
                    }
                    if( 0 == d){
                        [vLeftContent addSubview:l];
                    }
                    else if( 0< d) {
                        [vRightContent addSubview:l];
                        columnOffset += columnWidth;
                    }
                    
                    [l release];

                }
                
            }else
            {
                columnWidth = [[dataSource.columnWidth objectAtIndex:0] floatValue];
                l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, (i-1)  * cellHeight  , columnWidth-1, cellHeight -1 )];
                l.font = [UIFont systemFontOfSize:15.0f];
                l.text = [rowData objectAtIndex:a];
                
                l.backgroundColor=[UIColor blackColor];
                l.textColor=[UIColor whiteColor];
                l.shadowColor=[UIColor whiteColor   ];
                l.lineBreakMode = NSLineBreakByCharWrapping;
                
                l.textAlignment = NSTextAlignmentLeft;
              
                
                
                [vLeftContent addSubview:l];
                [l release];
                
                
                columnWidth = [[dataSource.columnWidth objectAtIndex:1] floatValue];
                
                NSLog(@"");
                
                l = [[UILabel alloc] initWithFrame:CGRectMake(0, (i-1)  * cellHeight  , contentWidth-1, cellHeight -1 )];
                
                l.backgroundColor=[UIColor blackColor];
                l.textColor=[UIColor whiteColor];
                l.shadowColor=[UIColor whiteColor   ];
                l.lineBreakMode = NSLineBreakByCharWrapping;
                
                
                l.font = [UIFont systemFontOfSize:15.0f];
                l.text =@"暂无";
                l.textAlignment = NSTextAlignmentCenter;
                
                
                [vRightContent addSubview:l];
                [l release];
            
            
            }
        
        }
    }
}





//-------------------------------以下为事件处发方法----------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	//vTopLeft.frame=CGRectMake(0, 0, cellWidth, vTopLeft.frame.size.height);
  //  vLeftContent.frame= CGRectMake(0,cellHeight,vLeftContent.frame.size.width,vLeft.frame.size.height)  ;
    
    
    
    
	vTopRight.frame = CGRectMake(cellWidth, 0, vRight.contentSize.width, vTopRight.frame.size.height);
	vTopRight.bounds = CGRectMake(scrollView.contentOffset.x, 0, vTopRight.frame.size.width, vTopRight.frame.size.height);
	vTopRight.clipsToBounds = YES;
    
    
    
    
	vRightContent.frame = CGRectMake(0, 0  ,
									 vRight.contentSize.width , contentHeight);
	[self addSubview:vTopRight];
    
    [self addSubview:vTopLeft];
	vRight.frame =CGRectMake(cellWidth, 0, self.frame.size.width - cellWidth, vLeft.contentSize.height);
    
    
	[vLeft addSubview:scrollView];
	
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	scrollView.frame = CGRectMake(cellWidth, 0, scrollView.frame.size.width, self.frame.size.height);
    
   // vLeftContent.frame=CGRectMake(0, cellHeight, cellWidth, contentHeight);

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
