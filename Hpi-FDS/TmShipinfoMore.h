//
//  TmShipinfoMore.h
//  Hpi-FDS
//
//  Created by 馬文培 on 13-3-27.
//  Copyright (c) 2013年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TmShipinfo.h"
@interface TmShipinfoMore : TmShipinfo
{
    //继承实体对象TmShipinfo，增加days用于纪录天数,画折线图使用
    NSInteger days;
}
@property NSInteger days;
@end
