//
//  TgPortDao.h
//  Hfds
//
//  Created by zcx on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TgPort.h"

@interface TgPortDao : NSObject{
    
}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(TgPort*) tgPort;
+(void)delete:(TgPort*) tgPort;
+(NSMutableArray *) getTgPort:(NSString *)portCode;
+(NSMutableArray *) getTgPortByPortName:(NSString *)portName;
+(NSMutableArray *) getTgPort;
+(NSMutableArray *) getTgPortBySql:(NSString *)sql;
+(void) deleteAll;

@end
