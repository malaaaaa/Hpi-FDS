//
//  SetupViewController.m
//  Hpi-FDS
//
//  Created by zcx on 12-4-9.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "SetupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PubInfo.h"
#import "XMLParser.h"
@interface SetupViewController ()

@end

@implementation SetupViewController
@synthesize tableView,xmlParser,activity;
//定义 alter类型
UIAlertView *alert;

- (void)dealloc {
	if (tableView) {
		[tableView release];
	}
    if (xmlParser) {
        [xmlParser release];
    }
    if (activity) {
        [activity release];
    }
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"设置", @"6th");
        self.tabBarItem.image = [UIImage imageNamed:@"setup"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [tableView reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma tableview 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 1) {
		return @"系统信息";
	}else {
		return @"系统设置";
	}
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0) {
		return 3;
	}
	else {
		return 4;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	int section = [indexPath indexAtPosition:0];  
	int row = [indexPath indexAtPosition:1];
	NSLog(@"选择的是 第%d组，第%d行",section+1,row+1);
    //同步基础数据
	if ((section==0) && (row==1)) {
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell addSubview:activity];
        [activity startAnimating];
        if (!xmlParser) {
            self.xmlParser=[[[XMLParser alloc]init] autorelease];
//            self.xmlParser=[[XMLParser alloc]init];

        }
        [xmlParser setISoapNum:11];
        
        [TfCoalTypeDao deleteAll];
        [xmlParser getTfCoalType];
        [TfFactoryDao deleteAll];
        [xmlParser getTfFactory];
        [TfPortDao deleteAll];
        [xmlParser getTfPort];
        [TfShipCompanyDao deleteAll];
        [xmlParser getTfShipCompany];
        [TfSupplierDao deleteAll];
        [xmlParser getTfSupplier];
        [TsShipStageDao deleteAll];
        [xmlParser getTsShipStage];
        [TgFactoryDao deleteAll];
        [xmlParser getTgFactory];
        [TgPortDao deleteAll];
        [xmlParser getTgPort];
        [TgShipDao deleteAll];
        [xmlParser getTgShip];
        [TmIndexdefineDao deleteAll];
        [xmlParser getTmIndexdefine];
        [TmIndextypeDao deleteAll];
        [xmlParser getTmIndextype];

        [self runActivity];
	}
    if ((section==0) && (row==2)) {
    alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    [alert show];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	int section = [indexPath indexAtPosition:0];  
	int row = [indexPath indexAtPosition:1]; 
	
	static NSString *MyIdentifier = @"MyIdentifier";
	{
		UITableViewCell *cell=(UITableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
		if(cell==nil)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier] autorelease];
		}
		
		if (section==0)
		{
			switch(row)
			{
				case 0	:
					cell.textLabel.text=@"启动自动更新数据";
					UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectMake(310, 8.5, 500.0, 0.0)] autorelease];
					
					if([PubInfo.autoUpdate isEqualToString:kYES])
						switchView.on = YES;//设置初始为ON的一边
					else {
						switchView.on = NO;//设置初始为ON的一边
					}				
					[switchView addTarget:self action:@selector(switchPress:) forControlEvents:UIControlEventValueChanged];
					[cell addSubview:switchView];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					
					break;
				case 1	:
					cell.textLabel.text=[NSString stringWithFormat:@"更新基础数据  上次更新:%@",PubInfo.updateTime];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    if (!activity) {
                        self.activity=[[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(400, 8.5, 20, 20)] autorelease];
                                               self.activity=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(400, 8.5, 20, 20)];
   
                        [cell addSubview:activity];
                        [activity removeFromSuperview];
                        [activity release];
                    }
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;
                case 2	:
                    cell.textLabel.text=@"删除本地文件";
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
			}
		}
		else
		{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch(row)
			{
				case 0	:
                    cell.textLabel.text=[NSString stringWithFormat:@"用户: %@",PubInfo.userName];
                    break;
				case 1	:
                    cell.textLabel.text=[NSString stringWithFormat:@"本地文件大小: %@",[self getFileSize]];
                    break;
                case 2	:
                    cell.textLabel.text=[NSString stringWithFormat:@"本地文件数量: %d",[self getFileNum]];
                    break;
                case 3	:
                    cell.textLabel.text=@"版本信息: HFDS for iPad  V1.2";
                    break;
                    
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
		return cell;
		
	}
	
}
#pragma mark -
#pragma action
-(void)switchPress:(UISwitch*)inSwitch
{
	if(inSwitch.on ==YES)
	{
		PubInfo.autoUpdate=kYES;
	}
	else {
		PubInfo.autoUpdate=kNO;
	}
	[PubInfo save];
}

-(void)runActivity
{
    NSLog(@"aaaaaaaaaaa==========%d",xmlParser.iSoapNum);
    if ([xmlParser iSoapNum]==0) {
        [activity stopAnimating];
        [activity removeFromSuperview];
        if ([xmlParser iSoapTmIndexdefineDone]==2 && [xmlParser iSoapTmIndextypeDone]==2) {
            [activity stopAnimating];
            [activity removeFromSuperview];
            
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            //用[NSDate date]可以获取系统当前时间
            PubInfo.updateTime=[dateFormatter stringFromDate:[NSDate date]];
            [dateFormatter release];
            [PubInfo save];
            [tableView reloadData];
        }
        return;
    }
    else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runActivity) userInfo:NULL repeats:NO];
    }
}


- (unsigned long long int)folderSize:(NSString *)folderPath {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
	
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    } 
	
    return fileSize;
}

-(NSInteger)getFileNum{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [NSString stringWithFormat:@"%@/%@/",[paths objectAtIndex:0],@"Files"];
	NSLog(@"统计的路径是%@",path);

    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    return [filesArray count];
}


-(NSString *)getFileSize
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [NSString stringWithFormat:@"%@/%@/",[paths objectAtIndex:0],@"Files"];
	NSLog(@"统计的路径是%@",path);
    int app = [self folderSize:path]; 
    return [NSString stringWithFormat:@"%iMB",app/1024/1024];
}


-(void) msgbox
{
	alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [TsFileinfoDao updateDown];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [NSString stringWithFormat:@"%@/%@/",[paths objectAtIndex:0],@"Files"];
        NSLog(@"统计的路径是%@",path);
        NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
        NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
        NSString *fileName;
        while (fileName = [filesEnumerator nextObject]) {
            [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
        } 
		[self.tableView reloadData];
    }
    [alert release];
	alert = NULL;
	
}

@end
