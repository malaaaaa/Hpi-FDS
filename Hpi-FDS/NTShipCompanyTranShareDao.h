//
//  NTShipCompanyTranShareDao.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-23.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTShipCompanyTranShare.h"
#import "PubInfo.h"
#import <sqlite3.h>

@interface NTShipCompanyTranShareDao : NSObject
+(NSString  *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(NTShipCompanyTranShare*) NTShipCompanyTranShare;
+(void) deleteAll;
@end
