//
//  hpiAnnotation.m
//  Hpi
//
//  Created by zcx on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "hpiAnnotation.h"

@implementation hpiAnnotation

@synthesize coordinate,subtitle,iAnnotationType,title,subtitle2,port,factory,topTitle,topImage;
@synthesize shipStat,shipStage;

- (id) initWithCoords:(CLLocationCoordinate2D) coords{
    
	self = [super init];
    
	if (self != nil) {
        
		coordinate = coords; 
        
	}
    
	return self;
    
}

- (void) dealloc
{
    if(!title)
        [title release];
	if(!subtitle)
        [subtitle release];
    if(!subtitle2)
        [subtitle release];
    if(!port)
        [port release];
    if(!factory)
        [factory release];
    if(!topTitle)
        [topTitle release];
    if(!shipStat)
        [shipStat release];
    if(!shipStage)
        [shipStage release];
	[super dealloc];
}
@end
