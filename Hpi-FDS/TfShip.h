//
//  TfShip.h
//  Hpi-FDS
//
//  Created by tang bin on 12-9-5.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TfShip : NSObject
{
    NSInteger SHIPID;
    NSInteger  COMID;
    NSString *SHIPNAME;
    NSString *SHIPCODE;
     NSString * MMSI;
    NSInteger  LENGTH;
    NSInteger  WIDTH;
   NSInteger MAXSPEED;
   NSInteger LOADWEIGHT;
   NSInteger DRAFT;
  NSInteger  VOLUME;
   NSInteger CABINNUM;
  NSInteger  GATENUM;
    NSString *  TELEPHONE;
   NSInteger FEERATE;
   NSInteger ALLOWPERIOD;
   NSInteger DESPATCHRATE;



}

@property NSInteger SHIPID;
@property  NSInteger  COMID;

@property(nonatomic,retain) NSString *SHIPNAME;
@property(nonatomic,retain) NSString *SHIPCODE;
@property(nonatomic,retain) NSString * MMSI;
@property    NSInteger  LENGTH;


@property    NSInteger  WIDTH;

@property NSInteger MAXSPEED;
@property NSInteger LOADWEIGHT;
@property NSInteger DRAFT;
@property NSInteger  VOLUME;
@property NSInteger CABINNUM;
@property NSInteger  GATENUM;
@property(nonatomic,retain)NSString *  TELEPHONE;
@property NSInteger FEERATE;
@property NSInteger ALLOWPERIOD;
@property NSInteger DESPATCHRATE;





@end
