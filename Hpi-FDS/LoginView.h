//
//  LoginView.h
//  Hpi-FDS
//
//  Created by tang bin on 12-10-19.
//  Copyright (c) 2012年 Landscape. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestData;
@class LoginResponse;
@interface LoginView : UIViewController
{


    IBOutlet UITextField *userName;

    IBOutlet UITextField *partName;
    
    
    
    IBOutlet UITextField *Phone;
    
    
    IBOutlet UITextField *emile;
    
    NSString* Rsdate;

    RequestData *requestData;
    
    NSMutableData *responseDate;
    
    LoginResponse *logr;
    NSString *method;
    
    int finish;
    
}
@property(nonatomic,retain)UITextField *userName;
@property(nonatomic,retain)UITextField *partName;
@property(nonatomic,retain)UITextField *Phone;
@property(nonatomic,retain)UITextField *emile;
@property(nonatomic,retain)  RequestData *requestData;

@property(nonatomic,retain)   NSString* Rsdate;
@property(nonatomic,retain)   NSString *method;
@property(nonatomic,retain)  NSMutableData *responseDate;

@property(nonatomic,retain)    LoginResponse *logr;



@property int finish;

-(void)requestSoap:(NSString *)requestStr;
@end

#import <UIKit/UIKit.h>
@interface RequestData : NSObject
{
    NSString *userName;
    NSString *partName;
    NSString  *phone;
    NSString *emile;
    
    NSString *strID;
    
    



}

@property(nonatomic,retain)   NSString *userName;
@property(nonatomic,retain)   NSString *partName;
@property(nonatomic,retain)   NSString *phone;
@property(nonatomic,retain)   NSString *emile;
@property(nonatomic,retain)   NSString *strID;
@end