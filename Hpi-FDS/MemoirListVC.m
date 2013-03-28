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
	
    NSLog(@"egoRefreshTableHeaderDataSourceLastUpdated");
    BadgeNumber=[TsFileinfoDao getUnDownloadNums:@"NOTICE"];
    //更新MapView信息栏按钮图标未读显示数量
    [self.parentMapView setControllerText:[NSString stringWithFormat:@"%d", BadgeNumber]];

	return [NSDate date]; // should return date data source was last changed
	
}
#pragma mark 手动触发刷新 EGORefreshTableHeaderDelegate 
-(void) ViewFrashData{
    NSLog(@"ViewFrashData");
    [self.memoirTableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.6];
}
-(void)doneManualRefresh{
    NSLog(@"doneManualRefresh");
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.memoirTableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.memoirTableView];
}

#pragma mark -
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
        [WebViewController setFileName:tsFile  ];
        //设置 加载状态.
        WebViewController*wbs=   (WebViewController*)self.webVC;
        
        [wbs  viewloadRequest];
        [self.popover dismissPopoverAnimated:YES];
        
        
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

    

    NSFileHandle *fh2=nil;
    __block uint fSize2= 0 ; // 以 B 为单位，记录已下载的文件大小 , 需要声明为块可写
    if ( [ fm createFileAtPath :path contents : nil attributes : nil ]){
        fh2=[ NSFileHandle fileHandleForWritingAtPath :path];
    }
     [fh2 truncateFileAtOffset:0];//清空原来文件.
    
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
        
        //更新后台
        if (![self SendFILEIDToServer:[NSString stringWithFormat:@"%d",tsFile.fileId]]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器更新推送信息失败！\n请联系管理员!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            [alert release];
        }
        BadgeNumber--;
        //更新MapView信息栏按钮图标未读显示数量
        [self.parentMapView setControllerText:[NSString stringWithFormat:@"%d", BadgeNumber]];
        
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


/*
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


*/





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
        //cell.okimage.hidden=NO;
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
#pragma mark 将FILEID发送至后台
- (BOOL) SendFILEIDToServer:(NSString *)fileID{
    
    NSString *reg=nil;
    NSString *requestStr=[NSString stringWithFormat:@"<GetSendFILEIDinfo xmlns=\"http://tempuri.org/\">\n <req>\n"
                          "<token>%@</token>\n"
                          "<fileid>%@</fileid>\n"
                          "</req>\n"
                          "</GetSendFILEIDinfo>\n"
                          , _token,fileID];
    
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                            "<soap12:Body>\n  %@ </soap12:Body>\n"
                            "</soap12:Envelope>\n",requestStr ];
    
    NSLog(@"soapMessage[%@]",soapMessage);
    
    // 初始化请求
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 设置URL
    [request setURL:[NSURL URLWithString:PubInfo.baseUrl]];
    // 设置HTTP方法
    [request setHTTPMethod:@"POST"];
    // 发送同步请求
    NSError *connectError=nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:&connectError];
    if (connectError) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"后台服务器连接失败！\n请检查网络或修改服务器地址!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        return FALSE;
    }
//    NSString *theXML = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",theXML);
    NSString *element1=@"SendFILEID";
    NSString *elementString1= [NSString stringWithFormat:@"Get%@infoResult",element1];
    NSString *elementString2= [NSString stringWithFormat:@"Get%@infoResponse",element1];
    // char *errorMsg;
    NSError *error = nil;
    TBXML * tbxml = [TBXML newTBXMLWithXMLData:returnData error:&error];
    if (error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        
    }else {
        TBXMLElement * root = tbxml.rootXMLElement;
        //=======================================
        if (root) {// @"retinfo"
            TBXMLElement *element = [TBXML childElementNamed: @"retcode"  parentElement:[TBXML childElementNamed:elementString1 parentElement:[TBXML childElementNamed:elementString2 parentElement:[TBXML childElementNamed:@"soap:Body" parentElement:root]]]];
            if (element != nil) {
                reg=[TBXML textForElement:element] ;
            }
            NSLog(@"reg=%@",reg);
        }
        
    }
    // 释放对象
    [request release];
    
    //返回值为0代表正常
    if (![reg isEqualToString:@"0"]) {
        
        return FALSE;
    }
    
    return TRUE;
}


@end
