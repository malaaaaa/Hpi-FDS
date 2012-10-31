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
NSString *deviceUID;
-(void)customizeAppearance{
    //设置底部TabBar
    //[[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageNamed:@"bgbg(3)"]];
}
- (void)dealloc
{
    [deviceUID release];
    if (self.login)
        [login release];
    [window release];
    [tabBarController release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

      [PubInfo initdata];
     NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *path=[paths   objectAtIndex:0];
     NSString *fileName=[path  stringByAppendingPathComponent:@"data.plist"];
     NSArray  *datePlist=[[NSArray alloc] initWithContentsOfFile:fileName];
    NSLog(@"=====================================%@",[datePlist objectAtIndex:3]);
    if (![[datePlist objectAtIndex:3] isEqualToString:UYES]) {
        //网络请求 后台服务  查找该设备id是否 存在    --根据后台结果 修改本地标识  下次可用     不存在 跳转到注册页面...
      deviceUID = [[NSString alloc] initWithString:[[UIDevice currentDevice] uniqueDeviceIdentifier]] ;
        NSString *requeStr=[NSString stringWithFormat:@"<GetLoginValadateinfo xmlns=\"http://tempuri.org/\">\n <req>\n"
                            "<deviceid>%@</deviceid>\n"
                            "<version>%@</version>\n"
                            "<updatetime>%@</updatetime>\n"
                            "</req>\n"
                            "</GetLoginValadateinfo>\n"
                            ,deviceUID, @"V1.2",PubInfo.currTime];
        
        self.login=[[[LoginView alloc] initWithNibName:@"LoginView" bundle:nil] autorelease];
        login. method=@"LoginValadate";
        [login requestSoap:requeStr];
        [self runWaite];
    }
    else
    {
        [self customizeAppearance];
        self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        UIViewController *viewController1 = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
        UIViewController *viewController2 = [[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil] autorelease];
        UIViewController *viewController3 = [[[MarketViewController alloc] initWithNibName:@"MarketViewController" bundle:nil] autorelease];
        UIViewController *viewController4 = [[[PortViewController alloc] initWithNibName:@"PortViewController" bundle:nil] autorelease];
        UIViewController *viewController5 = [[[DataQueryPopVC alloc] initWithNibName:@"DataQueryPopVC" bundle:nil] autorelease];
      
        
        
        
        UIViewController *viewController6 = [[[SetupViewController alloc] initWithNibName:@"SetupViewController" bundle:nil] autorelease];
     //   NSLog(@"设备ID-1 %@",[[UIDevice currentDevice] uniqueDeviceIdentifier]);
     //   NSLog(@"设备ID-2 %@",[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]);
        
        self.tabBarController = [[[UITabBarController alloc] init] autorelease];
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2,viewController3,viewController4,viewController5,viewController6,nil];
        
        [window addSubview:tabBarController.view];
        [self.window makeKeyAndVisible];
    
        
        [self.login release];
        
    }
    
    [datePlist release];
    return YES;
}

-(void)Valadate:(LoginResponse *)lr
{
    NSLog(@"=================Valadate=========================");
    //状态(0-接收注册请求；1-发送验证邮件；2-通过验证；3-未通过验证)
    if ([lr.SBID isEqualToString:deviceUID]&&[lr.STAGE isEqualToString:@"2"]) {
        //修改本地标识
        [PubInfo  setIsSucess:UYES];
        [PubInfo save];
        [self customizeAppearance];
        self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        // Override point for customization after application launch.
        UIViewController *viewController1 = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
        UIViewController *viewController2 = [[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil] autorelease];
        UIViewController *viewController3 = [[[MarketViewController alloc] initWithNibName:@"MarketViewController" bundle:nil] autorelease];
        UIViewController *viewController4 = [[[PortViewController alloc] initWithNibName:@"PortViewController" bundle:nil] autorelease];
        UIViewController *viewController5 = [[[DataQueryPopVC alloc] initWithNibName:@"DataQueryPopVC" bundle:nil] autorelease];
        
        
        
      
    
        
        
        
        UIViewController *viewController6 = [[[SetupViewController alloc] initWithNibName:@"SetupViewController" bundle:nil] autorelease];
     //   NSLog(@"设备ID-1 %@",[[UIDevice currentDevice] uniqueDeviceIdentifier]);
       // NSLog(@"设备ID-2 %@",[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]);
        
        self.tabBarController = [[[UITabBarController alloc] init] autorelease];
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2,viewController3,viewController4,viewController5,viewController6,nil];
        [window addSubview:tabBarController.view];
        [self.window makeKeyAndVisible];
        
        [self.login release];
    }
    else
    {
        NSLog(@"-------------注册页面--------------------");
        self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        [window addSubview:self.login.view];
        [self.window makeKeyAndVisible];
    }
    
    
    
}




-(void)runWaite
{
    if (login.logr) {
        LoginResponse *lr= login.logr;
        NSLog(@"runWaite=====%@",login.logr.STAGE);
        [self Valadate:lr];
        return;
    }
    else if(YES==login.connectError)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"后台服务器连接失败！\n，请检查网络或修改服务器地址!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];  
        
        NSLog(@"-------------注册页面--------------------");
        self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        [window addSubview:self.login.view];
        [self.window makeKeyAndVisible];
    }
    else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runWaite) userInfo:NULL repeats:NO];
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

@end
