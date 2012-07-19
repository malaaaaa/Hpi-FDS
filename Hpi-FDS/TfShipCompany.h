//
//  TfShipCompany.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-17.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface TfShipCompany : NSObject{
    NSInteger comid;
    NSString *_company;
    NSString *_description;
    NSString *_linkman;
    NSString *_contact;
    BOOL    didSelected;//是否选中

}
@property NSInteger comid;
@property(nonatomic,retain) NSString *description;
@property(nonatomic,retain) NSString *company;
@property(nonatomic,retain) NSString *linkman;
@property(nonatomic,retain) NSString *contact;
@property(assign) BOOL didSelected;
@end
