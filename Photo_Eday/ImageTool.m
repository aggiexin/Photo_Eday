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



+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
@end
