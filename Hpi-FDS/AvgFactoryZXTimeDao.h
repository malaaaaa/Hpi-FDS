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

+(void)initDb;


//创建临时表


+(void)insert:(AvgFactoryZXTime *)AvgF;

+(void)delete;

+(NSMutableArray *)getNT_AvgFactoryZXTime:(NSString *)startTime:(NSString *)endTime:(NSString *)FactoryCate
;
+(NSMutableArray *)getNT_AvgFactoryZXTimeBySql:(NSString *)sql;




+(NSMutableArray *)getTimeTitleBySql1:(NSString *)sql1:(NSString *)sql2;


+(NSMutableArray *)getTimeTitle1:(NSString *)startTime:(NSString *)endTime:(NSString *)factoryCate;





//根据   条件（时间  ，分类）   去查   给条件下的所有    电厂名
+(NSMutableArray *)getFactoryName:(NSString *)startTime:(NSString *)endTime;
+(NSMutableArray *)getFactoryNameBySql:(NSString *)sql1;


//根据条件  去查   存在的   时间字符串
+(NSMutableArray *)getTimeTitleBySql:(NSString *)sql1;

//根据条件  去查   存在的   时间字符串
+(NSMutableArray *)getTimeTitle:(NSString *)startTime:(NSString *)endTime;





//根据 条件  去查   该条件下的  指定电厂  名的所有数据

+(NSMutableDictionary *)getFactoryDate:(NSString *)startTime:(NSString *)endTime:(NSString *)factoryName;

+(NSMutableDictionary *)getFactoryDateBySql:(NSString *)sql1;













@end
