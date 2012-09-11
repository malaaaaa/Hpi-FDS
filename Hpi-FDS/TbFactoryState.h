//
//  TbFactoryState.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TbFactoryState : NSObject{
    NSInteger   STID;
    NSString    *FACTORYCODE;
    NSString    *RECORDDATE;
    NSInteger   IMPORT;
    NSInteger   EXPORT;
    NSInteger   STORAGE;
    NSInteger   CONSUM;
    NSInteger   AVALIABLE;
    NSInteger   MONTHIMP;
    NSInteger   YEARIMP;
    NSInteger   ELECGENER;
    NSInteger   STORAGE7;
    NSString    *TRANSNOTE;
    NSString    *NOTE;
    NSInteger   MONTHCONSUM;
    NSInteger  YEARCONSUM;
    
}


@property NSInteger STID;
@property (nonatomic,retain) NSString *FACTORYCODE;
@property (nonatomic,retain) NSString *RECORDDATE;
@property NSInteger IMPORT;
@property NSInteger EXPORT;
@property NSInteger STORAGE;
@property NSInteger CONSUM;
@property NSInteger AVALIABLE;
@property NSInteger MONTHIMP;
@property NSInteger YEARIMP;
@property NSInteger ELECGENER;
@property NSInteger STORAGE7;
@property (nonatomic,retain) NSString *TRANSNOTE;
@property (nonatomic,retain) NSString *NOTE;
@property NSInteger   MONTHCONSUM;

@property NSInteger   YEARCONSUM;
@end
