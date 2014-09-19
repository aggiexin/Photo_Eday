//
//  ImageTool.m
//  Photo_Eday
//
//  Created by dongl on 14-8-28.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "ImageTool.h"
#define PageH [[UIScreen mainScreen] bounds].size.height
#define PageW [[UIScreen mainScreen] bounds].size.width
@implementation ImageTool
+(UIImageView*)setImageSize:(UIImageView*)image{
    if (PageH==480) {
        image.frame = CGRectMake(0, 64, PageW, PageH-64);
        
    }else if(PageH == 568)
    {
        image.frame = CGRectMake(0, 64, PageW, PageH-128);
    }
    

    return image;
}

+(UIImageView*)setImageSizeDetailImageView:(UIImageView*)image
                             andPhotoCount:(NSInteger)number{

    if (PageH==480) {
        image.frame = CGRectMake(0+(number-1)*PageW,0, PageW, PageH-64);
        
    }else if(PageH == 568)
    {
        image.frame = CGRectMake(0+(number-1)*PageW,0, PageW, PageH-128);
    }
    
    
    return image;
}


+(CGRect)setRect{
    CGRect rect = CGRectMake(0, 0, 0, 0);
    if (PageH==480) {
        rect = CGRectMake(0, 64, PageW, PageH-64);
        
    }else if(PageH == 568)
    {
        rect = CGRectMake(0, 64, PageW, PageH-128);
    }
    
    
    return rect;
}




@end
