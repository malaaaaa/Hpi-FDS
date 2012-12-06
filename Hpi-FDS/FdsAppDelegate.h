//
//  FdsAppDelegate.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
@interface FdsAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    UIWindow *window;
    UITabBarController *tabBarController;
    LoginView *login;
    LoginResponse *logr;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic,retain)LoginView *login;
@property(nonatomic,retain)    LoginResponse *logr;


@end
