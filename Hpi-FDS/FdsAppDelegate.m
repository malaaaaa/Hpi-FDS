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
@implementation FdsAppDelegate

@synthesize window;
@synthesize tabBarController;


-(void)customizeAppearance{
    //设置底部TabBar
    //[[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageNamed:@"bgbg(3)"]];
}
- (void)dealloc
{
    [window release];
    [tabBarController release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PubInfo initdata];
    [self customizeAppearance];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
    UIViewController *viewController2 = [[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil] autorelease];
    UIViewController *viewController3 = [[[MarketViewController alloc] initWithNibName:@"MarketViewController" bundle:nil] autorelease];
    UIViewController *viewController4 = [[[PortViewController alloc] initWithNibName:@"PortViewController" bundle:nil] autorelease];
//    UIViewController *viewController5 = [[[DataQueryVC alloc] initWithNibName:@"DataQueryVC" bundle:nil] autorelease];
      UIViewController *viewController5 = [[[DataQueryPopVC alloc] initWithNibName:@"DataQueryPopVC" bundle:nil] autorelease];
    UIViewController *viewController6 = [[[SetupViewController alloc] initWithNibName:@"SetupViewController" bundle:nil] autorelease];
    //UIViewController *viewController4 = [[[QueryViewController alloc] initWithNibName:@"QueryViewController" bundle:nil] autorelease];
    //NSString *deviceUDID = [[UIDevice currentDevice] uniqueIdentifier];
    NSLog(@"设备ID-1 %@",[[UIDevice currentDevice] uniqueDeviceIdentifier]);
    NSLog(@"设备ID-2 %@",[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]);
    
    //获取设备id号
    NSString *deviceUID = [[[NSString alloc] initWithString:[[UIDevice currentDevice] uniqueDeviceIdentifier]] autorelease];
    NSLog(@"%@",deviceUID); // 输出设备id
    

    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
//    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2,viewController3,viewController4,viewController5,viewController6,nil];
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2,viewController3,viewController4,viewController5,viewController6,nil];
    
    [window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
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
