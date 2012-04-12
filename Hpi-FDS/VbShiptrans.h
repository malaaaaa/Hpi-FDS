//
//  VbShiptrans.h
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-3-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface VbShiptrans : NSObject
{
    NSString *disPatchNo;
    NSInteger shipCompanyId;
    NSString *shipCompany;
    NSInteger shipId;
    NSString *shipName;
    NSString *tripNo;
    NSString *factoryCode;
    NSString *factoryName;
    NSString *portCode;
    NSString *portName;
    NSInteger supId;
    NSString *supplier;
    NSInteger typeId;
    NSString *coalType;
    NSString *keyValue;
    NSString *keyName;
    NSString *trade;
    NSString *tradeName;
    NSInteger heatValue;
    NSString *stage;
    NSString *stageName;
    NSString *stateCode;
    NSString *stateName;
    NSInteger lw;
    NSString *p_AnchorageTime;
    NSString *p_Handle;
    NSString *p_ArrivalTime;
    NSString *p_DepartTime;
    NSString *p_Note;
    NSString *t_Note;
    NSString *f_AnchorageTime;
    NSString *f_ArrivalTime;
    NSString *f_DepartTime;
    NSString *f_Note;
    NSInteger lateFee;
    NSInteger offEfficiency;
    NSString *schedule;
    NSString *planType;
    NSString *planCode;
    NSString *laycanStart;
    NSString *laycanStop;
    NSString *reciept;
    NSString *shipShift;
    NSInteger facSort;
    NSString *tradeTime;
}

@property (nonatomic, retain) NSString *disPatchNo;
@property NSInteger shipCompanyId;
@property (nonatomic, retain) NSString *shipCompany;
@property NSInteger shipId;
@property (nonatomic, retain) NSString *shipName;
@property (nonatomic, retain) NSString *tripNo;
@property (nonatomic, retain) NSString *factoryCode;
@property (nonatomic, retain) NSString *factoryName;
@property (nonatomic, retain) NSString *portCode;
@property (nonatomic, retain) NSString *portName;
@property NSInteger supId;
@property (nonatomic, retain) NSString *supplier;
@property NSInteger typeId;
@property (nonatomic, retain) NSString *coalType;
@property (nonatomic, retain) NSString *keyValue;
@property (nonatomic, retain) NSString *keyName;
@property (nonatomic, retain) NSString *trade;
@property (nonatomic, retain) NSString *tradeName;
@property NSInteger heatValue;
@property (nonatomic, retain) NSString *stage;
@property (nonatomic, retain) NSString *stageName;
@property (nonatomic, retain) NSString *stateCode;
@property (nonatomic, retain) NSString *stateName;
@property NSInteger lw;
@property (nonatomic, retain) NSString *p_AnchorageTime;
@property (nonatomic, retain) NSString *p_Handle;
@property (nonatomic, retain) NSString *p_ArrivalTime;
@property (nonatomic, retain) NSString *p_DepartTime;
@property (nonatomic, retain) NSString *p_Note;
@property (nonatomic, retain) NSString *t_Note;
@property (nonatomic, retain) NSString *f_AnchorageTime;
@property (nonatomic, retain) NSString *f_ArrivalTime;
@property (nonatomic, retain) NSString *f_DepartTime;
@property (nonatomic, retain) NSString *f_Note;
@property NSInteger lateFee;
@property NSInteger offEfficiency;
@property (nonatomic, retain) NSString *schedule;
@property (nonatomic, retain) NSString *planType;
@property (nonatomic, retain) NSString *planCode;
@property (nonatomic, retain) NSString *laycanStart;
@property (nonatomic, retain) NSString *laycanStop;
@property (nonatomic, retain) NSString *reciept;
@property (nonatomic, retain) NSString *shipShift;
@property NSInteger facSort;
@property (nonatomic, retain) NSString *tradeTime;

@end
