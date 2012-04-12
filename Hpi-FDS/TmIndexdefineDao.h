//
//  TmIndexdefineDao.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TmIndexdefine.h"

@interface TmIndexdefineDao : NSObject{

}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(TmIndexdefine*) tmIndexdefine;
+(void)delete:(TmIndexdefine*) tmIndexdefine;
+(NSMutableArray *) getTmIndexdefine:(NSInteger)indexId;
+(NSMutableArray *) getTmIndexdefine;
+(NSMutableArray *) getTmIndexdefineBySql:(NSString *)sql;

@end
