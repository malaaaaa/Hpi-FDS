//
//  WebViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "WebViewController.h"
@implementation WebViewController
@synthesize webView,popover,titleLable,memoirListVC,segment;

static NSString *fileName;
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
    [segment release];
    [webView release];
    [popover release];
    [titleLable release];
    [memoirListVC release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.waitingLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 600, 50)];
    self.waitingLable.backgroundColor=[UIColor clearColor];
    self.waitingLable.text=@"文档加载缓慢，请耐心等待...";
    self.waitingLable.font = [UIFont systemFontOfSize:30.0f];
    webView.scalesPageToFit =  YES;
    segment.momentary = YES;	
}

- (void)viewDidUnload
{
    self.webView=nil;
    self.titleLable=nil;
    self.segment=nil;
    self.memoirListVC=nil;
    self.waitingLable=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewloadRequest
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *docPath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat: @"/Files/%@",fileName]];
    NSLog(@"####docPath# [%@]",docPath);
    
    NSURL *url = [NSURL fileURLWithPath:docPath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]];

    [webView setBackgroundColor:[UIColor whiteColor]];

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

    [webView loadRequest:request];

    self.titleLable.text=fileName;
//    webView.alpha=1;
}
- (void )webViewDidStartLoad:(UIWebView  *)webView
{
    [self.webView.scrollView addSubview:_waitingLable];
    
}
- (void )webViewDidFinishLoad:(UIWebView  *)webView
{
    [_waitingLable removeFromSuperview];

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
    
}
@end
