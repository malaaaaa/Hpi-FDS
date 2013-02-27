//
//  TgShip.h
//  Hfds
//
//  Created by zcx on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//create table TG_SHIP 
//(
// SHIPID               numeric              not null,
// SHIPNAME             varchar(20)          not null,
// COMID                numeric              not null,
// COMPANY              varchar(20)          not null,
// PORTCODE             varchar(10)          null,
// PORTNAME             varchar(20)          null,
// FACTORYCODE          varchar(10)          null,
// FACTORYNAME          varchar(20)          null,
// TRIPNO               varchar(8)           null,
// SUPID                numeric              null,
// SUPPLIER             varchar(20)          null,
// HEATVALUE            numeric(6)           null,
// LW                   numeric(10)          null,
// LENGTH               numeric(8,1)         null,
// WIDTH                numeric(8,1)         null,
// DRAFT                numeric(4,1)         null,
// ETA                  datetime             null,
// LAT                  numeric(18,10)       null,
// LON                  numeric(18,10)       null,
// SOG                  numeric(8,3)         null,
// DESTINATION          varchar(30)          null,
// INFOTIME             datetime             null,
// NAVI_STAT            numeric(4)           null,
// ONLINE               char(1)              null,
// STAGE                char(1)              not null,
// STAGENAME            varchar(20)          not null,
// STATECODE            char(2)              not null,
// STATENAME            varchar(20)          not null,
// constraint PK_TG_SHIP primary key (SHIPID)
// )

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TgShip : NSObject{
    NSInteger shipID;
    NSString *shipName;
    NSInteger comID;
    NSString *company;
    NSString *portCode;
    NSString *portName;
    NSString *factoryCode;
    NSString *factoryName;
    NSString *tripNo;       //航次
    NSInteger supID;        //供货方ID
    NSString *supplier;
    NSInteger heatValue;    //热值
    NSInteger lw;           //载煤量weight
    NSString *length;
    NSString *width;
    NSString *draft;        //吃水
    NSString *eta;          //预计抵港时间
    NSString *lat;          //纬度
    NSString *lon;          //经度
    NSString *sog;          //对地速度
    NSString *destination;  //目的港
    NSString *infoTime;     //接收时间
    NSString *naviStat;     //航行状态
    NSString *online;       //是否在线
    NSString *stage;        //0-空船在途 1-在港 2-满载在途 3-在厂 4-结束
    NSString *stageName;    //阶段说明
    NSString *statCode;     //状态编码
    NSString *statName;     //状态说明
    NSString *isOwn;
    BOOL    didSelected;
}
@property (nonatomic,retain) NSString *shipName;
@property (nonatomic,retain) NSString *company;
@property (nonatomic,retain) NSString *portCode;
@property (nonatomic,retain) NSString *portName;
@property (nonatomic,retain) NSString *factoryCode;
@property (nonatomic,retain) NSString *factoryName;
@property (nonatomic,retain) NSString *tripNo;
@property (nonatomic,retain) NSString *supplier;
@property (nonatomic,retain) NSString *length;
@property (nonatomic,retain) NSString *width;
@property (nonatomic,retain) NSString *draft;
@property (nonatomic,retain) NSString *eta;
@property (nonatomic,retain) NSString *lat;
@property (nonatomic,retain) NSString *lon;
@property (nonatomic,retain) NSString *sog;
@property (nonatomic,retain) NSString *destination;
@property (nonatomic,retain) NSString *infoTime;
@property (nonatomic,retain) NSString *naviStat;
@property (nonatomic,retain) NSString *online;
@property (nonatomic,retain) NSString *stage;
@property (nonatomic,retain) NSString *stageName;
@property (nonatomic,retain) NSString *statCode;
@property (nonatomic,retain) NSString *statName;
@property (nonatomic,retain) NSString *isOwn;

@property NSInteger shipID;
@property NSInteger comID;
@property NSInteger supID;
@property NSInteger heatValue;
@property NSInteger lw;
@property (assign)  BOOL didSelected;

@end
