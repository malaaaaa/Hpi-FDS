//
//  VbShiptrans.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VbShiptrans.h"

@implementation VbShiptrans




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
