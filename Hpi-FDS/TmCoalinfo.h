//
//  TmCoalinfo.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

//INFOID               //信息ID
//PORTCODE             //港口编号
//RECORDDATE           //采集日期
//IMPORT               //调进煤量
//EXPORT               //调出煤量
//STORAGE              //港存煤量

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface TmCoalinfo : NSObject
{
    NSInteger infoId;
    NSString *portCode;
    NSString *recordDate;
    NSInteger import;
    NSInteger Export;
    NSInteger storage;
}

@property NSInteger infoId;
@property (nonatomic, retain) NSString *portCode;
@property (nonatomic, retain) NSString *recordDate;
@property NSInteger import;
@property NSInteger Export;
@property NSInteger storage;

@end
