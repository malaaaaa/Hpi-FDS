//
//  TmShipinfo.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

//INFOID               //信息ID
//PORTCODE             //港口编号
//RECORDDATE           //采集日期
//WAITSHIP             //在港船数
//TRANSACTSHIP         //已办手续船数
//LOADSHIP             //在装船数

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface TmShipinfo : NSObject
{
    NSInteger infoId;
    NSString *portCode;
    NSString *recordDate;
    NSInteger waitShip;
    NSInteger transactShip;
    NSInteger loadShip;
}

@property NSInteger infoId;
@property (nonatomic, retain) NSString *portCode;
@property (nonatomic, retain) NSString *recordDate;
@property NSInteger waitShip;
@property NSInteger transactShip;
@property NSInteger loadShip;

@end
