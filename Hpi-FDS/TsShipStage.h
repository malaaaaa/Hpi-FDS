//
//  TsShipStage.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TsShipStage : NSObject{
    NSString *_STAGE;
    NSString *_STAGENAME;
    NSInteger _SORT;
    BOOL didSelected;
}
@property(nonatomic,retain) NSString *STAGE;
@property(nonatomic,retain) NSString *STAGENAME;
@property NSInteger SORT;
@property(assign) BOOL didSelected;

@end
