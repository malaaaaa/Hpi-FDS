//
//  NTZxgsjtj.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-9-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PubInfo.h"

@interface NTZxgsjtj : NSObject
{
    NSString *_factory;
    double _zg; //装港时间 单位 天/百万吨
    double _xg; //卸港时间 单位 天/百万吨
    double _lt; //合计时间 单位 天/百万吨
    double _lw; //运量 单位 天/百万吨
}
@property(nonatomic,copy) NSString *factory;
@property double zg;
@property double xg;
@property double lt;
@property double lw;


@end

@interface NTZxgsjtjDao : NSObject

+(NSString  *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) deleteAll;
+(void)insert:(NTZxgsjtj *) ntZxgsjtj;
+(void) InsertByCompany:(NSMutableArray *)company
               Schedule:(NSString *)schedule
               Category:(NSString *)category
              StartDate:(NSString *)startDate
                EndDate:(NSString *)endDate;
//单独获得装港数据
+(NSMutableArray *) getNTZxgsjtj_ZG;
//单独获得卸港数据
+(NSMutableArray *) getNTZxgsjtj_XG;
//单独获得合计数据
+(NSMutableArray *) getNTZxgsjtj_LT;

+(BOOL) isNoData_ZG;
+(BOOL) isNoData_XG;
+(BOOL) isNoData_LT;

+(NSInteger) getFactoryCount;


@end