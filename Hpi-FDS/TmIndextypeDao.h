//
//  TmIndextypeDao.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TmIndextype.h"

@interface TmIndextypeDao : NSObject{

}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(TmIndextype*) tmIndextype;
+(void)delete:(TmIndextype*) tmIndextype;
+(NSMutableArray *) getTmIndextype:(NSInteger)typeId;
+(NSMutableArray *) getTmIndextype;
+(NSMutableArray *) getTmIndextypeBySql:(NSString *)sql;

@end
