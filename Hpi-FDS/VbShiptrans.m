//
//  VbShiptrans.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VbShiptrans.h"

@implementation VbShiptrans


@synthesize shipCompanyId,shipId,supId,typeId,heatValue,lw,lateFee,offEfficiency,facSort;

@synthesize disPatchNo,shipCompany,shipName,tripNo,factoryCode,factoryName,portCode,portName,supplier,coalType,keyValue,keyName,trade,tradeName,stage,stageName,stateCode,stateName,p_AnchorageTime,p_Handle,p_ArrivalTime,p_DepartTime,p_Note,t_Note,f_AnchorageTime,f_ArrivalTime,f_DepartTime,f_Note,schedule,planType,planCode,laycanStart,laycanStop,reciept,shipShift,tradeTime,F_FINISHTIME,iscal;

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
