//
//  TB_OFFLOADSHIPDao.h
//  Hpi-FDS
//
//  Created by tang bin on 12-9-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TB_OFFLOADSHIP.h"

#import <sqlite3.h>

@interface TB_OFFLOADSHIPDao : NSObject

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) deleteAll;



+(NSMutableArray *)SelectAllByFactoryCode:(NSString *)factoryName:(NSString *)time;



@end
