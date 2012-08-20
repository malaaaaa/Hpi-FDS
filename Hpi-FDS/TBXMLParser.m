//
//  TBXMLParser.m
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-15.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import "TBXMLParser.h"

@implementation TBXMLParser
static int iSoap;
static int iSoapDone=1; //1未开始 0进行中 3出错
static int iSoapNum=0;
static NSString *version = @"V1.2";
static sqlite3  *database;

UIAlertView *alert;
NSString* alertMsg;
- (void)getVbFactoryTrans
{
    NSLog(@"aaa");
    if (iSoapDone==0) {
        NSLog(@"bbb");
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getVbFactoryTrans) userInfo:NULL repeats:NO];
        NSLog(@"ccc");
        
        return;
    }
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
    NSLog(@"开始 getTmIndexdefine");
    iSoap=15;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                             "<soap12:Body>\n"
                             "<GetThShipTransInfo xmlns=\"http://tempuri.org/\">\n"
                             "<req>\n"
                             "<deviceid>%@</deviceid>\n"
                             "<version>%@</version>\n"
                             "<updatetime>%@</updatetime>\n"
                             "</req>\n"
                             "</GetThShipTransInfo>\n"
                             "</soap12:Body>\n"
                             "</soap12:Envelope>\n",PubInfo.deviceID,version,PubInfo.currTime];
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
        webData = [[NSMutableData data] retain];
        
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    
}
//- (void)parserXML :(NSData *)data{
//    // error var
//    NSError *error = nil;
//    tbxml = [TBXML newTBXMLWithXMLData:data error:&error];
//
//    // if an error occured, log it
//    if (error) {
//        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
//
//    } else {
//
//        // Obtain root element
//        TBXMLElement * root = tbxml.rootXMLElement;
//
//        // if root element is valid
//        if (root) {
//            // search for the first author element within the root element's children
//            TBXMLElement * element = [TBXML childElementNamed:@"TfSupplier" parentElement:root];
//
//            // if an author element was found
//            while (element != nil) {
//
//                VbFactoryTrans *vbFactoryTrans= [[VbFactoryTrans alloc] init];
//
//                vbFactoryTrans.FACTORYCODE = [TBXML valueOfAttributeNamed:@"SUPPLIER" forElement:element];
//                NSLog(@"facotrycode=%@",vbFactoryTrans.FACTORYCODE);
//
//                // find the next sibling element named "author"
//                element = [TBXML nextSiblingNamed:@"TfSupplier" searchFromElement:element];
//            }
//        }
//    }
//}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
    NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    NSLog(@"connection: didReceiveData:2");
    
}
-(void) msgbox
{
	alert = [[UIAlertView alloc]initWithTitle:@"提示" message:alertMsg delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[alert show];
	[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
}
-(void) performDismiss:(NSTimer *)timer
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert release];
	alert = NULL;
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
    //    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //    NSLog(@"theXML[%@]",theXML);
    //    [theXML release];

    char *errorMsg;
    
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
            TBXMLElement *elementNoUsed = [TBXML childElementNamed:@"retinfo" parentElement:[TBXML childElementNamed:@"GetThShipTransInfoResult" parentElement:[TBXML childElementNamed:@"GetThShipTransInfoResponse" parentElement:[TBXML childElementNamed:@"soap:Body" parentElement:root]]]];
            
            
            TBXMLElement *element = [TBXML childElementNamed:@"VbThShipTrans" parentElement:elementNoUsed];
            [self openDataBase];
            int rc = sqlite3_exec(database, "BEGIN;", 0, 0, &errorMsg);
            // if an author element was found
            while (element != nil) {
                //                NSLog(@"aaaa");
                TH_ShipTrans *shipTrans= [[TH_ShipTrans alloc] init];
                
                TBXMLElement * desc = [TBXML childElementNamed:@"RECID" parentElement:element];
                if (desc != nil) {
                    shipTrans.RECID = [[TBXML textForElement:desc] integerValue];
                }
                //                NSLog(@"facotrycode=%d",shipTrans.RECID);
                
                desc = [TBXML childElementNamed:@"RECORDDATE" parentElement:element];
                if (desc != nil) {
                    shipTrans.RECORDDATE = [TBXML textForElement:desc] ;
                }
                //                NSLog(@"facotrycode=%@",shipTrans.RECORDDATE);
                
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
                //                [TH_ShipTransDao delete:shipTrans ];
                //                [TH_ShipTransDao insert:shipTrans];
                
                const char *insert="INSERT INTO Th_ShipTrans(recid,statecode,recorddate,statename,portcode,portname,shipname,tripno,factoryname,supplier,coaltype,lw,p_anchoragetime,p_handle ,p_arrivaltime,p_departtime,note)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                
                sqlite3_stmt *statement;
                int re =sqlite3_prepare(database, insert, -1, &statement, NULL);
                
                if (re!=SQLITE_OK) {
                    NSLog(@"Error: failed to prepare statement with message [%s]  sql[%s]",sqlite3_errmsg(database),insert);
                }
                
                //    NSLog(@"recid=%d", shipTrans.RECID);
                //
                //	NSLog(@"recorddate=%@", shipTrans.RECORDDATE );
                //
                //    NSLog(@"插入实体中   有值");
                //
                //绑定数据
                
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
            rc = sqlite3_exec(database, "COMMIT;", 0, 0, &errorMsg);

            NSLog(@"over   ");
            
        }       
    }
    sqlite3_close(database); 
    
    [connection release];
    //[webData release];
}

-(void) openDataBase
{
	NSString *file=[TH_ShipTransDao dataFilePath];
	if(sqlite3_open([file UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSLog(@"open  Th_ShipTrans error");
		return;
	}
	NSLog(@"open Th_ShipTrans database succes ....");
}
@end
