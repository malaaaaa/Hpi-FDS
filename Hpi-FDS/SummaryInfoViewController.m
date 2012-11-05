//
//  SummaryInfoViewController.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-23.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "SummaryInfoViewController.h"

@interface SummaryInfoViewController ()

@end

@implementation SummaryInfoViewController
@synthesize popover;
@synthesize scroll;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{

    [super viewDidUnload];
     
    [scroll release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [scroll release];

  
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loadViewData
{
    
    //    //动态添加一个按钮
    //    CGRect frame = CGRectMake(330, 80, 100, 70);
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    button.frame = frame;
    //    [button setTitle:@"新添加的动态按钮" forState: UIControlStateNormal];
    //    button.backgroundColor = [UIColor clearColor];
    //    button.tag = 2000;
    //    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:button];
    self.scroll=[[DataGridScrollView alloc] initWithFrame:CGRectMake(0, 0, 1000, 300)];//960
    self.scroll.pagingEnabled=NO;
    self.scroll.delegate=self;
    CGSize newSize=CGSizeMake(1200, 300);//1120
    [self.scroll setContentSize:newSize];
    
    
    
    
    int intY = 0;
    for(int j = 0; j < 5; j++)
    {
        int intX = 0;
        if ((j+2)%2 != 0)
        {
            for(int i = 0; i < 14; i++)
            {
                NSLog(@"=====%d=====",i);
                if((i+2)%2 == 0)
                {
                    NSMutableArray *array=[TiListinfoDao getTiListinfo:(i+1+1)/2 :j+1];
                    NSLog(@"######%d#######",[array count]);
                    if ([array count]>0) {
                        if (i==10) {
                            TiListinfo *tiListinfo=[array objectAtIndex:0];
                            NSLog(@"shuang");
                            NSLog(@"**%d**%d**",i+1,j+1);
                            [self drawLabel:intX :intY :140-1 :60-1 :tiListinfo.title];
                            intX += 140;
                        }else
                        {
                        
                        
                            TiListinfo *tiListinfo=[array objectAtIndex:0];
                            NSLog(@"shuang");
                            NSLog(@"**%d**%d**",i+1,j+1);
                            [self drawLabel:intX :intY :100-1 :60-1 :tiListinfo.title];
                            intX += 100;
                        
                        
                        }
                        
                        
                        
                    }
                    
                }
                else
                {
                    NSMutableArray *array=[TiListinfoDao getTiListinfo:(i+1)/2 :j+1];
                    if ([array count]>0) {
                        
                        TiListinfo *tiListinfo=[array objectAtIndex:0];
                        NSLog(@"dan");
                        NSLog(@"**%d**%d**",i+1,j+1);
                        if(tiListinfo.decLength == 1)
                        {
                            [self drawLabel:intX :intY :60-1 :60-1 :[NSString stringWithFormat:@"%.1f",[tiListinfo.dataValue floatValue]]];
                        }
                        else if (tiListinfo.decLength == 2) {
                            [self drawLabel:intX :intY :60-1 :60-1 :[NSString stringWithFormat:@"%.2f",[tiListinfo.dataValue floatValue]]];
                        }
                        else if (tiListinfo.decLength == 3) {
                            [self drawLabel:intX :intY :60-1 :60-1 :[NSString stringWithFormat:@"%.3f",[tiListinfo.dataValue floatValue]]];
                        }
                        else {
                            [self drawLabel:intX :intY :60-1 :60-1 :[NSString stringWithFormat:@"%d",[tiListinfo.dataValue intValue]]];
                        }
                        intX += 60;
                    }
                }
            }
        }
        else
        {
            for(int i = 0; i < 14; i++)
            {
                NSLog(@"=====%d=====",i);
                if((i+2)%2 == 0)
                {
                    NSMutableArray *array=[TiListinfoDao getTiListinfo:(i+1+1)/2 :j+1];
                    if ([array count]>0) {
                        
                        if (i==10) {
                            NSLog(@"######%d#######",[array count]);
                            TiListinfo *tiListinfo=[array objectAtIndex:0];
                            NSLog(@"shuang");
                            NSLog(@"**%d**%d**",i+1,j+1);
                            [self drawLabel2:intX :intY :140-1 :60-1 :tiListinfo.title];
                            intX += 140;
 
                            
                        }else{
                        
                        
                            NSLog(@"######%d#######",[array count]);
                            TiListinfo *tiListinfo=[array objectAtIndex:0];
                            NSLog(@"shuang");
                            NSLog(@"**%d**%d**",i+1,j+1);
                            [self drawLabel2:intX :intY :100-1 :60-1 :tiListinfo.title];
                            intX += 100;
                        
                        
                        }
                        
                        
                        
                        
                       
                    }
                }
                else
                {
                    
                    
                    
                    
                    
                    
                    
                    NSMutableArray *array=[TiListinfoDao getTiListinfo:(i+1)/2 :j+1];
                    if ([array count]>0) {
                        
                        TiListinfo *tiListinfo=[array objectAtIndex:0];
                        NSLog(@"dan");
                        NSLog(@"**%d**%d**",i+1,j+1);
                        if(tiListinfo.decLength == 1)
                        {
                            [self drawLabel2:intX :intY :60-1 :60-1 :[NSString stringWithFormat:@"%.1f",[tiListinfo.dataValue floatValue]]];
                        }
                        else if (tiListinfo.decLength == 2) {
                            [self drawLabel2:intX :intY :60-1 :60-1 :[NSString stringWithFormat:@"%.2f",[tiListinfo.dataValue floatValue]]];
                        }
                        else if (tiListinfo.decLength == 3) {
                            [self drawLabel2:intX :intY :60-1 :60-1 :[NSString stringWithFormat:@"%.3f",[tiListinfo.dataValue floatValue]]];
                        }
                        else {
                            [self drawLabel2:intX :intY :60-1 :60-1 :[NSString stringWithFormat:@"%d",[tiListinfo.dataValue intValue]]];
                        }
                        intX += 60;
                    }
                }
            }
        }
        intY += 60;
    }
    
    
    
    
    [self.view addSubview:self.scroll];
    
    
    //    //创建uilabel
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    //    //设置背景色
    //    label.backgroundColor = [UIColor grayColor];
    //    //设置标签文本
    //    label.text = @"海进江发电量";
    //    //设置标签文本字体和字体大小
    //    label.font = [UIFont fontWithName:@"Arial" size:18];
    //    //设置文本对其方式
    //    label.textAlignment = UITextAlignmentCenter;
    //    //文本颜色
    //    label.textColor = [UIColor blueColor];
    //    //文本文字自适应大小
    //    label.adjustsFontSizeToFitWidth = YES;
    //    //文本高亮
    //    label.highlighted = YES;
    //    [self.view addSubview:label];
    //    [label release];
    //
    //    //创建uilabel
    //    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 60, 60)];
    //    //设置背景色
    //    label1.backgroundColor = [UIColor grayColor];
    //    //设置标签文本
    //    label1.text = @"123.4";
    //    //设置标签文本字体和字体大小
    //    label1.font = [UIFont fontWithName:@"Arial" size:18];
    //    //设置文本对其方式
    //    label1.textAlignment = UITextAlignmentCenter;
    //    //文本颜色
    //    label1.textColor = [UIColor blueColor];
    //    //文本文字自适应大小
    //    label1.adjustsFontSizeToFitWidth = YES;
    //    //文本高亮
    //    label1.highlighted = YES;
    //    [self.view addSubview:label1];
    //    [label1 release];
    //
     
}

- (void)drawLabel :(NSInteger)intX :(NSInteger)intY :(NSInteger)intWidth :(NSInteger)intHeight :(NSString *)text
{
 
    
    
    
    
    //创建uilabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(intX, intY, intWidth, intHeight)];
    //设置背景色
    label.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
    //设置标签文本
    label.text = text;
    //设置标签文本字体和字体大小
    label.font = [UIFont fontWithName:@"Arial" size:18];
    //设置文本对其方式
    label.textAlignment = UITextAlignmentCenter;
    //文本颜色
    label.textColor = [UIColor whiteColor];
    //文本文字自适应大小
    label.adjustsFontSizeToFitWidth = YES;
    //文本高亮
    label.highlighted = YES;
    
    
    
    [self.scroll addSubview:label];
    
    
    
    [label release];
}
- (void)drawLabel2 :(NSInteger)intX :(NSInteger)intY :(NSInteger)intWidth :(NSInteger)intHeight :(NSString *)text
{
    //创建uilabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(intX, intY, intWidth, intHeight)];
    //设置背景色
    label.backgroundColor = [UIColor colorWithRed:61.0/255 green:61.0/255 blue:61.0/255 alpha:1];
    //设置标签文本
    label.text = text;
    //设置标签文本字体和字体大小
    label.font = [UIFont fontWithName:@"Arial" size:18];
    //设置文本对其方式
    label.textAlignment = UITextAlignmentCenter;
    //文本颜色
    label.textColor = [UIColor whiteColor];
    //文本文字自适应大小
    label.adjustsFontSizeToFitWidth = YES;
    //文本高亮
    label.highlighted = YES;
    
    
     [self.scroll addSubview:label];
    [label release];
}

//这个是新按钮的响应函数
-(IBAction) buttonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"单击了动态按钮！"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];  
    [alert show];
    [alert release];
}

@end
