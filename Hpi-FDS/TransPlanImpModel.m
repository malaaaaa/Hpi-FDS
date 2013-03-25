//
//  TransPlanImpModel.m
//  Hpi-FDS
//
//  Created by tang bin on 12-9-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TransPlanImpModel.h"

@implementation TransPlanImpModel

@synthesize S_SHIPID;
@synthesize S_FACTORYCODE;
@synthesize S_SHIPNAME;
@synthesize S_FACTORYNAME;
@synthesize S_PORTCODE;
@synthesize S_PORTNAME;
@synthesize S_TRIPNO;
@synthesize S_ARRIVETIME;
@synthesize ST_SUPID;
@synthesize ST_TYPEID;
@synthesize ST_KEYNAME;
@synthesize ST_KEYVALUE;
@synthesize ST_COALTYPE;
@synthesize ST_SUPPLIER;
@synthesize ST_ELW;
@synthesize ST_SORT;
@synthesize S_PLANMONTH;
@synthesize ST_PORTCODE;
@synthesize ST_PORTNAME;
@synthesize ST_ARRIVETIME;
@synthesize ST_LEAVETIME;
@synthesize ST_SHIPID;
@synthesize ST_SHIPNAME;
@synthesize ST_FACTORYCODE;
@synthesize ST_FACTORYNAME;
@synthesize ST_TRIPNO;
@synthesize T_DESCRIPTION;
@synthesize S_SUPPLIER;
@synthesize T_HEATVALUE;
@synthesize S_COALTYPE;
@synthesize S_LEAVETIME;
@synthesize T_SULFUR;
@synthesize ST_IntPlanMonth;
@synthesize S_LW;
@synthesize S_KEYNAME;
@synthesize ST_PLANMONTH;
@synthesize S_HEATVALUE;
@synthesize S_STAGE;
@synthesize T_COALTYPE;
@synthesize T_SUPPLIER;
@synthesize S_PLANTYPE;
@synthesize T_PLANMONTH;
@synthesize T_KEYNAME;
@synthesize T_ELW;
@synthesize S_SULFUR;
@synthesize T_FACTORYCODE;
@synthesize T_FACTORYNAME;
@synthesize T_SHIPID;
@synthesize T_SHIPNAME;
@synthesize T_LEAVETIME;
@synthesize T_ARRIVETIME;
@synthesize T_PORTCODE;
@synthesize T_PORTNAME;
@synthesize T_TRIPNO;



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

@synthesize PlanMonthE;
@synthesize PlanMonthS;
@synthesize Trade;
@synthesize KeyV;
@synthesize Supplier;
@synthesize FactoryName;
@synthesize CoalType;
@synthesize portName;
@synthesize ShipId;
@synthesize comName;

-(void)dealloc
{

    
    [comName release];
    [ShipId release];
    [portName release];
    [CoalType release];
    
    
   [FactoryName release];
   [Supplier release];
    
   [KeyV release];
    
  [Trade release];

    [super dealloc];
}

@end



