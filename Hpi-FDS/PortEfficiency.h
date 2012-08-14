//
//  PortEfficiency.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-8.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PubInfo.h"



@interface PortEfficiency : NSObject{
    NSString *_factory;
    NSInteger _efficiency;
}
@property(nonatomic,copy) NSString *factory;
@property NSInteger efficiency;

@end

@interface PortEfficiencyDao : NSObject

+(NSString  *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) deleteAll;
+(void)insert:(PortEfficiency *) portEfficiency;
+(void) InsertByCompany:(NSMutableArray *)company
Schedule:(NSString *)schedule
Category:(NSString *)category
StartDate:(NSString *)startDate
                EndDate:(NSString *)endDate;
+(NSMutableArray *) getPortEfficiency;
+(BOOL) isNoData;

@end