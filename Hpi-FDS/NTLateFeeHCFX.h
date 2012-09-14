//
//  NTLateFeeHCFX.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-9-13.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PubInfo.h"

@interface NTLateFeeHCFX : NSObject{
    NSString *_factory;
    NSInteger _hc; //航次
    double _yl; //运量
    double _latefee;// 滞期费
}
@property(nonatomic,copy) NSString *factory;
@property NSInteger hc;
@property double yl;
@property double latefee;


@end

@interface NTLateFeeHCFXDao : NSObject

+(NSString  *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) deleteAll;
+(void)insert:(NTLateFeeHCFX *) ntLateFeeHCFX;
+(void) InsertByCompany:(NSMutableArray *)company
              StartDate:(NSString *)startDate
                EndDate:(NSString *)endDate;
//单独获得滞期费数据
+(NSMutableArray *) getNTLateFeeHCFX_LATEFEE;
//单独获得航次数据
+(NSMutableArray *) getNTLateFeeHCFX_HC;
//单独获得运量数据
+(NSMutableArray *) getNTLateFeeHCFX_YL;

+(BOOL) isNoData_LATEFEE;
+(NSInteger) getFactoryCount;


@end