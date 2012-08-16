//
//  AvgFactoryZXTimeDao.h
//  Hpi-FDS
//
//  Created by tang bin on 12-8-13.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <sqlite3.h>
@interface AvgFactoryZXTimeDao : NSObject


+(NSString *)dataFilePath;
+(void) openDataBase;


//根据   条件（时间  ，分类）   去查   给条件下的所有    电厂名
+(NSMutableArray *)getFactoryName:(NSString *)startTime:(NSString *)endTime:(NSString *)factoryCate;
+(NSMutableArray *)getFactoryNameBySql:(NSString *)sql1:(NSString *)sql2;


//根据条件  去查   存在的   时间字符串
+(NSMutableArray *)getTimeTitleBySql:(NSString *)sql1:(NSString *)sql2;

//根据条件  去查   存在的   时间字符串
+(NSMutableArray *)getTimeTitle:(NSString *)startTime:(NSString *)endTime:(NSString *)factoryCate;





//根据 条件  去查   该条件下的  指定电厂  名的所有数据

+(NSMutableDictionary *)getFactoryDate:(NSString *)startTime:(NSString *)endTime:(NSString *)factoryCate:(NSString *)factoryName;

+(NSMutableDictionary *)getFactoryDateBySql:(NSString *)sql1:(NSString *)sql2;













@end
