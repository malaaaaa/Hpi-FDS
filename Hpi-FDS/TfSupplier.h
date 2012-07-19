//
//  TfSupplier.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface TfSupplier : NSObject{
    NSInteger _SUPID;
    NSInteger _PID;
    NSString *_SUPPLIER;
    NSString *_DESCRIPTION;
    NSString *_LINKMAN;
    NSString *_CONTACT;
    NSInteger _SORT;
    BOOL    didSelected;//是否选中

}
@property NSInteger SUPID;
@property NSInteger PID;
@property (nonatomic,retain) NSString *SUPPLIER;
@property (nonatomic,retain) NSString *DESCRIPTION;
@property (nonatomic,retain) NSString *LINKMAN;
@property (nonatomic,retain) NSString *CONTACT;
@property NSInteger SORT;
@property(assign) BOOL didSelected;


@end
