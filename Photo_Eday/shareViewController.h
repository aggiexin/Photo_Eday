//
//  shareViewController.h
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
//#import "TencentOpenAPI/QQApiInterface.h"
//#import "TencentRequest.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/TencentOAuthObject.h>
//#import <TencentOpenAPI/TencentApiInterface.h>
@interface shareViewController : UIViewController
//<QQApiInterfaceDelegate,TencentSessionDelegate,TencentApiInterfaceDelegate>
//{
//    QQApiObject *_qqApiObject;
//}
//
//@property (nonatomic, retain)TencentOAuth *oauth;

@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) UIImage *image;
//@property (strong, nonatomic) NSMutableURLRequest *URLRequest;
@end
