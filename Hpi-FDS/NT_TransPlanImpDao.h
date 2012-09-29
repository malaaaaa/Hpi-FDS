//
//  NT_TransPlanImpDao.h
//  Hpi-FDS
//
//  Created by tang bin on 12-9-14.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TransPlanImpModel.h"

#import <sqlite3.h>

@interface NT_TransPlanImpDao : NSObject

+(NSString *) dataFilePath;
+(void) openDataBase;
+(void)IntTb;

+(void)insert:(TransPlanImpModel *)model;

+(void)deleteAll;

+(NSMutableArray *)GetNT_TransPlanImpData:(SearchModel *)model;



+(NSMutableArray *)GetNT_TransPlanImpDataBySql:(NSString *)sql;


+(void  )getNT_TransPlanImp;
@end
