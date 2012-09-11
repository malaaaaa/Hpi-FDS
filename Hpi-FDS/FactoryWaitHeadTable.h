//
//  FactoryWaitHeadTable.h
//  Hpi-FDS
//
//  Created by tang bin on 12-8-29.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "DataGridComponent.h"

@interface FactoryWaitHeadTable : DataGridComponent

-(void)fillData;
-(void)layoutSubView:(CGRect)aRect;

- (id)initWithFrame:(CGRect)aRect data:(DataGridComponentDataSource*)aDataSource;
@end
