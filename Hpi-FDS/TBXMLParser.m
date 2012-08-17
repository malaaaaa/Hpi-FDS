//
//  TBXMLParser.m
//  Hpi-FDS
//  采用TBXML方式解析，经测试，解析速度是NSXMLParser的3-4倍
//  Created by 馬文培 on 12-8-15.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TBXMLParser.h"

@implementation TBXMLParser
static int iSoapDone=1; //1未开始 0进行中 3出错
static int iSoapNum=0;
static NSString *version = @"V1.2";
static sqlite3  *database;
static NSString *Identification;
UIAlertView *alert;
NSString* alertMsg;


- (void)requestSOAP:(NSString *)identification
{
    Identification=identification;
    
    //出错
    if (iSoapDone==3) {
        NSLog(@"ddd");
        
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
                             "</soap12:Envelope>\n",Identification,PubInfo.deviceID,version,PubInfo.currTime,Identification];
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
    //    NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    //    NSLog(@"connection: didReceiveData:2");
    
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
    [self parseXML];
    [connection release];
    [webData release];
}
-(void)parseXML
{
    //    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //    NSLog(@"theXML[%@]",theXML);
    //    [theXML release];
    NSString *elementString1= [NSString stringWithFormat:@"Get%@InfoResult",Identification];
    NSString *elementString2= [NSString stringWithFormat:@"Get%@InfoResponse",Identification];
    
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
            if ([Identification isEqualToString:@"ThShipTrans"]) {
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
                        //                    NSLog(@"insert shipTrans  SUCCESS");
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
            
            /****************************电厂动态查询**************************/
            if ([Identification isEqualToString:@"FactoryTrans"]) {
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
