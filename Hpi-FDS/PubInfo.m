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
#import "TH_ShipTransDao.h"
#import "TB_LatefeeDao.h"
#import "VB_LatefeeDao.h"
#import "NT_LatefeeTongjDao.h"
#import "TfPortDao.h"
#import "FactoryWaitDynamicDao.h"
#import "AvgFactoryZXTimeDao.h"
#import "TB_OFFLOADFACTORYDao.h"
#import "TB_OFFLOADSHIPDao.h"
#import "AvgPortPTimeDao.h"
#import "TfShip.h"
#import "TfShipDao.h"
#import "TF_FACTORYCAPACITYDao.h"
#import "TransPlanImpDao.h"
#import "NT_TransPlanImpDao.h"
@implementation PubInfo
//测试环境
static NSString *hostName =@"http://10.2.17.121";
static NSString *port =@":82";

//正式环境
//static NSString *hostName =@"http://cds.hpi.com.cn";
//static NSString *port =@"";
static NSString *autoUpdate;
static NSString *baseUrl;
static NSString *url;
static NSString *userInfoUrl;
static NSString *userName;
//基础数据更新时间
static NSString *updateTime;
//地图市场港口数据更新时间
static NSString *mmpUpdateTime;
//数据查询模块更新时间
static NSString *reportUpdateTime;
static NSString *isSucess;
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
    
    //新添  thshiptrans 调度日志  
    [TH_ShipTransDao openDataBase];
    [TH_ShipTransDao initDb];
    //新添  tblatefee  
    [TB_LatefeeDao openDataBase ];
    [TB_LatefeeDao initDb];
    [VB_LatefeeDao openDataBase ];
    [VB_LatefeeDao initDb];
    
    
    [NT_LatefeeTongjDao openDataBase];
     
    [TfPortDao openDataBase];
    [TfPortDao initDb];
    
    //港口平均装港时间统计
    [AvgPortPTimeDao openDataBase];
    
    //电厂平均装卸港时间
    [AvgFactoryZXTimeDao openDataBase];

    //电厂靠泊动态
    [FactoryWaitDynamicDao  openDataBase];
    
    //
    [TF_FACTORYCAPACITYDao openDataBase ];
    [TF_FACTORYCAPACITYDao initDb];
    
    
    //
    [TfShipDao openDataBase];
    [TfShipDao initDb];
    
    
    
    
    //  新添 量表
    [TB_OFFLOADFACTORYDao openDataBase];
    [TB_OFFLOADFACTORYDao initDb];
    
    [TB_OFFLOADSHIPDao openDataBase ];
    [TB_OFFLOADSHIPDao initDb];
    
    [TransPlanImpDao openDataBase   ];
    
    //航运计划临时表
    [ NT_TransPlanImpDao  openDataBase];
    [NT_TransPlanImpDao  IntTb];
    
    
    
    [NTShipCompanyTranShareDao openDataBase];
    [NTShipCompanyTranShareDao initDb];
    [NTShipCompanyTranShareDao initDb_tmpTable];
    [NTColorConfigDao openDataBase];
    [NTColorConfigDao initDb];
    [NTFactoryFreightVolumeDao openDataBase];
    [NTFactoryFreightVolumeDao initDb];
    [NTFactoryFreightVolumeDao initDb_tmpTable];    
    [PortEfficiencyDao openDataBase];
    [PortEfficiencyDao initDb];
    [NTLateFeeDMFXDao openDataBase];
    [NTLateFeeDMFXDao initDb];
    [NTLateFeeHCFXDao openDataBase];
    [NTLateFeeHCFXDao initDb];
    [NTZxgsjtjDao openDataBase];
    [NTZxgsjtjDao initDb];
    [TH_SHIPTRANS_ORIDAO openDataBase];
    [TH_SHIPTRANS_ORIDAO initDb];
    [PortBehaviourDao openDataBase];
    
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doc=[paths objectAtIndex:0];
	NSString *fileName=[[NSString alloc]initWithFormat:@"%@/data.plist",doc]; 
//	NSArray *tempArray = [[[NSArray alloc] initWithContentsOfFile:fileName] autorelease];
    NSArray *tempArray = [[NSArray alloc] initWithContentsOfFile:fileName] ;
	//NSLog(@"data=%d",[tempArray count]);
	if([tempArray count]<8)
	{
        //此处用Analyze工具监测会出现可能内存泄漏的提示，tempArray不能autorelease，否则会崩溃
		userName=@"developer";
        autoUpdate=kNO;
        updateTime=@"2000-01-01 00:00";
        mmpUpdateTime=@"2000-01-01 00:00";
        reportUpdateTime=@"2000-01-01 00:00";
        isSucess=UNO;
		[PubInfo save];
	}
	else {
        userName=[tempArray objectAtIndex:0];
		autoUpdate=[tempArray objectAtIndex:1];
        updateTime=[tempArray objectAtIndex:2];
        isSucess=[tempArray objectAtIndex:3];
        hostName=[tempArray objectAtIndex:4];
        port=[tempArray objectAtIndex:5];
        mmpUpdateTime=[tempArray objectAtIndex:6];
        reportUpdateTime=[tempArray objectAtIndex:7];
	}
  
//    [tempArray release];
    [fileName release];
}
+(void)save
{
	NSArray *tempArray = [[NSArray alloc]initWithObjects:
						  userName,
                          autoUpdate,
                          updateTime,
                          isSucess,
                          hostName,
                          port,
                          mmpUpdateTime,
                          reportUpdateTime,
						  nil
						  ];
	NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doc=[paths objectAtIndex:0];
	NSString *fileName=[[NSString alloc]initWithFormat:@"%@/data.plist",doc];
	[tempArray writeToFile:fileName atomically:YES];
    [tempArray release];
	[fileName release];
}

+(NSString *)baseUrl
{
	baseUrl=[NSString stringWithFormat:@"%@%@/CDSWebService/MobileSys.asmx",hostName,port];
    //baseUrl=@"http://172.16.1.16:84/CDSWebService/MobileSys.asmx";
    NSLog(@"baseUrl=%@",baseUrl);
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

+(void)setHostName:(NSString*) newHostName
{
    if (hostName!=newHostName) {
        [hostName release];
        hostName=[newHostName retain];
    }
}
+(NSString *)hostName
{	
	return hostName;
}
+(void)setPort:(NSString*) newPort
{
    if (port!=newPort) {
        [port release];
        port=[newPort retain];
    }
}
+(NSString *)port
{	
	return port;
}
+(void)setUserName:(NSString*) theName
{
	[userName release];
	userName=theName;
	[theName retain];
}
+(NSString *)userName
{
	
	return userName;
}


+(NSString *)isSucess
{
    return isSucess;
}

+(void)setIsSucess:(NSString *)theissucess
{
    [isSucess release];
	isSucess=theissucess;
	[theissucess retain];
}








+(void)setAutoUpdate:(NSString*)update
{
	[autoUpdate release];
	autoUpdate=update;
	[update retain];
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
	[time retain];
}
+(NSString *)mmpUpdateTime;
{
	return mmpUpdateTime;
}
+(void)setMmpUpdateTime:(NSString*) time
{
	[mmpUpdateTime release];
	mmpUpdateTime=time;
	[time retain];
}
+(NSString *)reportUpdateTime;
{
	return reportUpdateTime;
}
+(void)setReportUpdateTime:(NSString*) time
{
	[reportUpdateTime release];
	reportUpdateTime=time;
	[time retain];
}
+(NSString *)deviceID
{
    deviceID = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    return deviceID;
}
+(NSString *)currTime
{
    //实例化一个NSDateFormatter对象
   NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;

    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    return [dateFormatter stringFromDate:[NSDate date]];
}
#pragma mark   时间处理函数

+(NSInteger)getMonthDifference:(NSString *)startDate :(NSString *)endDate
{
    if (![startDate isPureInt]||
        ![endDate isPureInt]) {
        return -1;
    }
 
    NSInteger monthNum =0;
    NSInteger startYear= [[startDate substringToIndex:4] integerValue];
    NSInteger startMonth= [[startDate substringFromIndex:4] integerValue];
    NSInteger endYear= [[endDate substringToIndex:4] integerValue];
    NSInteger endMonth= [[endDate substringFromIndex:4] integerValue];
 
    if ([startDate integerValue]>[endDate integerValue] 
        || (startMonth<1||startMonth>12)
        || (endMonth<1||endMonth>12)){
        return  -2;
        
    }
    
    if (startYear==endYear) {
        monthNum= endMonth-startMonth+1;
    }
    else {
        monthNum= ((endYear-startYear)-1)*12+(12-startMonth)+endMonth+1;
    }
    return monthNum;
}


#pragma mark  计算两个时间段的和    [%d天%d小时%d分钟]  [%d天%d小时%d分钟]     string1/string2  [days,@"days",hours,@"hours",minutes,@"minutes"]
+(NSString *)getTotalTime:(NSMutableDictionary *)string1:(NSMutableDictionary *)string2 
{
    int hadd=0;
    int dadd=0;
    int m=0;
    int h =0;
    int d=0;
    NSString *str;  
    if (string1&&string2) {
        /**/
        /*
       NSLog(@"都不为空.........");
        NSLog(@"string1[%d]",string1.count    );
        NSLog(@"days:%@",[string1 objectForKey:@"days"]);
        NSLog(@"hours:%@",[string1 objectForKey:@"hours"]);
       NSLog(@"minutes:%@",[string1 objectForKey:@"minutes"]);
        NSLog(@"string2[%d]",string2.count   );
       NSLog(@"days:%@",[string2 objectForKey:@"days"]);
       NSLog(@"hours:%@",[string2 objectForKey:@"hours"]);
        NSLog(@"minutes:%@",[string2 objectForKey:@"minutes"]);
        */
        
        
        NSInteger mintues=[[string1 objectForKey:@"minutes"] intValue]+[[string2 objectForKey:@"minutes"] intValue];
        if (mintues>60) {
            hadd=mintues/60;
            
            m=mintues%60;
            
        }else {
            m=mintues;
        }
        NSInteger hours=[[string1 objectForKey:@"hours"] intValue]+[[string2 objectForKey:@"hours"] intValue]+hadd;
      //  hadd=0;
        if (hours>24) {
            dadd=hours/24;
            h=hours%24;
        }else {
            h=hours;
        }
        NSInteger days=[[string1 objectForKey:@"days"] intValue]+[[string2 objectForKey:@"days"] intValue]+dadd;
       // dadd=0;
        d=days;
        //可以不判断   先不改
        if(d!=0)
        {
            str=[NSString stringWithFormat:@"%d天%d小时%d分钟",d,h,m];
            return  str;
        }
        else if(d==0&&h!=0)
        {
            str=[NSString stringWithFormat:@"%d小时%d分钟",h,m];
            return str;
        }
        else if(d==0&&h==0&&m!=0)
        {
            str=[NSString stringWithFormat:@"%d分钟",m];
            return str;
        }else
        {
            
            str=@"0天0小时0分钟";
            return str;
            
        } 
        
    }else {
        str=@"0天0小时0分钟";
        
        return str;
    }
    
    
}

#pragma mark  指定格式formateStr @"yyyy/MM/dd"  格式化数据库里的字符串时间返回指定格式字符串 或 “未知”

+(NSString *)formaDateTime:(NSString *)string   FormateString:(NSString *)formateStr
{
    NSString *str;
    NSDateFormatter *formater=[[[NSDateFormatter alloc] init] autorelease];
    [formater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDateFormatter *formater1=[[[NSDateFormatter alloc] init] autorelease];
    [formater1 setDateFormat:@"yyyy/MM/dd"];
    NSDateFormatter *formater2=[[[NSDateFormatter alloc] init] autorelease];
    [formater2 setDateFormat:[NSString stringWithFormat:@"%@",formateStr]];
    
    
    NSString *date=[NSString  stringWithFormat:@"%@",        [formater1 stringFromDate:[formater dateFromString:string]]         ];
    NSString *date1=[NSString  stringWithFormat:@"%@",[formater2 stringFromDate:[formater dateFromString:string]]];
   // NSLog(@"formaDateTime---date--yyyy-MM-dd--:%@",date);
    if (![date isEqualToString:@"2000/01/01"]&&![date isEqualToString:@"1900/01/01"]&&![date isEqualToString:@"0001/01/01"]) {
        str=[NSString stringWithFormat:@"%@",date1]; 
        return str;
    }else {
        str=[NSString stringWithFormat:@"%@",@"未知"];
       // NSLog(@"未知：%@",date);
        return  str;
    }
    [date release];
    
   
   
}

#pragma mark 计算两个时间之间的时间段返回字典            [days,@"days",hours,@"hours",minutes,@"minutes"]     string1(yyyy-MM-dd HH:mm:ss) 和string2(yyyy-MM-dd HH:mm:ss)    

 +(NSMutableDictionary *)formatInfoDate1:(NSString *)string1 :(NSString *)string2 {
    
    NSMutableDictionary *d;
    if ([[PubInfo formaDateTime:string1   FormateString:@"yyyy/MM/dd"] isEqualToString:@"未知"]||[[PubInfo formaDateTime:string2  FormateString:@"yyyy/MM/dd"] isEqualToString:@"未知"]      ) {
        d=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",0],@"days",[NSString stringWithFormat:@"%d",0],@"hours",[NSString stringWithFormat:@"%d",0],@"minutes", nil];
        
    }else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *date1 = [formatter dateFromString:string1];
        NSDate *date2 = [formatter dateFromString:string2];
        NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
        unsigned int unitFlag = NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        
        NSDateComponents *components = [calendar components:unitFlag fromDate:date1 toDate:date2 options:0];
        int days    =fabs([components day]) ;
        int hours   = fabs([components hour]);
        int minutes =fabs([components minute]) ;
        
      //  NSLog(@"days :%d", days);
        //NSLog(@" hours :%d",hours);
        //NSLog(@" minutes :%d",minutes);
        
        
        d=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",days],@"days",[NSString stringWithFormat:@"%d",hours],@"hours",[NSString stringWithFormat:@"%d",minutes],@"minutes", nil];
      
        [formatter release];
        
    }
      [d autorelease];
    return d;
    
}


#pragma  mark  计算两个时间之间的时间段 返回 %d天%d小时%d分钟         string1(yyyy-MM-dd HH:mm:ss) 和string2(yyyy-MM-dd HH:mm:ss)    
+(NSString *)formatInfoDate:(NSString *)string1 :(NSString *)string2{
    
    NSString * str;
   // NSLog(@"formatInfoDate-string1:【%@】",[self formaDateTime:string1   FormateString:@"yyyy/MM/dd"]);
   // NSLog(@"formatInfoDate-string2:【%@】",[self formaDateTime:string2   FormateString:@"yyyy/MM/dd"]);
    
    if ([[self formaDateTime:string1   FormateString:@"yyyy/MM/dd"] isEqualToString:@"未知"]||[[self formaDateTime:string2   FormateString:@"yyyy/MM/dd"] isEqualToString:@"未知"]      ) {
        str=[NSString stringWithFormat:@"%@",@"0天0小时0分钟"];
        
        return  str;
        
    }else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *date1 = [formatter dateFromString:string1];
        NSDate *date2 = [formatter dateFromString:string2];
        NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
        unsigned int unitFlag = NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        
        NSDateComponents *components = [calendar components:unitFlag fromDate:date1 toDate:date2 options:0];
        int days    =fabs([components day]) ;
        int hours   = fabs([components hour]);
        int minutes =fabs([components minute]) ;
        
       // NSLog(@"days :%d", days);
       // NSLog(@" hours :%d",hours);
      //  NSLog(@" minutes :%d",minutes);
        [formatter release];
        
        if(days>=0&&hours>=0&&minutes>=0)
        {
            //先不改
            if(days!=0)
            {
                
                str=[NSString stringWithFormat:@"%d天%d小时%d分钟",days,hours,minutes];
                
                return str;
            }
            else if(days==0&&hours!=0)
            {
                str=[NSString stringWithFormat:@"0天%d小时%d分钟",hours,minutes];
                return str;
            }
            else if(days==0&&hours==0&&minutes!=0)
            {
                
                str=[NSString stringWithFormat:@"0天0小时%d分钟",minutes];
                
                return str;
            }
            else
            {

                str=@"0天0小时0分钟";
                return str;
            }
        }
        else
        {
            
            
            str=@"0天0小时0分钟";
            return str;
        }
        
    }
    
    
}

+ (BOOL)checkDeviceRegisterInfo{
    return YES;
}
+ (BOOL)checkDeviceVerificationInfo{
    return YES;
}


+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


@end
