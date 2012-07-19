//
//  MemoirListVC.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-5.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoirCell.h"
#import "PubInfo.h"
#import "EGORefreshTableHeaderView.h"
#import "XMLParser.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
@interface MemoirListVC : UIViewController<
    UITableViewDataSource,
    UITableViewDelegate,
    EGORefreshTableHeaderDelegate>
{
    IBOutlet UITableView *memoirTableView;
    UIPopoverController *popover;
    NSMutableArray *listArray;
    NSMutableArray *downLoadArray;
    NSMutableArray *cellArray;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    XMLParser *xmlParser;
    ASINetworkQueue *networkQueue;
    UIProgressView	*processView;
    float contentLength;//大小(BIT)
    id webVC;
    NSString *stringType;
}
@property (nonatomic,retain) UITableView *memoirTableView;
@property (nonatomic,retain) UIPopoverController *popover;
@property (nonatomic,retain) NSMutableArray *listArray;
@property (nonatomic,retain) XMLParser *xmlParser;
@property (nonatomic,retain) ASINetworkQueue *networkQueue;
//@property (nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic,retain) NSMutableArray *downLoadArray;
@property (nonatomic,retain) UIProgressView *processView;
@property (nonatomic,assign) float contentLength;
@property (nonatomic,assign) id webVC;
@property (nonatomic,retain) NSMutableArray *cellArray;
@property (nonatomic,copy) NSString *stringType;

-(void) stratDownload:(MemoirCell *)cell;
@end
