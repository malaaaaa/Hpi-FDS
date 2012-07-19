//
//  TsFileinfo.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

/*
create table TS_FILEINFO (
FILEID               numeric              identity,
FILETYPE             varchar(10)          not null,
TITLE                varchar(100)         not null,
FILEPATH             varchar(200)         not null,
FILENAME             varchar(100)         not null,
USERNAME             varchar(20)          not null,
RECORDTIME           datetime             not null,
constraint PK_TS_FILEINFO primary key (FILEID)
)#import <Foundation/Foundation.h>
*/

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface TsFileinfo : NSObject
{
    NSInteger fileId;
    NSString *fileType;
    NSString *title;
    NSString *filePath;
    NSString *fileName;
    NSString *userName;
    NSString *recordTime;
    NSString *xzbz;//下载标志 add 0未  1已
}

@property NSInteger fileId;
@property (nonatomic, retain) NSString *fileType;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *recordTime;
@property (nonatomic, retain) NSString *xzbz;

@end
