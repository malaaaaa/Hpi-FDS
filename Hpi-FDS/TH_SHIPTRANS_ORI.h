//
//  TH_SHIPTRANS_ORI.h
//  Hpi-FDS
//  原始TH_SHIPTRANS实体数据，（区别于TH_SHIPTRANS,这是调度日志使用，经过VB_TH_SHIPTRANS传输过来的）
//  Created by 馬文培 on 12-10-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TH_SHIPTRANS_ORI : NSObject
{
    NSInteger _RECID;
    NSString *_RECORDDATE;
    NSString *_DISPATCHNO;
    NSInteger _SHIPCOMPANYID;
    NSString *_SHIPCOMPANY;
    NSInteger _SHIPID;
    NSString *_SHIPNAME;
    NSString *_TRIPNO;
    NSString *_FACTORYCODE;
    NSString *_FACTORYNAME;
    NSString *_PORTCODE;
    NSString *_PORTNAME;
    NSInteger _SUPID;
    NSString *_SUPPLIER;
    NSInteger _TYPEID;
    NSString *_COALTYPE;
    NSString *_KEYVALUE;
    NSString *_KEYNAME;
    NSString *_TRADE;
    NSString *_TRADENAME;
    NSString *_STAGE;
    NSString *_STAGENAME;
    NSString *_STATECODE;
    NSString *_STATENAME;
    NSInteger _LW;
    NSInteger _HEATVALUE;
    NSString *_P_ANCHORAGETIME;
    NSString *_P_HANDLE;
    NSString *_P_ARRIVALTIME;
    NSString *_P_DEPARTTIME;
    NSString *_P_NOTE;
    NSString *_T_NOTE;
    NSString *_F_ANCHORAGETIME;
    NSString *_F_ARRIVALTIME;
    NSString *_F_DEPARTTIME;
    NSString *_F_NOTE;
    NSString *_LATEFEE;
    NSInteger _OFFEFFICIENCY;
    NSString *_SCHEDULE;
    NSString *_PLANTYPE;
    NSString *_PLANCODE;
    NSString *_LAYCANSTART;
    NSString *_LAYCANSTOP;
    NSString *_RECIEPT;
    NSString *_SHIPSHIFT;
    NSString *_F_FINISH;
}

@property NSInteger RECID;
@property(nonatomic ,retain) NSString * RECORDDATE;
@property(nonatomic ,retain) NSString * DISPATCHNO;
@property NSInteger SHIPCOMPANYID;
@property(nonatomic ,retain) NSString * SHIPCOMPANY;
@property NSInteger SHIPID;
@property(nonatomic ,retain) NSString * SHIPNAME;
@property(nonatomic ,retain) NSString * TRIPNO;
@property(nonatomic ,retain) NSString * FACTORYCODE;
@property(nonatomic ,retain) NSString * FACTORYNAME;
@property(nonatomic ,retain) NSString * PORTCODE;
@property(nonatomic ,retain) NSString * PORTNAME;
@property NSInteger SUPID;
@property(nonatomic ,retain) NSString * SUPPLIER;
@property NSInteger TYPEID;
@property(nonatomic ,retain) NSString * COALTYPE;
@property(nonatomic ,retain) NSString * KEYVALUE;
@property(nonatomic ,retain) NSString * KEYNAME;
@property(nonatomic ,retain) NSString * TRADE;
@property(nonatomic ,retain) NSString * TRADENAME;
@property(nonatomic ,retain) NSString * STAGE;
@property(nonatomic ,retain) NSString * STAGENAME;
@property(nonatomic ,retain) NSString * STATECODE;
@property(nonatomic ,retain) NSString * STATENAME;
@property NSInteger LW;
@property NSInteger HEATVALUE;
@property(nonatomic ,retain) NSString * P_ANCHORAGETIME;
@property(nonatomic ,retain) NSString * P_HANDLE;
@property(nonatomic ,retain) NSString * P_ARRIVALTIME;
@property(nonatomic ,retain) NSString * P_DEPARTTIME;
@property(nonatomic ,retain) NSString * P_NOTE;
@property(nonatomic ,retain) NSString * T_NOTE;
@property(nonatomic ,retain) NSString * F_ANCHORAGETIME;
@property(nonatomic ,retain) NSString * F_ARRIVALTIME;
@property(nonatomic ,retain) NSString * F_DEPARTTIME;
@property(nonatomic ,retain) NSString * F_NOTE;
@property(nonatomic ,retain) NSString * LATEFEE;
@property NSInteger OFFEFFICIENCY;
@property(nonatomic ,retain) NSString * SCHEDULE;
@property(nonatomic ,retain) NSString * PLANTYPE;
@property(nonatomic ,retain) NSString * PLANCODE;
@property(nonatomic ,retain) NSString * LAYCANSTART;
@property(nonatomic ,retain) NSString * LAYCANSTOP;
@property(nonatomic ,retain) NSString * RECIEPT;
@property(nonatomic ,retain) NSString * SHIPSHIFT;
@property(nonatomic ,retain) NSString * F_FINISH;
@end
