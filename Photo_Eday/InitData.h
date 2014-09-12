//
//  InitData.h
//  Photo_Eday
//
//  Created by dongl on 14-7-28.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTool.h"

@interface InitData : NSObject
//@property (strong,nonatomic)NSManagedObject *testid;
+(void)initData:(NSArray*)dataArry;
+(NSDictionary*)analysisInfo:(NSString*)name andType:(NSString*)type;

+(void)copyDataTosandbox;


@end
