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
    NSString* subtitle2;
    NSString* port;//转运港
    NSString* factory;//流向电厂
    NSString* topTitle;
    UIImage*  topImage;
    NSString* shipStat;
    NSString* shipStage;
    NSString* company; //航运公司
    NSString* online; //是否在线
} 
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) int iAnnotationType;
@property (nonatomic, copy) NSString *subtitle2;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *factory;
@property (nonatomic, copy) NSString *topTitle;
@property (nonatomic, retain) UIImage *topImage;
@property (nonatomic, copy) NSString *shipStat;
@property (nonatomic, copy) NSString *shipStage;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *online;

-(id) initWithCoords:(CLLocationCoordinate2D) coords;
@end
