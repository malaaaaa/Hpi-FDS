//
//  TmShipinfoDao.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TmShipinfo.h"
#import "TmShipinfoMore.h"
@interface TmShipinfoDao : NSObject{

}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(TmShipinfo*) tmShipinfo;
+(void)delete:(TmShipinfo*) tmShipinfo;
+(NSMutableArray *) getTmShipinfo:(NSInteger)infoId;
+(NSMutableArray *) getTmShipinfo:(NSString *)portCode :(NSDate*)startDay :(NSDate *)endDay;
+(NSMutableArray *) getTmShipinfoBySql:(NSString *)sql;
+(TmShipinfo *) getTmShipinfoOne:(NSString *)portCode :(NSDate*)day;
+(void) deleteAll;
+(NSMutableArray *) getTmShipinfoByPort:(NSString *)portCode startDay:(NSDate*)startDay Days:(NSInteger)days;


+(int) getZGShipAVG:(NSString *)portCode startDay:(NSDate*)startDay Days:(NSInteger)days ColumName:(NSString *)name;
@end
