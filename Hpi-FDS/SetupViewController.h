//
//  SetupViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"
#import "TBXMLParser.h"
#import "PubInfo.h"
@interface SetupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    IBOutlet UITableView *tableView;
    //基础数据接续同步解析
    XMLParser *xmlParser;
    UIActivityIndicatorView *activity;
    UITextField *serverTextField;
    NSInteger flag;
     UIProgressView *baseProgressview;
    UIProgressView *mmpProgressview;
    UIProgressView *reportProgressview;

    //地图市场港口同步解析
    TBXMLParser *mmpTbxmlParser;
    //数据查询同步解析
    TBXMLParser *reportTbxmlParser;

}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) XMLParser *xmlParser;
@property(nonatomic,retain) UIActivityIndicatorView *activity;
@property(nonatomic,retain) UITextField *serverTextField;
@property(nonatomic,retain) UIProgressView *baseProgressview;
@property(nonatomic,retain) UIProgressView *mmpProgressview;
@property(nonatomic,retain) UIProgressView *reportProgressview;
@property (retain, nonatomic) TBXMLParser *mmpTbxmlParser;
@property (retain, nonatomic) TBXMLParser *reportTbxmlParser;

@end
