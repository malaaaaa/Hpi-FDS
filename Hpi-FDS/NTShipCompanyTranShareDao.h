//
//  NTShipCompanyTranShareDao.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-23.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTShipCompanyTranShare.h"
#import "PubInfo.h"
#import <sqlite3.h>

@interface NTShipCompanyTranShareDao : NSObject
+(NSString  *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) initDb_tmpTable;
+(void)insert:(NTShipCompanyTranShare*) NTShipCompanyTranShare;
+(void)insert_tmpTable:(NTShipCompanyTranShare*) NTShipCompanyTranShare;

+(void) InsertByPortCode:(NSMutableArray *)portCode :(NSString *)startDate :(NSString *)endDate;

+(void) deleteAll;
+(void) deleteAll_tmpTable;
//根据航运公司ID，年份，月份得到唯一的市场份额对象
+(NTShipCompanyTranShare *) getTransShareByComid:(NSInteger)comid Year:(NSString *)year Month:(NSString *)month;
+(NTShipCompanyTranShare *) getTransShareByTag:(NSInteger)tag;
//更新点坐标
+(void) updateTransShareCoordinate:(NSInteger) tag setX:(NSInteger)x setY:(NSInteger)y;

@end
