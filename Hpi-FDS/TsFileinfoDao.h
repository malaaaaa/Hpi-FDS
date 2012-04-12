//
//  TsFileinfoDao.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TsFileinfo.h"

@interface TsFileinfoDao : NSObject{
    
}

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void)insert:(TsFileinfo*) tsFileinfo;
+(void)delete:(TsFileinfo*) tsFileinfo;
+(NSMutableArray *) getTsFileinfo:(NSInteger)fileId;
+(NSMutableArray *) getTsFileinfo;
+(NSMutableArray *) getTsFileinfoBySql:(NSString *)sql;
+(BOOL)tsFileIsDownload:(NSInteger)fileId;
+(void)deleteNotDownload;
+(void) updateTsFileXzbz:(NSInteger) fileId :(NSString *)xzbz;
+(void) updatezbz;
+(BOOL)tsFileHasDownload;
+(void) updateDown;
@end
