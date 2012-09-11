//
//  TfShipDao.h
//  Hpi-FDS
//
//  Created by tang bin on 12-9-5.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <sqlite3.h>
#import "TfShip.h"
@interface TfShipDao : NSObject
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;

+(void)deleteAll;




+(NSString *)getShipName:(NSInteger)shipID;










@end
