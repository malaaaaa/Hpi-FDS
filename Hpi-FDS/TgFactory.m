//
//  TgFactory.m
//  Hfds
//
//  Created by zcx on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TgFactory.h"

@implementation TgFactory
@synthesize factoryCode,factoryName,description,lon,lat;
@synthesize capacitySum,impOrt,impMonth,impYear,storage,conMonth,conSum,conYear;

-(void)dealloc {
    [factoryCode release];
    [description release];
    [factoryName release];
    [lon release];
    [lat release];
    [super dealloc];
}
@end
