//
//  NTLateFeeDMFX.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-9-6.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PubInfo.h"

@interface NTLateFeeDMFX : NSObject{
    NSString *_factory;
    double _latefee;// 滞期费分析量 费用/吨(元)
}
@property(nonatomic,copy) NSString *factory;
@property double latefee;
@end

@interface NTLateFeeDMFXDao : NSObject

+(NSString  *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) deleteAll;
+(void)insert:(NTLateFeeDMFX *) ntLateFeeDMFX;
+(void) InsertByCompany:(NSMutableArray *)company
              StartDate:(NSString *)startDate
                EndDate:(NSString *)endDate;
+(NSMutableArray *) getNTLateFeeDMFX;
+(BOOL) isNoData;
+(NSInteger) getFactoryCount;


@end