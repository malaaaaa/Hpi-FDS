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
@synthesize tableView,xmlParser,activity,serverTextField,baseProgressview,mmpProgressview,reportProgressview;
@synthesize mmpTbxmlParser;
@synthesize reportTbxmlParser;


//定义 alter类型
UIAlertView *alert;
UIAlertView *serverAlert;
UIAlertView *cellAlert;
//基础数据总同步报文数量
static NSInteger baseRequestNum=0;
//地图市场港口总同步报文数量
static NSInteger mmpRequestNum=0;
//查询统计总同步报文数量
static NSInteger reportRequestNum=0;

static bool parserFlag=FALSE;
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
    if (serverTextField) {
        [serverTextField release];
    }
    self.baseProgressview=nil;
    self.mmpProgressview=nil;
    self.reportProgressview=nil;
    
    self.mmpTbxmlParser=nil;
    self.reportTbxmlParser=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"系统设置", @"6th");
        self.tabBarItem.image = [UIImage imageNamed:@"setup"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tableView.layer.masksToBounds=YES;
    tableView.layer.cornerRadius=5.0;
    flag=0;
    self.baseProgressview = [[UIProgressView alloc] init];
    self.mmpProgressview=[[UIProgressView alloc] init];
    self.reportProgressview=[[UIProgressView alloc] init];
    
    self.mmpTbxmlParser =[[TBXMLParser alloc] init];
    self.reportTbxmlParser =[[TBXMLParser alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [tableView reloadData];
}

- (void)viewDidUnload
{
    self.baseProgressview=nil;
    self.mmpProgressview=nil;
    self.reportProgressview=nil;
    
    self.mmpTbxmlParser=nil;
    self.reportTbxmlParser=nil;
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
		return 6;
	}
	else {
		return 4;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	int section = [indexPath indexAtPosition:0];
	int row = [indexPath indexAtPosition:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
	NSLog(@"选择的是 第%d组，第%d行",section+1,row+1);
    switch (section) {
        case 0:
            switch (row) {
                case 1:
                    alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
                    [alert show];
                    
                    break;
                case 3:
                    //基础数据同步
                    
                    [cell addSubview:baseProgressview];
                    [baseProgressview setFrame:CGRectMake(31, 32, 362, 3)];
                    
                    //        [cell addSubview:activity];
                    //        [activity startAnimating];
                    if (!xmlParser) {
                        self.xmlParser=[[[XMLParser alloc]init] autorelease];
                        //            self.xmlParser=[[XMLParser alloc]init];
                        
                    }
                    //        [xmlParser setISoapNum:11];
                    baseRequestNum=8;
                    [xmlParser setISoapNum:baseRequestNum];
                    [self processBaseData];
                    
                    [self runActivity];
                    
                    break;
                case 4:
                    //地图市场港口数据同步
                    if (!parserFlag) {
                        [cell addSubview:mmpProgressview];
                        parserFlag=TRUE;
                        [mmpProgressview setFrame:CGRectMake(31, 32, 362, 3)];
                        mmpRequestNum=8;
                        [mmpTbxmlParser setISoapNum:mmpRequestNum];
                        
                        //多次调用runActivity_mmp 是为了避免异步下mmpTbxmlParser.iSoapNum值异常
                        [mmpTbxmlParser requestSOAP:@"List"];
                        [self runActivity_mmp];
                        
                        [mmpTbxmlParser requestSOAP:@"TmIndex"];
                        [self runActivity_mmp];
                        
                        [mmpTbxmlParser requestSOAP:@"Coal"];
                        [self runActivity_mmp];
                        
                        [mmpTbxmlParser requestSOAP:@"Ship"];
                        [self runActivity_mmp];
                        [mmpTbxmlParser requestSOAP:@"TgPort"];
                        [self runActivity_mmp];

                        [mmpTbxmlParser requestSOAP:@"TgShip"];
                        [self runActivity_mmp];

                        [mmpTbxmlParser requestSOAP:@"TgFactory"];
                        [self runActivity_mmp];
                        
                        [mmpTbxmlParser requestSOAP:@"TransPlan"];
                        [self runActivity_mmp];

                    }
                    else{
                        cellAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请等待当前数据同步结束..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                        [cellAlert show];
                        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
                        
                    }
                    
                    break;
                case 5:
                    //数据查询模块同步
                    if (!parserFlag) {
                        [cell addSubview:reportProgressview];
                        parserFlag=TRUE;
                        [reportProgressview setFrame:CGRectMake(31, 32, 362, 3)];
                        reportRequestNum=13;
                        [reportTbxmlParser setISoapNum:reportRequestNum];
                        
                        
                        [reportTbxmlParser requestSOAP:@"OffLoadFactory"];
                        [self runActivity_report];
                        
                        [reportTbxmlParser requestSOAP:@"OffLoadShip"];
                        [self runActivity_report];
                        
                        [reportTbxmlParser requestSOAP:@"YunLi"];
                        [self runActivity_report];
                        
                        [reportTbxmlParser requestSOAP:@"ShipTrans"];
                        [self runActivity_report];
                        
                        [reportTbxmlParser requestSOAP:@"FactoryState"];
                        [self runActivity_report];
                        
                        [reportTbxmlParser requestSOAP:@"FactoryTrans"];
                        [self runActivity_report];
                        
                        [reportTbxmlParser requestSOAP:@"FactoryCapacity"];
                        [self runActivity_report];
                        
                        [reportTbxmlParser requestSOAP:@"TmIndex"];
                        [self runActivity_report];
                        
                        [reportTbxmlParser requestSOAP:@"TbLateFee"];
                        [self runActivity_report];
                        
                        [reportTbxmlParser requestSOAP:@"TransPorts"];
                        [self runActivity_report];
                        [reportTbxmlParser requestSOAP:@"ThShipTranS"];
                        [self runActivity_report];
                        [reportTbxmlParser requestSOAP:@"TransPlan"];
                        [self runActivity_report];
                        [reportTbxmlParser requestSOAP:@"TfShip"];
                        [self runActivity_report];
                        break;
                    }
                    else{
                        cellAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请等待当前数据同步结束..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                        [cellAlert show];
                        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
                        
                    }
                    
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    /*
     //同步基础数据
     if ((section==0) && (row==3)) {
     
     UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
     [cell addSubview:baseProgressview];
     [baseProgressview setFrame:CGRectMake(31, 32, 362, 3)];
     
     //        [cell addSubview:activity];
     //        [activity startAnimating];
     if (!xmlParser) {
     self.xmlParser=[[[XMLParser alloc]init] autorelease];
     //            self.xmlParser=[[XMLParser alloc]init];
     
     }
     //        [xmlParser setISoapNum:11];
     [xmlParser setISoapNum:baseRequestNum];
     [self processBaseData];
     
     [self runActivity];
     }
     if ((section==0) && (row==1)) {
     alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
     [alert show];
     }
     */
}
-(void) performDismiss:(NSTimer *)timer
{
    [cellAlert dismissWithClickedButtonIndex:0 animated:YES];
    [cellAlert release];
	cellAlert =  nil;
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
					cell.textLabel.text=@"地图数据自动更新";
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
                    cell.textLabel.text=@"删除本地文件";
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 2	:
                    
                    if (!serverTextField) {
                        serverTextField = [[UITextField alloc] initWithFrame:CGRectMake(75, 10, 280, 40)];
                        serverTextField.clearsOnBeginEditing = NO;//鼠标点上时，不清空
                        serverTextField.text=PubInfo.url;
                        [cell.contentView addSubview:serverTextField];
                        cell.textLabel.text=@"服务器: ";
                        [serverTextField setDelegate: self];
                        serverTextField.returnKeyType = UIReturnKeyDone;
                        [serverTextField addTarget:self action:@selector(textfieldDone:) forControlEvents:UIControlEventEditingDidEnd];
                        [serverTextField release];
                    }
                    
                    break;
                case 3	:
					cell.textLabel.text=[NSString stringWithFormat:@"更新基础数据  上次更新:%@",PubInfo.updateTime];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0] ];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (!activity) {
                        self.activity=[[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(400, 8.5, 20, 20)] autorelease];
                        
                    }
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;
                case 4	:
					cell.textLabel.text=[NSString stringWithFormat:@"更新地图市场港口数据  上次更新:%@",PubInfo.mmpUpdateTime];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0] ];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;
                case 5	:
					cell.textLabel.text=[NSString stringWithFormat:@"更新数据查询模块数据  上次更新:%@",PubInfo.reportUpdateTime];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0] ];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                    
                    cell.textLabel.text=[NSString stringWithFormat:@"版本信息: 华能燃料调运系统 for iPad  V%@",version];
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
    float curProgess = 1.0/baseRequestNum*(baseRequestNum-xmlParser.iSoapNum);
    baseProgressview.progress=curProgess;
    if ([xmlParser iSoapNum]==0) {
        [activity stopAnimating];
        [activity removeFromSuperview];
        if ([xmlParser iSoapTmIndexdefineDone]==2 && [xmlParser iSoapTmIndextypeDone]==2) {
            [activity stopAnimating];
            [activity removeFromSuperview];
            [baseProgressview removeFromSuperview];
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
//地图市场港口
-(void)runActivity_mmp
{
    
    float curProgess = 1.0/mmpRequestNum*(mmpRequestNum-mmpTbxmlParser.iSoapNum);
    mmpProgressview.progress=curProgess;
    if ([mmpTbxmlParser iSoapNum]==0) {
        [mmpProgressview removeFromSuperview];
        parserFlag=FALSE;
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        //用[NSDate date]可以获取系统当前时间
        PubInfo.mmpUpdateTime=[dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter release];
        [PubInfo save];
        [tableView reloadData];
        return;
    }
    else {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(runActivity_mmp) userInfo:NULL repeats:NO];
    }
}
//数据查询模块

-(void)runActivity_report
{
    float curProgess = 1.0/reportRequestNum*(reportRequestNum-reportTbxmlParser.iSoapNum);
    reportProgressview.progress=curProgess;
    
    if ([reportTbxmlParser iSoapNum]==0) {
        [reportProgressview removeFromSuperview];
        parserFlag=FALSE;
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        //用[NSDate date]可以获取系统当前时间
        PubInfo.reportUpdateTime=[dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter release];
        [PubInfo save];
        [tableView reloadData];
        return;
    }
    else {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(runActivity_report) userInfo:NULL repeats:NO];
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
    if (serverAlert==alertView) {
        NSLog(@"dismiss");
        [self.serverTextField becomeFirstResponder];
    }
    
}

- (IBAction)textfieldDone:(id)sender {
    [PubInfo setHostName:serverTextField.text];
    [PubInfo setPort:@""];
    [PubInfo save];
    flag=1;
    NSLog(@"done");
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing");  //测试用
    
    
    return  YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
    if (0==flag) {
        [self.serverTextField resignFirstResponder];
        serverAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该地址为后台服务器地址\n 请谨慎修改！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil,nil];
        [serverAlert show];
        [serverAlert release];
        
    }
}
//基础数据
- (void)processBaseData
{
    //增删函数后注意更新参数baseRequestNum数量
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
    [TmIndexdefineDao deleteAll];
    [xmlParser getTmIndexdefine];
    [TmIndextypeDao deleteAll];
    [xmlParser getTmIndextype];

}

@end
