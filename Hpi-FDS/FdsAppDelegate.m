//
//  FdsAppDelegate.m
//  Hpi-FDS
//
//  Created by zcx on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FdsAppDelegate.h"
#import "MapViewController.h"
#import "WebViewController.h"
#import "MarketViewController.h"
#import "PortViewController.h"
#import "QueryViewController.h"
#import "SetupViewController.h"
#import "DataQueryVC.h"
#import "PubInfo.h"
#import "UIDevice+IdentifierAddition.h"
#import "DataQueryPopVC.h"

#import "LoginResponse.h"
@implementation FdsAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize login;
@synthesize logr;
NSString *deviceUID;
UIAlertView *VersionAlert;
UIAlertView *RegistAlert;
-(void)customizeAppearance{
    //设置底部TabBar
    //[[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageNamed:@"bgbg(3)"]];
}
- (void)dealloc
{
    [deviceUID release];
    if (self.login){
        [login release];
        login=nil;
    }
    [window release];
    window=nil;
    [tabBarController release];
    tabBarController=nil;
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [PubInfo initdata];
    self.logr=[[[LoginResponse alloc] init] autorelease];
    [self showMainPage];
    
    //    取消本地验证策略
    //    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *path=[paths   objectAtIndex:0];
    //    NSString *fileName=[path  stringByAppendingPathComponent:@"data.plist"];
    //    NSArray  *datePlist=[[NSArray alloc] initWithContentsOfFile:fileName];
    //    NSLog(@"=====================================%@",[datePlist objectAtIndex:3]);
    //    if (![[datePlist objectAtIndex:3] isEqualToString:UYES]) {
    
    return YES;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView==RegistAlert) {

        
        
        if (buttonIndex==1) {
            NSLog(@"取消");
            exit(0);
        }
        if(buttonIndex==0){
            NSLog(@"重新注册");
        }
    }
    else if (alertView==VersionAlert)
    {
        if(buttonIndex==0){         
          //  NSLog(@"更新");
            if (self.logr.regMsg.length>0&&self.logr.regMsg) {
                
                NSString *url=self.logr.regMsg;
                //[NSString stringWithFormat:@"http://10.2.17.121/install.html"];
                // NSLog(@"url>>>>>>>>>>>>>%@",url);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                
            }
             exit(0);
            
            
        }
    }
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    BOOL valid = [self validateFromServer];
    //注册未完成设备或被禁用设备
    if (FALSE==valid) {
        [self showLoginPage];
        if ([self.logr.ISHAVE isEqualToString:@"1"]) {
            NSLog(@"注册。。。。。。。。。。。。。。");
            RegistAlert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"注册信息已保存,是否重新注册？" delegate:self cancelButtonTitle:@"重新注册" otherButtonTitles:@"取消", nil];
            [RegistAlert show];
            [RegistAlert  release];
        }
    }
    //当前应用版本低，不可用
    else if ([self.logr.RETCODE isEqualToString:@"3"]) {
        VersionAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"程序版本更新 请下载安装！" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil,nil];
        
       
        
        [VersionAlert show];
        [VersionAlert release];
    }
    else{
        [self removeLoginPage];
    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
 {
 }
 */

- (BOOL) validateFromServer{
    deviceUID = [[NSString alloc] initWithString:[[UIDevice currentDevice] uniqueDeviceIdentifier]] ;
    NSString *requestStr=[NSString stringWithFormat:@"<GetLoginValadateinfo xmlns=\"http://tempuri.org/\">\n <req>\n"
                          "<deviceid>%@</deviceid>\n"
                          "<version>%@</version>\n"
                          "<updatetime>%@</updatetime>\n"
                          "</req>\n"
                          "</GetLoginValadateinfo>\n"
                          ,deviceUID, version,PubInfo.currTime];
    
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
    
   // NSString *theXML = [[NSString alloc] initWithBytes: [returnData mutableBytes] length:[returnData length] encoding:NSUTF8StringEncoding];
  // NSLog(@"xml=%@",theXML);
    
    NSString *element1=@"LoginValadate";
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
            TBXMLElement *elementNoUsed = [TBXML childElementNamed: @"retinfo"  parentElement:[TBXML childElementNamed:elementString1 parentElement:[TBXML childElementNamed:elementString2 parentElement:[TBXML childElementNamed:@"soap:Body" parentElement:root]]]];
            //@"LoginResponse"
            TBXMLElement *element = [TBXML childElementNamed:@"LoginResponse"    parentElement:elementNoUsed];
            TBXMLElement * desc;
            while (element != nil) {
                desc = [TBXML childElementNamed:@"SBID" parentElement:element];
                if (desc != nil) {
                    
                    self.logr.SBID=[TBXML textForElement:desc] ;
                   // NSLog(@"%@",self.logr.SBID);
                }
                desc = [TBXML childElementNamed:@"RETCODE" parentElement:element];
                if (desc != nil) {
                    self.logr.RETCODE=[TBXML textForElement:desc] ;
                   // NSLog(@"%@",self.logr.RETCODE);
                }
                
                
                desc = [TBXML childElementNamed:@"REGMsg" parentElement:element];
                if (desc != nil) {
                 self.logr.regMsg=   [TBXML textForElement:desc];
                   // NSLog(@"[TBXML textForElement:desc] >>>>>>>>>>>>>>>%@",self.logr.regMsg );
                }
                
                
                
                
                
                
                desc = [TBXML childElementNamed:@"STAGE" parentElement:element];
                if (desc != nil) {
                    
                    self.logr.STAGE=[TBXML textForElement:desc] ;
                   // NSLog(@"%@",self.logr.STAGE);
                }
                desc = [TBXML childElementNamed:@"ISHave" parentElement:element];
                if (desc != nil) {
                    
                    self.logr.ISHAVE=[TBXML textForElement:desc] ;
                  //  NSLog(@"%@",self.logr.ISHAVE);
                }
                
                element = [TBXML nextSiblingNamed:@"LoginResponse"  searchFromElement:element];
            }
        }
        
    }
    // 释放对象
    
    [request release];
    
    //所有状态不为已注册，包括没有上传注册信息的设备都认为不可用
    if (![self.logr.STAGE isEqualToString:@"2"]) {
        
        return FALSE;
    }
    
    return TRUE;
}

- (void)showMainPage{
    NSLog(@"-------------主页面--------------------");
    //    [self customizeAppearance];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UIViewController *viewController1 = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
   
    UIViewController *viewController3 = [[[MarketViewController alloc] initWithNibName:@"MarketViewController" bundle:nil] autorelease];
    UIViewController *viewController4 = [[[PortViewController alloc] initWithNibName:@"PortViewController" bundle:nil] autorelease];
    UIViewController *viewController5 = [[[DataQueryPopVC alloc] initWithNibName:@"DataQueryPopVC" bundle:nil] autorelease];
    
    UIViewController *viewController6 = [[[SetupViewController alloc] initWithNibName:@"SetupViewController" bundle:nil] autorelease];
    
    /*纪要查看*/
    // UIViewController *viewController7 = [[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil] autorelease];
    
    
    
    //新添 电厂动态
    UIViewController *viewController2=[[[FactoryWaitDynamicViewController alloc] initWithNibName:@"FactoryWaitDynamicViewController" bundle:nil] autorelease    ];
    
    
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2,viewController3,viewController4,viewController5,viewController6,nil];
    
    [window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    
}

- (void)showLoginPage{
    NSLog(@"-------------注册页面--------------------");
    self.login=[[[LoginView alloc] initWithNibName:@"LoginView" bundle:nil] autorelease];
    [self.tabBarController.view addSubview:self.login.view];
    
}
- (void)removeLoginPage{
    if (self.login) {
        [self.login.view removeFromSuperview];
        self.login=nil;
    }
}

@end
