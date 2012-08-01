//
//  TB_Latefee.h
//  Hpi-FDS
//
//  Created by bin tang on 12-7-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TB_Latefee : NSObject
{
    NSString *DISPATCHNO;
    NSString *PORTCODE;
    NSString *PORTNAME;
    
    NSString *FACTORYCODE;
    NSString *FACTORYNAME;
    
    
    NSInteger COMID;
    NSString *COMPANY;
    
    NSInteger SHIPID;
    NSString *SHIPNAME;
    
    
    NSString * FEERATE;
    NSString *ALLOWPERIOD;
    
    
    NSInteger SUPID;
    NSString *SUPPLIER;
    
    NSInteger TYPEID;
    NSString *COALTYPE;
    
    
    
    
    NSString *TRADE;

    NSString *KEYVALUE;
    NSString *TRIPNO;
    
    
    
    NSInteger LW;
    
    
    
    NSString *TRADETIME;
    NSString *P_ANCHORAGETIME;
    NSString *P_DEPARTTIME;
    NSString *P_CONFIRM;
    NSString *P_CONTIME;
    NSString *P_CONUSER;
    NSString *F_ANCHORAGETIME;
    NSString *F_DEPARTTIME;
    NSString *F_CONFIRM;
    NSString *F_CONTIME;
    NSString *F_CONUSER;
    
    NSString *LATEFEE;
      NSString *P_CORRECT;
    NSString *P_NOTE;
    NSString *F_CORRECT;
    NSString *F_NOTE;
    NSString *ISCAL;
    NSString  *CURRENCY;
    NSString *EXCHANGERATE;








}

@property (nonatomic,retain)NSString *DISPATCHNO;
@property (nonatomic,retain)NSString *PORTCODE;
@property (nonatomic,retain)NSString *PORTNAME;

@property (nonatomic,retain) NSString *FACTORYCODE;
@property (nonatomic,retain)NSString *FACTORYNAME;
@property (nonatomic,retain) NSString * FEERATE;

@property (nonatomic,retain) NSString *ALLOWPERIOD;


@property (nonatomic,retain)  NSString *TRADE;

@property (nonatomic,retain)  NSString *KEYVALUE;


@property (nonatomic,retain)  NSString *TRIPNO;

@property (nonatomic,retain)  NSString *TRADETIME;
@property (nonatomic,retain) NSString *P_ANCHORAGETIME;

@property (nonatomic,retain) NSString *P_DEPARTTIME;
@property (nonatomic,retain)   NSString *P_CONFIRM;

@property (nonatomic,retain) NSString *P_CONTIME;

@property (nonatomic,retain) NSString *P_CONUSER;
@property (nonatomic,retain)     NSString *F_ANCHORAGETIME;
@property (nonatomic,retain)NSString *F_DEPARTTIME;
@property (nonatomic,retain)   NSString *F_CONFIRM;

@property (nonatomic,retain)  NSString *F_CONTIME;

@property (nonatomic,retain)  NSString *F_CONUSER;
@property (nonatomic,retain)   NSString *LATEFEE;
@property (nonatomic,retain)    NSString *P_CORRECT;

@property (nonatomic,retain) NSString *P_NOTE;

@property (nonatomic,retain) NSString *F_CORRECT;
@property (nonatomic,retain)NSString *F_NOTE;
@property (nonatomic,retain) NSString *ISCAL;
@property (nonatomic,retain) NSString  *CURRENCY;
@property (nonatomic,retain)  NSString *EXCHANGERATE;

@property    NSInteger COMID;

@property (nonatomic,retain) NSString *COMPANY;
@property   NSInteger SHIPID;
@property (nonatomic,retain) NSString *SHIPNAME;

@property   NSInteger SUPID;
 @property (nonatomic,retain)  NSString *SUPPLIER;
@property   NSInteger TYPEID;

 @property (nonatomic,retain) NSString *COALTYPE;
@property   NSInteger LW;




@end
