//
//  WebViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoirListVC.h"
@interface WebViewController : UIViewController<UIWebViewDelegate,UIPopoverControllerDelegate>{
    IBOutlet UIWebView *webView;
    UIPopoverController *popover;
    IBOutlet UIButton *listButton;
    MemoirListVC *memoirListVC;
    IBOutlet UINavigationItem *navigationItem;
}
@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) UIPopoverController *popover;
@property (nonatomic,retain) UIButton *listButton;
@property (nonatomic,retain) MemoirListVC *memoirListVC;
@property (nonatomic,retain) UINavigationItem *navigationItem;
+(void)setFileName:(NSString*) theName;
- (void)viewloadRequest;
@end
