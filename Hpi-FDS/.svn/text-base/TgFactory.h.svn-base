//
//  TgFactory.h
//  Hfds
//
//  Created by zcx on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//create table TG_FACTORY 
//(
// FACTORYCODE          varchar(10)          not null,
// FACTORYNAME          varchar(20)          not null,
// CAPACITYSUM          numeric              not null,
// DESCRIPTION          varchar(100)         null,
// IMPORT               numeric(10)          not null,
// IMPMONTH             numeric(10)          not null,
// IMPYEAR              numeric(10)          not null,
// STORAGE              numeric(10)          not null,
// CONSUM               numeric(10)          not null,
// CONMONTH             numeric(10)          not null,
// CONYEAR              numeric(10)          not null,
// constraint PK_TG_FACTORY primary key (FACTORYCODE)
// )
#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface TgFactory : NSObject{
    NSString *factoryCode;
    NSString *factoryName;
    NSInteger capacitySum; //总装机容量
    NSString *description; //机组运行情况
    NSInteger impOrt;      //日调进煤量
    NSInteger impMonth;
    NSInteger impYear;
    NSInteger storage;     //库存煤量
    NSInteger conSum;      //日耗煤量
    NSInteger conMonth;
    NSInteger conYear;
    NSString *lon;
    NSString *lat;
    BOOL    didSelected;//是否选中
}
@property (nonatomic,retain) NSString *factoryCode;
@property (nonatomic,retain) NSString *factoryName;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *lon;
@property (nonatomic,retain) NSString *lat;
@property NSInteger capacitySum;
@property NSInteger impOrt;
@property NSInteger impMonth;
@property NSInteger impYear;
@property NSInteger storage;
@property NSInteger conSum;
@property NSInteger conMonth;
@property NSInteger conYear;
@property (assign) BOOL didSelected;

@end
