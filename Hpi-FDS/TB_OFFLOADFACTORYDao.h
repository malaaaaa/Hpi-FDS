//
//  TB_OFFLOADFACTORYDao.h
//  Hpi-FDS
//
//  Created by tang bin on 12-9-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TB_OFFLOADFACTORY.h"
#import <sqlite3.h>
@interface TB_OFFLOADFACTORYDao : NSObject



+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) deleteAll;

+(TB_OFFLOADFACTORY *)SelectFactoryByCode:(NSString *)factoryName :(NSString *)time;



@end
