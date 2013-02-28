//
//  PortBehaviour.h
//  Hpi-FDS
//
//  Created by 馬文培 on 13-2-27.
//  Copyright (c) 2013年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PubInfo.h"

@interface PortBehaviour : NSObject{
    NSString *_date;
    NSString *_portName;
    double _importWeight;
    double _exportWeight;
    double _storage;
    NSInteger _shipNum;
}
@property(nonatomic,copy) NSString *date;
@property(nonatomic,copy) NSString *portName;
@property double importWeight;
@property double exportWeight;
@property double storage;
@property NSInteger shipNum;
@end


@interface PortBehaviourDao : NSObject
+(NSString  *) dataFilePath;
+(void) openDataBase;
+(NSMutableArray *) getPortBehaviour;

@end