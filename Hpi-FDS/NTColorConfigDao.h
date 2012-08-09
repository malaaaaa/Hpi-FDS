//
//  NTColorConfigDao.h
//  Hpi-FDS
//  颜色配置表
//  Created by 马 文培 on 12-7-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTColorConfig.h"
#import "PubInfo.h"
#import <sqlite3.h>


@interface NTColorConfigDao : NSObject
+(NSString  *) dataFilePath;
+(void) openDataBase;
//初始化颜色信息配置表
+(void) initDb;
+(NSMutableArray *) getNTColorConfigByType:(NSString *)typeid;
@end
