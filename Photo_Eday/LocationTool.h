//
//  LocationTool.h
//  Photo_Eday
//
//  Created by dongl on 14-8-29.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationTool : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
typedef void (^myCallback) (id obj);


- (void)getBooksByCategory:(NSString*)categoryId andPageIndex:(NSUInteger)index andCompletion:(myCallback)completion;
-(void)getlocation;
@property float currLat;
@property float currLog;
@end
