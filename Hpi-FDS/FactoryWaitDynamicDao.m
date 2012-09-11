//
//  FactoryWaitDynamicDao.m
//  Hpi-FDS
//
//  Created by tang bin on 12-8-31.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "FactoryWaitDynamicDao.h"
#import "TbFactoryState.h"

#import "TbFactoryStateDao.h"
#import "TfFactory.h"

#import "TfFactoryDao.h"

#import "TF_FACTORYCAPACITYDao.h"
#import "TF_FACTORYCAPACITY.h"
static sqlite3  *database;
@implementation FactoryWaitDynamicDao


+(NSString *)dataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory=[paths objectAtIndex:0];
    NSString *path=[documentsDirectory  stringByAppendingPathComponent: @"database.db"  ];
    
    return  path;
}

+(void) openDataBase
{
	NSString *file=[self dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		//NSLog(@"open  database error");
		return;
	}
	
}

//公共条件   电厂名  时间  来查询中间表数据
+(NSMutableArray *)getMidDate:(NSDate *)stringTime:(NSString *)factoryName
{
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    float monthP=[TbFactoryStateDao GetMonthPort:stringTime :factoryName];
    float yeasP=[TbFactoryStateDao GetYearPort:stringTime :factoryName];
    float  monthE=[TbFactoryStateDao GetMonthConsum:stringTime :factoryName];
    float yeasE=[TbFactoryStateDao GetYearConsum:stringTime  :factoryName];
    
    
  
    NSString *unies= [NSString stringWithFormat:@"%@",[TF_FACTORYCAPACITYDao GetUnits:factoryName]];
    NSMutableArray *tfcapacity= [TF_FACTORYCAPACITYDao GetCapaCityByName:factoryName];
    
    
    NSString *s=@" ";
    for (int i=0; i<[tfcapacity count]; i++) {
        TF_FACTORYCAPACITY *t=[tfcapacity objectAtIndex:i];
        s=[s stringByAppendingFormat:@"%d*%.2f",t.UNITS,t.CAPACITY ];
    }
    
   TfFactory *tf1=[TfFactoryDao getTfFactoryByName:factoryName];
   TbFactoryState *tbS=[TbFactoryStateDao getStateBySql:factoryName :stringTime];
    
    NSMutableArray *d=[[NSMutableArray alloc] init];

    NSLog(@"tf1.DESCRIPTION=================== [%@]",tf1.DESCRIPTION);
    NSMutableArray *arr1= [ [NSMutableArray alloc] initWithObjects:
                       tf1.DESCRIPTION,
                       unies,
                       s,
                       tf1.MAXSTORAGE==0?@"0.00":  [NSString stringWithFormat:@"%.2f",tf1.MAXSTORAGE/10000.00   ]  ,
                       tf1.CHANNELDEPTH   , nil];
    [d addObject:arr1];
    
    NSMutableArray *arr2= [[NSMutableArray alloc] initWithObjects:
       tbS.ELECGENER==0?@"0.00":[NSString stringWithFormat:@"%.2f", tbS.ELECGENER/10000.00 ] ,
        monthP==0?@"0.00": [NSString stringWithFormat:@"%.2f",monthP/10000.00 ],
       yeasP==0?@"0.00": [NSString stringWithFormat:@"%.2f",yeasP/10000.00],
        monthE==0?@"0.00": [NSString stringWithFormat:@"%.2f",monthE/10000.00]  ,
        yeasE==0?@"0.00": [NSString stringWithFormat:@"%.2f", yeasE/10000.00],
                           nil ];

    [d addObject:arr2];
    
    
    NSMutableArray *arr3= [[NSMutableArray alloc] initWithObjects:
                         tbS.STORAGE7==0?@"0.00":   [NSString stringWithFormat:@"%.2f",tbS.STORAGE7/10000.00 ],
                          tbS.TRANSNOTE==nil?@"":tbS.TRANSNOTE,
                           nil];
    [d addObject:arr3];
    

    
    NSMutableArray *arr4=[[NSMutableArray  alloc] initWithObjects:tbS.NOTE==nil?@"":tbS.NOTE,nil];
    [d addObject:arr4];

       
    [d autorelease];
    [arr1 release];
    [arr2    release];
    [arr3 release];
    [arr4 release];
    [f release];
    return d;

}

/***************************底部表数据查询**********************************************/



















@end
