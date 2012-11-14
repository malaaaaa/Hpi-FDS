//
//  TgPort.h
//  Hfds
//
//  Created by zcx on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TgPort : NSObject{
    NSString *portCode;
    NSInteger shipNum;
    NSInteger handleShip;
    NSInteger waitShip;
    NSInteger transactShip;
    NSInteger loadShip;
    NSString *portName;
    NSString *lon;
    NSString *lat;
    BOOL didSelected;
}

@property (nonatomic,retain) NSString *portCode;
@property (nonatomic,retain) NSString *portName;
@property (nonatomic,retain) NSString *lon;
@property (nonatomic,retain) NSString *lat;
@property NSInteger shipNum;
@property NSInteger handleShip;
@property NSInteger waitShip;
@property NSInteger transactShip;
@property NSInteger loadShip;
@property (assign) BOOL didSelected;
@end
