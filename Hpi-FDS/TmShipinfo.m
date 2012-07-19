//
//  TmShipinfo.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TmShipinfo.h"

@implementation TmShipinfo

@synthesize infoId,portCode,recordDate,waitShip,transactShip,loadShip;

-(void)dealloc {
    [portCode release];
    [recordDate release];
    [super dealloc];
}

@end
