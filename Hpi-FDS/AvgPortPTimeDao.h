//
//  AvgPortPTimeDao.h
//  Hpi-FDS
//
//  Created by bin tang on 12-8-8.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <sqlite3.h>
@interface AvgPortPTimeDao : NSObject

+(NSString *)dataFilePath;
+(void) openDataBase;

//要根据时间去查  港口名
+(NSMutableArray *)getPortName:(NSString *)sql1;
+(NSMutableArray *)getPortName:(NSString *)startTime:(NSString *)endTime ;


+(NSMutableArray *)getTime:(NSString *)startTime:(NSString *)endTime;





//
+(NSMutableDictionary *)getTimeAndAvgTime:(NSString *)sql1;
//根据港口名获得  时间和平均时间
+(NSMutableDictionary *)getTimeAndAvgTime:(NSString *)portName:(NSString *)startTime:(NSString *)endTime ;






@end
