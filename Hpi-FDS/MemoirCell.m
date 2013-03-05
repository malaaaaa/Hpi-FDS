//
//  MemoirCell.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-5.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "MemoirCell.h"

@implementation MemoirCell
@synthesize backimage;//,okimage;
@synthesize iconimage;
@synthesize textlabel;
@synthesize subtextlabel;
//@synthesize	button;
@synthesize delegate;
@synthesize data;
@synthesize processView,index;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


/*
-(IBAction)buttonAction:(id)sender
{
	NSLog(@"button action");
	[self.delegate buttonAction:self];
}*/

- (void)dealloc {
    //self.okimage=nil;
    self.backimage=nil;
    self.iconimage=nil;
    self.textlabel=nil;
    self.subtextlabel=nil;
    //self.button=nil;
    self.processView=nil;
    [super dealloc];
}
@end
