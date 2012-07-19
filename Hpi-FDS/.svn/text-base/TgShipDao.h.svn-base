//
//  TgShipDao.h
//  Hfds
//
//  Created by zcx on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TgShip.h"

@interface TgShipDao : NSObject{
    
}
+(NSString *) dataFilePath;
+(void) openDataBase;
+(void) initDb;
+(void) insert:(TgShip*) tgShip;
+(void) delete:(TgShip*) tgShip;
+(NSMutableArray *) getTgShip:(NSInteger)ShipID;
+(NSMutableArray *) getTgShip;
+(NSMutableArray *) getTgShipBySql:(NSString *)sql;
+(NSMutableArray *) getTgShipZGPort:(NSString *)portName;
+(NSMutableArray *) getTgShipSZZTPort:(NSString *)portName;
+(NSMutableArray *) getTgShipZCPort:(NSString *)factoryName;
+(NSMutableArray *) getTgShipByName:(NSString *)shipName;
+(NSMutableArray *) getTgShipZTPort:(NSString *)chooseShip :(NSString *)chooseFactory :(NSString *)choosePort;
@end
