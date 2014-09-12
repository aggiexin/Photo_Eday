//
//  DetailTableViewCell.h
//  Photo_Eday
//
//  Created by dongl on 14-7-25.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTool.h"

@class DetailTableViewCell;
@protocol DetailCellDelegate <NSObject>

@required
- (void)didDeleteImageWithCell:(DetailTableViewCell*)cell
                           and:(UIButton*)sender;

-(void)turnDetailController:(DetailTableViewCell*)cell
                        and:(UIButton*)sender;

@end

@interface DetailTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIButton *buttoneye;
@property (strong, nonatomic)  UILabel *creatTimeLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UIButton *photoOriginal;
@property (strong, nonatomic)  UIButton *photoChange;
@property (strong, nonatomic) UIImageView *photo;
@property (weak, nonatomic) id<DetailCellDelegate>delegate;

@end
