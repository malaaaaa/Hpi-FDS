//
//  TbFactoryStateDao.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TbFactoryState.h"
@interface TbFactoryStateDao : NSObject{
    
}
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) insert:(TbFactoryState*) tbFactoryState;
+(void) delete:(TbFactoryState*) tbFactoryState;
+(NSMutableArray *) getTbFactoryState:(NSString *)factoryCode;
+(NSMutableArray *) getTbFactoryStateBySql:(NSString *)sql;
@end
