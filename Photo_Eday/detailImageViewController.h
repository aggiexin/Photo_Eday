//
//  detailImageViewController.h
//  Photo_Eday
//
//  Created by dongl on 14-8-28.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailImageViewController : UIViewController <UIScrollViewDelegate>
{
    BOOL isChickImage;
}
@property (strong, nonatomic) UIImage *middleimage;
@property (strong, nonatomic) NSString *creattime;
@property (strong, nonatomic) NSArray *photocount;
@property (strong, nonatomic) UIScrollView *scrollview;
@property (strong, nonatomic) UIImageView *footView;
@property NSInteger type;
@property NSInteger photoindex;
@end
