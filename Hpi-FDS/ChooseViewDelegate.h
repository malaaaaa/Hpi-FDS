//
//  ChooseViewDelegate.h
//  Hpi-FDS
//
//  Created by bin tang on 12-8-2.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseViewDelegate <NSObject>
@optional
-(void)setLableValue:(NSString *)currentSelectValue;
//多选控件代理方法
-(void)multipleSelectViewdidSelectRow:(NSInteger)indexPathRow;

@end
