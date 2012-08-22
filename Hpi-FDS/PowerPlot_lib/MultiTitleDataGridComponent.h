//
//  MultiTitleDataGridComponent.h
//  Hpi-FDS
//
//  Created by tang bin on 12-8-15.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//


#import "DataGridComponent.h"

@interface MultiTitleDataGridComponent : DataGridComponent


-(void)fillData;
-(void)layoutSubView:(CGRect)aRect;

@end



@interface MultiTitleDataSource : DataGridComponentDataSource
{
    /**
     * 二层标题名称
     */
    NSMutableArray *splitTitle;
    
}



@property(retain) NSMutableArray *splitTitle;

@end
