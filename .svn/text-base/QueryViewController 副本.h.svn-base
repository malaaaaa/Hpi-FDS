//
//  QueryViewController.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot/CorePlot.h>
#define num 20
#define yLength 1000.0f
#define yIntervalLength   @"200"
#define ynum 10

@interface QueryViewController : UIViewController<CPPlotDataSource,UIScrollViewDelegate>{
//@private
    CPXYGraph * graph ;
    double x  [ num ];// 散点的 x 坐标
    double y1 [ num ];// 第 1 个散点图的 y 坐标
    double y2 [ num ];// 第 2 个散点图的 y 坐标
    IBOutlet UIView *graphView;
    UIPageControl *pageCtrl;
    UIScrollView *scrView;
}
@property(nonatomic,retain) UIPageControl *pageCtrl;
@property(nonatomic,retain) UIScrollView *scrView;
@end
