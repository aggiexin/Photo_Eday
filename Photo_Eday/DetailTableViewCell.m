//
//  DetailTableViewCell.m
//  Photo_Eday
//
//  Created by dongl on 14-7-25.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "shareViewController.h"
#import "detailImageViewController.h"
@interface DetailTableViewCell ()

@property (strong, nonatomic)UIButton* senderButton;

@end

@implementation DetailTableViewCell
#define PageH ([[UIScreen mainScreen] bounds].size.height)
#define PageW ([[UIScreen mainScreen] bounds].size.width)
#define GREENCOLOR	([UIColor colorWithRed:102.0f/255 green:217.0f/255 blue:165.0f/255 alpha:1.0])

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
       
    }
    return self;
}

- (void)awakeFromNib
{
    
    _photo = [UIImageView new];
    _timeLabel  = [[UILabel alloc]initWithFrame:CGRectMake(26, 22, 105, 52)];
    _timeLabel.font = [UIFont fontWithName:@"Verdana" size:15.0];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.numberOfLines = 2;
    [self addSubview:_timeLabel];
    _photoChange = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoChange.tag =2;
    _photoChange.frame = CGRectMake(254, 22, 52, 52);
    _photoChange.layer.cornerRadius = _photoChange.frame.size.height/2;//设圆形
    _photoChange.contentMode = UIViewContentModeScaleAspectFit;
    _photoChange.layer.masksToBounds = YES;
    [_photoChange addTarget:self action:@selector(turnDetail:) forControlEvents:UIControlEventTouchUpInside];
//    [_photoChange setBackgroundColor:[UIColor orangeColor]];
    [self addSubview:_photoChange];
    
    _photoOriginal = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoOriginal.frame = CGRectMake(194, 22, 52, 52);
    _photoOriginal.contentMode = UIViewContentModeScaleAspectFill;
    _photoOriginal.tag = 1;
    _photoOriginal.layer.cornerRadius = _photoOriginal.frame.size.height/2;
    _photoOriginal.layer.masksToBounds = YES;
    [_photoOriginal addTarget:self action:@selector(turnDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoOriginal];
    
    _buttoneye = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttoneye.frame = CGRectMake(134, 20, 52, 52);
    _buttoneye.tag = 3;
    [_buttoneye setImage:[UIImage imageNamed:@"eyes.png"] forState:UIControlStateNormal];
    [_buttoneye addTarget:self action:@selector(turnDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttoneye];
    


}


-(void)turnDetail:(UIButton *)sender{
    
    [self.delegate turnDetailController:self and:sender];

}



-(void)deletePhtot{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲,真的要删吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.delegate didDeleteImageWithCell:self and:self.senderButton];
        [self.senderButton removeFromSuperview];
        [_photo removeFromSuperview];
    }
    
}


- (void)dismissImage
{
    [_photo removeFromSuperview];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}



- (void)layoutSubviews{
    [super layoutSubviews];
//    _photo.frame =
    
}

@end
