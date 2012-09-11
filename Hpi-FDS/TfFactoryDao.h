//
//  TfFactoryDao.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TfFactory.h"

@interface TfFactoryDao : NSObject{
    
}
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) insert:(TfFactory*) tfFactory;
+(void) delete:(TfFactory*) tfFactory;
+(NSMutableArray *) getTfFactory:(NSString *)factoryCode;
+(NSMutableArray *) getTfFactoryBySql:(NSString *)sql;
+(void) deleteAll;




//获得  tffactory  数据实体 根据 电厂名
+(TfFactory *)getTfFactoryByName:(NSString *)factoryName;

@end
