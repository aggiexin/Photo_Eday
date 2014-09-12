//
//  ImgHistory.h
//  Photo_Eday
//
//  Created by dongl on 14-8-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImgHistory : NSManagedObject

@property (nonatomic, retain) NSString * creatTime;
@property (nonatomic, retain) NSString * imgLocalPath;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * sentence;
@property (nonatomic, retain) NSString * title;

@end
