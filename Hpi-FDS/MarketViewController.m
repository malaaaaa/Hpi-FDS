//
//  MarketViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-7.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "MarketViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MarketViewController ()

@end

@implementation MarketViewController
@synthesize pageCtrl,scrView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"市场信息", @"3th");
        self.tabBarItem.image = [UIImage imageNamed:@"market"];
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
    
    CGRect bounds = self.view.frame;  //获取界面区域
    NSLog(@"self.view.frame [%@]",NSStringFromCGRect(self.view.frame));
    //加载蒙板图片，限于篇幅，这里仅显示一张图片的加载方法
    UIImageView* imageView1 = [[[UIImageView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, 30, 30)] autorelease];  //创建UIImageView，位置大小与主界面一样。
    [imageView1 setImage:[UIImage imageNamed:@"map.png"]];
    imageView1.alpha = 0.5f;//将透明度设为50%
    NSLog(@"imageView1.frame [%@]",NSStringFromCGRect(imageView1.frame));

    //加载蒙板图片，限于篇幅，这里仅显示一张图片的加载方法
    UIImageView* imageView2 = [[[UIImageView alloc] initWithFrame:CGRectMake(bounds.size.width, bounds.origin.y, 30,30)] autorelease];  //创建UIImageView，位置大小与主界面一样。
    [imageView2 setImage:[UIImage imageNamed:@"market.png"]];
    imageView2.alpha = 0.5f;//将透明度设为50%
    
    //加载蒙板图片，限于篇幅，这里仅显示一张图片的加载方法
    UIImageView* imageView3 = [[[UIImageView alloc] initWithFrame:CGRectMake(bounds.size.width*2, bounds.origin.y, 30,30)] autorelease];  //创建UIImageView，位置大小与主界面一样。
    [imageView3 setImage:[UIImage imageNamed:@"setup.png"]];
    imageView3.alpha = 0.5f;//将透明度设为50%
    
    
    //创建UIScrollView，位置大小与主界面一样
    scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 60, 1024-30*2, 60)];
    //设置全部内容的尺寸，这里帮助图片是3张，所以宽度设为界面宽度*3，高度和界面一致
    [scrView setContentSize:CGSizeMake(bounds.size.width * 3, bounds.size.height)];
    
    //设为YES时，会按页滑动
    scrView.pagingEnabled = YES;
    //取消UIScrollView的弹性属性，这个可以按个人喜好来定
    scrView.bounces = NO;
    //UIScrollView的delegate函数在本类中定义
    [scrView setDelegate:self];
    
    //因为我们使用UIPageControl表示页面进度，所以取消UIScrollView自己的进度条。
    scrView.showsHorizontalScrollIndicator = NO;
    [scrView addSubview:imageView1];
    [scrView addSubview:imageView2];
    [scrView addSubview:imageView3];
    [self.view addSubview:scrView];
    scrView.layer.borderColor = [[UIColor colorWithRed:1 green:0.8 blue:0.02 alpha:1] CGColor];
    scrView.layer.borderWidth = 1.0f;
    scrView.layer.shadowRadius =0.5;
    scrView.layer.shadowColor =[UIColor blackColor].CGColor;
    NSLog(@"scrView.frame [%@]",NSStringFromCGRect(scrView.frame));
    
    //创建UIPageControl，位置在屏幕最下方。
    pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 30, bounds.size.width, 30)];
    pageCtrl.numberOfPages = 3;
    //当前页
    pageCtrl.currentPage = 0;
    //用户点击UIPageControl的响应函数
    [pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageCtrl];
    NSLog(@"pageCtrl.frame [%@]",NSStringFromCGRect(pageCtrl.frame));
    
    [self reloadGraphView];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [data release];
    [indicator release];
    [graphView release];
    [super dealloc];
}

-(void)reloadGraphView{
    // 为 CPGraph 指定主题
    graph = [[ CPXYGraph alloc ] initWithFrame : CGRectZero ];
    CPTheme *theme = [ CPTheme themeNamed : kCPDarkGradientTheme ];
    [ graph applyTheme :theme];
    
    // 把 self.view 由 UIView 转变为 CPGraphHostingView ，因为 UIView 无法加载 CPGraph
    graphView =[[ CPGraphHostingView alloc ] initWithFrame:CGRectMake(100, 100, 1024-100*2, 400)]; 
    [self.view addSubview:graphView];
    CPGraphHostingView *hostingView = ( CPGraphHostingView *) graphView ;
    [hostingView setHostedGraph : graph ];
    // CPGraph 边框：无
    graph.plotAreaFrame.borderLineStyle = nil ;
    graph.plotAreaFrame.cornerRadius = 0.5f ;
    
    
    // 绘图空间 plot space
    CPXYPlotSpace *plotSpace = ( CPXYPlotSpace *) graph.defaultPlotSpace ;
    // 绘图空间大小： Y ： 0-300 ， x ： 0-16
    plotSpace. yRange = [ CPPlotRange plotRangeWithLocation : CPDecimalFromFloat ( 0.0f ) length : CPDecimalFromFloat ( yLength )];
    plotSpace. xRange = [ CPPlotRange plotRangeWithLocation : CPDecimalFromFloat ( 0.0f ) length : CPDecimalFromInt ( num )];
    // CPGraph 四边不留白
    graph.paddingLeft =0.0f ;
    graph.paddingRight = 0.0f ;
    graph.paddingTop = 0.0f ;
    graph.paddingBottom = 0.0f ;
    // 绘图区 4 边留白
    graph.plotAreaFrame.paddingLeft = 80.0 ;
    graph.plotAreaFrame.paddingTop = 40.0 ;
    graph.plotAreaFrame.paddingRight = 45.0 ;
    graph.plotAreaFrame.paddingBottom = 40.0 ;
    
    // 坐标系
    CPXYAxisSet *axisSet = ( CPXYAxisSet *) graph.axisSet ;
    //x 轴：为坐标系的 x 轴
    CPXYAxis *X = axisSet. xAxis ;
    // 清除默认的轴标签 , 使用自定义的轴标签
    X. labelingPolicy = CPAxisLabelingPolicyNone ;
    
    // 构造 MutableArray ，用于存放自定义的轴标签
    NSMutableArray *customLabels = [ NSMutableArray arrayWithCapacity : num ];
    // 构造一个 TextStyle
    static CPTextStyle * labelTextStyle= nil ;
    labelTextStyle=[[ CPTextStyle alloc ] init ];
    labelTextStyle. color =[ CPColor whiteColor ];
    labelTextStyle. fontSize = 10.0f ;
    // 每个数据点一个轴标签
    for ( int i= 0 ;i< num ;i++) {
        CPAxisLabel *newLabel = [[ CPAxisLabel alloc ] initWithText : [ NSString stringWithFormat : @"%d" ,(i+ 1 )] textStyle :labelTextStyle];
        newLabel. tickLocation = CPDecimalFromInt (i);
        newLabel. offset = X. labelOffset + X. majorTickLength;
        //旋转90度
        //newLabel. rotation = M_PI / 2 ;
        [customLabels addObject :newLabel];
        [newLabel release ];
    }
    X. axisLabels =  [ NSSet setWithArray :customLabels];
    
    //y 轴
    CPXYAxis *y = axisSet. yAxis ;
    //y 轴：不显示小刻度线
    y. minorTickLineStyle = nil ;
    // 大刻度线间距： 50 单位
    y. majorIntervalLength = CPDecimalFromString ( yIntervalLength );
    // 坐标原点： 0
    y. orthogonalCoordinateDecimal = CPDecimalFromString ( @"0" );
    y. titleOffset = 45.0f ;
    y. titleLocation = CPDecimalFromFloat ( 150.0f );
    
    
    // 第 2 个散点图：绿色
    
    CPScatterPlot *dataSourceLinePlot = [[[ CPScatterPlot alloc ] init ] autorelease ];
    dataSourceLinePlot. identifier = @"Green Plot" ;
    // 线型设置
    CPLineStyle *lineStyle = [[[ CPLineStyle alloc ] init ] autorelease ];
    lineStyle. lineWidth = 3.0f ;
    lineStyle. lineColor = [ CPColor greenColor ];
    dataSourceLinePlot. dataLineStyle = lineStyle;
    // 设置数据源 , 必须实现 CPPlotDataSource 协议
    dataSourceLinePlot. dataSource = self ;
    [ graph addPlot :dataSourceLinePlot] ;
    
    
    CPScatterPlot *dataSourceLinePlot1 = [[[ CPScatterPlot alloc ] init ] autorelease ];
    dataSourceLinePlot1. identifier = @"Blue Plot" ;
    // 线型设置
    CPLineStyle *lineStyle1 = [[[ CPLineStyle alloc ] init ] autorelease ];
    lineStyle1. lineWidth = 1.0f ;
    lineStyle1. lineColor = [ CPColor redColor ];
    dataSourceLinePlot1. dataLineStyle = lineStyle1;
    // 设置数据源 , 必须实现 CPPlotDataSource 协议
    dataSourceLinePlot1. dataSource = self ;
    [ graph addPlot :dataSourceLinePlot1] ;
    
    // 随机产生散点数据
    NSUInteger i;
    for ( i = 0 ; i < num ; i++ ) {
        x [i] = i ;
        y1 [i] = ( num * 10 )*( rand ()/( float ) RAND_MAX )+200;
        y2 [i] = ( num * 10 )*( rand ()/( float ) RAND_MAX )+300;
    }  
}


#pragma mark -
#pragma scrollview delegate
- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = scrView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [scrView scrollRectToVisible:rect animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageCtrl setCurrentPage:offset.x / bounds.size.width];
}
#pragma mark -
#pragma mark Plot Data Source Methods
// 返回散点数
-( NSUInteger )numberOfRecordsForPlot:( CPPlot *)plot
{
    return num ;
}
// 根据参数返回数据（一个 C 数组）
- ( double *)doublesForPlot:( CPPlot *)plot field:( NSUInteger )fieldEnum recordIndexRange:( NSRange )indexRange
{
    // 返回类型：一个 double 指针（数组）
    double *values;
    NSString * identifier=( NSString *)[plot identifier];
    
    switch (fieldEnum) {
            // 如果请求的数据是散点 x 坐标 , 直接返回 x 坐标（两个图形是一样的），否则还要进一步判断是那个图形
        case CPScatterPlotFieldX :
            values= x ;
            break ;
        case CPScatterPlotFieldY :
            // 如果请求的数据是散点 y 坐标，则对于图形 1 ，使用 y1 数组，对于图形 2 ，使用 y2 数组
            if ([identifier isEqualToString : @"Blue Plot" ]) {
                values= y1;
            } else
                values= y2;
            break ;
    }
    // 数组指针右移个 indexRage.location 单位，则数组截去 indexRage.location 个元素
    return values + indexRange. location ;
}
// 添加数据标签
-( CPLayer *)dataLabelForPlot:( CPPlot *)plot recordIndex:( NSUInteger )index
{
    // 定义一个白色的 TextStyle
    static CPTextStyle *whiteText = nil ;
    if ( !whiteText ) {
        whiteText = [[ CPTextStyle alloc ] init ];
        whiteText. color = [ CPColor whiteColor ];
    }
    // 定义一个 TextLayer
    CPTextLayer *newLayer = nil ;
    NSString * identifier=( NSString *)[plot identifier];
    if ([identifier isEqualToString : @"Blue Plot" ]) {
        newLayer = [[[ CPTextLayer alloc ] initWithText :[ NSString stringWithFormat : @"%.0f" , y1 [index]] style :whiteText] autorelease ];
    }
    if ([identifier isEqualToString : @"Green Plot" ]) {
        newLayer = [[[ CPTextLayer alloc ] initWithText :[ NSString stringWithFormat : @"%.0f" , y2 [index]] style :whiteText] autorelease ];
    }
    return newLayer;
}


@end
