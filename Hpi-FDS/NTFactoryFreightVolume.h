//
//  NTFactoryFreightVolume.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-1.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NTFactoryFreightVolume : NSObject{
    NSString *_TRADETIME;
    NSString *_TRADE;
    NSString *_TRADENAME;
    NSString *_CATEGORY;
    NSString *_FACTORYNAME;
    NSInteger _LW;
    
    
    
    NSInteger _COUNT;//航次
}
@property(nonatomic,copy) NSString *TRADETIME;
@property(nonatomic,copy) NSString *TRADE;
@property(nonatomic,copy) NSString *TRADENAME;
@property(nonatomic,copy) NSString *CATEGORY;
@property(nonatomic,copy) NSString *FACTORYNAME;
@property NSInteger LW;
@property NSInteger COUNT;

@end
