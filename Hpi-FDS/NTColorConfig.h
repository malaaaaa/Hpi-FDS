//
//  NTColorConfig.h
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-26.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTColorConfig : NSObject{
    NSString *_TYPE;
    NSString *_ID;
    NSString *_RED;
    NSString *_GREEN;
    NSString *_BLUE;
}
@property(nonatomic,copy) NSString *TYPE;
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *RED;
@property(nonatomic,copy) NSString *GREEN;
@property(nonatomic,copy) NSString *BLUE;
@end
