//
//  HpiGraphView.h
//  Created by zcx on 04/25/2012.
//

#import <QuartzCore/QuartzCore.h>
#import "HpiGraphData.h"
@interface HpiGraphView : UIView{
	// DATA
	HpiGraphData *data;
	// BASE ELEMENTS
	UILabel *titleLabel;
	//上下左右留边大小, 
	NSInteger marginLeft,marginTop,marginRight,marginBottom;
}

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) HpiGraphData *data;
@property NSInteger marginLeft;
@property NSInteger marginTop;
@property NSInteger marginRight;
@property NSInteger marginBottom;

- (id) initWithFrame:(CGRect)frame :(HpiGraphData *) graphData ;
@end

