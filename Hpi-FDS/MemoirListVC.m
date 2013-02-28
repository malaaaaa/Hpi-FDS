//
//  MemoirListVC.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-5.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "MemoirListVC.h"
#import "WebViewController.h"
@interface MemoirListVC ()

@end

@implementation MemoirListVC

@synthesize memoirTableView,popover,listArray,downLoadArray;
@synthesize xmlParser,networkQueue,processView,stringType;
@synthesize contentLength,webVC,cellArray;





@synthesize refreshHeaderView=_refreshHeaderView;

static int cellNum =0;
#pragma mark -
#pragma mark Data Source Loading / Reloading Method
- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    if (!xmlParser) {
        self.xmlParser=[[[XMLParser alloc]init] autorelease];
    }
    [xmlParser setISoapNum:1];
    [xmlParser getTsFileinfo];
    [self reloadTableView];
	_reloading = YES;
	self.memoirTableView.contentOffset=CGPointMake(0, 70);
	
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.memoirTableView];
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    //下拉时加载数据..
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
	
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {

    self.refreshHeaderView = nil;
	if(memoirTableView)
		[memoirTableView release];
	if(popover)
		[popover release];
    if(listArray){
		[listArray release];
    }

    if(downLoadArray)
		[downLoadArray release];
    [networkQueue setDelegate:nil];
	[networkQueue cancelAllOperations];
    if(networkQueue)
		[networkQueue release];
	networkQueue = nil;
    self.cellArray=nil;
    self.stringType=nil;

    
    
    [self.webVC release],self.webVC=nil;
    
    
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{

    NSLog(@"viewWillAppear");//从 这个tableview 掉转到 另一个 view 时被调用

    [self.listArray removeAllObjects];
    [self.cellArray removeAllObjects];
    cellNum=0;

    self.listArray =[TsFileinfoDao getTsFileinfoByType:self.stringType];

    for(int i=0;i<[listArray count];i++)
	{
		TsFileinfo *tsFile=(TsFileinfo *)[listArray objectAtIndex:i];
		[self.cellArray addObject:[self CreateDownCell:tsFile]];
	}
    [memoirTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.listArray =[TsFileinfoDao getTsFileinfo];
    //开始初始化下载数组
	self.cellArray=[[NSMutableArray alloc]init] ;
    cellNum=0;
    [memoirTableView setSeparatorColor:[UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1]];
//    for(int i=0;i<[listArray count];i++)
//	{
//		//TsFileinfo *tsFile=[[TsFileinfo alloc]init];
//		TsFileinfo *tsFile=(TsFileinfo *)[listArray objectAtIndex:i];
//		[self.cellArray addObject:[self CreateDownCell:tsFile]];
//	}

    //定义下拉刷新历史记录
	{
		[_refreshHeaderView removeFromSuperview];

		_refreshHeaderView=nil;
		if (_refreshHeaderView == nil) {
			EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f,-70, 320, 70)];
			view.delegate = self;
            
			[self.memoirTableView addSubview:view];
			self.refreshHeaderView = view;
			[view release];
		}
	}
  	self.downLoadArray=[[[NSMutableArray alloc]init] autorelease];
    
    
    if (! networkQueue ) {
        networkQueue = [[ ASINetworkQueue alloc ] init ];
    }
    
    //[ networkQueue reset ]; // 队列清零
    // [ networkQueue setDownloadProgressDelegate : progress_total ]; // 设置 queue 进度条
    [ networkQueue setShowAccurateProgress : YES ]; // 进度精确显示
    [ networkQueue setDelegate : self ]; // 设置队列的代理对象
    
    if ( fm == nil ) {
        fm =[ NSFileManager defaultManager ];
    }
    
    
    
    
    
    
}

- (void)viewDidUnload
{    

//    self.stringType=nil;
//

    self.listArray=nil;
    self.cellArray=nil;

//    self.downLoadArray=nil;
//    self.cellArray=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark tableview
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.listArray count];
    //return 20;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TsFileinfo *tsFile=[listArray objectAtIndex:indexPath.row];
    if ([tsFile.xzbz isEqualToString:@"1"]) {//1为 下载完成..
        
        
            //在本地Documents下加载  下载到的文件
            [WebViewController setFileName:tsFile.fileName];
        //设置 加载状态.
     WebViewController*wbs=   (WebViewController*)self.webVC;
         
         [wbs  viewloadRequest];
            [self.popover dismissPopoverAnimated:YES];
             
       
    }
    else {
            
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *MyIdentifier = @"MemoirCell";
	MemoirCell *cell=(MemoirCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if(cell==nil)
	{
//		NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MemoirCell" owner:self	options:nil];
//		cell=[nib objectAtIndex:0];//无法执行
	}
	cell=(MemoirCell *)[self.cellArray objectAtIndex:[indexPath row]];
	return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return 50;
} 
#pragma mark -
#pragma mark action
-(void) stratDownload:(MemoirCell *)cell
{
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //self.networkQueue=[[ASINetworkQueue alloc]init] ;
	//[networkQueue setShowAccurateProgress:NO];//    取消  进度条
	//[networkQueue go];
	//[networkQueue setDownloadProgressDelegate: self.processView ]; // 设置 queue 进度条
    //[networkQueue setDelegate:self];
    
   //[networkQueue setShouldCancelAllRequestsOnFailure:NO];

	//[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	//[networkQueue setRequestDidFailSelector:@selector(requestWentWrong:)];
	//[networkQueue setQueueDidFinishSelector:@selector(queueDone)];
    
    // NSString *tempPath=[NSString stringWithFormat:@"%@.tmp",path];
    // NSLog(@"临时文件路径=[%@]",tempPath);
    //[request setDownloadProgressDelegate : progress_file2 ]; // 文件 2 的下载进度条
    // [request setUserInfo :[ NSDictionary dictionaryWithObject :file2 forKey : @"TargetPath" ]];
    
    //设置文件保存路径
    //[request setDownloadDestinationPath:path];
    /*
     //设置临时文件路径
     [request setTemporaryFileDownloadPath:tempPath];
     //设置是是否支持断点下载
     [request setAllowResumeForFileDownloads:YES];
     //设置进度条的代理,
     
     //cell.processView =[[[UIProgressView alloc]init]autorelease];//已初始化 没有用..
     
     // NSLog(@"cell.processView=[%@]",cell.processView);
     [request setDownloadProgressDelegate:nil];
     */
    /*
     
     [request setDidFinishSelector:@selector(requestDone:)];
     [request setDidFailSelector:@selector(requestWentWrong:)];
     
     //  取得响应报头信息
     [request setDidReceiveResponseHeadersSelector:@selector(didReceiveResponseHeaders:)];
     //添加到ASINetworkQueue队列去下载
     [self.networkQueue addOperation:request];
     [networkQueue go];
     */
    
    

    
    
    
    
    
    
    NSLog(@"开始下载文件......");
     
    [cell retain];
    TsFileinfo *tsFile=cell.data;
    NSString * url=[NSString stringWithFormat:@"%@%@%@",PubInfo.url,tsFile.filePath,tsFile.fileName];
    NSLog(@"url=%@",url);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Files"];
    [[NSFileManager defaultManager]createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[tsFile.fileName stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
   // NSLog(@"文件保存路径=[%@]",path);

    

    NSFileHandle *fh2;
    __block uint fSize2= 0 ; // 以 B 为单位，记录已下载的文件大小 , 需要声明为块可写
    if ( [ fm createFileAtPath :path contents : nil attributes : nil ]){
        fh2=[ NSFileHandle fileHandleForWritingAtPath :path];
    }
    
    
   ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
       //设置基本信息
    [request setUsername:[NSString stringWithFormat:@"%d",cell.index]];
    [request setTimeOutSeconds:120];
    [request setCompletionBlock :^( void ){
        
        assert (fh2);
        // 关闭 file2
        [fh2 closeFile ];
        NSLog(@"已下载完成....");

        NSLog(@"request Done ok 第%@个",request.username);
        
        MemoirCell *cell=[self.cellArray objectAtIndex:[request.username intValue]];
        TsFileinfo *tsFile=cell.data;
        tsFile.xzbz=@"1";
        NSLog(@"request Done ok name[%@]",tsFile.fileName);
        [TsFileinfoDao updateTsFileXzbz:tsFile.fileId :@"1"];
        cell.button.enabled=FALSE;
        cell.button.hidden=YES;
        cell.okimage.hidden=NO;
        cell.backimage.frame = CGRectMake( 0.0f,  0.0f, 320, 50.0f);
        cell.backimage.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        [memoirTableView reloadData];   
        
    }];
    // 使用 failed 块，在下载失败时做一些事情
    [request setFailedBlock :^( void ){
        NSLog ( @"download failed !" );
    }];
    // 使用 received 块，在接受到数据时做一些事情
    [request setDataReceivedBlock :^( NSData * data){
        
        fSize2+=data. length ;
        
        NSLog(@"data.length:%d",[data length ]);
        
        
        //设置进度条
        //[ status_file2 setText :[ NSString stringWithFormat : @"%.1f K" ,fSize2/ 1000.0 ]];
        //[ status_total setText :[ NSString stringWithFormat : @"%.0f %%" , progress_total . progress * 100 ]];
        
        if (fh2!= nil ) {
            [fh2 seekToEndOfFile ];
            [fh2 writeData :data];
        }
    }];
    [ networkQueue addOperation :request];
    [ networkQueue go ]; // 队列任务开始
    
    
      //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateUI:) userInfo:cell repeats:NO];
    [cell release];
}
//下载书籍
-(void) buttonAction:(id)send
{
	NSLog(@"zhangcx buttonAction start");
    MemoirCell *cell=(MemoirCell *)send;
	[cell retain];
    cell.button.hidden=YES;
    TsFileinfo *tsFile=cell.data;
	tsFile.xzbz=@"2";
    [TsFileinfoDao updateTsFileXzbz:tsFile.fileId :tsFile.xzbz];
    
    [self stratDownload:cell];
}

-(void)reloadTableView
{
    if ([xmlParser iSoapNum]==0) {
        if ([xmlParser iSoapTsFileinfoDone]==2) {

            [self.listArray removeAllObjects];

//            listArray=nil;
            self.listArray =[TsFileinfoDao getTsFileinfoByType:self.stringType];


            [self.cellArray removeAllObjects];
            cellNum=0;
            for(int i=0;i<[listArray count];i++)
            {
                //TsFileinfo *tsFile=[[TsFileinfo alloc]init];
                TsFileinfo *tsFile=(TsFileinfo *)[listArray objectAtIndex:i];
                [self.cellArray addObject:[self CreateDownCell:tsFile]];
            }
            NSLog(@"reloadTableView---[listArray count]-%d",[listArray count]);
            [memoirTableView reloadData];
        }
        //定义下拉刷新历史记录
        {
            [_refreshHeaderView removeFromSuperview];

            _refreshHeaderView=nil;
            if (_refreshHeaderView == nil) {
                EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f,-70, 320, 70)];
                view.delegate = self;
                [self.memoirTableView addSubview:view];
                self.refreshHeaderView = view;
                [view release];
            }
        }
        return;
    }
    else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTableView) userInfo:NULL repeats:NO];
    }
}
#pragma mark
#pragma download file
//下载文件
- (void)queueDone
{
    
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    
    
    
    
    NSLog(@"request Done ok 第%@个",request.username);
    
    
    MemoirCell *cell=[self.cellArray objectAtIndex:[request.username intValue]];
    TsFileinfo *tsFile=cell.data;
    tsFile.xzbz=@"1";
    NSLog(@"request Done ok name[%@]",tsFile.fileName);
    [TsFileinfoDao updateTsFileXzbz:tsFile.fileId :@"1"];
    cell.button.enabled=FALSE;
    cell.button.hidden=YES;
    cell.okimage.hidden=NO;
    cell.backimage.frame = CGRectMake( 0.0f,  0.0f, 320, 50.0f);
    cell.backimage.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    [memoirTableView reloadData];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
	NSLog(@"ASIHTTPRequest error [%@] url[%@]",[[request error] localizedDescription],[request url]);
    
}

- (void)didReceiveResponseHeaders:(ASIHTTPRequest *)request
{
    NSLog(@"request.responseHeaders:>>>>>>>>>>>>>>>>>>>>>>>>>>>%@",request.responseHeaders);
    
    
    
    
    
    
    NSLog(@"didReceiveResponseHeaders  request.responseHeaders %@",[request.responseHeaders valueForKey:@"Content-Length"]);
	self.contentLength = self.contentLength + ([[request.responseHeaders valueForKey:@"Content-Length"] floatValue]/1024/1024);
	NSLog(@"didReceiveResponseHeaders  self.contentLength %f",self.contentLength);
}

-(void)updateUI:(id*)timer
{
    MemoirCell *cell=[(NSTimer*)timer userInfo];
    TsFileinfo *tsFile=cell.data;
    NSLog(@"cell.processView.progress %f",cell.processView.progress);
    if([tsFile.xzbz isEqualToString:@"2"])
    {
        if ( cell.processView.progress<= 1.0){
            cell.backimage.frame = CGRectMake( 0.0f,  0.0f, cell.processView.progress*320, 50.0f);
            cell.backimage.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateUI:) userInfo:cell repeats:NO];
        }
    }
}








- (UITableViewCell *)CreateDownCell: (TsFileinfo *)tsFile
{
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MemoirCell" owner:self	options:nil];
	MemoirCell *cell=[nib objectAtIndex:0];
    cell.index=cellNum++;
	cell.textlabel.text=tsFile.title;
	cell.subtextlabel.text=[NSString stringWithFormat:@"上传时间:%@",tsFile.recordTime];
	cell.delegate=self;
    cell.data=tsFile;
    //NSLog(@"filePath[%@]",[NSString stringWithFormat:@"%@%@%@",PubInfo.url,tsFile.filePath,tsFile.fileName]);
    if ([tsFile.xzbz isEqualToString:@"1"]) {
        cell.button.enabled=FALSE;
        cell.button.hidden=YES;
        cell.okimage.hidden=NO;
    }
    else if([tsFile.xzbz isEqualToString:@"2"]) {
        cell.button.enabled=FALSE;
        cell.button.hidden=YES;
        cell.okimage.hidden=YES;
    }
    else {
        cell.button.enabled=TRUE;
        cell.button.hidden=NO;
        cell.okimage.hidden=YES;
    }
    
    
    if([[tsFile.fileName pathExtension] isEqualToString:@"pdf"])
    {
        cell.iconimage.image =[UIImage imageNamed:@"pdf"];
    }
    else if([[tsFile.fileName pathExtension] isEqualToString:@"doc"])
    {
        cell.iconimage.image =[UIImage imageNamed:@"word"];
    }
    else if([[tsFile.fileName pathExtension] isEqualToString:@"docx"])
    {
        cell.iconimage.image =[UIImage imageNamed:@"word"];
    }
    else if([[tsFile.fileName pathExtension] isEqualToString:@"xls"])
    {
        cell.iconimage.image =[UIImage imageNamed:@"excel"];
    }
    else if([[tsFile.fileName pathExtension] isEqualToString:@"xlsx"])
    {
        cell.iconimage.image =[UIImage imageNamed:@"excel"];
    }
    else {
        cell.iconimage.image =[UIImage imageNamed:@"other"];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

@end
