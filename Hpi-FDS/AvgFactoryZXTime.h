//
//  AvgFactoryZXTime.h
//  Hpi-FDS
//
//  Created by tang bin on 12-8-17.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvgFactoryZXTime : NSObject

{
   
    NSString *avgZG;
    NSString *avgXG;
    NSString *avgLT;
    NSString *TradeMonth;
    NSString *FactoryName;
    
    
    
}


@property(nonatomic,retain)NSString *avgZG;
@property(nonatomic,retain)NSString *avgXG;
@property(nonatomic,retain)NSString *avgLT;

@property(nonatomic,retain)NSString *TradeMonth;
@property(nonatomic,retain)NSString *FactoryName;


@end
