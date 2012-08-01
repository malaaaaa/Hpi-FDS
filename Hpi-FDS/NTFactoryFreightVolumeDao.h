//
//  NTFactoryFreightVolumeDao.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PubInfo.h"
#import <sqlite3.h>
#import "NTFactoryFreightVolume.h"
@interface NTFactoryFreightVolumeDao : NSObject
+(NSString  *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) initDb_tmpTable;
+(void)insert:(NTFactoryFreightVolume *) factoryFreightVolume;
+(void)insert_tmpTable:(NTFactoryFreightVolume *) factoryFreightVolume;
+(void) InsertByTrade:(NSString *)trade Type:(NSString *)type StartDate:(NSString *)startDate EndDate:(NSString *)endDate;
+(void) deleteAll;
+(void) deleteAll_tmpTable;
+(NSMutableArray *) getFactoryFromTmpNTFactoryFreightVolume;
+(NSMutableArray *) getTradeTimeFromTmpNTFactoryFreightVolume;
+(NSMutableArray *) getAllDataByTradeTime:(NSMutableArray *)tradetime Factory:(NSMutableArray *)factory;

@end
