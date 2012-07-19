//
//  CSLabelAnnotationView.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-21.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "CSLabelAnnotationView.h"
#import "hpiAnnotation.h"
#import "util.h"

@implementation CSLabelAnnotationView
@synthesize label = _label;

#define kWidth  120
#define kHeight 20

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.backgroundColor = [UIColor clearColor];
    
    hpiAnnotation* csAnnotation = (hpiAnnotation *)annotation;   
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, -15, kWidth, kHeight)];
    _label.text=csAnnotation.topTitle;
    _label.backgroundColor=[UIColor clearColor];
    
    _label.font = [UIFont boldSystemFontOfSize:13.0f];
    _label.textColor = [UIColor whiteColor];
    _label.shadowColor = [UIColor blackColor];
    _label.shadowOffset = CGSizeMake(1.0, 1.0);

    self.image = csAnnotation.topImage;
    
    [self addSubview:_label];
    return self;
    
}

-(void) dealloc
{
    [_label release];
    [super dealloc];
}
@end
