//
//  TmIndexdefine.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//


/*
 create table TM_INDEXDEFINE (
 INDEXID              numeric              identity,
 INDEXNAME            varchar(20)          not null,
 INDEXTYPE            varchar(20)          not null,
 MAXIMUM              numeric              null,
 MINIMUM              numeric              null,
 DISPLAYNAME          varchar(30)          not null,
 constraint PK_TM_INDEXDEFINE primary key (INDEXID)
 )
 */
 
 
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TmIndexdefine : NSObject
{
    NSInteger indexId;
    NSString *indexName;
    NSString *indexType;
    NSInteger maxiMum;
    NSInteger miniMum;
    NSString *displayName;
}

@property NSInteger indexId;
@property (nonatomic, retain) NSString *indexName;
@property (nonatomic, retain) NSString *indexType;
@property NSInteger maxiMum;
@property NSInteger miniMum;
@property (nonatomic, retain) NSString *displayName;

@end
