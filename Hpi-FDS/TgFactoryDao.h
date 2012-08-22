//
//  TgFactoryDao.h
//  Hfds
//
//  Created by zcx on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TgFactory.h"

@interface TgFactoryDao : NSObject{
    
}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) insert:(TgFactory*) tgFactory;
+(void) delete:(TgFactory*) tgFactory;
+(NSMutableArray *) getTgFactory:(NSString *)portCode;
+(NSMutableArray *) getTgFactory;
+(NSMutableArray *) getTgFactoryBySql:(NSString *)sql;
+(void) deleteAll;

@end
