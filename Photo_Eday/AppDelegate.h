//
//  AppDelegate.h
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/TencentOAuthObject.h>
//#import <TencentOpenAPI/TencentApiInterface.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;

@end
