//
//  VB_LatefeeDao.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-9-27.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "VB_Latefee.h"
#import  <sqlite3.h>
@interface VB_LatefeeDao : NSObject
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;

+(void) insert:(VB_Latefee *) vb_Latefee;
+(void) delete:(VB_Latefee *) vb_Latefee;

+(NSMutableArray *) getVB_LateFee:(NSString *)dispatchno;

+(NSMutableArray *) getVB_LateFee;
//根据 搜索条件得到实体
+(NSMutableArray *) getVB_LateFee:(NSString * )compoayId:(NSString *)shipId:(NSString *)factoryCode:(NSString *)Typeid:(NSString *)supid:(NSString *)startTime:(NSString *)endTime;

+(NSMutableArray *) getVB_LateFeeBySql:(NSString *)sql1;

+(void)deleteAll;

@end
