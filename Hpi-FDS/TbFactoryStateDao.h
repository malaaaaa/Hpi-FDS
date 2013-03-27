//
//  TbFactoryStateDao.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TbFactoryState.h"
@interface TbFactoryStateDao : NSObject{
    
}
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) insert:(TbFactoryState*) tbFactoryState;
+(void) delete:(TbFactoryState*) tbFactoryState;
+(NSMutableArray *) getTbFactoryState:(NSString *)factoryCode;
+(NSMutableArray *) getTbFactoryStateBySql:(NSString *)sql;
+(void) deleteAll;

+(float)GetMonthPort:(NSDate *)time :(NSString *)facN;
//处理时间  //前一天所在月份的第二天  5/2   5/10
+(NSString  *)getTime:(NSDate *)time :(NSString *)s;
+(float)GetYearPort:(NSDate *)time :(NSString *)facN;


+(float)GetMonthConsum:(NSDate *)time :(NSString *)facN;


//  年累计耗用量  GetYearConsum
+(float)GetYearConsum:(NSDate *)time :(NSString *)facN;
// 获得  factoryState 实体  根据电厂名 和时间
+(TbFactoryState *)getStateBySql:(NSString *)facN :(NSDate *)time;


+(TbFactoryState *)getStateMode:(NSString *)factoryName :(NSString *)time;
@end
