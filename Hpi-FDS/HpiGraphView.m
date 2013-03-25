//
//  HpiGraphView.m
//  Created by zcx on 04/25/2012.
//

#import "HpiGraphView.h"

@implementation HpiGraphView
@synthesize titleLabel,data;
@synthesize  marginLeft,marginTop,marginRight,marginBottom;
- (id) initWithFrame:(CGRect)frame :(HpiGraphData *) graphData {
    self=[super initWithFrame:frame];
    if (self) {
        self.data=graphData;
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=5.0;
        self.layer.borderWidth=5.0;
        self.layer.borderColor=[[UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1]CGColor];
        self.backgroundColor=[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, frame.size.width-40, 30)];
        titleLabel.backgroundColor = [UIColor colorWithRed:49./255 green:49./255 blue:49./255 alpha:1.0];
        titleLabel.opaque = YES;
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        titleLabel.textColor =[UIColor whiteColor];
        titleLabel.shadowColor =[UIColor blackColor];
        titleLabel.shadowOffset= CGSizeMake(-1, -1);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
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
}

- (void)drawScale:(CGContextRef)context rect:(CGRect)_rect{
    if([data.ytitles count] < 1 || [data.xtitles count] < 1)
        return;
    
    CGContextSetRGBStrokeColor(context, 71./255, 71./255, 71./255, 1);//线条颜色
	CGContextSetAllowsAntialiasing(context, NO);
    //画橫坐标和竖线
    float favg= (_rect.size.width-marginLeft-marginRight)/([data.xtitles count]-1);
    //NSLog(@"HpiGraphView drawScale  %d条竖线 %d条横线  %f",[data.ytitles count],[data.xtitles count],favg);
	for(int i=0;i<[data.xtitles count]; i++){
        CGContextMoveToPoint(context, marginLeft+favg*i, marginTop);
        CGContextAddLineToPoint(context, marginLeft+favg*i, _rect.size.height-marginBottom);
        CGContextStrokePath(context);
        UILabel *l =[[UILabel alloc] initWithFrame:CGRectMake(marginLeft+favg*i-50, _rect.size.height-marginBottom+10, 100, 15)];
        [l setFont:[UIFont systemFontOfSize:13.0]];
		[l setTextColor:[UIColor colorWithRed:171./255 green:171./255 blue:171./255 alpha:1]];
        l.backgroundColor=[UIColor clearColor];
        l.text=[data.xtitles objectAtIndex:i];
//        l.minimumFontSize = 10.0;
        l.adjustsFontSizeToFitWidth = YES;
        l.textAlignment = NSTextAlignmentCenter;
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
//        l.minimumFontSize = 10.0;
        l.adjustsFontSizeToFitWidth = YES;
        l.textAlignment = NSTextAlignmentCenter;
        [self addSubview:l];
        [l release];
    }
}

- (void)drawPoints:(CGContextRef)context rect:(CGRect)_rect{
    //NSLog(@"HpiGraphView drawPoints  %d个点需描绘",[data.pointArray count]);
//    if([data.pointArray count] < 1)
//        return;
    
    
    
    NSLog(@"[data.pointArray count]========%d",[data.pointArray count]);
    NSLog(@"[data.pointArray2 count]========%d",[data.pointArray2 count]);
    NSLog(@"[data.pointArray3 count]========%d",[data.pointArray3 count]);
    
    
    
    
    BOOL start=NO;
    CGContextSetRGBStrokeColor(context, 220./255, 11./255, 11./255, 1);//线条颜色
	CGContextSetAllowsAntialiasing(context, YES);
    CGContextSaveGState(context); //将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝
    CGLineCap lineCap = kCGLineCapButt;
    CGContextSetLineCap(context, lineCap);
    CGContextSetLineWidth(context, 2.0f);
	CGContextSetLineJoin(context, kCGLineJoinMiter);
    
    float wlength,hlength;
    hlength=(_rect.size.height-marginTop-marginBottom)/data.yNum;

    wlength=(_rect.size.width-marginRight-marginLeft)/data.xNum;
   // NSLog(@"HpiGraphView drawPoints hlength[%f]  wlength [%f]",hlength,wlength);
    //将数据转化成坐标系
    CGContextMoveToPoint(context, marginLeft, _rect.size.height-marginBottom);
    for(int i=0;i<[data.pointArray count]; i++){
        
        HpiPoint *point=[data.pointArray objectAtIndex:i];
      // NSLog(@"HpiGraphView drawPoints  第%d个点  [%d]  [%d]",i+1,point.x,point.y);
        if (start == NO) {
            CGContextMoveToPoint(context, marginLeft+(point.x)*wlength, _rect.size.height-marginBottom-point.y*hlength);
            start = YES;
          // NSLog(@"HpiGraphView drawPoints  第%d个点  [%f]  [%f]",i+1,marginLeft+(point.x)*wlength,_rect.size.height-marginBottom-point.y*hlength);
        }
        else {
            CGContextAddLineToPoint(context, marginLeft+(point.x)*wlength, _rect.size.height-marginBottom-point.y*hlength);
            // NSLog(@"HpiGraphView drawPoints  第%d个点  [%f]  [%f]",i+1,marginLeft+(point.x)*wlength,_rect.size.height-marginBottom-point.y*hlength);
        }
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);

    
    
    
    
    CGContextSetRGBStrokeColor(context, 11.0/255, 220./255, 11./255, 1);//线条颜色
	CGContextSetAllowsAntialiasing(context, YES);
    CGContextSaveGState(context);
    CGContextSetLineCap(context, lineCap);
    CGContextSetLineWidth(context, 2.0f);
	CGContextSetLineJoin(context, kCGLineJoinMiter);
    CGContextSetRGBStrokeColor(context, 11./255, 220./255, 11./255, 1);//线条颜色
    start = NO;
    
    
    for(int i=0;i<[data.pointArray2 count]; i++){
             
        
        HpiPoint *point=[data.pointArray2 objectAtIndex:i];
//        NSLog(@"HpiGraphView drawPoints2  第%d个点  [%d]  [%d]",i+1,point.x,point.y);
        if (start == NO) {
            CGContextMoveToPoint(context, marginLeft+(point.x)*wlength, _rect.size.height-marginBottom-point.y*hlength);
            start = YES;
//            NSLog(@"HpiGraphView drawPoints2  第%d个点  [%f]  [%f]",i+1,marginLeft+(point.x)*wlength,_rect.size.height-marginBottom-point.y*hlength);
        }
        else {
            CGContextAddLineToPoint(context, marginLeft+(point.x)*wlength, _rect.size.height-marginBottom-point.y*hlength);
//            NSLog(@"HpiGraphView drawPoints2  第%d个点  [%f]  [%f]",i+1,marginLeft+(point.x)*wlength,_rect.size.height-marginBottom-point.y*hlength);
        }
    }
    
    
    
    
	CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSetRGBStrokeColor(context, 11.0/255, 11./255, 220./255, 1);//线条颜色
	CGContextSetAllowsAntialiasing(context, YES);
    CGContextSaveGState(context);
    CGContextSetLineCap(context, lineCap);
    CGContextSetLineWidth(context, 2.0f);
	CGContextSetLineJoin(context, kCGLineJoinMiter);
    CGContextSetRGBStrokeColor(context, 11./255, 11./255, 220./255, 1);//线条颜色
    start = NO;
    for(int i=0;i<[data.pointArray3 count]; i++){
        HpiPoint *point=[data.pointArray3 objectAtIndex:i];
//        NSLog(@"HpiGraphView drawPoints  第%d个点  [%d]  [%d]",i+1,point.x,point.y);
        if (start == NO) {
            CGContextMoveToPoint(context, marginLeft+(point.x)*wlength, _rect.size.height-marginBottom-point.y*hlength);
            start = YES;
//            NSLog(@"HpiGraphView drawPoints  第%d个点  [%f]  [%f]",i+1,marginLeft+(point.x)*wlength,_rect.size.height-marginBottom-point.y*hlength);
        }
        else {
            CGContextAddLineToPoint(context, marginLeft+(point.x)*wlength, _rect.size.height-marginBottom-point.y*hlength);
//            NSLog(@"HpiGraphView drawPoints  第%d个点  [%f]  [%f]",i+1,marginLeft+(point.x)*wlength,_rect.size.height-marginBottom-point.y*hlength);
        }
    }
	CGContextStrokePath(context);
   CGContextRestoreGState(context);
}

- (void) dealloc {
	
	[data release];
	[titleLabel release];
    [super dealloc];
}

@end