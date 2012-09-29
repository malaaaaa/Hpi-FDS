//
//  TransPlanImpModel.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TransPlanImpModel.h"

@implementation TransPlanImpModel




-(void)dealloc
{
    [S_HEATVALUE release];
    
    [S_SULFUR release];
    [T_SULFUR release];
    [T_HEATVALUE release];
    [S_PLANMONTH release];

  [S_SHIPNAME release];
   [S_FACTORYCODE release];
    [S_FACTORYNAME release];
   [S_TRIPNO release];
    [S_PORTCODE release];
   [S_PORTNAME release];
    [S_ARRIVETIME release];
    [S_LEAVETIME release];
    [S_COALTYPE release];
   [S_SUPPLIER release];
   [S_KEYNAME release];
  [S_PLANTYPE release];
    [S_STAGE release];
   [T_PLANMONTH release];
    [T_SHIPNAME release];
    [T_FACTORYCODE release];
      [T_FACTORYNAME release];
      [T_TRIPNO release];
     [T_PORTCODE release];
     [T_PORTNAME release];
    [T_ARRIVETIME release];
    [T_LEAVETIME release];
      [T_COALTYPE release];
      [T_SUPPLIER release];
      [T_KEYNAME release];
       [T_DESCRIPTION release];
[ST_PLANMONTH release];  
[ST_SHIPNAME release];
[ ST_FACTORYCODE release];
[ ST_FACTORYNAME release    ];
[ST_TRIPNO release];
[ST_PORTCODE release];
[ST_PORTNAME release];
[ST_ARRIVETIME release];
[ST_LEAVETIME release];
[ST_COALTYPE release];
[ST_SUPPLIER release];
[ST_KEYNAME release];
    
    [super dealloc];
    
}

@end
@implementation SearchModel

-(void)dealloc
{

    
    [comName release];
   [shipName release];
    [portName release];
    [CoalType release];
    
    
   [FactoryName release];
   [Supplier release];
    
   [KeyV release];
    
  [Trade release];

    [super dealloc];
}

@end



