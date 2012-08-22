//
//  TH_ShipTransDao.h
//  Hpi-FDS
//
//  Created by bin tang on 12-7-19.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TH_ShipTrans.h"
#import <sqlite3.h>



@interface TH_ShipTransDao : NSObject

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;

+(void) insert:(TH_ShipTrans *) th_Shiptrans;
+(void) delete:(TH_ShipTrans *) th_Shiptrans;

+(NSMutableArray *) getTH_ShipTrans:(NSInteger)recid;

+(NSMutableArray *) getTH_ShipTrans;
//根据 搜索条件得到实体
+(NSMutableArray *) getTH_ShipTrans:(NSString *)portName:(NSString *)dateTime:(NSString *)state;

+(NSMutableArray *) getTH_ShipTransBySql:(NSString *)sql1;
+(void)deleteAll;

@end
