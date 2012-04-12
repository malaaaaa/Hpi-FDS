//
//  PubInfo.m
//  Hpi-FDS
//
//  Created by zcx on 12-3-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "PubInfo.h"

@implementation PubInfo

static NSString *autoUpdate;
static NSString *baseUrl;
static NSString *url;
static NSString *userName;
static NSString *updateTime;

+(void)initdata
{
    [TgPortDao openDataBase];
	[TgPortDao initDb];
    [TgFactoryDao openDataBase];
	[TgFactoryDao initDb];
    [TgShipDao openDataBase];
	[TgShipDao initDb];
    [TsFileinfoDao openDataBase];
	[TsFileinfoDao initDb];
    [TmIndexinfoDao openDataBase];
	[TmIndexinfoDao initDb];
    [TmIndexdefineDao openDataBase];
	[TmIndexdefineDao initDb];
    [TmIndextypeDao openDataBase];
	[TmIndextypeDao initDb];
    [VbShiptransDao openDataBase];
	[VbShiptransDao initDb];
    
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doc=[paths objectAtIndex:0];
	NSString *fileName=[[NSString alloc]initWithFormat:@"%@/data.plist",doc]; 
	NSArray *tempArray = [[NSArray alloc] initWithContentsOfFile:fileName];
	NSLog(@"data=%d",[tempArray count]);
	if([tempArray count]<3)
	{
		userName=@"zcx-test";
        autoUpdate=kYES;
        updateTime=@"2012-04-02 00:00";
		[PubInfo save];
	}
	else {
        userName=[tempArray objectAtIndex:0];
		autoUpdate=[tempArray objectAtIndex:1];
        updateTime=[tempArray objectAtIndex:2];
	}
    [fileName release];
    //[tempArray release];
}
+(void)save
{
	NSArray *tempArray = [[NSArray alloc]initWithObjects:
						  userName,
                          autoUpdate,
                          updateTime,
						  nil
						  ];
	NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doc=[paths objectAtIndex:0];
	NSString *fileName=[[NSString alloc]initWithFormat:@"%@/data.plist",doc];
	[tempArray writeToFile:fileName atomically:YES];
	[fileName release];
}

+(NSString *)baseUrl
{
	baseUrl=@"http://10.2.17.121:82/CDSWebService/MobileSys.asmx";
	return baseUrl;	
}

+(NSString *)url
{
	url=@"http://10.2.17.121";
	return url;	
}

+(void)setUserName:(NSString*) theName
{
	[userName release];
	userName=theName;
	[userName retain];
}
+(NSString *)userName
{
	
	return userName;
}

+(void)setAutoUpdate:(NSString*)update
{
	[autoUpdate release];
	autoUpdate=update;
	[autoUpdate retain];
}
+(NSString *)autoUpdate
{
	
	return autoUpdate;
}

+(NSString *)updateTime;
{	
	return updateTime;
}
+(void)setUpdateTime:(NSString*) time
{
	[updateTime release];
	updateTime=time;
	[updateTime retain];
}
@end
