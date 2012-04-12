//
//  hpiAnnotation.h
//  Hpi
//
//  Created by zcx on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface hpiAnnotation : NSObject <MKAnnotation> 
{ 
    CLLocationCoordinate2D coordinate; 
    NSString* title; 
    NSString* subtitle;
    int iAnnotationType;
    UIImage *headImage;
    NSString* subtitle2;
    NSString* port;//转运港
    NSString* factory;//流向电厂
    NSString* stage;//状态
    NSString* stateCode;//状态

} 
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) int iAnnotationType;
@property (nonatomic, copy) UIImage *headImage;
@property (nonatomic, retain) NSString *subtitle2;
@property (nonatomic, retain) NSString *port;
@property (nonatomic, retain) NSString *factory;
@property (nonatomic, retain) NSString *stage;
@property (nonatomic, retain) NSString *stateCode;
-(id) initWithCoords:(CLLocationCoordinate2D) coords;
@end
