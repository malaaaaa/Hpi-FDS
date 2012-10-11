//
//  VbTransplanDao.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-3.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "VbTransplan.h"
@interface VbTransplanDao : NSObject{
}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(VbTransplan*) vbTransplan;
+(void)delete:(VbTransplan*) vbTransplan;
+(NSMutableArray *) getVbTransplan:(NSString *)planCode;
+(NSMutableArray *) getVbTransplan;
+(NSMutableArray *) getVbTransplan:(NSString *)shipCompany :(NSString *)shipName :(NSString *)portName :(NSString *)coalType:(NSString *)factoryName:(NSString *)dateTime:(NSString *)planCode;
+(NSMutableArray *) getVbTransplanBySql:(NSString *)sql;
+(void) deleteAll;
+(NSMutableArray *) getVbTransplanByTripNO:(NSString *)tripNO ShipID:(NSInteger)shipID;
@end
