//
//  TH_SHIPTRANS_ORIDAO.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-10-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TH_SHIPTRANS_ORI.h"
#import <sqlite3.h>

@interface TH_SHIPTRANS_ORIDAO : NSObject
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)delete:(TH_SHIPTRANS_ORI *)th_Shiptrans;

+(NSMutableArray *) getTH_ShipTransBySql:(NSString *)sql1;
+(void)deleteAll;
+(NSMutableArray *) getThShiptrans:(NSString *)shipCompany :(NSString *)shipName :(NSString *)portName :(NSString *)factoryName :(NSString *)stageName :(NSDate *)date;
+(NSMutableArray *) getVbFactoryTransBySql:(NSString *)querySql;
+(NSMutableArray *) getVbFactoryTransDetail:(NSString *)FactoryCode
                                           :(NSMutableArray *)shipCompany
                                           :(NSMutableArray *)ship
                                           :(NSMutableArray *)supplier
                                           :(NSMutableArray *)coalType
                                           :(NSString *)keyValue
                                           :(NSString *)trade
                                           :(NSMutableArray *)shipStage
                                           :(NSDate *)date;
@end
