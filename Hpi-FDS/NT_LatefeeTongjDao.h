//
//  NT_LatefeeTongjDao.h
//  Hpi-FDS
//
//  Created by bin tang on 12-8-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <sqlite3.h>
#import "NT_LatefeeTongj.h"
@interface NT_LatefeeTongjDao : NSObject
+(NSString *)dataFilePath;
+(void) openDataBase;


+(NSMutableArray *) getNT_LatefeeTongj;

+(NSMutableArray *) getNT_LatefeeTongjBySql:(NSString *)sql1;

+(NSMutableArray *)getNT_LatefeeTongj:(NSString *)factoryCate:(NSString *)startTime:(NSString *)endTime;





//的到电厂

+(NSMutableArray *)getFactoryName:(NSString *)cate:(NSString *)startTime:(NSString *)endTime;

+(NSMutableArray *)getFactoryName:(NSString *)sql1;




//根据 电厂名  获得 滞期费和月份

+(NSMutableDictionary *)getMonthAndLatefee:(NSString *)cate:(NSString *)factoryName :(NSString *)startTime:(NSString *)endTime ;

+(NSMutableDictionary *)getMonthAndLatefee:(NSString *)sql1;

@end
