//
//  TfCoalTypeDao.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TfCoalType.h"

@interface TfCoalTypeDao : NSObject{
    
}
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) insert:(TfCoalType *) tfCoalType;
+(void) delete:(TfCoalType*) tfCoalType;
+(NSMutableArray *) getTfCoalType:(NSInteger)typeid;
+(NSMutableArray *) getTfCoalType;
+(NSMutableArray *) getTfCoalTypeBySql:(NSString *)sql;
+(void) deleteAll;


@end
