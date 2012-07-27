//
//  BrokenLineGraphData.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-25.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTShipCompanyTranShare.h"

@interface BrokenLineGraphData : NSObject{
    //x坐标标题列表
	NSMutableArray *xtitles;
    //y坐标标题列表
	NSMutableArray *ytitles;
    //数据点
	NSMutableArray *pointArray;
    
    NSInteger yNum;
    NSInteger xNum;
}
@property(nonatomic,retain)NSMutableArray *xtitles;
@property(nonatomic,retain)NSMutableArray *ytitles;
@property(nonatomic,retain)NSMutableArray *pointArray;
@property NSInteger yNum;
@property NSInteger xNum;
@end


@interface LineArray : NSObject{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    NSMutableArray  *pointArray;
}
@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;

@property(nonatomic,retain) NSMutableArray *pointArray;

@end

@interface BrokenLineGraphPoint : NSObject{
    NSInteger x; //point
    NSInteger y;
    NTShipCompanyTranShare *companyShare;
}
@property NSInteger x;
@property NSInteger y;
@property(nonatomic,retain) NTShipCompanyTranShare *companyShare;

@end