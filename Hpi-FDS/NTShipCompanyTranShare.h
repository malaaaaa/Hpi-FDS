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
    NSString *_TRADEWEEK;
    NSString *_TRADEMONTH;
    NSInteger _LWSUM;
    
    
    
    
     NSInteger _TAG;//自动增长的主键，tmp表使用，作用是通过该值传递给button.tag实现@selector的参数的作用
    NSString *_PERCENT;
    NSInteger _X;
    NSInteger _Y;
}
@property NSInteger COMID;
@property(nonatomic,retain) NSString *COMPANY;
@property(nonatomic,retain) NSString *PORTCODE;
@property(nonatomic,retain) NSString *PORTNAME;
@property(nonatomic,retain) NSString *TRADEYEAR;
@property(nonatomic,retain) NSString *TRADEWEEK;
@property NSInteger LWSUM;



@property(nonatomic,retain) NSString *PERCENT;
@property NSInteger X;
@property NSInteger Y;
@property NSInteger TAG;

@end
