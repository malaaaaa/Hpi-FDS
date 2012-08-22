//
//  TfSupplierDao.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-18.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TfSupplier.h"

@interface TfSupplierDao : NSObject{
    
}
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) insert:(TfSupplier *) tfSupplier;
+(void) delete:(TfSupplier*) tfSupplier;
+(NSMutableArray *) getTfSupplier:(NSInteger)supid;
+(NSMutableArray *) getTfSupplier;
+(NSMutableArray *) getTfSupplierBySql:(NSString *)sql;
+(void) deleteAll;


@end
