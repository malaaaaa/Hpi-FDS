//
//  TiListinfoDao.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-17.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TiListinfo.h"
@interface TiListinfoDao : NSObject{

}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(TiListinfo*) tiListinfo;
+(void)delete:(TiListinfo*) tiListinfo;
+(NSMutableArray *) getTiListinfo: (NSInteger)infoId;
+(NSMutableArray *) getTiListinfo :(NSInteger)columns :(NSInteger)rows;
+(NSMutableArray *) getTiListinfoBySql:(NSString *)sql;

@end
