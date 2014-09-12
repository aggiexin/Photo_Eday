//
//  mainViewController.h
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTableViewCell.h"
#import "UMFeedback.h"
#import "SVProgressHUD.h"
@interface mainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UMFeedbackDataDelegate>{
    float scrollerviewY;
}
@property (strong,nonatomic) UITableView *maintable;
@property (strong,nonatomic) UIImageView *photoHead;
@property (strong,nonatomic) UIImageView *downdata;
@property (strong,nonatomic) UIImageView *garyline;
@property (strong,nonatomic) UIImageView *hintimage;
@property (strong,nonatomic) UIButton *buttonAdd;
@property (nonatomic, strong) UMFeedback *umFeedback;

@end
