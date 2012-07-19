//
//  TmIndexinfo.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

/*
create table TM_INDEXINFO (
INFOID               numeric              identity,
INDEXNAME            varchar(20)          not null,
RECORDTIME           datetime             not null,
INFOVALUE            numeric(10,3)        not null,
constraint PK_TM_INDEXINFO primary key (INFOID)
)
*/

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TmIndexinfo : NSObject
{
    NSInteger infoId;
    NSString *indexName;
    NSString *recordTime;
    NSString *infoValue;
}

@property NSInteger infoId;
@property (nonatomic, retain) NSString *indexName;
@property (nonatomic, retain) NSString *recordTime;
@property (nonatomic, retain) NSString *infoValue;

@end
