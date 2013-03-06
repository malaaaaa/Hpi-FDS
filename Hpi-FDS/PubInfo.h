//
//  PubInfo.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.

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
#import "NTFactoryFreightVolume.h"
#import "NTFactoryFreightVolumeDao.h"
#import "PortEfficiency.h"
#import "TH_ShipTrans.h"
#import "TH_ShipTransDao.h"
#import "NTLateFeeDMFX.h"
#import "NTLateFeeHCFX.h"
#import "NTZxgsjtj.h"
#import "VB_LatefeeDao.h"
#import "TB_LatefeeDao.h"
#import "TfPortDao.h"
#import "TfShipDao.h"
#import "TH_SHIPTRANS_ORIDAO.h"
#import "PortBehaviour.h"

static NSString *version = @"1.1";
typedef enum{
    kPORT=0, //TG_PORT
    kFACTORY,
    kSHIP,
    kChPORT,
    kChFACTORY,
    kChFACTORY_Latefee,
    kChSHIP,
    kchship_Latefee,
    kChCOM,
    kChCOM_Latefee,
    kChSTAT,
    kPORTBUTTON,
    kSHIPCOMPANY,
    
    kCOALTYPE,
    kCOALTYPE_Latefee,
    kTypeValue,//重点非重点
    kKEYVALUE,
    kTRADE,
    kSHIPSTAGE,
    kSUPPLIER,//14
    kSUPPLIER_Latefee,
    kshiptransStage,//15
    kfactoryCate,
    kTYPE, //电厂类型
    kSCHEDULE, //班轮
    kPORT_F //TF_PORT
} CoordinateType;


//数据查询菜单
typedef enum{
     kMenuDCDTCX=0, //电厂动态查询
     kMenuSSCBCX, //实时船舶查询
    // kMenuFactoryWaitState,//电厂靠泊动态
     kMenuCYJH, //船运计划
   // kDataQueryMenu_MAX,//最大数量

} DataQueryMenu_Select;


typedef enum{
    kMenuHYGSFETJ=0, //航运公司份额统计
    kMenuDCYLYLTJ, //电厂运力运量统计
    kMenuZXGXLTJ, //装卸港效率统计
//    kMenuDDRZCX, //调度日志查询
    kMenuGKMJZGSJ, //港口平均装港时间统计
    kMenuFcAvgZXTime,//电厂装卸港时间统计
    kMenuZXGSJTJ,//装卸港时间统计
    kMenuTransPlanimplment,//航运计划执行情况     
    
    
}DataQueryMenu_Tj;//查询统计
typedef enum{ 
    kMenuZQFMXCX=0, //滞期费明细查询
    kMenuZQFTJ, //滞期费统计
    kMenuZQFDMFX,//滞期费吨煤分析
    kMenuZQFHCFX,//滞期费航次分析
    
}DataQueryMenu_Latefee;//滞期费

typedef enum{ 
    kMenuSelect=0,//实时查询
    kMenuTJ,//查询统计
    kMenuLatefee,//滞期费
} DataQueryMenu_Section;


#define All_PORT    @"全部港口"
#define All_FCTRY   @"全部电厂"
#define All_SHIP    @"全部船舶"
#define All_        @"全部"
#define kYES        @"1"
#define kNO         @"0"
#define ONLINE_SHIP    @"在线船舶"
#define OFFLINE_SHIP    @"离线船舶"
#define UYES    @"1"  //是否 存在该设备号
#define UNO     @"0"


@interface PubInfo : NSObject



+(void)initdata;
+(void)save;
+(NSString *)baseUrl;
+(NSString *)url;
+(NSString *)userInfoUrl;

+(NSString *)userName;
+(void)setUserName:(NSString*) theuserName;


+(NSString *)isSucess;
+(void)setIsSucess:(NSString*) theissucess;

+(void)setHostName:(NSString*) newHostName;
+(NSString *)hostName;
+(void)setPort:(NSString*) newPort;
+(NSString *)port;


+(NSString *)autoUpdate;
+(void)setAutoUpdate:(NSString*) update;
+(NSString *)updateTime;
+(void)setUpdateTime:(NSString*) time;
+(NSString *)mmpUpdateTime;
+(void)setMmpUpdateTime:(NSString*) time;
+(NSString *)reportUpdateTime;
+(void)setReportUpdateTime:(NSString*) time;
+(NSString *)deviceID;
+(NSString *)currTime;

/*!
 @method +(BOOL)checkDeviceRegisterInfo;
 @author 马文培
 @abstract 监测该设备是否注册成功
 @param 参数说明
 @result 返回结果
 */
+(BOOL)checkDeviceRegisterInfo;
/*!
 @method +(BOOL)checkDeviceVerificationInfo;
 @author 马文培
 @abstract 监测该设备是否登陆验证成功
 @param 参数说明
 @result 返回结果
 */
+(BOOL)checkDeviceVerificationInfo;

//计算两个YYYYMM格式字符串之间月份之差
/*!
 @method +(NSInteger)getMonthDifference:(NSString *)startDate :(NSString *)endDate;
 @author 马文培
 @abstract 计算两个YYYYMM格式字符串之间月份之差
 @param startDate 开始时间 endDate 结束时间
 @result 返回整型的月份
 */
+(NSInteger)getMonthDifference:(NSString *)startDate :(NSString *)endDate;




//计算两个 时间段[%d天%d小时%d分钟]  [%d天%d小时%d分钟]的和       返回[%d天%d小时%d分钟]字符串      string1/string2  [days,@"days",hours,@"hours",minutes,@"minutes"]  
+(NSString *)getTotalTime:(NSMutableDictionary *)string1:(NSMutableDictionary *)string2 ;


//从数据库时间（string）里格式化 字符串时间   返回formateStr @"yyyy/MM/dd"格式字符串  或  “未知”    
+(NSString *)formaDateTime:(NSString *)string  FormateString:(NSString *)formateStr;


//计算两个  string1(yyyy-MM-dd HH:mm:ss) 和string2(yyyy-MM-dd HH:mm:ss)做差    时间之间的时间段 返回 [days,@"days",hours,@"hours",minutes,@"minutes"]字典 如果有一个时间为“未知”   则返回 [0,@"days",0,@"hours",0,@"minutes"]

+(NSMutableDictionary *)formatInfoDate1:(NSString *)string1 :(NSString *)string2;



//计算两个  string1(yyyy-MM-dd HH:mm:ss) 和string2(yyyy-MM-dd HH:mm:ss)    时间之间的时间段 返回 %d天%d小时%d分钟  如果有一个时间为“未知”   则返回 0天0小时0分钟
+(NSString *)formatInfoDate  :(NSString *)string1 :(NSString *)string2;

//判断邮箱地址是否合法
+ (BOOL) validateEmail: (NSString *) candidate;

@end
