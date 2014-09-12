//
//  InitData.m
//  Photo_Eday
//
//  Created by dongl on 14-7-28.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "InitData.h"
@implementation InitData
+(void)initData:(NSArray*)dataArry{

    int j = 0;
    NSManagedObjectContext* context = [CoreDataTool CreatCoreData:data_Name];
    NSManagedObject *testid = [NSEntityDescription insertNewObjectForEntityForName:@"DestributionTitle" inManagedObjectContext:context];

    
    for (int i=0; i<[dataArry count]; i++) {

        if (i%4==0&&i!=0) {


            NSError *error2 = nil;
            BOOL success = [context save:&error2];
            if (!success) {
                [NSException raise:@"访问数据库错误" format:@"%@", [error2 localizedDescription]];
            }
            
            testid = [NSEntityDescription insertNewObjectForEntityForName:@"DestributionTitle" inManagedObjectContext:context];
        }
        
//        if (i==0||i%4==0) {
//            NSLog(@"info = %@",[dataArry objectAtIndex:i]);
//            [testid setValue:[NSNumber numberWithInt:[[dataArry objectAtIndex:i] intValue]] forKey:@"number"];
//            j = i;
//        }else if(i==j+1){
//            NSLog(@"info = %@",[dataArry objectAtIndex:i]);
//            [testid setValue:[dataArry objectAtIndex:i] forKey:@"key"];
//
//        }else if(i==j+2){
//            NSLog(@"info = %@",[dataArry objectAtIndex:i]);
//            [testid setValue:[dataArry objectAtIndex:i] forKey:@"title"];
//
//        }else if(i==j+3){
//            NSLog(@"info = %@",[dataArry objectAtIndex:i]);
//            [testid setValue:[dataArry objectAtIndex:i] forKey:@"sentence"];
//            
//            
//        }
//        
//        if (i==11) {
//            NSError *error3 = nil;
//            BOOL success = [context save:&error3];
//            if (!success) {
//                [NSException raise:@"访问数据库错误" format:@"%@", [error3 localizedDescription]];
//            }
//        }
    }

    
}
//解析文本
+(NSDictionary*)analysisInfo:(NSString*)name andType:(NSString*)type{
    
    NSString *txt = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSString* messages = [NSString stringWithContentsOfFile:txt encoding:NSUTF8StringEncoding error:nil];
    NSArray* lines = [messages componentsSeparatedByString:@"\n"]; //按照行来分割
    
    
    NSLog(@"%lu",(unsigned long)[lines count]);
    NSMutableDictionary * infoCity = [NSMutableDictionary new];
    
    for (NSString* line in lines){
        NSRange rang = [line rangeOfString:@"="];
        NSString *numberstring = [line substringWithRange:NSMakeRange(0,rang.location)];
        NSString *citystring = [line substringWithRange:NSMakeRange(numberstring.length+1, line.length-numberstring.length-1)];
        [infoCity setObject:numberstring forKey:citystring];

    }

    return infoCity;
}

+(void)copyDataTosandbox{
    NSBundle *bundle=[NSBundle mainBundle];
    
    NSString *eday_photo=[bundle pathForResource:@"eday_photo" ofType:@"sqlite"];
    
    
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString*filepath=[docs stringByAppendingPathComponent:data_Name];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager copyItemAtPath:eday_photo toPath:filepath error:&error];
    
}

@end
