//
//  PubInfo.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//mawp 周二

#import <Foundation/Foundation.h>
#import "NSString+Verify.h"
#import "TgPort.h"
#import "TgFactory.h"
#import "TgShip.h"
#import "TsFileinfo.h"
#import "TmIndexinfo.h"
#import "TmIndexdefine.h"
#import "TmIndextype.h"
#import "VbShiptrans.h"
#import "VbTransplan.h"
#import "TmCoalinfo.h"
#import "TmShipinfo.h"
#import "TiListinfo.h"
#import "VbFactoryTrans.h"
#import "TfFactory.h"
#import "TbFactoryState.h"


#import "TgPortDao.h"
#import "TgFactoryDao.h"
#import "TgShipDao.h"
#import "TsFileinfoDao.h"
#import "TmIndexinfoDao.h"
#import "TmIndexdefineDao.h"
#import "TmIndextypeDao.h"
#import "VbShiptransDao.h"
#import "VbTransplanDao.h"
#import "TmCoalinfoDao.h"
#import "TmShipinfoDao.h"
#import "TiListinfoDao.h"
#import "VbFactoryTransDao.h"
#import "TfFactoryDao.h"
#import "TbFactoryStateDao.h"
#import "TfShipCompany.h"
#import "TfShipCompanyDao.h"
#import "TfSupplier.h"
#import "TfSupplierDao.h"
#import "TfCoalType.h"
#import "TfCoalTypeDao.h"
#import "TsShipStage.h"
#import "TsShipStageDao.h"
#import "NTShipCompanyTranShare.h"
#import "NTShipCompanyTranShareDao.h"
#import "NTColorConfig.h"
#import "NTColorConfigDao.h"

typedef enum{
    kPORT=0,
    kFACTORY,
    kSHIP,
    kChPORT,
    kChFACTORY,
    kChSHIP,
    kChCOM,
    kChSTAT,
    kPORTBUTTON,
    kSHIPCOMPANY,
    kSUPPLIER,
    kCOALTYPE,
    kKEYVALUE,
    kTRADE,
    kSHIPSTAGE,
    
    
    
    kshiptransStage
} CoordinateType;

#define All_PORT    @"全部港口"
#define All_FCTRY   @"全部电厂"
#define All_SHIP    @"全部船舶"
#define All_        @"全部"
#define kYES        @"1"
#define kNO         @"0"


@interface PubInfo : NSObject

+(void)initdata;
+(void)save;
+(NSString *)baseUrl;
+(NSString *)url;
+(NSString *)userInfoUrl;
+(NSString *)userName;
+(void)setUserName:(NSString*) theuserName;
+(NSString *)autoUpdate;
+(void)setAutoUpdate:(NSString*) update;
+(NSString *)updateTime;
+(void)setUpdateTime:(NSString*) time;
+(NSString *)deviceID;
+(NSString *)currTime;

//计算两个YYYYMM格式字符串之间月份之差
+(NSInteger)getMonthDifference:(NSString *)startDate :(NSString *)endDate;

@end
