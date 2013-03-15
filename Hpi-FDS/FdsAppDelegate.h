//
//  FdsAppDelegate.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "MapViewController.h"
@interface FdsAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    UIWindow *window;
    UITabBarController *tabBarController;
    LoginView *login;
    LoginResponse *logr;
    MapViewController *_mapVC;
    UIImageView *zView;//Z图片ImageView
    UIImageView *fView;//F图片ImageView
    UIView *rView;//图片的UIView
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic,retain)LoginView *login;
@property(nonatomic,retain)    LoginResponse *logr;
@property(nonatomic,retain)    MapViewController *mapVC;


@end
