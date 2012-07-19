//
//  VBFactoryTransDetailVC.m
//  Hpi-FDS
//
//  Created by 马 文培 on 12-7-12.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "VBFactoryTransDetailVC.h"

@interface VBFactoryTransDetailVC ()

@end

@implementation VBFactoryTransDetailVC
@synthesize popover;
@synthesize iDArray;
@synthesize parentView;
@synthesize labelView;
@synthesize listTableview;
static DataGridComponentDataSource *dataSource;

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
    dataSource = [[DataGridComponentDataSource alloc] init];
    //(20.20.985.42)
    dataSource.columnWidth = [NSArray arrayWithObjects:@"120",@"100",@"120",@"120",@"160",nil];
    dataSource.titles = [NSArray arrayWithObjects:@"调度单号",@"状态",@"船名",@"载重（吨）",@"备注",nil];
    float columnOffset = 0.0;
    [labelView removeFromSuperview];
    //填冲标题数据
	for(int column = 0;column < [dataSource.titles count];column++){
		float columnWidth = [[dataSource.columnWidth objectAtIndex:column] floatValue];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth -1, 40+2 )];
		l.font = [UIFont systemFontOfSize:16.0f];
		l.text = [dataSource.titles objectAtIndex:column];
        l.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtopbg"]];
		l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(0, -0.5);
		l.textAlignment = UITextAlignmentCenter;
        [self.labelView addSubview:l];
		[l release];
        columnOffset += columnWidth;
        
	}
    
    dataSource.data=[[NSMutableArray alloc]init];
    for (int i=0;i<[self.iDArray count];i++) {
        VbFactoryTrans *vbFactoryTrans = [iDArray objectAtIndex:i];
        [dataSource.data addObject:[NSArray arrayWithObjects:
                                    kBLACK,
                                    vbFactoryTrans.DISPATCHNO,
                                    vbFactoryTrans.STATENAME,
                                    vbFactoryTrans.SHIPNAME,
                                    [NSString stringWithFormat:@"%d",vbFactoryTrans.elw],
                                    vbFactoryTrans.T_NOTE,
                                    nil]];
        NSLog(@"shippppp==%@",vbFactoryTrans.SHIPNAME);
        
        
    }
    NSLog(@"test5==%d",[dataSource.data count]);
    
    [self.view addSubview:labelView];
    [listTableview reloadData];
    
    
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
  return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataSource.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    for (UIView *v in cell.subviews) {
        [v removeFromSuperview];
    }
    float columnOffset = 0.0;
    int iColorRed=0;
    //NSLog(@"rowData  count %d  at %d",[dataSource.data count],indexPath.row);
    NSArray *rowData = [dataSource.data objectAtIndex:indexPath.row];
    NSLog(@"rowdata==%d=%d=%@",indexPath.row,[indexPath row],[[dataSource.data objectAtIndex:indexPath.row] objectAtIndex:3]);
    
    for(int column=0;column<[rowData count];column++){
        //第1个字段表示是否显示红色字体
        if(column==0)
        {  
            if([[rowData objectAtIndex:0] intValue] == 1)
            {
                iColorRed=1;
            }
            else if([[rowData objectAtIndex:0] intValue] == 2)
            {
                iColorRed=2;
            }
            else
                iColorRed=0;
            
        }
        else
        {
            float columnWidth = [[dataSource.columnWidth objectAtIndex:column-1] floatValue];;
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth-1, 40 -1 )];
            l.font = [UIFont systemFontOfSize:14.0f];
            NSLog(@"l.text=%@",[rowData objectAtIndex:column]);
            l.text = [rowData objectAtIndex:column];
            l.textAlignment = UITextAlignmentCenter;
            l.tag = 40 + column + 1000;
            if(indexPath.row % 2 == 0)
                l.backgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1];
            else
                l.backgroundColor = [UIColor colorWithRed:49.0/255 green:49.0/255 blue:49.0/255 alpha:1];
            if (iColorRed==1) 
            {
                l.textColor=[UIColor redColor];
            }
            if (iColorRed==2) 
            {
                l.textColor=[UIColor colorWithRed:0.0/255 green:180.0/255 blue:90.0/255 alpha:1];
            }
            if (iColorRed==0) 
            {
                l.textColor=[UIColor whiteColor];
            }
            
            [cell addSubview:l];
            columnOffset += columnWidth;
            [l release];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:15.0/255 green:43.0/255 blue:64.0/255 alpha:1];
    // Configure the cell...
    
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return 40;
} 

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
