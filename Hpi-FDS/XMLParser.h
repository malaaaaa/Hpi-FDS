//
//  XMLParser.h
//  Hpi-FDS
//
//  Created by zcx on 12-3-30.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TgPort.h"
#import "TgFactory.h"
#import "TgShip.h"
#import "TsFileinfo.h"
#import "TmIndexinfo.h"
#import "TmIndexdefine.h"
#import "TmIndextype.h"
#import "VbShiptrans.h"

@interface XMLParser : NSObject<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
    BOOL recordResults;
    TgPort *tgPort;
    TgFactory *tgFactory;
    TgShip *tgShip;
    TsFileinfo *tsFileinfo;
    TmIndexinfo *tmIndexinfo;
    TmIndexdefine *tmIndexdefine;
    TmIndextype *tmIndextype;
    VbShiptrans *vbShiptrans;
    id webVC;
}

@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) TgPort *tgPort;
@property(nonatomic, retain) TgFactory *tgFactory;
@property(nonatomic, retain) TgShip *tgShip;
@property(nonatomic, retain) TsFileinfo *tsFileinfo;
@property(nonatomic, retain) TmIndexinfo *tmIndexinfo;
@property(nonatomic, retain) TmIndexdefine *tmIndexdefine;
@property(nonatomic, retain) TmIndextype *tmIndextype;
@property(nonatomic, retain) VbShiptrans *vbShiptrans;
@property(nonatomic, assign) id webVC;
- (void)getTgPort;
- (void)getTgFactory;
- (void)getTgShip;
- (void)getTsFileinfo;
- (void)getTmIndexinfo;
- (void)getTmIndexdefine;
- (void)getTmIndextype;
- (void)getVbShiptrans;

-(NSInteger)iSoapTmIndextypeDone;
-(NSInteger)iSoapTmIndexdefineDone;
-(NSInteger)iSoapTmIndexinfoDone;
-(NSInteger)iSoapTsFileinfoDone;
-(NSInteger)iSoapTgPortDone;
-(NSInteger)iSoapTgFactoryDone;
-(NSInteger)iSoapTgShipDone;
-(NSInteger)iSoapVbShiptransDone;
-(NSInteger)iSoapDone;
-(NSInteger)iSoapNum;
-(void)setISoapNum:(NSInteger)theNum;
@end
