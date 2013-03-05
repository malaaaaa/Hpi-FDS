//
//  MemoirCell.h
//  Hpi-FDS
//
//  Created by zcx on 12-4-5.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoirCell : UITableViewCell{
    IBOutlet UIImageView* backimage;
    IBOutlet UIImageView* iconimage;
    IBOutlet UILabel* textlabel;
    IBOutlet UILabel* subtextlabel;
    //IBOutlet UIButton *button;
   // IBOutlet UIImageView *okimage;
    id delegate;
    id data;
    UIProgressView *processView;
    NSInteger index;
}
@property (nonatomic,retain) id delegate;
@property (nonatomic,retain) id data;
@property (nonatomic,retain) UIImageView* backimage;
@property (nonatomic,retain) UIImageView* iconimage;
//@property (nonatomic,retain) UIImageView* okimage;
@property (nonatomic,retain) UILabel* textlabel;
@property (nonatomic,retain) UILabel* subtextlabel;
//@property (nonatomic,retain) UIButton *button;
@property (nonatomic,retain) UIProgressView *processView;
@property NSInteger index;
//-(IBAction)buttonAction:(id)sender;
@end