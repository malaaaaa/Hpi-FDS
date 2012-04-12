//
//  FdsAppDelegate.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FdsAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
