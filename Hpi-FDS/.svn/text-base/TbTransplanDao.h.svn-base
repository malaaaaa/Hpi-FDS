//
//  TbTransplanDao.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-25.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TbTransplan.h"

@interface TbTransplanDao : NSObject {
   
}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(TbTransplan*) tbTransplan;
+(void)delete:(TbTransplan*) tbTransplan;
+(NSMutableArray *) getTbTransplan:(NSString *)planCode;
+(NSMutableArray *) getTbTransplan;
+(NSMutableArray *) getTbTransplanBySql:(NSString *)sql;

@end
