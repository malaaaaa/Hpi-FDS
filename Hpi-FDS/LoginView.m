//
//  LoginView.m
//  Hpi-FDS
//
//  Created by tang bin on 12-10-19.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "LoginView.h"
#import "UIDevice+IdentifierAddition.h"
#import "PubInfo.h"

#import "LoginResponse.h"
#import "TBXML.h"
@interface LoginView ()

@end

@implementation LoginView
@synthesize partName;
@synthesize Phone;
@synthesize userName;
@synthesize emile;
@synthesize server;
@synthesize requestData;
@synthesize responseDate;
@synthesize method;
@synthesize logr;
@synthesize finish;
@synthesize connectError;

NSString* alertMsg;

NSString* msg;

UIAlertView *alert;
UIAlertView *MailAlert;
static NSString *version = @"V1.2";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    requestData=[[RequestData alloc] init];
    finish=1;
    connectError=NO;
    
    server.clearsOnBeginEditing = NO;//鼠标点上时，不清空
    server.text=PubInfo.url;
    server.returnKeyType = UIReturnKeyDone;
    [server addTarget:self action:@selector(textfieldDone:) forControlEvents:UIControlEventEditingDidEnd];
}

- (IBAction)ZHUC:(id)sender {
    //发送 信息......
    requestData.userName=self.userName.text;
    requestData.emile=self.emile .text;
    requestData.phone=self.Phone .text;
    requestData.partName=self.partName .text;
    if ([self.userName.text isEqualToString:@""]&&[self.emile .text isEqualToString:@""]&&[self.Phone .text isEqualToString:@""]&&[self.partName .text isEqualToString:@""]) {
        return;
    }
    //校验邮箱地址是否合法
    if ([PubInfo validateEmail:requestData.emile]) {
        [self regist];
    }
    else{
        MailAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱地址非法，是否提交？" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:@"提交",nil ];
        [MailAlert show];
        [MailAlert release];

    }
       
}
-(void)regist{
    //获取设备id号
    NSString *deviceUID = [[[NSString alloc] initWithString:[[UIDevice currentDevice] uniqueDeviceIdentifier]] autorelease];
    
    requestData.strID=deviceUID;
    
    NSString *requestStr=[NSString stringWithFormat:@"<GetLoginRequestinfo xmlns=\"http://tempuri.org/\">\n <req>\n"
                          "<deviceid>%@</deviceid>\n"
                          "<version>%@</version>\n"
                          "<updatetime>%@</updatetime>\n"
                          "<usename>%@</usename>\n"
                          "<partname>%@</partname>\n"
                          "<phone>%@</phone>\n"
                          "<emile>%@</emile>\n"
                          "</req>\n"
                          "</GetLoginRequestinfo>\n"
                          ,requestData.strID, version,PubInfo.currTime,requestData.userName,requestData.partName,requestData.phone,requestData.emile ];
    
    method=@"LoginRequest";//@"LoginRequest";
    [self requestSoap:requestStr];
    //................
    [self runWaite];
    [PubInfo setUserName:self.userName.text];
    [PubInfo save];
    
}
-(void)alertMsg:(LoginResponse *)lr
{
    //  //状态(0-接收注册请求；1-发送验证邮件；2-通过验证；3-未通过验证)
    if ([lr.STAGE isEqualToString:@"0"])
        msg=@"设备信息已保存。\n请查收内部邮件完成注册或等待管理员注册该设备";
    if ([lr.STAGE isEqualToString:@"1"])
        msg=@"请进入注册邮箱激活账号";
    //  if ([lr.STAGE isEqualToString:@"2"])  直接进入程序
    //    msg=@"请进入注册邮箱激活账号";
    
    if ([lr.STAGE isEqualToString:@"3"])
        msg=@"请重新注册";
    
    if ([lr.RETCODE isEqualToString:@"2"])
        msg=@"请求非法";
    
    if ([lr.RETCODE isEqualToString:@"1"]) {
        msg=@"注册失败";
    }

    NSLog(@"%@======%@",lr.STAGE,msg);  
 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
    [alert release];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView==MailAlert) {
        if (buttonIndex==0) {
            NSLog(@"do nothing");
        }
        else{
            [self regist];
        }
    }
    else if (buttonIndex==0) {
        exit(0);
    }
}

-(void)runWaite
{
    if (finish==0) {
        NSLog(@"logr.STAGE===========================%@",logr.STAGE);
        [self alertMsg:self.logr];
        return;
    }else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runWaite) userInfo:NULL repeats:NO];
    }
}

-(void)requestSoap:(NSString *)requestStr
{
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                            "<soap12:Body>\n  %@ </soap12:Body>\n"
                            "</soap12:Envelope>\n",requestStr ];
    
    NSLog(@"soapMessage[%@]",soapMessage);
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    NSURL *url = [NSURL URLWithString:PubInfo.baseUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        NSLog(@"yes connect");
        
        responseDate = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseDate setLength: 0];
    NSLog(@"connection: didReceiveResponse:1    建立连接、。、、、、");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseDate appendData:data];
    
}
-(void) msgbox
{
	alert = [[UIAlertView alloc]initWithTitle:@"提示" message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    
}
-(void) performDismiss:(NSTimer *)timer
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert release];
	alert =  nil;
}

//如果没有连接网络，则出现此信息（不是网络服务器不通）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"--------------------------------------------ERROR with theConenction");
    [connection release];
    [responseDate release];
    
//    alertMsg = @"无法连接,请检查网络是否正常?";
//    [self msgbox];
    connectError=YES;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"--------------------------------------------  connectionDidFinishLoading");
    [connection release];
    NSString *result = [[NSString alloc] initWithBytes: [responseDate mutableBytes] length:[responseDate length] encoding:NSUTF8StringEncoding];

     NSLog(@"%@",result);
    [self XMLPART:method ];
}


-( void)XMLPART:(NSString *)element1
{
    self.logr=[[LoginResponse alloc] init] ;
    
    NSString *elementString1= [NSString stringWithFormat:@"Get%@infoResult",element1];
    NSString *elementString2= [NSString stringWithFormat:@"Get%@infoResponse",element1];
    // char *errorMsg;
    NSError *error = nil;
    TBXML * tbxml = [TBXML newTBXMLWithXMLData:responseDate error:&error];
    if (error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        
    }else {
        TBXMLElement * root = tbxml.rootXMLElement;
        //=======================================
        if (root) {
            TBXMLElement *elementNoUsed = [TBXML childElementNamed:@"retinfo" parentElement:[TBXML childElementNamed:elementString1 parentElement:[TBXML childElementNamed:elementString2 parentElement:[TBXML childElementNamed:@"soap:Body" parentElement:root]]]];
            
            TBXMLElement *element = [TBXML childElementNamed:@"LoginResponse" parentElement:elementNoUsed];
            TBXMLElement * desc;
            while (element != nil) {
                desc = [TBXML childElementNamed:@"SBID" parentElement:element];
                if (desc != nil) {
                    
                    self.logr.SBID=[TBXML textForElement:desc] ;
                    NSLog(@"%@",self.logr.SBID);
                }
                desc = [TBXML childElementNamed:@"RETCODE" parentElement:element];
                if (desc != nil) {
                    self.logr.RETCODE=[TBXML textForElement:desc] ;
                    NSLog(@"%@",self.logr.RETCODE);
                }
                
                desc = [TBXML childElementNamed:@"STAGE" parentElement:element];
                if (desc != nil) {
                    
                    self.logr.STAGE=[TBXML textForElement:desc] ;
                    NSLog(@"%@",self.logr.STAGE);
                }
                element = [TBXML nextSiblingNamed:@"LoginResponse"  searchFromElement:element];
            }
        }
        
    }
    finish--;
    
    
    
    
    
}


- (void)viewDidUnload
{
    [userName release];
    userName = nil;
    [partName release];
    partName = nil;
    [Phone release];
    Phone = nil;
    [emile release];
    emile = nil;
    [server release];
    server = nil;

    [responseDate release];
    responseDate=nil;
    [requestData release];
    requestData=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//强制横屏幕显示
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation  == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (void)dealloc {
    [userName release];
    [partName release];
    [Phone release];
    [emile release];
    [server release];
    [requestData release];
    [responseDate release];
    [ method release];
    if (self.logr)
        [self.logr release];

    [super dealloc];
}

- (IBAction)textfieldDone:(id)sender {
    [PubInfo setHostName:server.text];
    [PubInfo setPort:@""];
    [PubInfo save];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing");  //测试用
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该地址为后台服务器地址\n 请谨慎修改！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil,nil];
	[alert show];
    [alert release];
    return  YES;
}

@end


@implementation RequestData
@synthesize userName;
@synthesize phone;
@synthesize partName;
@synthesize emile;
@synthesize strID;


-(void)dealloc
{
    [userName release];
    [phone release];
    [emile release];
    [partName release];
    [strID release];
    [super dealloc];
}

@end







