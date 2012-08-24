//
//  BrokenLineGraphView.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-25.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "BrokenLineGraphView.h"

@implementation BrokenLineGraphView

@synthesize titleLabel,data;
@synthesize  marginLeft,marginTop,marginRight,marginBottom;

static sqlite3  *database;

- (id) initWithFrame:(CGRect)frame :(BrokenLineGraphData *) graphData {
    self=[super initWithFrame:frame];
    if (self) {
        self.data=graphData;
        //    self.layer.masksToBounds=YES;
        //    self.layer.cornerRadius=10.0;
        //    self.layer.borderWidth=10.0;
        self.layer.borderColor=[[UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1]CGColor];
        self.backgroundColor=[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width-40, 30)];
        titleLabel.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1.0];
        titleLabel.opaque = YES;
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        titleLabel.textColor =[UIColor whiteColor];
        titleLabel.shadowColor =[UIColor blackColor];
        titleLabel.shadowOffset= CGSizeMake(-1, -1);
        titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:titleLabel];
        [titleLabel release];
    }
  
    return self;
}

- (void) reload{
	[self setNeedsDisplay];
    
}

- (void) drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	//画刻度
    [self drawScale:context rect:rect];
    //填充点阵
    [self drawPoints:context rect:rect];
    
    [self drawTriggerPoint:context rect:rect];
    
    
}

- (void)drawScale:(CGContextRef)context rect:(CGRect)_rect{
    if([data.ytitles count] < 1 || [data.xtitles count] < 1)
        return;
    
    
    CGContextSetRGBStrokeColor(context, 71./255, 71./255, 71./255, 1);//线条颜色
	CGContextSetAllowsAntialiasing(context, NO);
    //画橫坐标和竖线
    float favg;
    if ([data.xtitles count]>1) {
        favg= (_rect.size.width-marginLeft-marginRight)/([data.xtitles count]-1);
    }
    else {
        favg= (_rect.size.width-marginLeft-marginRight);
    }
//    NSLog(@"HpiGraphView drawScale  %d条横线 %d条竖线  %f",[data.ytitles count],[data.xtitles count],favg);
	for(int i=0;i<[data.xtitles count]; i++){
        CGContextMoveToPoint(context, marginLeft+favg*i, marginTop);
        CGContextAddLineToPoint(context, marginLeft+favg*i, _rect.size.height-marginBottom);
        CGContextStrokePath(context);
        UILabel *l =[[UILabel alloc] initWithFrame:CGRectMake(marginLeft+favg*i-50, _rect.size.height-marginBottom+10, 100, 15)];
        [l setFont:[UIFont systemFontOfSize:13.0]];
		[l setTextColor:[UIColor colorWithRed:171./255 green:171./255 blue:171./255 alpha:1]];
        l.backgroundColor=[UIColor clearColor];
        l.text=[data.xtitles objectAtIndex:i];
        l.minimumFontSize = 10.0;
        l.adjustsFontSizeToFitWidth = YES;
        l.textAlignment = UITextAlignmentCenter;
        [self addSubview:l];
        [l release];
    }
    //画纵坐标和橫线
    favg= (_rect.size.height-marginTop-marginBottom)/([data.ytitles count]-1);
    for(int i=0;i<[data.ytitles count]; i++){
        CGContextMoveToPoint(context, marginLeft, marginTop+favg*i);
        CGContextAddLineToPoint(context, _rect.size.width-marginRight ,marginTop+favg*i);
        CGContextStrokePath(context);
        UILabel *l =[[UILabel alloc] initWithFrame:CGRectMake(marginLeft-62,_rect.size.height-(marginBottom+favg*i+8), 60, 16)];
        [l setFont:[UIFont systemFontOfSize:11.0]];
		[l setTextColor:[UIColor colorWithRed:171./255 green:171./255 blue:171./255 alpha:1]];
        l.backgroundColor=[UIColor clearColor];
        l.text=[data.ytitles objectAtIndex:i];
        l.minimumFontSize = 10.0;
        l.adjustsFontSizeToFitWidth = YES;
        l.textAlignment = UITextAlignmentRight;
        [self addSubview:l];
        [l release];
    }
}

- (void)drawPoints:(CGContextRef)context rect:(CGRect)_rect{
    //NSLog(@"HpiGraphView drawPoints  %d个点需描绘",[data.pointArray count]);
    //    if([data.pointArray count] < 1)
    //        return;
    BOOL start=NO;
    
//    NSLog(@"graphData.pointArray222.count=%d",[self.data.pointArray count]);
    
    for (int i=0; i<[self.data.pointArray count]; i++) {
        
        LineArray *line=[self.data.pointArray objectAtIndex:i];
        
        //CGContextSetRGBStrokeColor(context, 220./255, 11./255, 11./255, 1);//线条颜色
        CGContextSetRGBStrokeColor(context, line.red/255, line.green/255, line.blue/255, 1);//线条颜色
        
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSaveGState(context); //将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝
        CGLineCap lineCap = kCGLineCapButt;
        CGContextSetLineCap(context, lineCap);
        CGContextSetLineWidth(context, 3.0f);
        CGContextSetLineJoin(context, kCGLineJoinMiter);
        
        float wlength,hlength;
        hlength=(_rect.size.height-marginTop-marginBottom)/data.yNum;
        wlength=(_rect.size.width-marginRight-marginLeft)/(data.xNum-1);
//        NSLog(@"HpiGraphView drawPoints hlength[%f]  wlength [%f]",hlength,wlength);
        //将数据转化成坐标系
        CGContextMoveToPoint(context, marginLeft, _rect.size.height-marginBottom);
//        NSLog(@"graphData.pointArray333.count=%d",[line.pointArray count]);
        
        
        for(int i=0;i<[line.pointArray count]; i++){
            BrokenLineGraphPoint *point=[line.pointArray objectAtIndex:i];
//            NSLog(@"HpiGraphView drawPoints  第%d个点  [%d]  [%d]",i+1,point.x,point.y);
            if (start == NO) {
                CGContextMoveToPoint(context, marginLeft+(point.x)*wlength, _rect.size.height-marginBottom-point.y*hlength);
                start = YES;
//                NSLog(@"HpiGraphView drawPoints  第%d个点  [%f]  [%f]",i+1,marginLeft+(point.x)*wlength,_rect.size.height-marginBottom-point.y*hlength);
            }
            else {
                CGContextAddLineToPoint(context, marginLeft+(point.x)*wlength, _rect.size.height-marginBottom-point.y*hlength);
//                NSLog(@"HpiGraphView drawPoints Line 第%d个点  [%f]  [%f]",i+1,marginLeft+(point.x)*wlength,_rect.size.height-marginBottom-point.y*hlength);
            }
        }
        CGContextStrokePath(context);
        
        CGContextRestoreGState(context);
        
    }
    
}

- (void)drawTriggerPoint:(CGContextRef)context rect:(CGRect)_rect{
//    NSLog(@"HpiGraphView drawPoints  %d个点需描绘",[data.pointArray count]);
    //    if([data.pointArray count] < 1)
    //        return;
    BOOL start=NO;
    char *errorMsg;
    //打开数据库
    NSString *file=[NTShipCompanyTranShareDao dataFilePath];
    if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"open  NTShipCompanyTranShareDao error");
        return;
    }
    NSLog(@"open NTShipCompanyTranShareDao database succes ....");
    
    //为提高数据库写入性能，加入事务控制，批量提交
    if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec begin error");
        return;
    }

//    NSLog(@"graphData.pointArray222.count=%d",[self.data.pointArray count]);
    
    for (int i=0; i<[self.data.pointArray count]; i++) {
        
        LineArray *line=[self.data.pointArray objectAtIndex:i];
        
        
        float wlength,hlength;
        hlength=(_rect.size.height-marginTop-marginBottom)/data.yNum;
        wlength=(_rect.size.width-marginRight-marginLeft)/(data.xNum-1);
//        NSLog(@"HpiGraphView drawPoints hlength[%f]  wlength [%f]",hlength,wlength);
        //将数据转化成坐标系
//        NSLog(@"graphData.pointArray333.count=%d",[line.pointArray count]);
        
        
        for(int i=0;i<[line.pointArray count]; i++){
            BrokenLineGraphPoint *point=[line.pointArray objectAtIndex:i];
            
//            NSLog(@"HpiGraphView drawPoints  第%d个点  [%d]  [%d]",i+1,point.x,point.y);
            if (start == NO) {
                start = YES;
//                NSLog(@"HpiGraphView drawPoints  第%d个点  [%f]  [%f]",i+1,marginLeft+(point.x)*wlength,_rect.size.height-marginBottom-point.y*hlength);
            }
            else {
                NTShipCompanyTranShare *companyShare = point.companyShare;
                NSInteger x=marginLeft+(point.x)*wlength;
                NSInteger y=_rect.size.height-marginBottom-point.y*hlength;
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 10, 10)];
                button.center=CGPointMake(x, y);
//                button.backgroundColor=[UIColor blueColor];
                button.backgroundColor= [UIColor colorWithRed:line.red/255 green:line.green/255 blue:line.blue/255 alpha:1];
//                [NTShipCompanyTranShareDao updateTransShareCoordinate:companyShare.TAG setX:x setY:y];
                NSString *updateSql=[NSString stringWithFormat:@"update  TMP_NTShipCompanyTranShare  set x=%d, y=%d where TAG=%d ",x,y,companyShare.TAG];
                if(sqlite3_exec(database,[updateSql UTF8String],NULL,NULL,NULL)!=SQLITE_OK)
                {
                    NSLog( @"Error: update data error with message [%s]  sql[%@]", sqlite3_errmsg(database),updateSql);
                }
                else
                {
                    //		NSLog(@"update success");
                }

                button.tag=companyShare.TAG;
                button.layer.cornerRadius=4.0;
                [button addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:button];
                [button release];
                
            }
        }
        
    }
    if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec commit error");
        return;
    }
    sqlite3_close(database);
    NSLog(@"commit over   ");

//        NSLog(@"HpiGraphView drawPoints  %d个点需描绘",[data.pointArray count]);
}

-(void)showDetail:(id)sender{
    UIButton *buttonTag= sender;
    NSLog(@"tag=%d",buttonTag.tag);
    //以此判断该点是否在横坐标上，是的话不显示Pop
    if (buttonTag.tag!=0) {
        NTShipCompanyTranShare *companyShare=[NTShipCompanyTranShareDao getTransShareByTag:buttonTag.tag];
        
        ShipCompanyShareDetailVC *detailVC = [[ShipCompanyShareDetailVC alloc]init];
        UIPopoverController *pop= [[UIPopoverController alloc] initWithContentViewController:detailVC];
        detailVC.popover=pop;
        pop.popoverContentSize=CGSizeMake(150, 150);
        
        [pop  presentPopoverFromRect:CGRectMake(companyShare.X, companyShare.Y, 5, 5) inView:self permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        detailVC.company.text=[NSString stringWithFormat:@"船厂：%@",companyShare.COMPANY];
        detailVC.lw.text=[NSString stringWithFormat:@"载煤量：%d",companyShare.LW];
        detailVC.percent.text=[NSString stringWithFormat:@"份额：%@%%",companyShare.PERCENT];
        detailVC.company.textColor= [UIColor whiteColor];
        detailVC.lw.textColor= [UIColor whiteColor];
        detailVC.percent.textColor= [UIColor whiteColor];
        
        [pop release];
        [detailVC release];
    }
    
}

- (void) dealloc {
	
	[data release];
	[titleLabel release];
    [super dealloc];
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
