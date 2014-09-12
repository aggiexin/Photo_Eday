//
//  TimeTool.m
//  Photo_Eday
//
//  Created by dongl on 14-7-24.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool
+(NSString *)GetTime:(NSDate*)senddate{
    
    
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm:ss\nMM月dd日"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:senddate];
    NSString * time2 =@"";
    switch ([comps weekday]-1) {
        case 1:
            time2=@"周一";
            break;
        case 2:
            time2=@"周二";
            break;
        case 3:
            time2=@"周三";
            break;
        case 4:
            time2=@"周四";
            break;
        case 5:
            time2=@"周五";
            break;
        case 6:
            time2=@"周六";
            break;
        case 0:
            time2=@"周日";
            break;
        default:
            break;
    }
    
    NSString * time1 = [dateformatter stringFromDate:senddate];
    NSString *timer = [NSString stringWithFormat:@"%@ %@",time1,time2];
    
    return timer;
}


+ (NSDate *)stringFromDate:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy/MM/dd HH:mm:ss"];
    
    
    
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    
    
    
    
    return destDate;
}



+(NSString*)getCreatTime:(NSDate*)senddate{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *monthday = [dateformatter stringFromDate:senddate];
    return monthday;

}
+(NSString*)getYearMonthAndDay{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY/MM/dd"];
    NSString *monthday = [dateformatter stringFromDate:senddate];
    return monthday;
}


+(NSString*)getMonthAndDay{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"M/dd"];
    NSString *monthday = [dateformatter stringFromDate:senddate];
    return monthday;
}

+(NSString*)getHoursAndMin{
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
//    fmt.dateStyle = kCFDateFormatterShortStyle;
    fmt.timeStyle = kCFDateFormatterShortStyle;
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString* dateString = [fmt stringFromDate:now];
    return dateString;
}

+(NSString*)getMonthDateHoursAndMin:(NSDate*)now{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateStyle = kCFDateFormatterShortStyle;
    fmt.timeStyle = kCFDateFormatterShortStyle;
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString* dateString = [fmt stringFromDate:now];
    return dateString;
}
@end

