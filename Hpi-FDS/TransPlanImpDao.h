//
//  TransPlanImpDao.h
//  Hpi-FDS
//
//  Created by tang bin on 12-9-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransPlanImpModel.h"
#import <sqlite3.h>

@interface TransPlanImpDao : NSObject

+(NSString *) dataFilePath;
+(void) openDataBase;




+(NSMutableArray *)GetTransPlanImpDataBySql;








@end
