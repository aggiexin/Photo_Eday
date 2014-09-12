//
//  Internet.m
//  Photo_Eday
//
//  Created by dongl on 14-9-11.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "Internet.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
@implementation Internet
+(NSInteger)ChickInternet{
    [SVProgressHUD showWithStatus:@"真在检查网络请稍后..."];
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            [SVProgressHUD showErrorWithStatus:@"当前没有网络"];
            // 没有网络连接
            break;
        case ReachableViaWWAN:
            [SVProgressHUD showSuccessWithStatus:@"当前3G网络正常"];
            // 使用3G网络
            break;
        case ReachableViaWiFi:
            [SVProgressHUD showSuccessWithStatus:@"当前wifi网络正常"];
            // 使用WiFi网络
            break;
    }
    return [r currentReachabilityStatus];
    
}

@end
