//
//  tempViewController.h
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface tempViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    BOOL chickTemplateOpen;
    BOOL ischanged;
    BOOL isSecendtake;
    BOOL bingochange;
    CLLocationManager *locationManager;
     float currLat;
     float currLog;
    BOOL isbacktomain;

}
typedef NS_ENUM (NSInteger, NumberOfTemplete) {
	templeteOne = 1,
    templeteTwo = 2,
	templeteThree = 3,
	templeteFour = 4,
    templeteFive = 5,
    templeteSix = 6,
};
@property (nonatomic)NumberOfTemplete templete;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIImageView *buttomBackGround;
@property (strong, nonatomic) IBOutlet UIButton *templateButton;
@property (strong, nonatomic) IBOutlet UIButton *binggoButton;
@property (strong, nonatomic) UIImageView *middleImage;
@property (strong, nonatomic) UIImageView *templateBK;
@property (strong, nonatomic) UIScrollView *tempScroll;
@property (strong, nonatomic) UIView *destributionView;
@property (strong, nonatomic) UIView *timeView;
@property (strong, nonatomic) UILabel *destributionTitle;
@property (strong, nonatomic) UILabel *destributionSentence;
@property (strong, nonatomic) UILabel *monthday;
@property (strong, nonatomic) UILabel *loc;
@property (strong, nonatomic) UILabel *hourmin;
@property (strong, nonatomic) UIImageView *weather;
@property (strong, nonatomic) UIImageView *locimg;
@property (strong, nonatomic) UILabel *agelabel;
@property (strong, nonatomic) UILabel *happylabel;
@property (strong, nonatomic) UIImageView *ageimage;
@property (strong, nonatomic) UIImageView *happyimage;
@property (strong, nonatomic) UILabel * backgaryfirst;
@property (strong, nonatomic) UILabel * backgarysecend;
@property (strong, nonatomic) UIImage *imagebefore;
@property (strong, nonatomic) UIImage *imageafter;
@property (strong, nonatomic) NSString*facechick;
@property (strong, nonatomic) NSString *desSentence;
@property (strong, nonatomic) NSString *desTitle;
@property NSInteger agevalue;
@property NSInteger happyvalue;
@property (strong, nonatomic) NSDate *creattime;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) UIImage *weatherimage;
@property (strong, nonatomic) UIImage *imagebeforechanged;
@property (strong, nonatomic) UIImage *imageafterchanged;
@property (strong, nonatomic) NSString *weatherstring;
@property (strong, nonatomic) NSDictionary *imgInfo;
@property (strong, nonatomic) UIImageView *watermark;
-(void)getPhotoInfo:(UIImage*)photo;
-(void)getlocation;
@end
