//
//  hpiAnnotation.m
//  Hpi
//
//  Created by zcx on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "hpiAnnotation.h"

@implementation hpiAnnotation

@synthesize coordinate,subtitle,title,iAnnotationType,headImage,subtitle2,port,factory,stage,stateCode;

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
    if(!headImage)
        [headImage release];
    if(!port)
        [port release];
    if(!factory)
        [factory release];
    if(!stage)
        [stage release];
	[super dealloc];
}
@end
