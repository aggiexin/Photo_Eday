//
//  FaceTool.h
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppAPI.h"
@interface FaceTool : NSObject
+(NSDictionary*)ChickFace:(NSData*)img;
+(NSString*)getDescriptionSentence:(NSDictionary*)img;
+(NSString*)getDescriptionTitle:(NSDictionary*)img;
+(UIImage*)getImage:(NSDictionary*)img;
+(NSInteger)getAge:(NSDictionary*)img;
+(NSInteger)getHappy:(NSDictionary*)img;
@end
