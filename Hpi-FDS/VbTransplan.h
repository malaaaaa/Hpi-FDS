//
//  VbTransplan.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-3.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface VbTransplan : NSObject{
    NSString  *planCode;            //计划号
    NSString  *planMonth;           //计划月份
    NSInteger shipID;               //船舶ID
    NSString  *shipName;            //船名1
    NSString  *factoryCode;         //电厂编码
    NSString  *factoryName;         //电厂名称1
    NSString  *portCode;            //港口编号
    NSString  *portName;            //港口名称1
    NSString  *tripNo;              //航次
    NSString  *eTap;                //预抵装港时间
    NSString  *eTaf;                //预抵卸港时间
    double eLw;                  //预计载煤量
    NSInteger supID;                //供货方ID
    NSString  *supplier;            //供货方1
    NSInteger typeID;               //煤种ID
    NSString  *coalType;            //煤种1
    NSString  *keyValue;            //性质
    NSString  *keyName;             //性质名称1
    NSString  *schedule;            //是否班轮
    NSString  *description;         //备注
    NSInteger serialNo;            //顺序号
    NSString  *facSort;             //电厂序号1
    double    heatvalue;//热值
    double   sulfur;//硫分
    
}

@property (nonatomic, retain) NSString  *planCode;
@property (nonatomic, retain) NSString  *planMonth;
@property (nonatomic, retain) NSString  *shipName;
@property (nonatomic, retain) NSString  *factoryCode;
@property (nonatomic, retain) NSString  *factoryName;
@property (nonatomic, retain) NSString  *portCode; 
@property (nonatomic, retain) NSString  *portName; 
@property (nonatomic, retain) NSString  *tripNo; 
@property (nonatomic, retain) NSString  *eTap; 
@property (nonatomic, retain) NSString  *eTaf;
@property (nonatomic, retain) NSString  *supplier;
@property (nonatomic, retain) NSString  *coalType;
@property (nonatomic, retain) NSString  *keyValue;
@property (nonatomic, retain) NSString  *keyName; 
@property (nonatomic, retain) NSString  *schedule;
@property (nonatomic, retain) NSString  *description;

@property (nonatomic, retain) NSString  *facSort;
@property NSInteger shipID;
@property double eLw;
@property NSInteger supID;
@property NSInteger typeID;
@property  double heatvalue;
@property  double  sulfur;
@property NSInteger serialNo;
@end
