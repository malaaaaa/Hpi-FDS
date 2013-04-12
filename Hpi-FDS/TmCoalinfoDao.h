//
//  TmCoalinfoDao.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TmCoalinfo.h"
#import "TmCoalinfoMore.h"
@interface TmCoalinfoDao : NSObject{
}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(TmCoalinfo*) tmCoalinfo;
+(void)delete:(TmCoalinfo*) tmCoalinfo;
+(NSMutableArray *) getTmCoalinfo:(NSInteger)infoId;
+(NSMutableArray *) getTmCoalinfo:(NSString *)portCode :(NSDate*)startDay :(NSDate *)endDay;
+(NSMutableArray *) getTmCoalinfoBySql:(NSString *)sql;
//+(TmCoalinfo *) getTmCoalinfoOne:(NSString *)portCode :(NSDate*)day;
+(void) deleteAll;
+(NSMutableArray *) getTmCoalinfoByPort:(NSString *)portCode startDay:(NSDate*)startDay Days:(NSInteger)days;
@end
