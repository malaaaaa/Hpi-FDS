//
//  VbShiptrans.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VbShiptrans.h"

@implementation VbShiptrans

@synthesize p_AnchorageTime=p_AnchorageTime;
@synthesize shipName=shipName;
@synthesize p_Handle=p_Handle;
@synthesize lw=lw;
@synthesize schedule=schedule;
@synthesize tripNo=tripNo;
@synthesize factoryName=factoryName;
@synthesize factoryCode=factoryCode;
@synthesize f_DepartTime=f_DepartTime;
@synthesize portCode=portCode;
@synthesize f_Note=f_Note;
@synthesize p_ArrivalTime=p_ArrivalTime;
@synthesize lateFee=lateFee;
@synthesize laycanStart=laycanStart;
@synthesize laycanStop=laycanStop;
@synthesize portName=portName;
@synthesize t_Note=t_Note;
@synthesize p_Note=p_Note;
@synthesize p_DepartTime=p_DepartTime;
@synthesize supId=supId;
@synthesize offEfficiency=offEfficiency;
@synthesize reciept=reciept;
@synthesize planType=planType;
@synthesize supplier=supplier;
@synthesize coalType=coalType;
@synthesize f_AnchorageTime=f_AnchorageTime;
@synthesize f_ArrivalTime=f_ArrivalTime;
@synthesize typeId=typeId;
@synthesize planCode=planCode;
@synthesize tradeTime=tradeTime;
@synthesize keyName=keyName;
@synthesize keyValue=keyValue;
@synthesize F_FINISHTIME=F_FINISHTIME;
@synthesize iscal=iscal;
@synthesize tradeName=tradeName;
@synthesize trade=trade;
@synthesize shipShift=shipShift;
@synthesize facSort=facSort;
@synthesize disPatchNo=disPatchNo;
@synthesize stageName=stageName;
@synthesize heatValue=heatValue;
@synthesize shipCompany=shipCompany;
@synthesize shipCompanyId=shipCompanyId;
@synthesize stage=stage;
@synthesize stateCode=stateCode;
@synthesize stateName=stateName;
@synthesize shipId=shipId;


-(void)dealloc {
    [disPatchNo release];
    [shipCompany release];
    [shipName release];
    [tripNo release];
    [factoryCode release];
    [factoryName release];
    [portCode release];
    [portName release];
    [supplier release];
    [coalType release];
    [keyValue release];
    [keyName release];
    [trade release];
    [tradeName release];
    [stage release];
    [stageName release];
    [stateCode release];
    [stateName release];
    [p_AnchorageTime release];
    [p_Handle release];
    [p_ArrivalTime release];
    [p_DepartTime release];
    [p_Note release];
    [t_Note release];
    [f_AnchorageTime release];
    [f_ArrivalTime release];
    [f_DepartTime release];
    [f_Note release];
    [schedule release];
    [planType release];
    [planCode release];
    [laycanStart release];
    [laycanStop release];
    [reciept release];
    [shipShift release];
    [tradeTime release];
    [iscal release];
    [F_FINISHTIME release];
    [super dealloc];
}

@end
