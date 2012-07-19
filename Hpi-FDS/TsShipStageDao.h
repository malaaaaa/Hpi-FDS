//
//  TsShipStageDao.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TsShipStage.h"

@interface TsShipStageDao : NSObject{
    
}
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) insert:(TsShipStage *) tsShipStage;
+(void) delete:(TsShipStage*) tsShipStage;
+(NSMutableArray *) getTsShipStage:(NSString *)stage;
+(NSMutableArray *) getTsShipStage;
+(NSMutableArray *) getTsShipStageBySql:(NSString *)sql;

@end
