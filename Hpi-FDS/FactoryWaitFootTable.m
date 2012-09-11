//
//  FactoryWaitFootTable.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "FactoryWaitFootTable.h"
 /*
@implementation MultiTitleDataGridScrollView
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
*/
@implementation FactoryWaitFootTable
MultiTitleDataSource *source;

NSMutableArray *columnWidth1;
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
-(void)getColument
{
    NSMutableArray *subTitel=[[NSMutableArray alloc] init ];
    NSMutableArray *columW=[[NSMutableArray alloc] init ];
    columnWidth1=[[NSMutableArray alloc] init ];
 
 //拆分 成每个单元格的宽度
     NSLog(@"%d",[source.columnWidth count]);
    
    
    
    for (int i=0; i<[source.columnWidth count]; i++) {
        
        if (i>1&&i!=[source.columnWidth count]-1) {
              //提取  父标题的宽度  数组columnWidth1
            [columnWidth1 addObject:[source.columnWidth objectAtIndex:i]];
            
           subTitel=[source.splitTitle objectAtIndex:i-2];
            
            for (int a=0; a<[subTitel count]; a++) {
                int cW=[[source.columnWidth objectAtIndex:i]integerValue]/[subTitel count];
                [columW addObject:[NSString stringWithFormat:@"%d",cW]];
            }

        }else{
            if (i==1) {
                [columnWidth1 addObject:[source.columnWidth objectAtIndex:i]];
            }
            
        [columW addObject:[source.columnWidth objectAtIndex:i]];
        }
    } 
    source.columnWidth=columW;
    [columW release];  
}
-(void)layoutSubView:(CGRect)aRect{
    source=(MultiTitleDataSource *)dataSource;
    [self getColument];
   //   NSLog(@"-----source.splitTitle-------%d", [source.splitTitle count]) ;
   // NSLog(@"-----source.data-------%d", [source.data count]) ;
    // NSLog(@"-----source.columnWidth-------%d", [source.columnWidth  count]) ;
   //  NSLog(@"-----source.titles -------%d", [source.titles  count]) ;
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
    int d=2;
   	//-------------------填冲标题数据
    //第一个单元格   ---------高度  没有二层标题时   *1
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth-1, cellHeight*2-1 )];
    l2.font = [UIFont systemFontOfSize:13.0f];
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
            
            [vTopRight addSubview:l];
            [l release];

        }
        
        if (column!=[source.titles count]-1)
         {
             //父标题 宽度
             int fTitleWidth=[[columnWidth1 objectAtIndex:column-1] integerValue];
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
            
            [vTopRight addSubview:l];
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
                     
                     [vTopRight addSubview:l1];
                     set+=cdw;
                     [l1 release];
                     d++;
                     
                   }
                
              }
             
             
             columnOffset += fTitleWidth;
            
        }
               
    }
    




//填充数据内容
//填冲数据内容
for(int i = 0;i<[source.data count];i++){
    NSLog(@"填充数据中 .。。。");
    
    NSArray *rowData = [source.data objectAtIndex:i];
    columnOffset = 0.0;
     int count=2;
    for(int column=0;column<[source.titles count];column++){
              
        UILabel *l;
        if(column==0){
             float columnWidth = [[source.columnWidth objectAtIndex:column] floatValue];
            l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 )];
            l.font = [UIFont systemFontOfSize:14.0f];
            l.text = [rowData objectAtIndex:column];
            l.textAlignment = UITextAlignmentCenter;
            l.tag = i * cellHeight + column + 1000;
            
            if(i % 2 == 0)
                l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
            else
                l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
            
             [vLeftContent addSubview:l];
            
            
             [l release];
        
        }else
        {
              NSMutableArray *subRowdata=[rowData objectAtIndex:column];
           
            float columnWidth =0;
            
            
            if(column==1){//计划
                NSLog(@"计划");
                  columnWidth = [[columnWidth1 objectAtIndex:column-1] floatValue];
               /* 
                UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom] ;
                b.frame= CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 );
                
                b.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                b.titleLabel.textAlignment=UITextAlignmentCenter;
                b.tag= i * cellHeight + column + 1000;
                
                
                if ([subRowdata count]<=0)
                [b setTitle:@"" forState:UIControlStateNormal];
                else
                [b setTitle:[ NSString stringWithFormat:@"有数据【%d】",[subRowdata count   ]] forState:UIControlStateNormal];
                
                if(i % 2 == 0)
                    [b setBackgroundColor:[UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1]];
                else
                    [b setBackgroundColor:[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1]];
                
                
                [b addTarget:self action:@selector(onClick3) forControlEvents:UIControlEventTouchUpInside];
                
                
                [vRightContent addSubview:b];
                [b release];
                
                */
                
                
                l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , columnWidth-1, cellHeight -1 )];
               
                
                l.font = [UIFont systemFontOfSize:14.0f];
                l.textAlignment = UITextAlignmentCenter;
                l.tag = i * cellHeight + column + 1000;

                if ([subRowdata count]<=0)
                    l.text = @"";
                    else
                    l.text = [ NSString stringWithFormat:@"有数据【%d】",[subRowdata count   ]];
                

                if(i % 2 == 0)
                    l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                else
                    l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                [vRightContent addSubview:l];
                [l release];
            
            }
           
            
            if(column==2)//电厂
            {
                 NSLog(@"电厂");
                 columnWidth = [[columnWidth1 objectAtIndex:column-1] floatValue];
                int co =0;
                
                 for(int t=0;t<[subRowdata count];t++){
                  
                     int cw=[[source.columnWidth objectAtIndex:count] integerValue];
                 
                     l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset+co, i * cellHeight  , cw-1, cellHeight -1 )];
                     
                     
                     l.font = [UIFont systemFontOfSize:14.0f];
                     l.text = [subRowdata objectAtIndex:t ];
                     l.textAlignment = UITextAlignmentCenter;
                     l.tag = i * cellHeight + column+t + 1000;
                     
                     if(i % 2 == 0)
                         l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                     else
                         l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                     
                     [vRightContent addSubview:l];
                     [l release];
                     co+=cw;
                     count++;
            
            
                }
            }
            if (column==3) {//实际
                
                 NSLog(@"实际");
                columnWidth = [[columnWidth1 objectAtIndex:column-1] floatValue];
                 int co =0;
                for (int t=0; t<[subRowdata count]; t++) {
                    NSMutableArray *subArr=[subRowdata objectAtIndex:t];
                    int cw=[[source.columnWidth objectAtIndex:count] integerValue];
                    
                    l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset+co, i * cellHeight  , cw-1, cellHeight -1 )];
                    
                    l.font = [UIFont systemFontOfSize:14.0f];
                    l.textAlignment = UITextAlignmentCenter;
                    l.tag = i * cellHeight + column+t + 1000;
                    if ([subArr  count]>0) 
                       
                        l.text = [ NSString stringWithFormat:@"有数据【%d】",[subArr count   ]];
                    else
                        l.text=@"";
                       
                    if(i % 2 == 0)
                        l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                    else
                        l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                    
                    [vRightContent addSubview:l];
                    [l release];
                    co+=cw;
                    count++;
                    
                } 
            }
            if (column==4) {
                
                  NSLog(@"备注");
                NSLog(@"==[subRowdata count]============%d",[subRowdata count]);
               NSLog(@"====count==========%d",count);
                for (int t=0; t<[subRowdata count]; t++) {
                    int cw=[[source.columnWidth objectAtIndex:count] integerValue] ;
  
                    l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, i * cellHeight  , cw-1, cellHeight -1 )];
                    
                    l.font = [UIFont systemFontOfSize:14.0f];
                    l.text =[subRowdata objectAtIndex:t ];
                    l.textAlignment = UITextAlignmentCenter;
                    l.tag = i * cellHeight+t + column + 1000;
                    
                    
                    if(i % 2 == 0)
                        l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
                    else
                        l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
                    [vRightContent addSubview:l];
                    [l release];
                }
                 NSLog(@"备注  完毕");
               
            }
            columnOffset += columnWidth;
             
        
        }  
    }
    NSLog(@"i=======%d",i);
    
}


    
    
}

-(void)onClick3
{


    NSLog(@"哈哈");




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
