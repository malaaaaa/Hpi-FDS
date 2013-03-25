//
//  AvgFactoryZXTimeDao.h
//  Hpi-FDS
//
//  Created by tang bin on 12-8-13.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <sqlite3.h>
#import "AvgFactoryZXTime.h"
@interface AvgFactoryZXTimeDao : NSObject


+(NSString *)dataFilePath;
+(void) openDataBase;

+(NSMutableArray *)getTimeTitleBySql1:(NSString *)sql1 :(NSString *)sql2;

+(NSMutableArray *)getTimeTitle1:(NSString *)startTime :(NSString *)endTime :(NSString *)factoryCate;

+(NSMutableArray *)getAvgFactoryDate:(NSString *)startTime :(NSString*)endTime :(NSString *)factoryCate :(NSMutableArray *)titleTime;
+(NSMutableArray *)getAvgFactoryDateBySql:(NSString *)sql1 :(NSString *)sql2    titleTimeCount:(NSInteger)count;


@end
