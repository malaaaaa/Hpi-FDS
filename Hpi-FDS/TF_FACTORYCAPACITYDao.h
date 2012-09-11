//
//  TF_FACTORYCAPACITYDao.h
//  Hpi-FDS
//
//  Created by tang bin on 12-8-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TF_FACTORYCAPACITY.h"


@interface TF_FACTORYCAPACITYDao : NSObject


+(NSString *)dataFilePath;
+(void) openDataBase;

+(void)initDb;

+(void)deleteAll;



//机组台数(台) 获取电厂机组运行信 GetUnits
+(NSString *)GetUnits:(NSString *)factoryName;




+(NSMutableArray *)GetCapaCityByName:(NSString *)factoryName;




@end
