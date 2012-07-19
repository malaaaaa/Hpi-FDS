//
//  TmIndextype.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

/*
 create table TM_INDEXTYPE (
 TYPEID               numeric              identity,
 INDEXTYPE            varchar(20)          not null,
 TYPENAME             varchar(100)         not null,
 constraint PK_TM_INDEXTYPE primary key (TYPEID)
 )
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TmIndextype : NSObject
{
    NSInteger typeId;
    NSString *indexType;
    NSString *typeName;
}

@property NSInteger typeId;
@property (nonatomic, retain) NSString *indexType;
@property (nonatomic, retain) NSString *typeName;

@end
