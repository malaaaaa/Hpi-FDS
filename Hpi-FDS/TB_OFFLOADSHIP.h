//
//  TB_OFFLOADSHIP.h
//  Hpi-FDS
//
//  Created by tang bin on 12-9-4.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TB_OFFLOADSHIP : NSObject
{
    NSInteger  ID;
    NSString *FACTORYCODE;
    NSString *RECORDDATE;
    NSString *TYPE;
   NSInteger SHIPID;
    NSString *EVENTTIME;
   NSInteger LW;
   NSInteger HEATVALUE;
  double  SULFUR;
   double DRAFT;
  NSString *  SUPPLIER;
   NSString * TRADENAME;
  NSString *  COALTYPE;
    
    
}
@property NSInteger ID;
@property NSInteger SHIPID;
@property NSInteger LW;
@property NSInteger HEATVALUE;
@property double SULFUR;
@property double DRAFT;



@property (nonatomic,retain) NSString * FACTORYCODE;
@property (nonatomic,retain) NSString * RECORDDATE;
@property (nonatomic,retain) NSString * EVENTTIME;
@property (nonatomic,retain) NSString * TYPE;
@property (nonatomic,retain) NSString * SUPPLIER;
@property (nonatomic,retain) NSString * TRADENAME;
@property (nonatomic,retain) NSString * COALTYPE;



@end
