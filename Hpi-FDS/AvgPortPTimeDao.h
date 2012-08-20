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



+(NSMutableArray *)getTime:(NSString *)startTime:(NSString *)endTime;

+(NSMutableArray *)getAvgPortDate:(NSString *)startTime:(NSString *)endTime:(NSMutableArray *)titleTime;


+(NSMutableArray *)getAvgPortDateBySql:(NSString *)sql1:(NSString *)sql2 :(NSInteger)count;

@end
