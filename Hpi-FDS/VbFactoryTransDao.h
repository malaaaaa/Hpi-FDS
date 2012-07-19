//
//  VbFactoryTransDao.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-6.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "VbFactoryTrans.h"

@interface VbFactoryTransDao : NSObject{
    
}
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(VbFactoryTrans*) vbFactoryTrans;
+(void)delete:(VbFactoryTrans*) vbFactoryTrans;
+(void) deleteAll;

+(NSMutableArray *) getVbFactoryTransState:(NSMutableArray *)factory 
                                          :(NSDate *)date 
                                          :(NSMutableArray *)shipCompany 
                                          :(NSMutableArray *)ship 
                                          :(NSMutableArray *)supplier 
                                          :(NSMutableArray *)coalType 
                                          :(NSString *)keyValue 
                                          :(NSString *)trade 
                                          :(NSMutableArray *)shipStage;

+(NSMutableArray *) getVbFactoryTransDetail:(NSString *)FactoryCode 
                                           :(NSMutableArray *)shipCompany 
                                           :(NSMutableArray *)ship 
                                           :(NSMutableArray *)supplier 
                                           :(NSMutableArray *)coalType 
                                           :(NSString *)keyValue 
                                           :(NSString *)trade
                                           :(NSMutableArray *)shipStage;

@end
