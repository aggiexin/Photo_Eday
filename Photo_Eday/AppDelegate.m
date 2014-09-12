//
//  AppDelegate.m
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "AppDelegate.h"
#import "FaceTool.h"
#import "CoreDataTool.h"
#import <CoreData/CoreData.h>
#import "InitData.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#define PageH [[UIScreen mainScreen] bounds].size.height
#define PageW [[UIScreen mainScreen] bounds].size.width
@implementation AppDelegate
@synthesize wbtoken;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ShareSDK registerApp:@"26c19060a35c"];

    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    if (![accountDefaults boolForKey:@"opened"]) {
        
//        UIViewController *vc = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"wellcome"];
//        self.window.rootViewController = vc;
        
        NSDictionary *code =[NSDictionary dictionaryWithDictionary:[InitData analysisInfo:@"city" andType:@"txt"]];
         [accountDefaults setObject:code forKey:@"cityCode"];
        [InitData copyDataTosandbox];
        [accountDefaults setInteger:0 forKey:@"id"];
        }
        [accountDefaults setBool:YES forKey:@"opened"];
        [accountDefaults synchronize];
    
//    [WXApi registerApp:@"wx32a52a5c2222b080"];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"3333798819"];
    
    _oauth = [[TencentOAuth alloc] initWithAppId:@"1101960550"
                                     andDelegate:self];

//    //……
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
        [ShareSDK connectSinaWeiboWithAppKey:@"3201194191"
                                  appSecret:@"fd42545985a090707503f5902b94d8d7"
                                 redirectUri:@"https://api.weibo.com/oauth2/default.html"];

    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"3333798819"
                                appSecret:@"fd42545985a090707503f5902b94d8d7"
                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                              weiboSDKCls:[WeiboSDK class]];

    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801529182"
                                  appSecret:@"b404955465ad5a18097fcb25c631e042"
                                redirectUri:@"http://edaysoft.cn"
                                   wbApiCls:[WeiboApi class]];

    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1101960550"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:nil
                     tencentOAuthCls:nil];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"1101960550"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx32a52a5c2222b080"
                           wechatCls:[WXApi class]];
//
//    
//    //添加Instapaper应用   注册网址  http://www.instapaper.com/main/request_oauth_consumer_token
//    [ShareSDK connectInstapaperWithAppKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
//                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
//    
//    [ShareSDK connectWeChatWithAppId:@"wx32a52a5c2222b080"        //此参数为申请的微信AppID
//                           wechatCls:[WXApi class]];
////    [ShareSDK importWeChatClass:[WXApi class]];
//    
//    [ShareSDK connectQQWithQZoneAppKey:@"1101960550"                 //该参数填入申请的QQ AppId
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
////    [ShareSDK importQQClass:[QQApiInterface class]
////            tencentOAuthCls:[TencentOAuth class]];
       return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    if (YES == [TencentApiInterface canOpenURL:url delegate:self])
//    {
//        [TencentApiInterface handleOpenURL:url delegate:self];
//    }
//    return [WXApi handleOpenURL:url delegate:self];
//    return [WeiboSDK handleOpenURL:url delegate:self];
//    return [TencentOAuth HandleOpenURL:url];
    return YES;
//    return [TencentOAuth HandleOpenURL:url];
    
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//#if __QQAPI_ENABLE__
//    [QQApiInterface handleOpenURL:url delegate:(id)[QQAPIDemoEntry class]];
//#endif
//    if (YES == [TencentOAuth CanHandleOpenURL:url])
//    {
//        return [TencentOAuth HandleOpenURL:url];
//    }
//    if (YES == [TencentApiInterface canOpenURL:url delegate:self])
//    {
//        [TencentApiInterface handleOpenURL:url delegate:self];
//    }
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
   
}

@end
