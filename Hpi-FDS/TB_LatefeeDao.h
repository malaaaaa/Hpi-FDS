//
//  TB_LatefeeDao.h
//  Hpi-FDS
//
//  Created by bin tang on 12-7-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "TB_Latefee.h"
#import  <sqlite3.h>
@interface TB_LatefeeDao : NSObject

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;

+(void) insert:(TB_Latefee *) tb_Latefee;
+(void) delete:(TB_Latefee *) tb_Latefee;

+(NSMutableArray *) getTB_LateFee:(NSString *)dispatchno;

+(NSMutableArray *) getTB_LateFee;
//根据 搜索条件得到实体
+(NSMutableArray *) getTB_LateFee:(NSString * )compoayId:(NSString *)shipId:(NSString *)factoryCode:(NSString *)Typeid:(NSString *)supid:(NSString *)startTime:(NSString *)endTime;

+(NSMutableArray *) getTB_LateFeeBySql:(NSString *)sql1;

+(void)deleteAll;











@end
