//
//  TBXMLParser.m
//  Hpi-FDS
//  采用TBXML方式解析，经测试，解析速度是NSXMLParser的3-4倍
//  Created by 馬文培 on 12-8-15.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TBXMLParser.h"
#import <objc/runtime.h>
#import "TF_FACTORYCAPACITYDao.h"
#import "TfShipDao.h"
#import "TB_OFFLOADSHIPDao.h"
#import "TB_OFFLOADFACTORYDao.h"

@implementation TBXMLParser
@synthesize Identification=_Identification;

static int iSoapDone=1; //1未开始 0进行中 3出错
static int iSoapNum=0;
static sqlite3  *database;
UIAlertView *alert;
NSString* alertMsg;
static bool ThreadFinished=TRUE;



- (void)requestSOAP:(NSString *)identification
{
    //由于NSURLConnection是异步方式，加入对当前RunLoop的控制，等待其他进程完成解析后再进行下一个请求的调用。
    while(!ThreadFinished) {
        //        NSLog(@"runloop");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
    }
    self.Identification=identification;
    
    //出错
    if (iSoapDone==3) {
       
       iSoapNum--;
        if (iSoapNum<1) {
            iSoapDone=1;
        }
        return;
    }
    iSoapDone=0;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                             "<soap12:Body>\n"
                             "<Get%@Info xmlns=\"http://tempuri.org/\">\n"
                             "<req>\n"
                             "<deviceid>%@</deviceid>\n"
                             "<version>%@</version>\n"
                             "<updatetime>%@</updatetime>\n"
                             "</req>\n"
                             "</Get%@Info>\n"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>\n",_Identification,PubInfo.deviceID,version,PubInfo.currTime,_Identification];
    NSLog(@"soapMessage[%@]",soapMessage);
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSURL *url = [NSURL URLWithString:PubInfo.baseUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 请求
    NSURLConnection *theConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        NSLog(@"yes connect");
        
        ThreadFinished=FALSE;
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    NSLog(@"dddddddddddd");
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
    NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    
}
-(void) msgbox
{
  
	alert = [[UIAlertView alloc]initWithTitle:@"提示" message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
    
	[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    
}
-(void) performDismiss:(NSTimer *)timer
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert release];
	alert =  nil;
}
//如果没有连接网络，则出现此信息（不是网络服务器不通）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"--------------------------------------------ERROR with theConenction");
    //    [connection release];
    [webData release];
    iSoapDone=3;
    alertMsg = @"无法连接,请检查网络是否正常?";
    [self msgbox];
    iSoapDone=1;
    iSoapNum--;
    //    if (iSoapNum==0) {
    //        iSoapDone=1;
    //    }
    //    iSoapNum=0;
    ThreadFinished = TRUE;
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"--------------------------------------------  connectionDidFinishLoading");
//    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
     NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:6 encoding:NSUTF8StringEncoding];
    //没找到其它办法，通过返回报文前6位字符串判断是否出错，需要验证
    if ([theXML isEqualToString:@"<html>"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"调用后台服务出错！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        iSoapDone=1;
        iSoapNum=0;

    }
    else{
        [self parseXML];
    }
//  NSLog(@"theXML[%@]",theXML);
    [theXML release];

    ThreadFinished = TRUE;

    [webData release];
}
/*!
 @method parseXML
 @author 马文培
 @version 1.0
 @abstract TBXML方式解析，批量写入数据库
 @discussion 用法
 @param 参数说明
 @result 返回结果
 */
#pragma mark -参数：1，xml子节点【TfCoalType】  2，表的对应实体类 3，插入的表名

-(void)parseXML
{
    /***********************TfCoalType**********************/
    if ([_Identification isEqualToString:@"CoalType"]) {
        [TfCoalTypeDao deleteAll];
        [self getDate:@"TfCoalType" entityClass:@"TfCoalType" insertTableName:@"TfCoalType"];
    }
    
    /****************************实时船舶查询-VbShiptrans**************************/
    if ([_Identification isEqualToString:@"ShipTrans"]) {
        //先清空表  数据
        [VbShiptransDao deleteAll];
        //调用  解析
        [self getDate:@"VbShipTrans" entityClass:@"VbShiptrans" insertTableName:@"VbShiptrans"];
    }
    
    /****************************调度日志**************************/
    
    if ([_Identification isEqualToString:@"ThShipTrans"]) {
        [TH_ShipTransDao deleteAll];
        
        [self getDate:@"VbThShipTrans" entityClass:@"TH_ShipTrans" insertTableName:@"Th_ShipTrans"];
        
    }
    /****************************电厂动态查询-FactoryTrans**************************/
    if ([_Identification isEqualToString:@"FactoryTrans"]) {
        //全部删除
        [VbFactoryTransDao deleteAll];
        [self getDate:@"VbFactoryTrans" entityClass:@"VbFactoryTrans" insertTableName:@"VbFactoryTrans"];
    }
    /****************************电厂动态查询-FactoryState**************************/
    if ([_Identification isEqualToString:@"FactoryState"]) {
        //全部删除
        [TbFactoryStateDao deleteAll];
        //TbFactoryState
        
        [self getDate:@"TbFactoryState" entityClass:@"TbFactoryState" insertTableName:@"TbFactoryState"];
    }
    
       /**************************电厂信息基础表******************************/
    if ([_Identification isEqualToString:@"Factory"]) {
        //全部删除
        [TfFactoryDao deleteAll];
        [self getDate:@"TfFactory" entityClass:@"TfFactory" insertTableName:@"TfFactory"];
    }
    /******************************滞期费vb*****************************/
    if ([_Identification isEqualToString:@"LateFee"]) {
        [VB_LatefeeDao deleteAll];
        [self getDate:@"VbLateFee" entityClass:@"VB_Latefee" insertTableName:@"VB_Latefee"];
    }
    /******************************滞期费tb*****************************/
    if ([_Identification isEqualToString:@"TbLateFee"]) {
        [TB_LatefeeDao deleteAll];
        [self getDate:@"TbLateFee" entityClass:@"TB_Latefee" insertTableName:@"TB_Latefee"];
    }
    /****************************航运公司份额统计-NTShipCompanyTranShare**************************/
    if ([_Identification isEqualToString:@"TransPorts"]) {
        //全部删除
        [NTShipCompanyTranShareDao deleteAll];
        [self getDate:@"VbTransPorts" entityClass:@"NTShipCompanyTranShare" insertTableName:@"NTShipCompanyTranShare"];
    }
    /****************************电厂运力运量统计-NTFactoryFreightVolume**************************/
    if ([_Identification isEqualToString:@"YunLi"]) {
        
        //全部删除
        [NTFactoryFreightVolumeDao deleteAll];
        [self getDate:@"YunLi" entityClass:@"NTFactoryFreightVolume" insertTableName:@"NTFactoryFreightVolume"];
    }
    /****************************航运计划-vbTransplan**************************/
    if ([_Identification isEqualToString:@"TransPlan"]) {
        //全部删除
        [VbTransplanDao deleteAll];
        
        [self getDate:@"VbTransPlan" entityClass:@"VbTransplan" insertTableName:@"VbTransplan"];
        
    }
    /****************************市场指数-TmIndexinfo**************************/
    if ([_Identification isEqualToString:@"TmIndex"]) {
        //全部删除
        [TmIndexinfoDao deleteAll];
        [self getDate:@"TmIndexInfo" entityClass:@"TmIndexinfo" insertTableName:@"TmIndexinfo"];
    }
    
    
    /***************GetTmIndexDefineInfo************市场指数-定义TmIndexdefine**************************/
    if ([_Identification isEqualToString:@"TmIndexDefine"]) {
        //全部删除
        [TmIndexdefineDao deleteAll];
        [self getDate:@"TmIndexDefine" entityClass:@"TmIndexdefine" insertTableName:@"TmIndexdefine"];
    }
    
    
    /***********GetTmIndexTypeInfo*****************市场指数类型信息-TmIndexinfo**************************/
    if ([_Identification isEqualToString:@"TmIndexType"]) {
        //全部删除
        [TmIndextypeDao deleteAll];
        [self getDate:@"TmIndexType" entityClass:@"TmIndextype" insertTableName:@"TmIndextype"];
    }
    
    
    
    
    
    
    /****************************港口信息-TmCoalinfo**************************/
    if ([_Identification isEqualToString:@"Coal"]) {
        //全部删除
        [TmCoalinfoDao deleteAll];
        [self getDate:@"TmCoalInfo" entityClass:@"TmCoalinfo" insertTableName:@"TmCoalinfo"];
    }
    /***********************船舶信息*****-ShipInfo**************************/

     if ([_Identification isEqualToString:@"Ship"]) {
    
         //全部删除
         [TmShipinfoDao deleteAll];
 [self getDate:@"TmShipInfo" entityClass:@"TmShipinfo" insertTableName:@"TmShipinfo"];
    
     }

     /***********************电厂信息*****-**************************/
  //tgFactory   
    if ([_Identification isEqualToString:@"TgFactory"]) {
        
        //全部删除 GetTgFactoryInfo
        [TgFactoryDao deleteAll];
        [self getDate:@"TgFactory" entityClass:@"TgFactory" insertTableName:@"TgFactory"];
        
    }
 
  /******************获取电厂机组运行信息**********TF_FACTORYCAPACITY**************************/
    
    if ([_Identification isEqualToString:@"FactoryCapacity"]) {
        
        //全部删除  GetFactoryCapacityInfo
        [TF_FACTORYCAPACITYDao deleteAll];
        [self getDate:@"TfFactoryCapacity" entityClass:@"TF_FACTORYCAPACITY" insertTableName:@"TF_FACTORYCAPACITY"];
        
    }

    
  /****************************TB_OFFLOADSHIP**************************/
    
    if ([_Identification isEqualToString:@"OffLoadShip"]) {
        
        //全部删除   GetOffLoadShipInfo
        [TB_OFFLOADSHIPDao deleteAll];
        [self getDate:@"OffLoadShip" entityClass:@"TB_OFFLOADSHIP" insertTableName:@"TB_OFFLOADSHIP"];
        
    }
    /****************************TB_OFFLOADFACTORY**************************/
    
    if ([_Identification isEqualToString:@"OffLoadFactory"]) {
        
        //全部删除  GetOffLoadFactoryInfo
        [TB_OFFLOADFACTORYDao deleteAll];
        [self getDate:@"OffLoadFactory" entityClass:@"TB_OFFLOADFACTORY" insertTableName:@"TB_OFFLOADFACTORY"];
        
    }
 
    
    /****************************TfShip************************GetTfShipInfo**/
    if ([_Identification isEqualToString:@"TfShip"]) {
        //全部删除   GetTfShipInfo
        [TfShipDao deleteAll];
        [self getDate:@"TfShip" entityClass:@"TfShip" insertTableName:@"TfShip"];
        
    }

//    if ([_Identification isEqualToString:@"TsFile"]) {
//        
//        //全部删除
//        [TsFileinfoDao deleteAll];
//        [self getDate:@"TsFileinfo" entityClass:@"TsFileinfo" insertTableName:@"TsFileinfo"];
//        
//    }
    /****************************船舶动态查询**************************/
    
    if ([_Identification isEqualToString:@"ThShipTranS"]) {
        [TH_SHIPTRANS_ORIDAO deleteAll];
        
        [self getDate:@"ThShipTranS" entityClass:@"TH_SHIPTRANS_ORI" insertTableName:@"TH_SHIPTRANS_ORI"];
        
    }
}
#pragma mark -参数：1，xml子节点【TfCoalType】  2，表的对应实体类 3，插入的表名
-(void)getDate :(NSString *)element1  entityClass:(NSString *)className    insertTableName:(NSString *)tableName
{
    NSString *elementString1= [NSString stringWithFormat:@"Get%@InfoResult",_Identification];
    NSString *elementString2= [NSString stringWithFormat:@"Get%@InfoResponse",_Identification];
    
    char *errorMsg;
    NSLog(@"start Parser");
    NSError *error = nil;
    NSLog(@"webData length %d", [webData length]);
    tbxml = [TBXML newTBXMLWithXMLData:webData error:&error];
    
    if (error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        
    } else {
        TBXMLElement * root = tbxml.rootXMLElement;
        //=======================================
        if (root) {
            
            
            NSLog(@"elementString1[%@]",elementString1);
            NSLog(@"elementString2[%@]",elementString2);
            TBXMLElement *elementNoUsed = [TBXML childElementNamed:@"retinfo" parentElement:[TBXML childElementNamed:elementString1 parentElement:[TBXML childElementNamed:elementString2 parentElement:[TBXML childElementNamed:@"soap:Body" parentElement:root]]]];
            
            /*
        
            if ([TBXML childElementNamed:elementString1 parentElement:[TBXML childElementNamed:elementString2 parentElement:[TBXML childElementNamed:@"soap:Body" parentElement:root]]]) {
                NSLog(@"dddddddddddd");
            }
            if ( [TBXML childElementNamed:@"soap:Body" parentElement:root]) {
                NSLog(@"sssssssssssssss");
            }
            
            
            
            NSLog(@"element1[%@]",element1);
            if (elementNoUsed) {
                NSLog(@"=================");
            }
            */
                TBXMLElement *element = [TBXML childElementNamed:element1 parentElement:elementNoUsed];
            
           //  NSLog(@"element==================");
            
                //打开数据库
               	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *file= [documentsDirectory stringByAppendingPathComponent:@"database.db"];
                
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"open  database error");
                    return;
                }else
                {
                  NSLog(@"open  database ");
                
                }
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                //动态调用某个类的方法
                sqlite3_stmt *statement;
                id LenderClass = objc_getClass([className UTF8String]);//要不要释放
                NSUInteger outCount;
                objc_property_t *properties = class_copyPropertyList(LenderClass, &outCount);
                NSString *columName=@" ";
                NSString *columValue=@" ";
            if (_Identification==@"OffLoadFactory") {
                
                outCount=10;
            }

            if (_Identification==@"FactoryTrans") {
                outCount=16;
            }
            if (_Identification==@"CoalType") {
                outCount=5;
                
            }
            if (_Identification==@"TgPort") {
                outCount=9;
                
            }
            if (_Identification==@"TgShip") {
                outCount=28;
              
            }
            if(_Identification==@"TransPorts"){
                outCount=7;
                
            }
            if(_Identification==@"YunLi"){
                
                outCount=6;
            }
            if (_Identification==@"TgFactory") {
                
                outCount=13;
            }
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                NSString *propertyName=[[NSString alloc] initWithFormat:@"%s",property_getName(property)];
                columName=[columName stringByAppendingFormat:@"%@,",propertyName];//多一个
                columValue=[columValue stringByAppendingFormat:@"%@",@"?,"];//多一个
                [propertyName release];
            }
            columName=[columName substringWithRange:NSMakeRange(0,[columName length]-1)];
            columValue=[columValue substringWithRange:NSMakeRange(0,[columValue length]-1)];
            TBXMLElement * desc;
            NSString *sql=[NSString stringWithFormat:@"INSERT INTO %@ (%@) values(%@)",tableName,columName,columValue];
            NSLog(@"==============sql[%@]",sql);
                while (element != nil) {
                    
                    int re =sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL);
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),[sql UTF8String]);
                    }
                    for (int i = 0; i < outCount; i++) {
                        // objc_property_t property = *properties++;
                        objc_property_t property = properties[i];
                        NSString *propertyName=[[NSString alloc] initWithFormat:@"%s",property_getName(property)]; 
                        NSString *type=[[NSString    alloc] initWithFormat:@"%s",property_getAttributes(property)];
                        desc = [TBXML childElementNamed:[propertyName uppercaseString] parentElement:element];
                        if (desc != nil) {
                            if ([type rangeOfString:@"NSString"].length!=0) {
                                sqlite3_bind_text(statement, i+1, [[TBXML textForElement:desc]
                                                                   UTF8String], -1, SQLITE_TRANSIENT);
                            }
                          if ([type rangeOfString:@"Ti,"].length!=0){
                                sqlite3_bind_int(statement, i+1,[[TBXML textForElement:desc] integerValue]);
                            }
                         if ([type rangeOfString:@"Td,"].length!=0){
                                sqlite3_bind_double(statement, i+1,[[TBXML textForElement:desc] doubleValue]);
                            } 
                        }
                        [propertyName release];
                        [type release];
                    }                
                    re=sqlite3_step(statement);
                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert error with message [%s]  sql[%s]", sqlite3_errmsg(database),[sql UTF8String]);
                        sqlite3_finalize(statement);
                        return;  
                    }else {
                        //NSLog(@"insert shipTrans  SUCCESS");

                    }
                sqlite3_finalize(statement);
                //element1   :TfCoalType
                element = [TBXML nextSiblingNamed:element1 searchFromElement:element];
            }
            
            if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                sqlite3_close(database);
                NSLog(@"exec commit error");
                return;
            }
            sqlite3_close(database);
            NSLog(@"-----------%@-----------commit over  ",_Identification);
            iSoapDone=1;
            iSoapNum--;
        
            
        
        
        
       }

    }


}

-(void)test
{
    char *errorMsg;
    NSLog(@"start test");

    
    //打开数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file= [documentsDirectory stringByAppendingPathComponent:@"database.db"];

    if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"open  database error");
        return;
    }else
    {
        NSLog(@"open  database ");
        
    }
    //为提高数据库写入性能，加入事务控制，批量提交
    if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec begin error");
        return;
    }
    //动态调用某个类的方法
    sqlite3_stmt *statement;

/*直接读取Document的文件*/
/*
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];//去处需要的路径
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory1 stringByExpandingTildeInPath]];
    //获取文件路径
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"test.sql"];
 */
    /*拷贝工程中的文件到Document目录*/

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"test.sql"];
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        NSLog(@"test.sql is not exist");
         NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/test.sql"];//获取程序包中相应文件的路径
        NSError *error;
        if([fileManager copyItemAtPath:dataPath toPath:filePath error:&error]) //拷贝
        {
            NSLog(@"copy xxx.txt success");
        }
        else
        {
            NSLog(@"%@",error);
        }
    }
     NSData *reader = [NSData dataWithContentsOfFile:filePath];
//    NSData *reader = [NSData dataWithContentsOfFile:path];
    NSString *a= [[NSString alloc] initWithData:reader
                                       encoding:NSUTF8StringEncoding];
    NSArray *b=[a componentsSeparatedByString:@"\n"];
    NSLog(@"b=%d", [b count]);
//    NSLog(@"aababab=%@",[[NSString alloc] initWithData:reader
//                                              encoding:NSUTF8StringEncoding]);
    for (int i=0; i< [b count]-1; i++) {
//        NSLog(@"aa=%@", [b objectAtIndex:i]);
        NSString *sql=[b objectAtIndex:i];
//        NSString *sql=@"INSERT INTO NTShipCompanyTranShare VALUES (7, '其它', 'HYG', '黄骅港', 2011, 12, 31635); INSERT INTO NTShipCompanyTranShare VALUES (7, '其它', 'HYG', '黄骅港', 2012, '01', 38208); INSERT INTO NTShipCompanyTranShare VALUES (7, '其它', 'HYG', '黄骅港', 2012, '02', 109124);";
        int re =sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL);
        if (re!=SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),[sql UTF8String]);
        }
        
        re=sqlite3_step(statement);
        if (re!=SQLITE_DONE) {
            NSLog( @"Error: insert error with message [%s]  sql[%s]", sqlite3_errmsg(database),[sql UTF8String]);
            sqlite3_finalize(statement);
            return;
        }else {
            //NSLog(@"insert shipTrans  SUCCESS");
            
        }
    }
    sqlite3_finalize(statement);
    if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"exec commit error");
        return;
    }
    sqlite3_close(database);
    iSoapDone=1;
    iSoapNum--;
    NSLog(@"over");
}


-(NSInteger)iSoapDone
{
    return iSoapDone;
}
-(NSInteger)iSoapNum
{
    return iSoapNum;
}
-(void)setISoapNum:(NSInteger)theNum
{
    iSoapNum=theNum;
}
@end
