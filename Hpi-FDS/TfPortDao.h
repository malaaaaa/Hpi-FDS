//
//  TfPortDao.h
//  Hpi-FDS
//
//  Created by bin tang on 12-8-7.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <sqlite3.h>
#import "TfPort.h"
@interface TfPortDao : NSObject

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) insert:(TfPort *) tfprot;
+(void) delete:(TfPort *) tfprot;
+(void)deleteAll;
+(NSString *)getPortName:(NSString *)portcode;
+(NSMutableArray *) getTfPort;
+(NSMutableArray *) getTfPortBySql:(NSString *)sql1;

@end
