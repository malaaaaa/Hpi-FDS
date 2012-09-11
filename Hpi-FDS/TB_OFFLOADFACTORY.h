//
//  TB_OFFLOADFACTORY.h
//  Hpi-FDS
//
//  Created by tang bin on 12-9-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TB_OFFLOADFACTORY : NSObject
{
    NSInteger  ID;
    NSString *FACTORYCODE;
    NSString *RECORDDATE;
    NSInteger CONSUM;
    NSInteger STORAGE;
    NSInteger HEATVALUE;
    double  SULFUR;
    NSInteger  AVALIABLE;
    double  MINDEPTH;
    NSString *NOTE;
    
    
    
    
    NSMutableArray *tbShipList;
    
}
@property (nonatomic,retain )NSString *FACTORYCODE;
@property (nonatomic,retain )NSString *RECORDDATE;
@property (nonatomic,retain )NSString *NOTE;
@property  NSInteger  ID;
@property NSInteger CONSUM;
@property NSInteger STORAGE;
@property NSInteger HEATVALUE;
@property double  SULFUR;
@property NSInteger  AVALIABLE;
@property double  MINDEPTH;




@property (nonatomic,retain )NSMutableArray *tbShipList;




@end
