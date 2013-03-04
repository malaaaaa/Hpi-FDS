//
//  WebViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "WebViewController.h"
@implementation WebViewController
@synthesize webView1,popover,titleLable,memoirListVC;
@synthesize loadCount;
@synthesize infoButton;
@synthesize FileLoadStatus;
//,segment
static NSString *fileName;

static int a=0;

+(void)setFileName:(NSString*) theName
{
    
    if (fileName!=theName) {
        [fileName release];
        fileName = [theName retain];
    }
//	[fileName release];
//	fileName=theName;
//	[fileName retain];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"纪要查看", @"2th");
        self.tabBarItem.image = [UIImage imageNamed:@"download"];
        
        
       // NSLog(@"FileLoadStatus已初始");
         FileLoadStatus=0;
        loadCount=0;
    }
    return self;
}







- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)dealloc {
    
    
    
   // [segment release];
    [webView1 release];
    [popover release];
    [titleLable release];
    [memoirListVC release];
    [infoButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    infoButton.hidden=YES;
    
    
    // Do any additional setup after loading the view from its nib.
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *docPath = [documentsDirectory stringByAppendingString:@"/1.png"];
//    NSLog(@"####docPath# [%@]",docPath);
//    
//    NSURL *url = [NSURL fileURLWithPath:docPath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//    webView.alpha=0.3;
    self.waitingLable = [[UILabel alloc] initWithFrame:CGRectMake(50,100, 600, 50)];
    self.waitingLable.backgroundColor=[UIColor clearColor];
    self.waitingLable.text=@"文档正在加载中，请稍等...";
    self.waitingLable.font = [UIFont systemFontOfSize:30.0f];
    
    
    
    webView1.scalesPageToFit =  YES;
   // segment.momentary = YES;
    
 
    
    
   
    //self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self   action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired  = 1;
    
    singleTapGesture.delegate=self;
    [self.webView1.scrollView addGestureRecognizer:singleTapGesture];
    
    
    
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self   action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    doubleTapGesture.delegate=self;
    
    [self.webView1.scrollView addGestureRecognizer:doubleTapGesture];
    // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    
    
    [doubleTapGesture release];
    [singleTapGesture release];
    
   
    
   
    
}


-(void)handleSingleTap:(UIGestureRecognizer *)sender{
   CGPoint touchPoint = [sender locationInView:self.webView1];
    //...
   // NSLog(@"这是个Single.....");
   // NSLog(@"touchPoint.x>>>>>>>>>>>>>>%f",touchPoint.x);
     // NSLog(@"touchPoint.y>>>>>>>>>>>>>>%f",touchPoint.y);
    
    
   
   //加载完毕   才生效
    if ( FileLoadStatus ==1) {
    // 隐藏
    if ([self.view superview]) {
       // NSLog(@"mainView不为空");
        UIView*mapView=[[self.view superview] superview];
        NSArray *MapsubVW=[mapView subviews];
       // NSLog(@"subViews:%d",[MapsubVW count]);
        int i;
        for (i=0; i<[MapsubVW count]; i++) {
            if ([[MapsubVW objectAtIndex:i] isKindOfClass:[UIImageView class]]||[[MapsubVW objectAtIndex:i] isKindOfClass:[UIButton class]]||[[MapsubVW objectAtIndex:i] isKindOfClass:[ UIActivityIndicatorView class]]) {

                UIView*sub=   [MapsubVW objectAtIndex:i];
                if (!sub.hidden){
                 sub .hidden=YES;
            
                }else{
                    
                     if (touchPoint.y>=40) //获取坐标
                     {
                      sub .hidden=NO;
                     }

                } 
            }
        }
     }
   }
    
      
  
    
    
    
}
-(void)handleDoubleTap:(UIGestureRecognizer *)sender{
    //CGPoint touchPoint = [sender locationInView:self.view];
    //...
   // NSLog(@"这是个Double.....");
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
} 


- (void)viewDidUnload
{
    self.webView1=nil;
    self.titleLable=nil;
    
    
    [infoButton release],infoButton=nil;
    
    //self.segment=nil;
    self.memoirListVC=nil;
    self.waitingLable=nil;
    [infoButton release];
    infoButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewloadRequest
{
    
 //  NSLog(@">>>>>>>>>>>>加载文件>>>>>>>>>>>>>>>");
  FileLoadStatus=0;
   [webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    a=0;
   self.loadCount=0;//没执行一次viewloadRequest  为一次加载..
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *docPath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat: @"/Files/%@",fileName]];
   // NSLog(@"####docPath# [%@]",docPath);
    NSURL *url = [NSURL fileURLWithPath:docPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
 
    [webView1 setBackgroundColor:[UIColor whiteColor]];
    [webView1 loadRequest:request];
    
    self.titleLable.text=fileName;
//    webView.alpha=1;
    FileLoadStatus=1;//加载完毕
    self.loadCount=1;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    
    //NSLog(@"+++++++++++++++++");
    
    
    return YES;




}








- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

  // NSLog(@"加载失败.........");

}

- (void )webViewDidStartLoad:(UIWebView  *)webView
{
    
    
    //if (loadCount==1) {//限制只加载一次
    //  NSLog(@"开始加载文件>>>>>>>>");
    //  NSLog(@"%@",webView.request.URL);
    [self.webView1.scrollView addSubview:_waitingLable];
    loadCount--;
    //}
    
    
}
- (void )webViewDidFinishLoad:(UIWebView  *)webView
{
    
  //if (loadCount==0) {
    // NSLog(@"加载文件完毕>>>>>>>>");
    [_waitingLable removeFromSuperview];
      loadCount--;
       
     
 // }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
//#pragma mark -
//#pragma mark Actions
//- (IBAction)listDocView:(id)sender
//{
//    if (self.popover.popoverVisible) {
//        [self.popover dismissPopoverAnimated:YES];
//    }
//    if (!memoirListVC) {
//        //初始化待显示控制器
//        memoirListVC=[[MemoirListVC alloc]init]; 
//        //设置待显示控制器的范围
//        [memoirListVC.view setFrame:CGRectMake(0,0, 320, 484)];
//        //设置待显示控制器视图的尺寸
//        memoirListVC.contentSizeForViewInPopover = CGSizeMake(320, 484);
//    }
//    //初始化弹出窗口
//    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:memoirListVC];
//    memoirListVC.popover = pop;
//    memoirListVC.webVC=self;
//    self.popover = pop;
//    self.popover.delegate = self;
//    //设置弹出窗口尺寸
//    self.popover.popoverContentSize = CGSizeMake(320, 484);
//    //显示，其中坐标为箭头的坐标以及尺寸
//    [self.popover presentPopoverFromRect:CGRectMake(1000, 40, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    //[memoirListVC.memoirTableView reloadData];
//    
//    [pop release];
//    
//}



- (IBAction)showINFO:(id)sender {
    
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    if (!memoirListVC) {
        //初始化待显示控制器
        self.memoirListVC=[[MemoirListVC alloc]init];
        //设置待显示控制器的范围
        [self.memoirListVC.view setFrame:CGRectMake(0,0, 320, 484)];
        //设置待显示控制器视图的尺寸
        self.memoirListVC.contentSizeForViewInPopover = CGSizeMake(320, 484);
    }
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:memoirListVC];
    self.memoirListVC.popover = pop;
    self.memoirListVC.webVC=self;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(320, 484);
    self.memoirListVC.stringType=@"NOTICE";
    [self.popover presentPopoverFromRect:CGRectMake(950, 20, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    
      [pop release];
    
}




/*
#pragma mark -
#pragma mark - segment
//根据选择，显示不同文件类型
-(IBAction)segmentChanged:(id) sender
{
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    if (!memoirListVC) {
        //初始化待显示控制器
        self.memoirListVC=[[MemoirListVC alloc]init];
        //设置待显示控制器的范围
        [self.memoirListVC.view setFrame:CGRectMake(0,0, 320, 484)];
        //设置待显示控制器视图的尺寸
        self.memoirListVC.contentSizeForViewInPopover = CGSizeMake(320, 484);
    }
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:memoirListVC];
    self.memoirListVC.popover = pop;
    self.memoirListVC.webVC=self;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(320, 484);
    
   
    
    if(segment.selectedSegmentIndex==0)
    {
        self.memoirListVC.stringType=@"QHD";
        [self.popover presentPopoverFromRect:CGRectMake(590, 20, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    if(segment.selectedSegmentIndex==1)
    {
        self.memoirListVC.stringType=@"COALSITE";
        [self.popover presentPopoverFromRect:CGRectMake(770, 20, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    if(segment.selectedSegmentIndex==2)
    {
        self.memoirListVC.stringType=@"NOTICE";
        [self.popover presentPopoverFromRect:CGRectMake(950, 20, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    [pop release];
    
 }*/

@end
