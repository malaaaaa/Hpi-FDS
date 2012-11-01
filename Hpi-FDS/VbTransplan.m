//
//  VbTransplan.m
//  Hpi-FDS/Users/tangbineml/Documents/NewWorkSpace/Hpi-FDS/Hpi-FDS/VbTransplan.m
//
//  Created by Hoshino Wei on 12-5-3.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VbTransplan.h"

@implementation VbTransplan
@synthesize planCode, planMonth, shipName, factoryCode, factoryName, portCode, portName, tripNo, eTap, eTaf, supplier, coalType, keyValue, keyName, schedule, description,  facSort;
@synthesize shipID,serialNo, eLw, supID, typeID,heatvalue,sulfur;

- (void)dealloc {
    [planCode release];
    [planMonth release];
    [shipName release];
    [factoryCode release];
    [factoryName release];
    [portCode release];
    [portName release];
    [tripNo release];
    [eTap release];
    [eTaf release];
    [supplier release];
    [coalType release];
    [keyValue release];
    [keyName release];
    [schedule release];
    [description release];
    
    [facSort release];
    [super dealloc];
}
@end
