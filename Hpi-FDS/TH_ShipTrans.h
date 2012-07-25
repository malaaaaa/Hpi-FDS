//
//  TH_ShipTrans.h
//  Hpi-FDS
//
//  Created by bin tang on 12-7-19.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TH_ShipTrans : NSObject

{
    NSInteger _RECID;
    NSInteger _STATECODE;
    
    
    
    NSString *_RECORDDATE;
       NSString *_STATENAME;
    
    
    
    
    NSString *_PORTCODE;
    NSString *_PORTNAME;
        NSString *_SHIPNAME;
    NSString *_TRIPNO;
    NSString *_FACTORYNAME;
    NSString *_SUPPLIER;
    NSString *_COALTYPE;
        NSInteger _LW;
    NSString *_P_ANCHORAGETIME;
    NSString *_P_HANDLE;
    NSString *_P_ARRIVALTIME;
    NSString *_P_DEPARTTIME;
    NSString *_NOTE;
    
    
    
    
    
        
 
    
   
    
  
}


@property(nonatomic ,retain)   NSString *RECORDDATE;


@property(nonatomic ,retain) NSString * SHIPNAME;
@property(nonatomic ,retain)  NSString *TRIPNO;

@property(nonatomic ,retain)  NSString *FACTORYNAME;
@property(nonatomic ,retain)  NSString *PORTCODE;
@property(nonatomic ,retain)  NSString *PORTNAME;
@property(nonatomic ,retain)  NSString *SUPPLIER;
@property(nonatomic ,retain)  NSString *COALTYPE;


@property(nonatomic ,retain)   NSString * STATENAME;


@property(nonatomic ,retain)   NSString *P_ANCHORAGETIME;
@property(nonatomic ,retain)  NSString *P_HANDLE;
@property(nonatomic ,retain)  NSString *P_ARRIVALTIME;
@property(nonatomic ,retain)  NSString *P_DEPARTTIME;
@property(nonatomic ,retain) NSString *NOTE;








@property NSInteger  RECID;
@property  NSInteger STATECODE;

@property  NSInteger  LW;


  







@end
