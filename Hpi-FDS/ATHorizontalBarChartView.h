//
//  ATHorizontalBarChartView.h
//  Hpi-FDS
//  横版实现ATPagingView柱状图形式
//  Created by 馬文培 on 12-9-13.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATPagingView.h"
#import "PowerPlot_lib/PowerPlot.h"
@interface ATHorizontalBarChartView : UIView<ATPagingViewDelegate>{
    ATPagingView* myPV;
}
@property(nonatomic,retain)NSArray* ds;
@property(nonatomic,retain)NSIndexPath* curIndexPath;

@end
