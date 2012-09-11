//
//  TF_FACTORYCAPACITY.h
//  Hpi-FDS
//
//  Created by tang bin on 12-8-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TF_FACTORYCAPACITY : NSObject

{
    
    NSInteger CAPID;
    
    NSString *FACTORYCODE;
    double  CAPACITY;
    NSInteger  UNITS;
    NSString *DESCRIPTION;
  



}
@property(nonatomic,retain)NSString *FACTORYCODE;
@property(nonatomic,retain)NSString *DESCRIPTION;

@property NSInteger CAPID;

@property double CAPACITY;

@property NSInteger UNITS;
@end
