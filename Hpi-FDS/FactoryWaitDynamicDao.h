//
//  FactoryWaitDynamicDao.h
//  Hpi-FDS
//
//  Created by tang bin on 12-8-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <sqlite3.h>


@interface FactoryWaitDynamicDao : NSObject
+(NSString *)dataFilePath;
+(void) openDataBase;


+(NSMutableArray *)getMidDate:(NSDate *)stringTime :(NSString *)factoryName;

























@end
