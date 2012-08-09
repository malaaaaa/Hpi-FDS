//
//  TfPort.h
//  Hpi-FDS
//
//  Created by bin tang on 12-8-7.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TfPort : NSObject
{

    NSString *PORTCODE;
    NSString *PORTNAME;
    NSString *SORT;
    NSString *UPLOAD;
    NSString *DOWNLOAD;
    NSString *NATIONALTYPE;




}
@property (nonatomic,retain)NSString *PORTCODE;
@property (nonatomic,retain)NSString *PORTNAME;
@property (nonatomic,retain) NSString *SORT;
@property (nonatomic,retain)   NSString *UPLOAD;
@property (nonatomic,retain)NSString *DOWNLOAD;

@property (nonatomic,retain)NSString *NATIONALTYPE;



@end
