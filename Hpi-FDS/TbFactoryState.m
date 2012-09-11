//
//  TbFactoryState.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TbFactoryState.h"

@implementation TbFactoryState
@synthesize STID,FACTORYCODE,RECORDDATE,IMPORT,EXPORT,STORAGE,CONSUM,AVALIABLE,MONTHIMP,YEARIMP,ELECGENER,STORAGE7,TRANSNOTE,NOTE,MONTHCONSUM,YEARCONSUM;
-(void)dealloc {
    [FACTORYCODE release];
    [RECORDDATE release];
    [TRANSNOTE release];
    [NOTE release];
    [super dealloc];
}
@end
