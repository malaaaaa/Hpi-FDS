//
//  TgShip.m
//  Hfds
//
//  Created by zcx on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TgShip.h"

@implementation TgShip
@synthesize comID,heatValue,lw,shipID,supID;
@synthesize company,factoryCode,factoryName,portCode,eta,lat,lon,sog;
@synthesize draft,stage,width,length,online,tripNo,infoTime,naviStat,portName;
@synthesize shipName,statCode,statName,supplier,stageName,destination,isOwn;
@synthesize didSelected;
- (void)dealloc {
    [shipName release];
    [company release];
    [portCode release];
    [portName release];
    [factoryCode release];
    [factoryName release];
    [tripNo release];
    [supplier release];
    [length release];
    [width release];
    [draft release];
    [eta release];
    [lat release];
    [lon release];
    [sog release];
    [destination release];
    [infoTime release];
    [naviStat release];
    [online release];
    [stage release];
    [stageName release];
    [statCode release];
    [statName release];
    [isOwn release];
    [super dealloc];
}

@end
