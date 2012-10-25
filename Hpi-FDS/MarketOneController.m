//
//  MarketOneController.m
//  Hpi-FDS
//
//  Created by Hoshino Wei on 12-5-15.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MarketOneController.h"
#import "DataGridComponent.h"
#import "PubInfo.h"
@interface MarketOneController ()

@end

@implementation MarketOneController
@synthesize popover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [popover release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)loadViewData :(NSString *)stringType :(NSDate*)startDay :(NSDate *)endDay :(NSString *)portCode
{
    int i;
    DataGridComponentDataSource *ds = [[DataGridComponentDataSource alloc] init];
    if([stringType isEqualToString:@"BSPI"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"300",@"300",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"平均价格",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmIndexinfoDao getTmIndexinfo :stringType :startDay :endDay];
        
        //[dateFormatter stringFromDate:endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmIndexinfo *tmIndexinfo=[array objectAtIndex:i];
            //NSLog(@" tmIndexinfo [%@][%@]",tmIndexinfo.recordTime,tmIndexinfo.infoValue);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                               [tmIndexinfo.recordTime substringWithRange:NSMakeRange(0, 10)],
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo.infoValue floatValue]],
                                nil]];
            
        }
        
       
        
    }
    else if([stringType isEqualToString:@"BDI"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"300",@"300",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"指数",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmIndexinfoDao getTmIndexinfo :stringType :startDay :endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmIndexinfo *tmIndexinfo=[array objectAtIndex:i];
            
           // NSLog(@" tmIndexinfo [%@][%@]",tmIndexinfo.recordTime,tmIndexinfo.infoValue);
            
            
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                [tmIndexinfo.recordTime substringWithRange:NSMakeRange(0, 10)] ,
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo.infoValue floatValue]],
                                nil]];
            
        }
    }
    else if([stringType isEqualToString:@"BJ_PRICE"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"200",@"200",@"200",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"价格",@"指数",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmIndexinfoDao getTmIndexinfo :stringType :startDay :endDay];
        NSMutableArray *array2=[TmIndexinfoDao getTmIndexinfo :@"BJ_INDEX" :startDay :endDay];
        
        
        
        
        
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmIndexinfo *tmIndexinfo=[array objectAtIndex:i];
            TmIndexinfo *tmIndexinfo2=[array2 objectAtIndex:i];
            NSLog(@" tmIndexinfo [%@][%@]",tmIndexinfo.recordTime,tmIndexinfo.infoValue);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                [tmIndexinfo.recordTime substringWithRange:NSMakeRange(0, 10)] ,
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo.infoValue floatValue]],
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo2.infoValue floatValue]],
                                nil]];
            
        }
    }
    else if([stringType isEqualToString:@"QHD_GZ"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"200",@"200",@"200",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"秦皇岛-广州",@"秦皇岛-上海",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmIndexinfoDao getTmIndexinfo :stringType :startDay :endDay];
        NSMutableArray *array2=[TmIndexinfoDao getTmIndexinfo :@"QHD_SH" :startDay :endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmIndexinfo *tmIndexinfo=[array objectAtIndex:i];
            TmIndexinfo *tmIndexinfo2=[array2 objectAtIndex:i];
            NSLog(@" tmIndexinfo [%@][%@]",tmIndexinfo.recordTime,tmIndexinfo.infoValue);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                 [tmIndexinfo.recordTime substringWithRange:NSMakeRange(0, 10)] ,
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo.infoValue floatValue]],
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo2.infoValue floatValue]],
                                nil]];
            
        }

    }
    else if([stringType isEqualToString:@"WTI"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"300",@"300",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"收盘价",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmIndexinfoDao getTmIndexinfo :stringType :startDay :endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmIndexinfo *tmIndexinfo=[array objectAtIndex:i];
          //  NSLog(@" tmIndexinfo [%@][%@]",tmIndexinfo.recordTime,tmIndexinfo.infoValue);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                [tmIndexinfo.recordTime substringWithRange:NSMakeRange(0, 10)] ,
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo.infoValue floatValue]],
                                nil]];
            
        }
    }
    else if([stringType isEqualToString:@"HPI4500"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"150",@"150",@"150",@"150",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"4500大卡",@"5000大卡",@"5500大卡",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmIndexinfoDao getTmIndexinfo :stringType :startDay :endDay];
        NSMutableArray *array2=[TmIndexinfoDao getTmIndexinfo :@"HPI5000" :startDay :endDay];
        NSMutableArray *array3=[TmIndexinfoDao getTmIndexinfo :@"HPI5500" :startDay :endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmIndexinfo *tmIndexinfo=[array objectAtIndex:i];
            TmIndexinfo *tmIndexinfo2=[array2 objectAtIndex:i];
            TmIndexinfo *tmIndexinfo3=[array3 objectAtIndex:i];
          //  NSLog(@" tmIndexinfo [%@][%@]",tmIndexinfo.recordTime,tmIndexinfo.infoValue);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                 [tmIndexinfo.recordTime substringWithRange:NSMakeRange(0, 10)] ,
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo.infoValue floatValue]],
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo2.infoValue floatValue]],
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo3.infoValue floatValue]],
                                nil]];
            
        }
    }
    else if([stringType isEqualToString:@"NEWC"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"300",@"300",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"纽卡斯尔港煤炭指数",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmIndexinfoDao getTmIndexinfo :stringType :startDay :endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmIndexinfo *tmIndexinfo=[array objectAtIndex:i];
         //   NSLog(@" tmIndexinfo [%@][%@]",tmIndexinfo.recordTime,tmIndexinfo.infoValue);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                [tmIndexinfo.recordTime substringWithRange:NSMakeRange(0, 10)] ,
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo.infoValue floatValue]],
                                nil]];
            
        }
    }
    else if([stringType isEqualToString:@"RB"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"300",@"300",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"南非理查德港指数",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmIndexinfoDao getTmIndexinfo :stringType :startDay :endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmIndexinfo *tmIndexinfo=[array objectAtIndex:i];
         //   NSLog(@" tmIndexinfo [%@][%@]",tmIndexinfo.recordTime,tmIndexinfo.infoValue);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                [tmIndexinfo.recordTime substringWithRange:NSMakeRange(0, 10)] ,
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo.infoValue floatValue]],
                                nil]];
            
        }
    }
    else if([stringType isEqualToString:@"DESARA"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"300",@"300",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"欧洲ARA煤炭市场指数",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmIndexinfoDao getTmIndexinfo :stringType :startDay :endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmIndexinfo *tmIndexinfo=[array objectAtIndex:i];
           // NSLog(@" tmIndexinfo [%@][%@]",tmIndexinfo.recordTime,tmIndexinfo.infoValue);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                 [tmIndexinfo.recordTime substringWithRange:NSMakeRange(0, 10)] ,
                                [NSString stringWithFormat:@"%.3f",[tmIndexinfo.infoValue floatValue]],
                                nil]];
            
        }
    }
    else if([stringType isEqualToString:@"GKDJL"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"300",@"300",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"港口调进(万吨)",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmCoalinfoDao getTmCoalinfo:portCode :startDay :endDay];
        
        //[dateFormatter stringFromDate:endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmCoalinfo *tmCoalinfo=[array objectAtIndex:i];
           // NSLog(@" tmCoalinfo [%@][%d]",tmCoalinfo.recordDate,tmCoalinfo.import);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                 [tmCoalinfo.recordDate substringWithRange:NSMakeRange(0, 10)] ,
                                [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%d",tmCoalinfo.import] floatValue]/10000],
                                nil]];
            
        }
    }
    else if([stringType isEqualToString:@"GKDCL"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"300",@"300",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"港口调出(万吨)",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmCoalinfoDao getTmCoalinfo:portCode :startDay :endDay];
        
        //[dateFormatter stringFromDate:endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmCoalinfo *tmCoalinfo=[array objectAtIndex:i];
          //  NSLog(@" tmCoalinfo [%@][%d]",tmCoalinfo.recordDate,tmCoalinfo.Export);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                [tmCoalinfo.recordDate substringWithRange:NSMakeRange(0, 10)] ,
                                //[NSString stringWithFormat:@"%d",tmCoalinfo.Export],
                                [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%d",tmCoalinfo.Export] floatValue]/10000],
                                nil]];
            
        }
    }
    else if([stringType isEqualToString:@"GKCML"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"300",@"300",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"港口存量(万吨)",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmCoalinfoDao getTmCoalinfo:portCode :startDay :endDay];
        
        //[dateFormatter stringFromDate:endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmCoalinfo *tmCoalinfo=[array objectAtIndex:i];
          //  NSLog(@" tmCoalinfo [%@][%d]",tmCoalinfo.recordDate,tmCoalinfo.storage);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                [tmCoalinfo.recordDate substringWithRange:NSMakeRange(0, 10)] ,
                                //[NSString stringWithFormat:@"%d",tmCoalinfo.storage],
                                [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%d",tmCoalinfo.storage] floatValue]/10000],
                                nil]];
            
        }
    }
    else if([stringType isEqualToString:@"ZGCS"]){
        ds.columnWidth = [NSArray arrayWithObjects:@"300",@"300",nil];
        ds.titles = [NSArray arrayWithObjects:@"日期",@"在港船数",nil];
        ds.data=[[[NSMutableArray alloc]init] autorelease];
        NSMutableArray *array=[TmShipinfoDao getTmShipinfo:portCode :startDay :endDay];
        
        //[dateFormatter stringFromDate:endDay];
        NSLog(@"查询 %@ 详细信息 %d条记录",stringType,[array count]);
        for (i=0;i<[array count];i++) {
            TmShipinfo *tmShipinfo=[array objectAtIndex:i];
          //  NSLog(@" tmCoalinfo [%@][%d]",tmShipinfo.recordDate,tmShipinfo.waitShip);
            [ds.data addObject:[NSArray arrayWithObjects:
                                kBLACK,
                                [tmShipinfo.recordDate substringWithRange:NSMakeRange(0, 10)] ,
                                [NSString stringWithFormat:@"%d",tmShipinfo.waitShip],
                                nil]];
            
        }
    } 
    
	DataGridComponent *grid = [[DataGridComponent alloc] initWithFrame:CGRectMake(0, 0, 600, 350) data:ds];
	[ds release];
	[self.view addSubview:grid];
	[grid release];
}

@end
