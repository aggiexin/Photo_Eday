//
//  LocationTool.m
//  Photo_Eday
//
//  Created by dongl on 14-8-29.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "LocationTool.h"

@implementation LocationTool
- (void)getBooksByCategory:(NSString*)categoryId andPageIndex:(NSUInteger)index andCompletion:(myCallback)completion
{
//    if (CAN_CONNECT_TO_WEBSITE) {
//        //        pageindex=%d&pagesize=%d
//        NSString* pageIndex = [NSString stringWithFormat:@"pageindex=%d&pagesize=%d", index, BOOK_PAGE_SIZE];
//        NSString* path = [categoryId isEqualToString:@"0"] ?
//        [NSString stringWithFormat:@"%@book/GetHot?%@&devicesType=0", BASE_URL, pageIndex] :
//        [NSString stringWithFormat:@"%@book/GetByCategory?cid=%@&%@&devicesType=0", BASE_URL, categoryId, pageIndex];
//        
//        NSLog(@"%@", path);
//        
//        NSURL* url = [NSURL URLWithString:path];
//        
//        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
//        
//        [NSURLConnection sendAsynchronousRequest:request queue:self.myQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            
//            if (!connectionError) {
//                
//                NSLog(@"getBooksByCategory data:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                
//                NSMutableArray* books = [NSMutableArray array];
//                
//                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                
//                books = [OHJsonParser parseBooksByDictionary:dict];
//                
//                completion(books);
//                
//            } else {
//                
//                completion(connectionError);
//                
//            }
//            
//        }];
//        
//    }
//    
//    else {
//        
//        completion([NSError errorWithDomain:@"无法连接到服务器" code:000 userInfo:nil]);
//        
//    }
    
    
}






-(void)getlocation{
    
    //初始化CLLocationManager
    locationManager =[[CLLocationManager alloc]init];
    //设置当前委托，此委托CLLocationManagerDelegate
    locationManager.delegate = self;
    //设置精准度为忧
    locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    //设置距离筛选器,告知位置管理器直到iphone从以前报告的位置移动至少100米才通知委托。
    locationManager.distanceFilter = 100.0f;
    //开始更新数据
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    _currLat =  newLocation.coordinate.latitude;
    _currLog =  newLocation.coordinate.longitude;
    
}
@end
