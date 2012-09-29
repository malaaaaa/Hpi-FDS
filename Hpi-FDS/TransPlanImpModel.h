//
//  TransPlanImpModel.h
//  Hpi-FDS
//
//  Created by tang bin on 12-9-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransPlanImpModel : NSObject
{
    //船舶动态
    NSString *S_PLANMONTH;
    NSInteger S_SHIPID;
    NSString *S_SHIPNAME;
    NSString *S_FACTORYCODE;
    NSString *S_FACTORYNAME;
    NSString *S_TRIPNO;
    NSString *S_PORTCODE;
    NSString *S_PORTNAME;
    NSString *S_ARRIVETIME;
    NSString *S_LEAVETIME;
    NSString *S_COALTYPE;
    NSString *S_SUPPLIER;
    NSString *S_KEYNAME;

    double S_LW;
    NSString *S_PLANTYPE;
    NSString *S_STAGE;
    NSString *   S_HEATVALUE;  
    NSString *   S_SULFUR;
    
    //航运计划
    NSString *T_PLANMONTH;
    NSInteger  T_SHIPID;
 NSString *   T_SHIPNAME;
   NSString * T_FACTORYCODE;
 NSString *   T_FACTORYNAME;
 NSString *   T_TRIPNO;
  NSString * T_PORTCODE;
   NSString * T_PORTNAME;
 NSString *   T_ARRIVETIME;
  NSString *  T_LEAVETIME;
 NSString *   T_COALTYPE;
 NSString *   T_SUPPLIER;
 NSString *   T_KEYNAME;
double    T_ELW;
 NSString *   T_DESCRIPTION;
 NSString *   T_HEATVALUE;
  NSString *   T_SULFUR;
    //实际航运与航运计划
    /// 航运月份
    NSInteger ST_IntPlanMonth;
    /// 航运月份
    NSString *  ST_PLANMONTH;
    /// 船舶ID
    NSInteger ST_SHIPID;
    /// 船名
    NSString *  ST_SHIPNAME;
    /// 电厂编号
    NSString *  ST_FACTORYCODE;
    /// 电厂名称
     NSString * ST_FACTORYNAME;
    /// 航次
   NSString * ST_TRIPNO;
    /// 港口编号
   NSString * ST_PORTCODE;
    /// 港口名称
    NSString * ST_PORTNAME;
    /// 到港时间
    NSString * ST_ARRIVETIME;
    /// 离港时间
    NSString * ST_LEAVETIME;
    /// 煤
     NSString * ST_COALTYPE;
    /// 供货方
    NSString * ST_SUPPLIER;
    /// 贸易性质
    NSString * ST_KEYNAME;
    /// 预计载煤量
    double ST_ELW;
    /// 电厂排序
    NSInteger ST_SORT;
    /// 供货方ID
   NSInteger ST_SUPID;
    /// 煤种ID
    NSInteger ST_TYPEID;
    /// 性质ID
    NSInteger ST_KEYVALUE;

    
}

//船舶动态
@property(nonatomic,retain)  NSString *S_PLANMONTH;
@property  NSInteger S_SHIPID;
@property(nonatomic,retain)NSString *S_SHIPNAME;
@property(nonatomic,retain)NSString *S_FACTORYCODE;
@property(nonatomic,retain)NSString *S_FACTORYNAME;

@property(nonatomic,retain)NSString *S_TRIPNO;
@property(nonatomic,retain)NSString *S_PORTCODE;
@property(nonatomic,retain)NSString *S_PORTNAME;
@property(nonatomic,retain)NSString *S_ARRIVETIME;
@property(nonatomic,retain)NSString *S_LEAVETIME;

@property(nonatomic,retain)NSString *S_COALTYPE;
@property(nonatomic,retain)NSString *S_SUPPLIER;
@property(nonatomic,retain)NSString *S_KEYNAME;

@property  double S_LW;
@property(nonatomic,retain)NSString *S_PLANTYPE;
@property(nonatomic,retain)NSString *S_STAGE;
@property(nonatomic,retain) NSString *   S_HEATVALUE;
@property(nonatomic,retain)  NSString *   S_SULFUR;

//航运计划
@property(nonatomic,retain)  NSString *T_PLANMONTH;
@property   NSInteger  T_SHIPID;//20
@property(nonatomic,retain)NSString *   T_SHIPNAME;
@property(nonatomic,retain)NSString * T_FACTORYCODE;
@property(nonatomic,retain)NSString *   T_FACTORYNAME;
@property(nonatomic,retain)NSString *   T_TRIPNO;
@property(nonatomic,retain)NSString * T_PORTCODE;
@property(nonatomic,retain)NSString * T_PORTNAME;
@property(nonatomic,retain)NSString *   T_ARRIVETIME;
@property(nonatomic,retain)NSString *  T_LEAVETIME;
@property(nonatomic,retain)NSString *   T_COALTYPE;
@property(nonatomic,retain)NSString *   T_SUPPLIER;
@property(nonatomic,retain)NSString *   T_KEYNAME;
@property  double    T_ELW;
@property(nonatomic,retain)NSString *   T_DESCRIPTION;
@property  (nonatomic,retain)  NSString *   T_HEATVALUE;
@property  (nonatomic,retain)  NSString *  T_SULFUR;//35
//实际航运与航运计划
@property   NSInteger ST_IntPlanMonth;
@property(nonatomic,retain)NSString *  ST_PLANMONTH;
 @property  NSInteger ST_SHIPID;
@property(nonatomic,retain)NSString *  ST_SHIPNAME;
@property(nonatomic,retain)NSString *  ST_FACTORYCODE;
@property(nonatomic,retain)NSString * ST_FACTORYNAME;
@property(nonatomic,retain)NSString * ST_TRIPNO;
@property(nonatomic,retain)NSString * ST_PORTCODE;
@property(nonatomic,retain)NSString * ST_PORTNAME;
@property(nonatomic,retain) NSString * ST_ARRIVETIME;


@property(nonatomic,retain)NSString * ST_LEAVETIME;
@property(nonatomic,retain)NSString * ST_COALTYPE;
@property(nonatomic,retain)NSString * ST_SUPPLIER;
@property(nonatomic,retain)NSString * ST_KEYNAME;
 @property  double ST_ELW;//50
@property   NSInteger ST_SORT;
 @property  NSInteger ST_SUPID;
 @property  NSInteger ST_TYPEID;
@property   NSInteger ST_KEYVALUE;//54




@end

@interface SearchModel: NSObject

/*
 public string PlanMonthS { get; set; }
 public string PlanMonthE { get; set; }
 public string ComId { get; set; }
 public string ShipId { get; set; }
 public string PortCode { get; set; }
 public string CoalTypeId { get; set; }
 public string Trade { get; set; }
 public string FactoryCode { get; set; }
 public string SupplierID { get; set; }
 public string KeyID { get; set; }
 
 
 */
{
    NSInteger  PlanMonthS;
    NSInteger  PlanMonthE;
    NSString *comName;
    NSString *shipName;
    NSString *portName; 
    NSString *CoalType;
    
   
    NSString *FactoryName;
    NSString *Supplier;
    
     NSString *KeyV;
    
     NSString *Trade;
}

@property NSInteger  PlanMonthS;
@property NSInteger PlanMonthE;
@property(nonatomic,retain)NSString *comName;
@property(nonatomic,retain)NSString *shipName;
@property(nonatomic,retain)NSString *portName;
@property(nonatomic,retain)NSString *CoalType;


@property(nonatomic,retain)NSString *FactoryName;
@property(nonatomic,retain)NSString *Supplier;

@property(nonatomic,retain)NSString *KeyV;

@property(nonatomic,retain)NSString *Trade;


@end








