//
//  NTShipCompanyTranShare.h
//  Hpi-FDS
//  NT标示新建表，作为船运公司市场份额统计使用
//  Created by 马 文培 on 12-7-23.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTShipCompanyTranShare : NSObject{
    NSInteger _COMID;
    NSString *_COMPANY;
    NSString *_PORTCODE;
    NSString *_PORTNAME;
    NSString *_TRADEYEAR;
    NSString *_TRADEMONTH;
    NSInteger _LW;
    NSInteger _PERCENT;
}
@property NSInteger COMID;
@property(nonatomic,retain) NSString *COMPANY;
@property(nonatomic,retain) NSString *PORTCODE;
@property(nonatomic,retain) NSString *PORTNAME;
@property(nonatomic,retain) NSString *TRADEYEAR;
@property(nonatomic,retain) NSString *TRADEMONTH;
@property NSInteger LW;
@property NSInteger PERCENT;


@end
