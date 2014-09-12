//
//  DestributionTitle.h
//  Photo_Eday
//
//  Created by dongl on 14-8-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DestributionTitle : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSNumber * glass;
@property (nonatomic, retain) NSNumber * smile;
@property (nonatomic, retain) NSString * title;

@end
