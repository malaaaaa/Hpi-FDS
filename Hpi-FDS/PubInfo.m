//
//  PubInfo.m
//  Hpi-FDS
//
//  Created by zcx on 12-3-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//
#import "PubInfo.h"
#import "NSString+MD5Addition.h"
#import "UIDevice+IdentifierAddition.h"
@implementation PubInfo
static NSString *hostName = @"http://10.2.17.121";     //http://172.16.1.16:84
static NSString *port = @":82";                  //:82
static NSString *autoUpdate;
static NSString *baseUrl;
static NSString *url;
static NSString *userInfoUrl;
static NSString *userName;
static NSString *updateTime;    
static NSString *deviceID;

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
    [VbTransplanDao openDataBase];
	[VbTransplanDao initDb];
    [TiListinfoDao openDataBase];
    [TiListinfoDao initDb];
    [TmCoalinfoDao openDataBase];
    [TmCoalinfoDao initDb];
     
    
    [TmShipinfoDao openDataBase];
    [TmShipinfoDao initDb];
  
    [VbFactoryTransDao openDataBase];
    [VbFactoryTransDao initDb];
    [TfFactoryDao openDataBase];
    [TfFactoryDao initDb];
    [TbFactoryStateDao openDataBase];
    [TbFactoryStateDao initDb];
    [TfShipCompanyDao openDataBase];
    [TfShipCompanyDao initDb];
    [TfSupplierDao openDataBase];
    [TfSupplierDao initDb];
    [TfCoalTypeDao openDataBase];
    [TfCoalTypeDao initDb];
    [TsShipStageDao openDataBase];
    [TsShipStageDao initDb];
    
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doc=[paths objectAtIndex:0];
	NSString *fileName=[[NSString alloc]initWithFormat:@"%@/data.plist",doc]; 
	NSArray *tempArray = [[NSArray alloc] initWithContentsOfFile:fileName];
	//NSLog(@"data=%d",[tempArray count]);
	if([tempArray count]<3)
	{
		userName=@"weix-test";
        autoUpdate=kNO;
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
	baseUrl=[NSString stringWithFormat:@"%@%@/CDSWebService/MobileSys.asmx",hostName,port];
    //baseUrl=@"http://172.16.1.16:84/CDSWebService/MobileSys.asmx";
	return baseUrl;	
}

+(NSString *)url
{
	url=[NSString stringWithFormat:@"%@%@",hostName,port];
    //url=@"http://172.16.1.16:84";
	return url;	
}

+(NSString *)userInfoUrl
{
	userInfoUrl=@"http://app.hpi.com.cn/HPIWebService/IOSUserInfoWebService.asmx";
	return userInfoUrl;	
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
+(NSString *)deviceID
{
    deviceID = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    return deviceID;
}
+(NSString *)currTime
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    return [dateFormatter stringFromDate:[NSDate date]];
}
@end
