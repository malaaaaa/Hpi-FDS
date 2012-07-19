//
//  VbShiptransDao.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-4-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "VbShiptrans.h"

@interface VbShiptransDao : NSObject{

}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(VbShiptrans*) vbShiptrans;
+(void)delete:(VbShiptrans*) vbShiptrans;
+(NSMutableArray *) getVbShiptrans:(NSString *)dispatchNo;
+(NSMutableArray *) getVbShiptrans:(NSString *)shipCompany :(NSString *)shipName :(NSString *)portName :(NSString *)factoryName :(NSString *)stateName;
+(NSMutableArray *) getVbShiptransBySql:(NSString *)sql;
@end
