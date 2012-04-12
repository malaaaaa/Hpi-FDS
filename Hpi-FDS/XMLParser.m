//
//  XMLParser.m
//  Hpi-FDS
//
//  Created by zcx on 12-3-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

#import "PubInfo.h"

static int iSoap;
static int iSoapTgPortDone=0;
static int iSoapTgFactoryDone=0;
static int iSoapTgShipDone=0;
static int iSoapTsFileinfoDone=0;
static int iSoapTmIndexinfoDone=0;
static int iSoapTmIndexdefineDone=0;
static int iSoapTmIndextypeDone=0;
static int iSoapVbShiptransDone=0;
static int iSoapDone=1; //1未开始 0进行中 3出错
static int iSoapNum=0;

UIAlertView *alert;
NSString* alertMsg;

@synthesize tgFactory,tgPort,tgShip,tsFileinfo,tmIndexinfo,tmIndexdefine,tmIndextype,vbShiptrans;
@synthesize soapResults,webData,xmlParser,webVC;

#pragma Soap alert
-(void) msgbox
{
	alert = [[UIAlertView alloc]initWithTitle:@"提示" message:alertMsg delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[alert show];
	[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
}
-(void) performDismiss:(NSTimer *)timer
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert release];
	alert = NULL;
}

- (void)dealloc {
	if(soapResults)
		[soapResults release];
	if(webData)
		[webData release];
    if(xmlParser)
		[xmlParser release];
    if(tgFactory)
		[tgFactory release];
    if(tgPort)
		[tgPort release];
    if(tgShip)
		[tgShip release];
    if(tsFileinfo)
		[tsFileinfo release];
    if(tmIndexinfo)
		[tmIndexinfo release];
    if(tmIndexdefine)
		[tmIndexdefine release];
    if(tmIndextype)
		[tmIndextype release];
    if(vbShiptrans)
		[vbShiptrans release];
    [super dealloc];
}

#pragma Soap connection
- (void)getTgPort
{
    if (iSoapDone==0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getTgPort) userInfo:NULL repeats:NO];
        return;
    }
    //出错
    if (iSoapDone==3) {
        iSoapNum--;
        if (iSoapNum<1) {
            iSoapDone=1;
        }
        return;
    }
    iSoapDone=0;
    iSoapTgPortDone=1;
    NSLog(@"开始 getTgPort");
    recordResults = NO;
    iSoap=0;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                             "<soap12:Body>\n"
                             "<GetTgPort xmlns=\"http://tempuri.org/\" />"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>\n"];
    //NSLog(@"soapMessage[%@]",soapMessage);
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSURL *url = [NSURL URLWithString:PubInfo.baseUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}
- (void)getTgFactory
{
    if (iSoapDone==0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getTgFactory) userInfo:NULL repeats:NO];
        return;
    }
    //出错
    if (iSoapDone==3) {
        iSoapNum--;
        if (iSoapNum<1) {
            iSoapDone=1;
        }
        return;
    }
    iSoapDone=0;
    iSoapTgFactoryDone=1;
    NSLog(@"开始 getTgShip");
    recordResults = NO;
    iSoap=1;//0 -port 1-factory 2-ship
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                             "<soap12:Body>\n"
                             "<GetTgFactory xmlns=\"http://tempuri.org/\" />"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>\n"];
    NSLog(@"soapMessage[%@]",soapMessage);
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSURL *url = [NSURL URLWithString:PubInfo.baseUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

- (void)getTgShip
{
    if (iSoapDone==0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getTgShip) userInfo:NULL repeats:NO];
        return;
    }
    //出错
    if (iSoapDone==3) {
        iSoapNum--;
        if (iSoapNum<1) {
            iSoapDone=1;
        }
        return;
    }
    iSoapDone=0;
    iSoapTgShipDone=1;
    NSLog(@"开始 getTgShip");
    recordResults = NO;
    iSoap=2;//0 -port 1-factory 2-ship
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                             "<soap12:Body>\n"
                             "<GetTgShip xmlns=\"http://tempuri.org/\" />"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>\n"];
    NSLog(@"soapMessage[%@]",soapMessage);
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSURL *url = [NSURL URLWithString:PubInfo.baseUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

- (void)getVbShiptrans
{
    if (iSoapDone==0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getVbShiptrans) userInfo:NULL repeats:NO];
        return;
    }
    //出错
    if (iSoapDone==3) {
        iSoapNum--;
        if (iSoapNum<1) {
            iSoapDone=1;
        }
        return;
    }
    iSoapDone=0;
    iSoapVbShiptransDone=1;
    NSLog(@"开始 getTmIndexdefine");
    recordResults = NO;
    iSoap=7;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                             "<soap12:Body>\n"
                             "<GetShipTrans xmlns=\"http://tempuri.org/\" />"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>\n"];
    NSLog(@"soapMessage[%@]",soapMessage);
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSURL *url = [NSURL URLWithString:PubInfo.baseUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

- (void)getTmIndexdefine
{
    NSLog(@"开始 getTmIndexdefine  iSoapDone=%d   iSoapNum=%d",iSoapDone,iSoapNum);
    //等待上一个请求结束后在开始
    if (iSoapDone==0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getTmIndexdefine) userInfo:NULL repeats:NO];
        return;
    }
    //出错
    if (iSoapDone==3) {
        iSoapNum--;
        if (iSoapNum<1) {
            iSoapDone=1;
        }
        NSLog(@"err getTmIndexdefine  iSoapDone=%d   iSoapNum=%d",iSoapDone,iSoapNum);
        return;
    }
    iSoapDone=0;
    iSoapTmIndexdefineDone=1;
    NSLog(@"开始 getTmIndexdefine");
    recordResults = NO;
    iSoap=5;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                             "<soap12:Body>\n"
                             "<GetTmIndexDefine xmlns=\"http://tempuri.org/\" />"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>\n"];
    NSLog(@"soapMessage[%@]",soapMessage);
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSURL *url = [NSURL URLWithString:PubInfo.baseUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

- (void)getTmIndexinfo
{
    if (iSoapDone==0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getTmIndexinfo) userInfo:NULL repeats:NO];
        return;
    }
    //出错
    if (iSoapDone==3) {
        iSoapNum--;
        if (iSoapNum<1) {
            iSoapDone=1;
        }
        return;
    }
    iSoapDone=0;
    iSoapTmIndexinfoDone=1;
    NSLog(@"开始 getTmIndexinfo");
    recordResults = NO;
    iSoap=4;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                             "<soap12:Body>\n"
                             "<GetTmIndexInfo xmlns=\"http://tempuri.org/\" />"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>\n"];
    NSLog(@"soapMessage[%@]",soapMessage);
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSURL *url = [NSURL URLWithString:PubInfo.baseUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

- (void)getTmIndextype
{
    if (iSoapDone==0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getTmIndextype) userInfo:NULL repeats:NO];
        return;
    }
    //出错
    if (iSoapDone==3) {
        iSoapNum--;
        if (iSoapNum<1) {
            iSoapDone=1;
        }
        return;
    }
    iSoapDone=0;
    iSoapTmIndextypeDone=1;
    NSLog(@"开始 getTmIndextype");
    recordResults = NO;
    iSoap=6;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                             "<soap12:Body>\n"
                             "<GetTmIndexType xmlns=\"http://tempuri.org/\" />"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>\n"];
    NSLog(@"soapMessage[%@]",soapMessage);
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSURL *url = [NSURL URLWithString:PubInfo.baseUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

- (void)getTsFileinfo
{
    if (iSoapDone==0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getTsFileinfo) userInfo:NULL repeats:NO];
        return;
    }
    //出错
    if (iSoapDone==3) {
        iSoapNum--;
        if (iSoapNum<1) {
            iSoapDone=1;
        }
        return;
    }
    iSoapDone=0;
    iSoapTsFileinfoDone=1;
    NSLog(@"开始 getTsFileinfo");
    recordResults = NO;
    iSoap=3;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                             "<soap12:Body>\n"
                             "<GetTsFileInfo xmlns=\"http://tempuri.org/\" />"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>\n"];
    NSLog(@"soapMessage[%@]",soapMessage);
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSURL *url = [NSURL URLWithString:PubInfo.baseUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
    NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    NSLog(@"connection: didReceiveData:2");
    
}
//如果没有连接网络，则出现此信息（不是网络服务器不通）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with theConenction");
    [connection release];
    [webData release];
    iSoapDone=3;
    iSoapNum--;
    alertMsg = @"无法连接,请检查网络是否正常?";
    [self msgbox];
    if (iSoapNum==0) {
        iSoapDone=1;
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"3 DONE. Received Bytes: %d", [webData length]);
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"theXML[%@]",theXML);
    [theXML release];
    
    //重新加載xmlParser
    if( xmlParser )
    {
        [xmlParser release];
    }
    
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
    
    [connection release];
    //[webData release];
}


#pragma mark SOAPWebService 解析xml
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict
{
    //NSLog(@"4 parser didStarElemen: namespaceURI: attributes: elementName[%@]",elementName);
    //解析port
    if(iSoap==0)
    {
        if( [elementName isEqualToString:@"PORTCODE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SHIPNUM"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"HANDLESHIP"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"WAITSHIP"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"TRANSACTSHIP"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LOADSHIP"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"PORTNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LAT"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LON"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
    }
    //解析Factory
    if(iSoap==1)
    {
        if( [elementName isEqualToString:@"FACTORYCODE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"FACTORYNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"CAPACITYSUM"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"DESCRIPTION"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"IMPORT"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"IMPMONTH"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"IMPYEAR"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"STORAGE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"CONSUM"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"CONMONTH"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"CONYEAR"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LON"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LAT"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
    }
    //解析Ship
    if(iSoap==2)
    {
        if( [elementName isEqualToString:@"SHIPID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SHIPNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"COMID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"COMPANY"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"PORTCODE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"PORTNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"FACTORYCODE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"FACTORYNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"TRIPNO"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SUPID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SUPPLIER"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"HEATVALUE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LW"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LENGTH"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"WIDTH"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"DRAFT"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"ETA"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
        else if( [elementName isEqualToString:@"LAT"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
        else if( [elementName isEqualToString:@"LON"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
        else if( [elementName isEqualToString:@"SOG"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
        else if( [elementName isEqualToString:@"DESTINATION"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
        else if( [elementName isEqualToString:@"INFOTIME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
        else if( [elementName isEqualToString:@"ONLINE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
        else if( [elementName isEqualToString:@"STAGENAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
        else if( [elementName isEqualToString:@"STAGE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
        else if( [elementName isEqualToString:@"STATECODE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
        else if( [elementName isEqualToString:@"STATENAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
    }
    
    //解析Fileinfo
    if(iSoap==3)
    {
        if( [elementName isEqualToString:@"FILEID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"FILETYPE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"TITLE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"FILEPATH"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"FILENAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"USERNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"RECORDTIME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
    }
    
    //解析Indexinfo
    if(iSoap==4)
    {
        if( [elementName isEqualToString:@"INFOID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"INDEXNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"RECORDTIME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"INFOVALUE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
    }
    
    //解析Indexdefine
    if(iSoap==5)
    {
        if( [elementName isEqualToString:@"INDEXID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"INDEXNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"INDEXTYPE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"MAXIMUM"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"MINIMUM"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"DISPLAYNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
    }
    //解析Indextype
    if(iSoap==6)
    {
        if( [elementName isEqualToString:@"TYPEID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"INDEXTYPE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"TYPENAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
    }
    //解析Shiptrans
    if(iSoap==7)
    {
        if( [elementName isEqualToString:@"DISPATCHNO"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SHIPCOMPANYID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SHIPCOMPANY"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SHIPID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SHIPNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"TRIPNO"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"FACTORYCODE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"FACTORYNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"PORTCODE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"PORTNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SUPID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SUPPLIER"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"TYPRID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"COALTYPE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"KEYVALUE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"KEYNAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"TRADE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"TRADENAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"HEATVALUE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"STAGE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"STAGENAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"STATECODE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"STATENAME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LW"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"P_ANCHORAGETIME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"P_HANDLE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"P_ARRIVALTIME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"P_DEPARTTIME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"P_NOTE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"T_NOTE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"F_ANCHORAGETIME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"F_ARRIVALTIME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"F_DEPARTTIME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"F_NOTE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LATEFEE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"OFFEFFICIENCY"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SCHEDULE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"PLANTYPE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"PLANCODE"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LAYCANSTART"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"LAYCANSTOP"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"RECIEPT"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"SHIPSHIFT"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"FACSORT"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        else if( [elementName isEqualToString:@"TRADETIME"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = YES;
        }
        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"5 parser: foundCharacters:");
    
    if( recordResults )
    {
        [soapResults appendString: string];
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"6 parser: didEndElement:");
    if(iSoap==0)
    {   
        if( [elementName isEqualToString:@"PORTCODE"])
        {
            if(!tgPort)
                tgPort = [[TgPort alloc]init];
            
            tgPort.portCode = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SHIPNUM"])
        {
            tgPort.shipNum = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"HANDLESHIP"])
        {
            tgPort.handleShip = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"WAITSHIP"])
        {
            tgPort.waitShip = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"TRANSACTSHIP"])
        {
            tgPort.transactShip = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LOADSHIP"])
        {
            tgPort.loadShip = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"PORTNAME"])
        {
            tgPort.portName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LON"])
        {
            tgPort.lon = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LAT"])
        {
            tgPort.lat = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
            [TgPortDao delete:tgPort];
            [TgPortDao insert:tgPort];
            [tgPort release];
            tgPort = nil;
        }
    }
    //解析Factory
    if(iSoap==1)
    {
        if( [elementName isEqualToString:@"FACTORYCODE"])
        {
            if(!tgFactory)
                tgFactory = [[TgFactory alloc]init];
            tgFactory.factoryCode = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"FACTORYNAME"])
        {
            tgFactory.factoryName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"CAPACITYSUM"])
        {
            tgFactory.capacitySum = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"DESCRIPTION"])
        {
            tgFactory.description = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"IMPORT"])
        {
            tgFactory.impOrt = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"IMPMONTH"])
        {
            tgFactory.impMonth = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"IMPYEAR"])
        {
            tgFactory.impYear = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"STORAGE"])
        {
            tgFactory.storage = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"CONSUM"])
        {
            tgFactory.conSum = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"CONMONTH"])
        {
            tgFactory.conMonth = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"CONYEAR"])
        {
            tgFactory.conYear = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LON"])
        {
            tgFactory.lon = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LAT"])
        {
            tgFactory.lat = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
            [TgFactoryDao delete:tgFactory];
            [TgFactoryDao insert:tgFactory];
            [tgFactory release];
            tgFactory = nil;
        }
    }
    //解析Ship
    if(iSoap==2)
    {
        if( [elementName isEqualToString:@"SHIPID"])
        {
            if(!tgShip)
                tgShip = [[TgShip alloc]init];
            tgShip.shipID = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SHIPNAME"])
        {
            tgShip.shipName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"COMID"])
        {
            tgShip.comID = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"COMPANY"])
        {
            tgShip.company = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"PORTCODE"])
        {
            tgShip.portCode = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"PORTNAME"])
        {
            tgShip.portName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"FACTORYCODE"])
        {
            tgShip.factoryCode = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"FACTORYNAME"])
        {
            tgShip.factoryName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"TRIPNO"])
        {
            tgShip.tripNo = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SUPID"])
        {
            tgShip.supID = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SUPPLIER"])
        {
            tgShip.supplier = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"HEATVALUE"])
        {
            tgShip.heatValue = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LW"])
        {
            tgShip.lw = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LENGTH"])
        {
            tgShip.length = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"WIDTH"])
        {
            tgShip.width = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"DRAFT"])
        {
            tgShip.draft = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"ETA"])
        {
            tgShip.eta = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"LAT"])
        {
            tgShip.lat = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"LON"])
        {
            tgShip.lon = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"SOG"])
        {
            tgShip.sog = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"DESTINATION"])
        {
            tgShip.destination = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"INFOTIME"])
        {
            tgShip.infoTime = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"ONLINE"])
        {
            tgShip.online = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"STAGENAME"])
        {
            tgShip.stageName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"STAGE"])
        {
            tgShip.stage = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"STATECODE"])
        {
            tgShip.statCode = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"STATENAME"])
        {
            tgShip.statName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
            [TgShipDao delete:tgShip];
            [TgShipDao insert:tgShip];
            [tgShip release];
            tgShip = nil;
        }
    }
    
    //解析Fileinfo
    if(iSoap==3)
    {
        if( [elementName isEqualToString:@"FILEID"])
        {
            if(!tsFileinfo)
                tsFileinfo = [[TsFileinfo alloc]init];
            tsFileinfo.fileId = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"FILETYPE"])
        {
            tsFileinfo.fileType = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"TITLE"])
        {
            tsFileinfo.title = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"FILEPATH"])
        {
            tsFileinfo.filePath = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"FILENAME"])
        {
            tsFileinfo.fileName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"USERNAME"])
        {
            tsFileinfo.userName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"RECORDTIME"])
        {
            tsFileinfo.recordTime = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
            if ([TsFileinfoDao tsFileIsDownload:tsFileinfo.fileId]) {
                tsFileinfo.xzbz=@"1";
            }
            else {
                tsFileinfo.xzbz=@"0";
            }
            [TsFileinfoDao delete:tsFileinfo];
            [TsFileinfoDao insert:tsFileinfo];
            [tsFileinfo release];
            tsFileinfo = nil;
        }
    }
    
    //解析Indexinfo
    if(iSoap==4)
    {
        if( [elementName isEqualToString:@"INFOID"])
        {
            if(!tmIndexinfo)
                tmIndexinfo = [[TmIndexinfo alloc]init];
            tmIndexinfo.infoId = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"INDEXNAME"])
        {
            tmIndexinfo.indexName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"RECORDTIME"])
        {
            tmIndexinfo.recordTime = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"INFOVALUE"])
        {
            tmIndexinfo.infoValue = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
            [TmIndexinfoDao delete:tmIndexinfo];
            [TmIndexinfoDao insert:tmIndexinfo];
            [tmIndexinfo release];
            tmIndexinfo = nil;
        }
    }
    //解析Indexdefine
    if(iSoap==5)
    {
        NSLog(@"%@",elementName);
        if( [elementName isEqualToString:@"INDEXID"])
        {
            if(!tmIndexdefine)
                tmIndexdefine = [[TmIndexdefine alloc]init];
            tmIndexdefine.indexId = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"INDEXNAME"])
        {
            tmIndexdefine.indexName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"INDEXTYPE"])
        {
            tmIndexdefine.indexType = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"MAXIMUM"])
        {
            tmIndexdefine.maxiMum = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"MINIMUM"])
        {
            tmIndexdefine.miniMum = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"DISPLAYNAME"])
        {
            tmIndexdefine.displayName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
            [TmIndexdefineDao delete:tmIndexdefine];
            [TmIndexdefineDao insert:tmIndexdefine];
            [tmIndexdefine release];
            tmIndexdefine = nil;
        }
    }
    //解析Indextype
    if(iSoap==6)
    {
        if( [elementName isEqualToString:@"TYPEID"])
        {
            if(!tmIndextype)
                tmIndextype = [[TmIndextype alloc]init];
            tmIndextype.typeId = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"INDEXTYPE"])
        {
            tmIndextype.indexType = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"TYPENAME"])
        {
            tmIndextype.typeName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
            [TmIndextypeDao delete:tmIndextype];
            [TmIndextypeDao insert:tmIndextype];
            [tmIndextype release];
            tmIndextype = nil;
        }
    }
    //解析Shiptrans
    if(iSoap==7)
    {
        if( [elementName isEqualToString:@"DISPATCHNO"])
        {
            if(!vbShiptrans)
                vbShiptrans = [[VbShiptrans alloc]init];
            vbShiptrans.disPatchNo = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SHIPCOMPANYID"])
        {
            vbShiptrans.shipCompanyId = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SHIPCOMPANY"])
        {
            vbShiptrans.shipCompany = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SHIPID"])
        {
            vbShiptrans.shipId = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SHIPNAME"])
        {
            vbShiptrans.shipName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"TRIPNO"])
        {
            vbShiptrans.tripNo = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"FACTORYCODE"])
        {
            vbShiptrans.factoryCode = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"FACTORYNAME"])
        {
            vbShiptrans.factoryName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"PORTCODE"])
        {
            vbShiptrans.portCode = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"PORTNAME"])
        {
            vbShiptrans.portName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SUPID"])
        {
            vbShiptrans.supId = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SUPPLIER"])
        {
            vbShiptrans.supplier = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"TYPRID"])
        {
            vbShiptrans.typeId = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"COALTYPE"])
        {
            vbShiptrans.coalType = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"KEYVALUE"])
        {
            vbShiptrans.keyValue = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"KEYNAME"])
        {
            vbShiptrans.keyName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"TRADE"])
        {
            vbShiptrans.trade = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"TRADENAME"])
        {
            vbShiptrans.tradeName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"HEATVALUE"])
        {
            vbShiptrans.heatValue = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"STAGE"])
        {
            vbShiptrans.stage = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"STAGENAME"])
        {
            vbShiptrans.stageName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"STATECODE"])
        {
            vbShiptrans.stateCode = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"STATENAME"])
        {
            vbShiptrans.stateName = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LW"])
        {
            vbShiptrans.lw = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"P_ANCHORAGETIME"])
        {
            vbShiptrans.p_AnchorageTime = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"P_HANDLE"])
        {
            vbShiptrans.p_Handle = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"P_ARRIVALTIME"])
        {
            vbShiptrans.p_ArrivalTime = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"P_DEPARTTIME"])
        {
            vbShiptrans.p_DepartTime = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"P_NOTE"])
        {
            vbShiptrans.p_Note = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"T_NOTE"])
        {
            vbShiptrans.t_Note = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"F_ANCHORAGETIME"])
        {
            vbShiptrans.f_AnchorageTime = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"F_ARRIVALTIME"])
        {
            vbShiptrans.f_ArrivalTime = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"F_DEPARTTIME"])
        {
            vbShiptrans.f_DepartTime = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"F_NOTE"])
        {
            vbShiptrans.f_Note = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LATEFEE"])
        {
            vbShiptrans.lateFee = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        
        else if( [elementName isEqualToString:@"FACSORT"])
        {
            vbShiptrans.facSort = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"OFFEFFICIENCY"])
        {
            vbShiptrans.offEfficiency = [soapResults integerValue];
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SCHEDULE"])
        {
            vbShiptrans.schedule = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"PLANTYPE"])
        {
            vbShiptrans.planType = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"PLANCODE"])
        {
            vbShiptrans.planCode = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LAYCANSTART"])
        {
            vbShiptrans.laycanStart = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"LAYCANSTOP"])
        {
            vbShiptrans.laycanStop = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"RECIEPT"])
        {
            vbShiptrans.reciept = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"SHIPSHIFT"])
        {
            vbShiptrans.shipShift = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
        }
        else if( [elementName isEqualToString:@"TRADETIME"])
        {
            vbShiptrans.tradeTime = soapResults;
            recordResults = FALSE;
            [soapResults release];
            soapResults = nil;
            [VbShiptransDao delete:vbShiptrans];
            [VbShiptransDao insert:vbShiptrans];
            [vbShiptrans release];
            vbShiptrans = nil;
        }
        
    }
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"-------------------start---- xml解析--------------");
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"-------------------end---------------------------");
    iSoapDone=1;
    if (iSoapTmIndexdefineDone==1) {
        iSoapTmIndexdefineDone=2;
//        alertMsg = @"成功更新 TmIndexdefine";
//        [self msgbox];
        iSoapNum--;
    }
    if (iSoapTmIndextypeDone==1) {
        iSoapTmIndextypeDone=2;
//        alertMsg = @"成功更新 TmIndextype";
//        [self msgbox];
        iSoapNum--;
    }
    if (iSoapTmIndexinfoDone==1) {
        iSoapTmIndexinfoDone=2;
//        alertMsg = @"成功更新 TmIndexinfo";
//        [self msgbox];
        iSoapNum--;
    }
    if (iSoapTsFileinfoDone==1) {
        iSoapTsFileinfoDone=2;
//        alertMsg = @"成功更新 TsFileinfo";
//        [self msgbox];
        iSoapNum--;
    }
    if (iSoapTgPortDone==1) {
        iSoapTgPortDone=2;
//        alertMsg = @"成功更新 TgPort";
//        [self msgbox];
        iSoapNum--;
    }
    if (iSoapTgFactoryDone==1) {
        iSoapTgFactoryDone=2;
//        alertMsg = @"成功更新 TgFactory";
//        [self msgbox];
        iSoapNum--;
    }
    if (iSoapTgShipDone==1) {
        iSoapTgShipDone=2;
//        alertMsg = @"成功更新 TgShip";
//        [self msgbox];
        iSoapNum--;
    }
    if (iSoapVbShiptransDone==1) {
        iSoapVbShiptransDone=2;
//        alertMsg = @"成功更新 VbShiptrans";
//        [self msgbox];
        iSoapNum--;
    }
}

-(NSInteger)iSoapTmIndextypeDone
{
	return iSoapTmIndextypeDone;
}
-(NSInteger)iSoapTmIndexdefineDone
{
	return iSoapTmIndexdefineDone;
}
-(NSInteger)iSoapTmIndexinfoDone
{
	return iSoapTmIndexinfoDone;
}
-(NSInteger)iSoapTsFileinfoDone
{
	return iSoapTsFileinfoDone;
}
-(NSInteger)iSoapTgPortDone
{
	return iSoapTgPortDone;
}
-(NSInteger)iSoapTgFactoryDone
{
	return iSoapTgFactoryDone;
}
-(NSInteger)iSoapTgShipDone
{
	return iSoapTgShipDone;
}
-(NSInteger)iSoapVbShiptransDone
{
	return iSoapVbShiptransDone;
}
-(NSInteger)iSoapDone
{
	return iSoapDone;
}
-(NSInteger)iSoapNum
{
	return iSoapNum;
}
-(void)setISoapNum:(NSInteger)theNum
{
	iSoapNum=theNum;
}
@end
