//
//  WebViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoirListVC.h"
@interface WebViewController : UIViewController<UIWebViewDelegate,UIPopoverControllerDelegate,UIGestureRecognizerDelegate>{
    IBOutlet UIWebView *webView1;
    UIPopoverController *popover;
    IBOutlet UILabel *titleLable;
    
    
    
   // IBOutlet UISegmentedControl *segment;
    
    IBOutlet UIButton *infoButton;
    
    int  FileLoadStatus;
    MemoirListVC *memoirListVC;
    UILabel *_waitingLable;
    
    
    int loadCount;
    
}

@property   int FileLoadStatus;

@property   int loadCount;

@property (nonatomic,retain) UIWebView *webView1;
@property (nonatomic,retain) UIPopoverController *popover;
@property (nonatomic,retain) UILabel *titleLable;
@property (nonatomic,retain) MemoirListVC *memoirListVC;


//@property (nonatomic,retain) UISegmentedControl *segment;

@property (nonatomic,retain) UIButton *infoButton;

@property (nonatomic,retain) UILabel *waitingLable;
+(void)setFileName:(NSString*) theName;




- (void)viewloadRequest;
@end
