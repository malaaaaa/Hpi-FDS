//
//  SuperViewDelegate.h
//  Hpi-FDS
//  操作父视图控件
//  Created by 馬文培 on 13-3-25.
//  Copyright (c) 2013年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SuperViewDelegate <NSObject>
@optional
#pragma mark 设置父视图上的控件文本
-(void)setControllerText:(NSString *)Text;
@end
