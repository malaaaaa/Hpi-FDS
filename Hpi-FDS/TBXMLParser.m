//
//  TBXMLParser.m
//  Hpi-FDS
//  采用TBXML方式解析，经测试，解析速度是NSXMLParser的3-4倍
//  Created by 馬文培 on 12-8-15.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TBXMLParser.h"

@implementation TBXMLParser
@synthesize Identification=_Identification;

static int iSoapDone=1; //1未开始 0进行中 3出错
static int iSoapNum=0;
static NSString *version = @"V1.2";
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
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // 如果连接已经建好，则初始化data
    if( theConnection )
    {
        ThreadFinished=FALSE;
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
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
	alert = [[UIAlertView alloc]initWithTitle:@"提示" message:alertMsg delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[alert show];
	[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
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
    [connection release];
    [webData release];
    iSoapDone=3;
    iSoapNum--;
    alertMsg = @"无法连接,请检查网络是否正常?";
    [self msgbox];
    if (iSoapNum==0) {
        iSoapDone=1;
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"--------------------------------------------  connectionDidFinishLoading");
    
    [self parseXML];
    ThreadFinished = TRUE;
    [connection release];
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
-(void)parseXML
{
    //    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //    NSLog(@"theXML[%@]",theXML);
    //    [theXML release];
    NSString *elementString1= [NSString stringWithFormat:@"Get%@InfoResult",_Identification];
    NSString *elementString2= [NSString stringWithFormat:@"Get%@InfoResponse",_Identification];
    
    char *errorMsg;
    NSLog(@"start Parser");
    NSError *error = nil;
    tbxml = [TBXML newTBXMLWithXMLData:webData error:&error];
    // if an error occured, log it
    if (error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        
    } else {
        
        // Obtain root element
        TBXMLElement * root = tbxml.rootXMLElement;
        
        // if root element is valid
        if (root) {
            // search for the first author element within the root element's children
            TBXMLElement *elementNoUsed = [TBXML childElementNamed:@"retinfo" parentElement:[TBXML childElementNamed:elementString1 parentElement:[TBXML childElementNamed:elementString2 parentElement:[TBXML childElementNamed:@"soap:Body" parentElement:root]]]];
            
            /****************************调度日志**************************/
            if ([_Identification isEqualToString:@"ThShipTrans"]) {
                
                TBXMLElement *element = [TBXML childElementNamed:@"VbThShipTrans" parentElement:elementNoUsed];
                
                //打开数据库
                NSString *file=[TH_ShipTransDao dataFilePath];
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"open  Th_ShipTrans error");
                    return;
                }
                NSLog(@"open Th_ShipTrans database succes ....");
                
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                
                [TH_ShipTransDao deleteAll];
                // if an author element was found
                while (element != nil) {
                    TH_ShipTrans *shipTrans= [[TH_ShipTrans alloc] init];
                    
                    TBXMLElement * desc = [TBXML childElementNamed:@"RECID" parentElement:element];
                    if (desc != nil) {
                        shipTrans.RECID = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"RECORDDATE" parentElement:element];
                    if (desc != nil) {
                        shipTrans.RECORDDATE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"STATECODE" parentElement:element];
                    if (desc != nil) {
                        shipTrans.STATECODE = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PORTCODE" parentElement:element];
                    if (desc != nil) {
                        shipTrans.PORTCODE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SHIPNAME" parentElement:element];
                    if (desc != nil) {
                        shipTrans.SHIPNAME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TRIPNO" parentElement:element];
                    if (desc != nil) {
                        shipTrans.TRIPNO = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"FACTORYNAME" parentElement:element];
                    if (desc != nil) {
                        shipTrans.FACTORYNAME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PORTNAME" parentElement:element];
                    if (desc != nil) {
                        shipTrans.PORTNAME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SUPPLIER" parentElement:element];
                    if (desc != nil) {
                        shipTrans.SUPPLIER = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"COALTYPE" parentElement:element];
                    if (desc != nil) {
                        shipTrans.COALTYPE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"STATENAME" parentElement:element];
                    if (desc != nil) {
                        shipTrans.STATENAME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"LW" parentElement:element];
                    if (desc != nil) {
                        shipTrans.LW = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"P_ANCHORAGETIME" parentElement:element];
                    if (desc != nil) {
                        shipTrans.P_ANCHORAGETIME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"P_HANDLE" parentElement:element];
                    if (desc != nil) {
                        shipTrans.P_HANDLE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"P_ARRIVALTIME" parentElement:element];
                    if (desc != nil) {
                        shipTrans.P_ARRIVALTIME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"P_DEPARTTIME" parentElement:element];
                    if (desc != nil) {
                        shipTrans.P_DEPARTTIME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"NOTE" parentElement:element];
                    if (desc != nil) {
                        shipTrans.NOTE = [TBXML textForElement:desc] ;
                    }
                    //                NSLog(@"执行  删除  插入   ");
                    const char *insert="INSERT INTO Th_ShipTrans(recid,statecode,recorddate,statename,portcode,portname,shipname,tripno,factoryname,supplier,coaltype,lw,p_anchoragetime,p_handle ,p_arrivaltime,p_departtime,note)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *statement;
                    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                    
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                    }
                    
                    sqlite3_bind_int(statement,1 ,shipTrans.RECID);
                    sqlite3_bind_int(statement,2,shipTrans.STATECODE );
                    sqlite3_bind_text(statement, 3, [shipTrans.RECORDDATE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 4, [shipTrans.STATENAME  UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 5, [shipTrans.PORTCODE      UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 6, [shipTrans.PORTNAME     UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 7, [shipTrans.SHIPNAME      UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 8, [shipTrans.TRIPNO     UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 9, [shipTrans.FACTORYNAME      UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 10, [shipTrans.SUPPLIER       UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 11, [shipTrans.COALTYPE       UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement,12,shipTrans.LW );
                    sqlite3_bind_text(statement, 13, [shipTrans.P_ANCHORAGETIME      UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 14, [shipTrans.P_HANDLE    UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 15, [shipTrans.P_ARRIVALTIME      UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 16, [shipTrans.P_DEPARTTIME    UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 17, [shipTrans.NOTE    UTF8String], -1, SQLITE_TRANSIENT);
                    re=sqlite3_step(statement);
                    
                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert shipTrans  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
                        sqlite3_finalize(statement);
                        return;
                        
                    }else {
                        //                                           NSLog(@"insert shipTrans  SUCCESS");
                    }
                    sqlite3_finalize(statement);
                    [shipTrans release];
                    // find the next sibling element named "author"
                    element = [TBXML nextSiblingNamed:@"VbThShipTrans" searchFromElement:element];
                }
                if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec commit error");
                    return;
                }
                sqlite3_close(database);
                NSLog(@"commit over   ");
                iSoapDone=1;
                iSoapNum--;
                
                
            }
            
            /****************************电厂动态查询-FactoryTrans**************************/
            if ([_Identification isEqualToString:@"FactoryTrans"]) {
                
                TBXMLElement *element = [TBXML childElementNamed:@"VbFactoryTrans" parentElement:elementNoUsed];
                //打开数据库
                NSString *file=[VbFactoryTransDao dataFilePath];
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"open  VbFactoryTrans error");
                    return;
                }
                NSLog(@"open VbFactoryTrans database succes ....");
                
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                //全部删除
                [VbFactoryTransDao deleteAll];
                // if an author element was found
                while (element != nil) {
                    VbFactoryTrans *table= [[VbFactoryTrans alloc] init];
                    
                    TBXMLElement * desc = [TBXML childElementNamed:@"FACTORYCODE" parentElement:element];
                    if (desc != nil) {
                        table.FACTORYCODE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"DISPATCHNO" parentElement:element];
                    if (desc != nil) {
                        table.DISPATCHNO = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SHIPID" parentElement:element];
                    if (desc != nil) {
                        table.SHIPID = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"SHIPNAME" parentElement:element];
                    if (desc != nil) {
                        table.SHIPNAME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TYPEID" parentElement:element];
                    if (desc != nil) {
                        table.TYPEID = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"TRADE" parentElement:element];
                    if (desc != nil) {
                        table.TRADE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"KEYVALUE" parentElement:element];
                    if (desc != nil) {
                        table.KEYVALUE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SUPID" parentElement:element];
                    if (desc != nil) {
                        table.SUPID = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"STATECODE" parentElement:element];
                    if (desc != nil) {
                        table.STATECODE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"STATENAME" parentElement:element];
                    if (desc != nil) {
                        table.STATENAME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"STAGE" parentElement:element];
                    if (desc != nil) {
                        table.STAGECODE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"STAGENAME" parentElement:element];
                    if (desc != nil) {
                        table.STAGENAME = [TBXML textForElement:desc] ;
                    }
                    
                    
                    desc = [TBXML childElementNamed:@"ELW" parentElement:element];
                    if (desc != nil) {
                        table.elw = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    
                    desc = [TBXML childElementNamed:@"T_NOTE" parentElement:element];
                    if (desc != nil) {
                        table.T_NOTE = [TBXML textForElement:desc] ;
                    }
                    
                    
                    desc = [TBXML childElementNamed:@"F_NOTE" parentElement:element];
                    if (desc != nil) {
                        table.F_NOTE = [TBXML textForElement:desc] ;
                    }
                    
                    
                    desc = [TBXML childElementNamed:@"COMID" parentElement:element];
                    if (desc != nil) {
                        table.COMID = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    //                NSLog(@"执行  删除  插入   ");
                    const char *insert="INSERT INTO VbFactoryTrans (FACTORYCODE,DISPATCHNO,SHIPID,SHIPNAME,TYPEID, TRADE,KEYVALUE,SUPID,STATECODE,STATENAME,STAGECODE,STAGENAME,elw,COMID,T_NOTE,F_NOTE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *statement;
                    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                    
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                    }
                    
                    sqlite3_bind_text(statement, 1, [table.FACTORYCODE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 2, [table.DISPATCHNO UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 3, table.SHIPID);
                    sqlite3_bind_text(statement, 4, [table.SHIPNAME UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 5, table.TYPEID);
                    sqlite3_bind_text(statement, 6, [table.TRADE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 7, [table.KEYVALUE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 8, table.SUPID);
                    sqlite3_bind_text(statement, 9, [table.STATECODE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 10, [table.STATENAME UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 11, [table.STAGECODE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 12, [table.STAGENAME UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 13, table.elw);
                    sqlite3_bind_int(statement, 14, table.COMID);
                    sqlite3_bind_text(statement, 15, [table.T_NOTE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 16, [table.F_NOTE UTF8String], -1, SQLITE_TRANSIENT);
                    
                    re=sqlite3_step(statement);
                    
                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert VbFactoryTrans  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
                        sqlite3_finalize(statement);
                        return;
                        
                    }else {
                        //                    NSLog(@"insert shipTrans  SUCCESS");
                    }
                    sqlite3_finalize(statement);
                    [table release];
                    // find the next sibling element named "author"
                    element = [TBXML nextSiblingNamed:@"VbFactoryTrans" searchFromElement:element];
                }
                
                if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec commit error");
                    return;
                }
                sqlite3_close(database);
                NSLog(@"commit over   ");
                iSoapDone=1;
                iSoapNum--;
                
            }
            
            /****************************电厂动态查询-FactoryState**************************/
            if ([_Identification isEqualToString:@"FactoryState"]) {
                TBXMLElement *element = [TBXML childElementNamed:@"TbFactoryState" parentElement:elementNoUsed];
                //打开数据库
                NSString *file=[TbFactoryStateDao dataFilePath];
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"open  TbFactoryState error");
                    return;
                }
                NSLog(@"open TbFactoryState database succes ....");
                
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                //全部删除
                [TbFactoryStateDao deleteAll];
                // if an author element was found
                while (element != nil) {
                    TbFactoryState *table= [[TbFactoryState alloc] init];
                    
                    TBXMLElement * desc = [TBXML childElementNamed:@"STID" parentElement:element];
                    if (desc != nil) {
                        table.STID = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"FACTORYCODE" parentElement:element];
                    if (desc != nil) {
                        table.FACTORYCODE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"RECORDDATE" parentElement:element];
                    if (desc != nil) {
                        table.RECORDDATE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"IMPORT" parentElement:element];
                    if (desc != nil) {
                        table.IMPORT = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"EXPORT" parentElement:element];
                    if (desc != nil) {
                        table.EXPORT = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"STORAGE" parentElement:element];
                    if (desc != nil) {
                        table.STORAGE = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"CONSUM" parentElement:element];
                    if (desc != nil) {
                        table.CONSUM = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"AVALIABLE" parentElement:element];
                    if (desc != nil) {
                        table.AVALIABLE = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"MONTHIMP" parentElement:element];
                    if (desc != nil) {
                        table.MONTHIMP = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"YEARIMP" parentElement:element];
                    if (desc != nil) {
                        table.YEARIMP = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"ELECGENER" parentElement:element];
                    if (desc != nil) {
                        table.ELECGENER = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"STORAGE7" parentElement:element];
                    if (desc != nil) {
                        table.STORAGE7 = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    
                    desc = [TBXML childElementNamed:@"TRANSNOTE" parentElement:element];
                    if (desc != nil) {
                        table.TRANSNOTE = [TBXML textForElement:desc]  ;
                    }
                    
                    
                    desc = [TBXML childElementNamed:@"NOTE" parentElement:element];
                    if (desc != nil) {
                        table.NOTE = [TBXML textForElement:desc] ;
                    }
                    
                    //                NSLog(@"执行  删除  插入   ");
                  	const char *insert="INSERT INTO TbFactoryState (STID, FACTORYCODE, RECORDDATE, IMPORT, EXPORT, STORAGE, CONSUM, AVALIABLE, MONTHIMP, YEARIMP, ELECGENER, STORAGE7, TRANSNOTE, NOTE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *statement;
                    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                    
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                    }
                    
                    sqlite3_bind_int(statement, 1, table.STID);
                    sqlite3_bind_text(statement, 2,[table.FACTORYCODE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 3, [table.RECORDDATE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 4, table.IMPORT);
                    sqlite3_bind_int(statement, 5, table.EXPORT);
                    sqlite3_bind_int(statement, 6, table.STORAGE);
                    sqlite3_bind_int(statement, 7, table.CONSUM);
                    sqlite3_bind_int(statement, 8, table.AVALIABLE);
                    sqlite3_bind_int(statement, 9, table.MONTHIMP);
                    sqlite3_bind_int(statement, 10, table.YEARIMP);
                    sqlite3_bind_int(statement, 11, table.ELECGENER);
                    sqlite3_bind_int(statement, 12, table.STORAGE7);
                    sqlite3_bind_text(statement, 13,[table.TRANSNOTE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 14,[table.NOTE UTF8String], -1, SQLITE_TRANSIENT);
                    
                    re=sqlite3_step(statement);
                    
                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert tbFactoryState  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
                        sqlite3_finalize(statement);
                        return;
                        
                    }else {
                        //                    NSLog(@"insert shipTrans  SUCCESS");
                    }
                    sqlite3_finalize(statement);
                    [table release];
                    // find the next sibling element named "author"
                    element = [TBXML nextSiblingNamed:@"TbFactoryState" searchFromElement:element];
                }
                
                if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec commit error");
                    return;
                }
                sqlite3_close(database);
                NSLog(@"commit over   ");
                iSoapDone=1;
                iSoapNum--;
                
            }
            /****************************航运公司份额统计-NTShipCompanyTranShare**************************/
            if ([_Identification isEqualToString:@"TransPorts"]) {
                TBXMLElement *element = [TBXML childElementNamed:@"VbTransPorts" parentElement:elementNoUsed];
                //打开数据库
                NSString *file=[NTShipCompanyTranShareDao dataFilePath];
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"open  NTShipCompanyTranShare error");
                    return;
                }
                NSLog(@"open NTShipCompanyTranShare database succes ....");
                
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                //全部删除
                [NTShipCompanyTranShareDao deleteAll];
                // if an author element was found
                while (element != nil) {
                    NTShipCompanyTranShare *table= [[NTShipCompanyTranShare alloc] init];
                    
                    TBXMLElement * desc = [TBXML childElementNamed:@"COMID" parentElement:element];
                    if (desc != nil) {
                        table.COMID = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"COMPANY" parentElement:element];
                    if (desc != nil) {
                        table.COMPANY = [TBXML textForElement:desc] ;
                    }
                    desc = [TBXML childElementNamed:@"TRADEYEAR" parentElement:element];
                    if (desc != nil) {
                        table.TRADEYEAR = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TRADEWEEK" parentElement:element];
                    if (desc != nil) {
                        table.TRADEMONTH = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PORTCODE" parentElement:element];
                    if (desc != nil) {
                        table.PORTCODE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PORTNAME" parentElement:element];
                    if (desc != nil) {
                        table.PORTNAME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"LWSUM" parentElement:element];
                    if (desc != nil) {
                        table.LW = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    
                    //                NSLog(@"执行  删除  插入   ");
                    const char *insert="INSERT INTO NTShipCompanyTranShare (COMID,COMPANY,PORTCODE,PORTNAME,TRADEYEAR,TRADEMONTH,LW) values(?,?,?,?,?,?,?)";
                    
                    
                    sqlite3_stmt *statement;
                    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                    
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                    }
                    
                    sqlite3_bind_int(statement, 1, table.COMID);
                    sqlite3_bind_text(statement, 2, [table.COMPANY UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 3, [table.PORTCODE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 4, [table.PORTNAME UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 5, [table.TRADEYEAR UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 6, [table.TRADEMONTH UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 7, table.LW);
                    
                    re=sqlite3_step(statement);
                    
                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert NTShipCompanyTranShare  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
                        sqlite3_finalize(statement);
                        return;
                        
                    }else {
                        //                    NSLog(@"insert shipTrans  SUCCESS");
                    }
                    sqlite3_finalize(statement);
                    [table release];
                    // find the next sibling element named "author"
                    element = [TBXML nextSiblingNamed:@"VbTransPorts" searchFromElement:element];
                }
                
                if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec commit error");
                    return;
                }
                sqlite3_close(database);
                NSLog(@"commit over   ");
                iSoapDone=1;
                iSoapNum--;
                
            }
            /****************************电厂运力运量统计-NTFactoryFreightVolume**************************/
            if ([_Identification isEqualToString:@"YunLi"]) {
                TBXMLElement *element = [TBXML childElementNamed:@"YunLi" parentElement:elementNoUsed];
                //打开数据库
                NSString *file=[NTFactoryFreightVolumeDao dataFilePath];
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"open  YunLi error");
                    return;
                }
                NSLog(@"open NTFactoryFreightVolume database succes ....");
                
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                //全部删除
                [NTFactoryFreightVolumeDao deleteAll];
                // if an author element was found
                while (element != nil) {
                    NTFactoryFreightVolume *table= [[NTFactoryFreightVolume alloc] init];
                    
                    TBXMLElement * desc = [TBXML childElementNamed:@"TRADETIME" parentElement:element];
                    if (desc != nil) {
                        table.TRACETIME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TRADE" parentElement:element];
                    if (desc != nil) {
                        table.TRADE = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TRADENAME" parentElement:element];
                    if (desc != nil) {
                        table.TRADENAME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"CATEGORY" parentElement:element];
                    if (desc != nil) {
                        table.CATEGORY = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"FACTORYNAME" parentElement:element];
                    if (desc != nil) {
                        table.FACTORYNAME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"LW" parentElement:element];
                    if (desc != nil) {
                        table.LW = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    
                    //                NSLog(@"执行  删除  插入   ");
                    const char *insert="INSERT INTO NTFactoryFreightVolume (TRADETIME,TRADE,TRADENAME,CATEGORY,FACTORYNAME,LW) values(?,?,?,?,?,?)";
                    
                    sqlite3_stmt *statement;
                    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                    
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                    }
                    
                    sqlite3_bind_text(statement, 1, [table.TRACETIME UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 2, [table.TRADE UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 3, [table.TRADENAME UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 4, [table.CATEGORY UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 5, [table.FACTORYNAME UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 6, table.LW);
                    
                    re=sqlite3_step(statement);
                    
                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert NTFactoryFreightVolume  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
                        sqlite3_finalize(statement);
                        return;
                        
                    }else {
                        //                    NSLog(@"insert shipTrans  SUCCESS");
                    }
                    sqlite3_finalize(statement);
                    [table release];
                    // find the next sibling element named "author"
                    element = [TBXML nextSiblingNamed:@"YunLi" searchFromElement:element];
                }
                
                if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec commit error");
                    return;
                }
                sqlite3_close(database);
                NSLog(@"commit over   ");
                iSoapDone=1;
                iSoapNum--;
                
            }
            
            /****************************实时船舶查询-VbShiptrans**************************/
            if ([_Identification isEqualToString:@"ShipTrans"]) {
                TBXMLElement *element = [TBXML childElementNamed:@"VbShipTrans" parentElement:elementNoUsed];
                //打开数据库
                NSString *file=[VbShiptransDao dataFilePath];
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"VbShipTrans  open error");
                    return;
                }
                NSLog(@"open VbShipTrans database succes ....");
                
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                //全部删除
                [VbShiptransDao deleteAll];
                // if an author element was found
                while (element != nil) {
                    VbShiptrans *table= [[VbShiptrans alloc] init];
                    
                    TBXMLElement * desc = [TBXML childElementNamed:@"DISPATCHNO" parentElement:element];
                    if (desc != nil) {
                        table.disPatchNo = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SHIPCOMPANYID" parentElement:element];
                    if (desc != nil) {
                        table.shipCompanyId = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"SHIPCOMPANY" parentElement:element];
                    if (desc != nil) {
                        table.shipCompany = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SHIPID" parentElement:element];
                    if (desc != nil) {
                        table.shipId = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SHIPNAME" parentElement:element];
                    if (desc != nil) {
                        table.shipName = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TRIPNO" parentElement:element];
                    if (desc != nil) {
                        table.tripNo = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"FACTORYCODE" parentElement:element];
                    if (desc != nil) {
                        table.factoryCode = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PORTCODE" parentElement:element];
                    if (desc != nil) {
                        table.portCode = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PORTNAME" parentElement:element];
                    if (desc != nil) {
                        table.portName = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SUPID" parentElement:element];
                    if (desc != nil) {
                        table.supId = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SUPPLIER" parentElement:element];
                    if (desc != nil) {
                        table.supplier = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TYPRID" parentElement:element];
                    if (desc != nil) {
                        table.typeId = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"COALTYPE" parentElement:element];
                    if (desc != nil) {
                        table.coalType = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"KEYVALUE" parentElement:element];
                    if (desc != nil) {
                        table.keyValue = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"KEYNAME" parentElement:element];
                    if (desc != nil) {
                        table.keyName = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TRADE" parentElement:element];
                    if (desc != nil) {
                        table.trade = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TRADENAME" parentElement:element];
                    if (desc != nil) {
                        table.tradeName = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"HEATVALUE" parentElement:element];
                    if (desc != nil) {
                        table.heatValue = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"STAGE" parentElement:element];
                    if (desc != nil) {
                        table.stage = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"STAGENAME" parentElement:element];
                    if (desc != nil) {
                        table.stageName = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"STATECODE" parentElement:element];
                    if (desc != nil) {
                        table.stateCode = [TBXML textForElement:desc] ;
                    }
                    desc = [TBXML childElementNamed:@"STATENAME" parentElement:element];
                    if (desc != nil) {
                        table.stageName = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"LW" parentElement:element];
                    if (desc != nil) {
                        table.lw = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"P_ANCHORAGETIME" parentElement:element];
                    if (desc != nil) {
                        table.p_AnchorageTime = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"P_HANDLE" parentElement:element];
                    if (desc != nil) {
                        table.p_Handle = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"P_ARRIVALTIME" parentElement:element];
                    if (desc != nil) {
                        table.p_ArrivalTime = [TBXML textForElement:desc] ;
                    }
                    desc = [TBXML childElementNamed:@"P_DEPARTTIME" parentElement:element];
                    if (desc != nil) {
                        table.p_DepartTime = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"P_NOTE" parentElement:element];
                    if (desc != nil) {
                        table.p_Note = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"T_NOTE" parentElement:element];
                    if (desc != nil) {
                        table.t_Note = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"F_ANCHORAGETIME" parentElement:element];
                    if (desc != nil) {
                        table.f_AnchorageTime = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"F_ARRIVALTIME" parentElement:element];
                    if (desc != nil) {
                        table.f_ArrivalTime = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"F_DEPARTTIME" parentElement:element];
                    if (desc != nil) {
                        table.f_DepartTime = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"F_NOTE" parentElement:element];
                    if (desc != nil) {
                        table.f_Note = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"LATEFEE" parentElement:element];
                    if (desc != nil) {
                        table.lateFee = [[TBXML textForElement:desc] integerValue] ;
                    }
                    desc = [TBXML childElementNamed:@"OFFEFFICIENCY" parentElement:element];
                    if (desc != nil) {
                        table.offEfficiency = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"SCHEDULE" parentElement:element];
                    if (desc != nil) {
                        table.schedule = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PLANTYPE" parentElement:element];
                    if (desc != nil) {
                        table.planType = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PLANCODE" parentElement:element];
                    if (desc != nil) {
                        table.planCode = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"LAYCANSTART" parentElement:element];
                    if (desc != nil) {
                        table.laycanStart = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"LAYCANSTOP" parentElement:element];
                    if (desc != nil) {
                        table.laycanStop = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"RECIEPT" parentElement:element];
                    if (desc != nil) {
                        table.reciept = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SHIPSHIFT" parentElement:element];
                    if (desc != nil) {
                        table.shipShift = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TRADETIME" parentElement:element];
                    if (desc != nil) {
                        table.tradeTime = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"F_FINISHTIME" parentElement:element];
                    if (desc != nil) {
                        table.F_FINISHTIME = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"ISCAL" parentElement:element];
                    if (desc != nil) {
                        table.iscal = [TBXML textForElement:desc] ;
                    }
                    
                    
                    
                    //                NSLog(@"执行  删除  插入   ");
                  	const char *insert="INSERT INTO VbShiptrans (disPatchNo,shipCompanyId,shipCompany,shipId,shipName,tripNo,factoryCode,factoryName,portCode,portName,supId,supplier,typeId,coalType,keyValue,keyName,trade,tradeName,heatValue,stage,stageName,stateCode,stateName,lw,p_AnchorageTime,p_Handle,p_ArrivalTime,p_DepartTime,p_Note,t_Note,f_AnchorageTime,f_ArrivalTime,f_DepartTime,f_Note,lateFee,offEfficiency,schedule,planType,planCode,laycanStart,laycanStop,reciept,shipShift,facSort,tradeTime,f_finishtime,iscal) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *statement;
                    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                    
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                    }
                    
                    
                    sqlite3_bind_text(statement, 1, [table.disPatchNo UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 2, table.shipCompanyId);
                    sqlite3_bind_text(statement, 3, [table.shipCompany UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 4, table.shipId);
                    sqlite3_bind_text(statement, 5, [table.shipName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 6, [table.tripNo UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 7, [table.factoryCode UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 8, [table.factoryName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 9, [table.portCode UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 10, [table.portName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 11, table.supId);
                    sqlite3_bind_text(statement, 12, [table.supplier UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 13, table.typeId);
                    sqlite3_bind_text(statement, 14, [table.coalType UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 15, [table.keyValue UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 16, [table.keyName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 17, [table.trade UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 18, [table.tradeName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 19, table.heatValue);
                    sqlite3_bind_text(statement, 20, [table.stage UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 21, [table.stageName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 22, [table.stateCode UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 23, [table.stateName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 24, table.lw);
                    sqlite3_bind_text(statement, 25, [table.p_AnchorageTime UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 26, [table.p_Handle UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 27, [table.p_ArrivalTime UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 28, [table.p_DepartTime UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 29, [table.p_Note UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 30, [table.t_Note UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 31, [table.f_AnchorageTime UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 32, [table.f_ArrivalTime UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 33, [table.f_DepartTime UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 34, [table.f_Note UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 35, table.lateFee);
                    sqlite3_bind_int(statement, 36, table.offEfficiency);
                    sqlite3_bind_text(statement, 37, [table.schedule UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 38, [table.planType UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 39, [table.planCode UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 40, [table.laycanStart UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 41, [table.laycanStop UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 42, [table.reciept UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 43, [table.shipShift UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 44, table.facSort);
                    sqlite3_bind_text(statement, 45, [table.tradeTime UTF8String], -1, SQLITE_TRANSIENT);
                    
                    sqlite3_bind_text(statement, 46, [table.F_FINISHTIME   UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 47, [table.iscal   UTF8String], -1, SQLITE_TRANSIENT);
                    
                    
                    re=sqlite3_step(statement);
                    
                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert VbShiptrans  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
                        sqlite3_finalize(statement);
                        return;
                        
                    }else {
                        //                    NSLog(@"insert shipTrans  SUCCESS");
                    }
                    sqlite3_finalize(statement);
                    [table release];
                    // find the next sibling element named "author"
                    element = [TBXML nextSiblingNamed:@"VbShipTrans" searchFromElement:element];
                }
                
                if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec commit error");
                    return;
                }
                sqlite3_close(database);
                NSLog(@"commit over   ");
                iSoapDone=1;
                iSoapNum--;
                
            }
            
            
            /****************************航运计划-vbTransplan**************************/
            if ([_Identification isEqualToString:@"TransPlan"]) {
                TBXMLElement *element = [TBXML childElementNamed:@"VbTransPlan" parentElement:elementNoUsed];
                //打开数据库
                NSString *file=[VbTransplanDao dataFilePath];
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"VbTransPlan  open error");
                    return;
                }
                NSLog(@"open VbTransPlan database succes ....");
                
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                //全部删除
                [VbTransplanDao deleteAll];
                // if an author element was found
                while (element != nil) {
                    VbTransplan *table= [[VbTransplan alloc] init];
                    
                    TBXMLElement * desc = [TBXML childElementNamed:@"PLANCODE" parentElement:element];
                    if (desc != nil) {
                        table.planCode = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PLANMONTH" parentElement:element];
                    if (desc != nil) {
                        table.planMonth = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SHIPID" parentElement:element];
                    if (desc != nil) {
                        table.shipID = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SHIPNAME" parentElement:element];
                    if (desc != nil) {
                        table.shipName = [TBXML textForElement:desc]  ;
                    }
                    
                    desc = [TBXML childElementNamed:@"FACTORYCODE" parentElement:element];
                    if (desc != nil) {
                        table.factoryCode = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"FACTORYNAME" parentElement:element];
                    if (desc != nil) {
                        table.factoryName = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PORTCODE" parentElement:element];
                    if (desc != nil) {
                        table.portCode = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PORTNAME" parentElement:element];
                    if (desc != nil) {
                        table.portName = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TRIPNO" parentElement:element];
                    if (desc != nil) {
                        table.tripNo = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"ETAP" parentElement:element];
                    if (desc != nil) {
                        table.eTap = [TBXML textForElement:desc]  ;
                    }
                    
                    desc = [TBXML childElementNamed:@"ETAF" parentElement:element];
                    if (desc != nil) {
                        table.eTaf = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"ELW" parentElement:element];
                    if (desc != nil) {
                        table.eLw = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"SUPID" parentElement:element];
                    if (desc != nil) {
                        table.supID = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SUPPLIER" parentElement:element];
                    if (desc != nil) {
                        table.supplier = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TYPEID" parentElement:element];
                    if (desc != nil) {
                        table.typeID = [[TBXML textForElement:desc] integerValue];
                    }
                    
                    desc = [TBXML childElementNamed:@"COALTYPE" parentElement:element];
                    if (desc != nil) {
                        table.coalType = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"KEYVALUE" parentElement:element];
                    if (desc != nil) {
                        table.keyValue = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"KEYNAME" parentElement:element];
                    if (desc != nil) {
                        table.keyName = [TBXML textForElement:desc]  ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SCHEDULE" parentElement:element];
                    if (desc != nil) {
                        table.schedule = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"DESCRIPTION" parentElement:element];
                    if (desc != nil) {
                        table.description = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"SERIALNO" parentElement:element];
                    if (desc != nil) {
                        table.serialNo = [TBXML textForElement:desc] ;
                    }
                    desc = [TBXML childElementNamed:@"FACSORT" parentElement:element];
                    if (desc != nil) {
                        table.facSort = [TBXML textForElement:desc] ;
                    }
                    
                    //                NSLog(@"执行  删除  插入   ");
                    const char *insert="INSERT INTO VbTransplan (planCode,planMonth,shipID,shipName,factoryCode,factoryName,portCode,portName,tripNo,eTap,eTaf,eLw,supID,supplier,typeID,coalType,keyValue,keyName,schedule,description,serialNo,facSort) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *statement;
                    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                    
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                    }
                    
                    
                	sqlite3_bind_text(statement, 1, [table.planCode UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 2, [table.planMonth UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 3, table.shipID);
                    sqlite3_bind_text(statement, 4, [table.shipName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 5, [table.factoryCode UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 6, [table.factoryName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 7, [table.portCode UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 8, [table.portName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 9, [table.tripNo UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 10, [table.eTap UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 11, [table.eTaf UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 12, table.eLw);
                    sqlite3_bind_int(statement, 13, table.supID);
                    sqlite3_bind_text(statement, 14, [table.supplier UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 15, table.typeID);
                    sqlite3_bind_text(statement, 16, [table.coalType UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 17, [table.keyValue UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 18, [table.keyName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 19, [table.schedule UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 20, [table.description UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 21, [table.serialNo UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 22, [table.facSort UTF8String], -1, SQLITE_TRANSIENT);
                    
                    
                    re=sqlite3_step(statement);
                    
                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert VbTransPlan  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
                        sqlite3_finalize(statement);
                        return;
                        
                    }else {
                        //                    NSLog(@"insert shipTrans  SUCCESS");
                    }
                    sqlite3_finalize(statement);
                    [table release];
                    // find the next sibling element named "author"
                    element = [TBXML nextSiblingNamed:@"VbTransPlan" searchFromElement:element];
                }
                
                if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec commit error");
                    return;
                }
                sqlite3_close(database);
                NSLog(@"commit over   ");
                iSoapDone=1;
                iSoapNum--;
                
            }
            
            /****************************市场指数-TmIndexinfo**************************/
            if ([_Identification isEqualToString:@"TmIndex"]) {
                TBXMLElement *element = [TBXML childElementNamed:@"TmIndexInfo" parentElement:elementNoUsed];
                //打开数据库
                NSString *file=[TmIndexinfoDao dataFilePath];
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"TmIndexInfo  open error");
                    return;
                }
                NSLog(@"open TmIndexInfo database succes ....");
                
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                //全部删除
                [TmIndexinfoDao deleteAll];
                // if an author element was found
                while (element != nil) {
                    TmIndexinfo *table= [[TmIndexinfo alloc] init];
                    
                    TBXMLElement * desc = [TBXML childElementNamed:@"INFOID" parentElement:element];
                    if (desc != nil) {
                        table.infoId = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"INDEXNAME" parentElement:element];
                    if (desc != nil) {
                        table.indexName = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"RECORDTIME" parentElement:element];
                    if (desc != nil) {
                        table.recordTime = [TBXML textForElement:desc]  ;
                    }
                    
                    desc = [TBXML childElementNamed:@"INFOVALUE" parentElement:element];
                    if (desc != nil) {
                        table.infoValue = [TBXML textForElement:desc]  ;
                    }
                    
                    
                    //                NSLog(@"执行  删除  插入   ");
                    const char *insert="INSERT INTO TmIndexinfo (infoId,indexName,recordTime,infoValue) values(?,?,?,?)";
                    
                    sqlite3_stmt *statement;
                    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                    
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                    }
                    
                    
                    sqlite3_bind_int(statement, 1, table.infoId);
                    sqlite3_bind_text(statement, 2, [table.indexName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 3, [table.recordTime UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 4, [table.infoValue UTF8String], -1, SQLITE_TRANSIENT);
                    re=sqlite3_step(statement);
                    
                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert TmIndexinfo  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
                        sqlite3_finalize(statement);
                        return;
                        
                    }else {
                        //                    NSLog(@"insert shipTrans  SUCCESS");
                    }
                    sqlite3_finalize(statement);
                    [table release];
                    // find the next sibling element named "author"
                    element = [TBXML nextSiblingNamed:@"TmIndexInfo" searchFromElement:element];
                }
                
                if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec commit error");
                    return;
                }
                sqlite3_close(database);
                NSLog(@"commit over   ");
                iSoapDone=1;
                iSoapNum--;
                
            }
            
            
            /****************************港口信息-TmCoalinfo**************************/
            if ([_Identification isEqualToString:@"Coal"]) {
                TBXMLElement *element = [TBXML childElementNamed:@"TmCoalInfo" parentElement:elementNoUsed];
                //打开数据库
                NSString *file=[TmCoalinfoDao dataFilePath];
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"TmCoalinfo  open error");
                    return;
                }
                NSLog(@"open TmCoalinfo database succes ....");
                
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                //全部删除
                [TmCoalinfoDao deleteAll];
                // if an author element was found
                while (element != nil) {
                    TmCoalinfo *table= [[TmCoalinfo alloc] init];
                    
                    TBXMLElement * desc = [TBXML childElementNamed:@"INFOID" parentElement:element];
                    if (desc != nil) {
                        table.infoId = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PORTCODE" parentElement:element];
                    if (desc != nil) {
                        table.portCode = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"RECORDDATE" parentElement:element];
                    if (desc != nil) {
                        table.recordDate = [TBXML textForElement:desc]  ;
                    }
                    
                    desc = [TBXML childElementNamed:@"IMPORT" parentElement:element];
                    if (desc != nil) {
                        table.import = [[TBXML textForElement:desc] integerValue]  ;
                    }
                    
                    desc = [TBXML childElementNamed:@"EXPORT" parentElement:element];
                    if (desc != nil) {
                        table.Export = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"STORAGE" parentElement:element];
                    if (desc != nil) {
                        table.storage = [[TBXML textForElement:desc] integerValue]  ;
                    }
                    
                    
                    //                NSLog(@"执行  删除  插入   ");
                    const char *insert="INSERT INTO TmCoalinfo (infoId,portCode,recordDate,import,Export,storage) values(?,?,?,?,?,?)";
                    
                    sqlite3_stmt *statement;
                    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                    
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                    }
                    
                    
                    sqlite3_bind_int(statement, 1, table.infoId);
                    sqlite3_bind_text(statement, 2, [table.portCode UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 3, [table.recordDate UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 4, table.import);
                    sqlite3_bind_int(statement, 5, table.Export);
                    sqlite3_bind_int(statement, 6, table.storage);
                    
                    re=sqlite3_step(statement);
                    
                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert TmCoalinfo  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
                        sqlite3_finalize(statement);
                        return;
                        
                    }else {
                        //                    NSLog(@"insert shipTrans  SUCCESS");
                    }
                    sqlite3_finalize(statement);
                    [table release];
                    // find the next sibling element named "author"
                    element = [TBXML nextSiblingNamed:@"TmCoalInfo" searchFromElement:element];
                }
                
                if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec commit error");
                    return;
                }
                sqlite3_close(database);
                NSLog(@"commit over   ");
                iSoapDone=1;
                iSoapNum--;
                
            }
            
            
            /****************************港口信息-ShipInfo**************************/
            if ([_Identification isEqualToString:@"Ship"]) {
                TBXMLElement *element = [TBXML childElementNamed:@"TmShipInfo" parentElement:elementNoUsed];
                //打开数据库
                NSString *file=[TmShipinfoDao dataFilePath];
                if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
                {
                    sqlite3_close(database);
                    NSLog(@"TmShipinfo  open error");
                    return;
                }
                NSLog(@"open TmShipinfo database succes ....");
                
                //为提高数据库写入性能，加入事务控制，批量提交
                if (sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec begin error");
                    return;
                }
                //全部删除
                [TmShipinfoDao deleteAll];
                // if an author element was found
                while (element != nil) {
                    TmShipinfo *table= [[TmShipinfo alloc] init];
                    
                    TBXMLElement * desc = [TBXML childElementNamed:@"INFOID" parentElement:element];
                    if (desc != nil) {
                        table.infoId = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"PORTCODE" parentElement:element];
                    if (desc != nil) {
                        table.portCode = [TBXML textForElement:desc] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"RECORDDATE" parentElement:element];
                    if (desc != nil) {
                        table.recordDate = [TBXML textForElement:desc]  ;
                    }
                    
                    desc = [TBXML childElementNamed:@"WAITSHIP" parentElement:element];
                    if (desc != nil) {
                        table.waitShip = [[TBXML textForElement:desc] integerValue]  ;
                    }
                    
                    desc = [TBXML childElementNamed:@"TRANSACTSHIP" parentElement:element];
                    if (desc != nil) {
                        table.transactShip = [[TBXML textForElement:desc] integerValue] ;
                    }
                    
                    desc = [TBXML childElementNamed:@"LOADSHIP" parentElement:element];
                    if (desc != nil) {
                        table.loadShip = [[TBXML textForElement:desc] integerValue]  ;
                    }
                    
                    
                    //                NSLog(@"执行  删除  插入   ");
                	const char *insert="INSERT INTO TmShipinfo (infoId,portCode,recordDate,waitShip,transactShip,loadShip) values(?,?,?,?,?,?)";
                    
                    sqlite3_stmt *statement;
                    int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                    
                    if (re!=SQLITE_OK) {
                        NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                    }
                    
                    
                    sqlite3_bind_int(statement, 1, table.infoId);
                    sqlite3_bind_text(statement, 2, [table.portCode UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 3, [table.recordDate UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 4, table.waitShip);
                    sqlite3_bind_int(statement, 5, table.transactShip);
                    sqlite3_bind_int(statement, 6, table.loadShip);
                    
                    re=sqlite3_step(statement);

                    if (re!=SQLITE_DONE) {
                        NSLog( @"Error: insert TmShipinfo  error with message [%s]  sql[%s]", sqlite3_errmsg(database),insert);
                        sqlite3_finalize(statement);
                        return;
                        
                    }else {
                        //                    NSLog(@"insert shipTrans  SUCCESS");
                    }
                    sqlite3_finalize(statement);
                    [table release];
                    // find the next sibling element named "author"
                    element = [TBXML nextSiblingNamed:@"TmShipInfo" searchFromElement:element];
                }
                
                if (sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg)!=SQLITE_OK) {
                    sqlite3_close(database);
                    NSLog(@"exec commit error");
                    return;
                }
                sqlite3_close(database);
                NSLog(@"commit over   ");
                iSoapDone=1;
                iSoapNum--;
                
            }
        }
        
    }
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
