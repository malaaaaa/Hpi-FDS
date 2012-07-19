//
//  TfShipCompanyDao.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-17.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TfShipCompany.h"

@interface TfShipCompanyDao : NSObject{
    
}
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) insert:(TfShipCompany *) tfShipCompany;
+(void) delete:(TfShipCompany*) tfShipCompany;
+(NSMutableArray *) getTfShipCompany:(NSInteger)comid;
+(NSMutableArray *) getTfShipCompany;
+(NSMutableArray *) getTfShipCompanyBySql:(NSString *)sql;

@end
