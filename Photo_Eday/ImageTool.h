//
//  ImageTool.h
//  Photo_Eday
//
//  Created by dongl on 14-8-28.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageTool : NSObject
+(UIImageView*)setImageSize:(UIImageView*)image;
+(UIImageView*)setImageSizeDetailImageView:(UIImageView*)image
                             andPhotoCount:(NSInteger)number;
+(CGRect)setRect;
@end
