//
//  HpiGraphData.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-25.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface HpiGraphData : NSObject{
    //x坐标标题列表
	NSMutableArray *xtitles;
    //y坐标标题列表
	NSMutableArray *ytitles;
    //数据点
	NSMutableArray *pointArray;
    
    //数据点
	NSMutableArray *pointArray2;
    
    //数据点
	NSMutableArray *pointArray3;
    
    NSInteger yNum;
    NSInteger xNum;
    
}
@property(nonatomic,retain)NSMutableArray *xtitles;
@property(nonatomic,retain)NSMutableArray *ytitles;
@property(nonatomic,retain)NSMutableArray *pointArray;
@property(nonatomic,retain)NSMutableArray *pointArray2;
@property(nonatomic,retain)NSMutableArray *pointArray3;
@property NSInteger yNum;
@property NSInteger xNum;
@end

@interface HpiPoint : NSObject{
    NSInteger x; //point
    NSInteger y;
    NSString *title;
}
@property NSInteger x;
@property NSInteger y;
@property (nonatomic,copy)NSString *title;

@end