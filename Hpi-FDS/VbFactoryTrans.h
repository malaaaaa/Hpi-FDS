//
//  VbFactoryTrans.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-6.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface VbFactoryTrans : NSObject
{
    NSString *FACTORYCODE;

    NSString *DISPATCHNO;
    NSInteger SHIPID;
    NSString *SHIPNAME;
    NSInteger TYPEID;
    NSString * TRADE;
    NSString *KEYVALUE;
    NSInteger SUPID;
    NSString *_STATECODE;
    NSString *_STATENAME;
    NSString    *_STAGECODE; //船舶状态
    NSInteger   COMID;
    NSString    *_STAGENAME; //船舶状态
    NSInteger elw;
    NSString *T_NOTE;
    NSString *F_NOTE;
    
    
    
    
    
    NSString *FACTORYNAME;
    NSInteger CONSUM;//日耗
    NSInteger STORAGE; //库存
    NSInteger   COMPARE; //较前日
    NSInteger   AVALIABLE;//可用天数
    NSInteger   MONTHIMP;//当月调进量
    NSInteger   YEARIMP;//年调进量
    NSString    *DESCRIPTION_;
    NSInteger   SHIPNUM;    //第一层中标示船舶运行情况用
  
    NSString *CAPACITYSUM;//装机容量
}
@property (nonatomic, retain) NSString *FACTORYCODE;

@property (nonatomic, retain) NSString *DISPATCHNO;
@property NSInteger SHIPID;
@property (nonatomic, retain) NSString *SHIPNAME;
@property NSInteger TYPEID;
@property (nonatomic, retain) NSString * TRADE;
@property (nonatomic, retain) NSString *KEYVALUE;
@property NSInteger SUPID;
@property NSInteger elw;
@property NSInteger COMID;
@property (nonatomic, retain) NSString *T_NOTE;
@property (nonatomic, retain) NSString *F_NOTE;
@property (nonatomic, retain) NSString *STAGECODE;
@property (nonatomic, retain) NSString *STAGENAME;
@property (nonatomic, retain) NSString *STATECODE;
@property (nonatomic, retain) NSString *STATENAME;





@property (nonatomic, retain) NSString *FACTORYNAME;
@property NSInteger CONSUM;
@property NSInteger STORAGE;
@property NSInteger COMPARE;
@property NSInteger AVALIABLE;
@property NSInteger MONTHIMP;
@property NSInteger YEARIMP;
@property (nonatomic, retain) NSString *DESCRIPTION;
@property NSInteger SHIPNUM;

@property (nonatomic, retain) NSString *CAPACITYSUM;


@end
