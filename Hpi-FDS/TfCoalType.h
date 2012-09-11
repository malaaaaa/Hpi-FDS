//
//  TfCoalType.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TfCoalType : NSObject{
    NSInteger TYPEID;
    NSString *COALTYPE;
    NSInteger SORT;
    NSInteger HEATVALUE;
    NSInteger SULFUR;
    
    BOOL didSelected;
}
@property NSInteger TYPEID;
@property (nonatomic,retain) NSString *COALTYPE;
@property NSInteger SORT;
@property NSInteger HEATVALUE;
@property NSInteger SULFUR;
@property(assign) BOOL didSelected;

@end
