//
//  TimeTool.h
//  Photo_Eday
//
//  Created by dongl on 14-7-24.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTool : NSObject
+(NSString *)GetTime:(NSDate*)senddate;
+(NSString*)getMonthAndDay;
+(NSString*)getHoursAndMin;
+(NSString*)getMonthDateHoursAndMin;
+(NSString*)getMonthDateHoursAndMin:(NSDate*)now;
+(NSString*)getYearMonthAndDay;
+(NSString*)getCreatTime:(NSDate*)senddate;
+ (NSDate *)stringFromDate:(NSString *)dateString;
@end
