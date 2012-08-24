//
//  TBXMLParser.h
//  Hpi-FDS
//
//  Created by 馬文培 on 12-8-15.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "PubInfo.h"
#import "TfPortDao.h"
#import "TB_LatefeeDao.h"
@interface TBXMLParser : NSObject{
    NSMutableData *webData;
    NSMutableString *soapResults;
    TBXML * tbxml;
     NSString *_Identification;

}
@property(nonatomic,copy) NSString *Identification;
- (void)requestSOAP:(NSString *)identification;
-(NSInteger)iSoapNum;
-(NSInteger)iSoapDone;
-(void)setISoapNum:(NSInteger)theNum;
-(void)parseXML;


@end
