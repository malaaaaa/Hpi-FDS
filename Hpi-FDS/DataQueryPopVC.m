//
//  DataQueryPopVC.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "DataQueryPopVC.h"

@interface DataQueryPopVC ()

@end

@implementation DataQueryPopVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"数据查询", @"5th");
        self.tabBarItem.image = [UIImage imageNamed:@"query"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat width =  self.view.frame.size.width;
    UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    
    toolBar.barStyle = UIBarButtonItemStyleBordered;
    [toolBar sizeToFit];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;//这句作用是切换时宽度自适应.
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPress:)];
    
    [toolBar setItems:[NSArray arrayWithObject:barItem]];
    
    [self.view addSubview:toolBar];
    [barItem release];

    [toolBar release];
    
    _vbFactoryTransVC=[[ VBFactoryTransVC alloc ]initWithNibName:@"VBFactoryTransVC" bundle:nil] ;
    _vbFactoryTransVC.view.frame = CGRectMake(0, 40, 1024,661 );
    [self.view addSubview:_vbFactoryTransVC.view];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void)dealloc {
   // NSLog(@"dealloc ok");
    [super dealloc];
}
-(void)buttonPress:(id)sender
{
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    //初始化待显示控制器
    menuView=[[DataQueryMenuVC alloc]init];
    //设置待显示控制器的范围
    [menuView.view setFrame:CGRectMake(0,0, 200, 700)];
    //设置待显示控制器视图的尺寸
    menuView.contentSizeForViewInPopover = CGSizeMake(200, 700);
    //初始化弹出窗口
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:menuView];
    menuView.popover = pop;
    menuView.parentView=self.view;
    self.popover = pop;
    self.popover.delegate = self;
    //设置弹出窗口尺寸
    self.popover.popoverContentSize = CGSizeMake(200, 615);
    //显示，其中坐标为箭头的坐标以及尺寸
    [self.popover presentPopoverFromRect:CGRectMake(30, 30, 5, 5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [menuView.tableView reloadData];
    [menuView release];
    [pop release];
    
    
   // NSLog(@"ToolBar Button taped.");
}
@end
