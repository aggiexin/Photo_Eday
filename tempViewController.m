//
//  tempViewController.m
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "tempViewController.h"
#import "TranInfo.h"
#import "TimeTool.h"
#import "ImgHistory.h"
#import "CoreDataTool.h"
#import <objc/runtime.h>
#import "FaceTool.h"
#define PageH ([[UIScreen mainScreen] bounds].size.height)
#define PageW ([[UIScreen mainScreen] bounds].size.width)
#define GREENCOLOR	([UIColor colorWithRed:102.0f/255 green:217.0f/255 blue:165.0f/255 alpha:1.0])

#define REDCOLOR	([UIColor colorWithRed:232.0f/255 green:85.0f/255 blue:85.0f/255 alpha:1.0])
@interface tempViewController ()

@end

@implementation tempViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    chickTemplateOpen = NO;
    ischanged = NO;
    _middleImage  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, PageW, PageH-60)];
//    _middleImage.image =  [TranInfo Instance].img;
    _middleImage.image = _imagemiddle;
    [self.view addSubview:_middleImage];
//    [self SetMiddleImg];
    [self SetTemplate];
    [self setUI];
    [super viewDidLoad];

    
}

-(void)initsubview{
    _destributionTitle = [UILabel new];
    _destributionSentence = [UILabel new];
    _timeView = [UIView new];
    _destributionView = [UIView new];
    _monthday = [UILabel new];
    _loc = [UILabel new];
    _hourmin = [UILabel new];
    _weather = [UIImageView new];
    _locimg = [UIImageView new];
    _ageimage = [UIImageView new];
    _agelabel = [UILabel new];
    _happyimage = [UIImageView new];
    _happylabel = [UILabel new];
    _backgarysecend = [UILabel new];
    _backgaryfirst = [UILabel new];
}

-(void)removesubview{
    [_destributionTitle removeFromSuperview];
    [_destributionSentence removeFromSuperview];
    [_destributionView removeFromSuperview];
    [_timeView removeFromSuperview];
    [_loc removeFromSuperview];
    [_monthday removeFromSuperview];
    [_hourmin removeFromSuperview];
    [_weather removeFromSuperview];
    [_locimg removeFromSuperview];
    [_agelabel removeFromSuperview];
    [_ageimage  removeFromSuperview];
    [_happylabel removeFromSuperview];
    [_happyimage removeFromSuperview];
    [_backgaryfirst removeFromSuperview];
    [_backgarysecend removeFromSuperview];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)takephotoagain{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
        
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
  
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//拍摄图片保存到系统相册
    [picker dismissViewControllerAnimated:YES completion:nil];

}


-(void)bingo{
    CGRect rect  =  CGRectMake(0, 58, 320, 430);
    UIGraphicsBeginImageContext(_middleImage.frame.size); //currentView 当前的view
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSaveGState(cont);
    UIRectClip(rect);
    [self.view.layer renderInContext:cont];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger number =  [[accountDefaults objectForKey:@"id"] integerValue]+1;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *beforephotoPathsName = [NSString stringWithFormat:@"edayPhotoBefore%li.png",(long)number];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:beforephotoPathsName]; // 保存文件的名称,照片的路径
    [UIImagePNGRepresentation(viewImage)writeToFile:filePath atomically:YES]; // 保存成功会返回YES
    [CoreDataTool insertInfo:number andCreatTime:[TimeTool getMonthDateHoursAndMin] andPhtotPath:filePath anddtitle:_destributionTitle.text andsentence:_destributionSentence.text];
    NSData* fileData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary * imgInfo=  [FaceTool ChickFace:fileData];
    [FaceTool getDescriptionSentence:imgInfo];

    
    
    
    
    if (!ischanged) {
        ischanged =YES;
        CGRect rect  =  CGRectMake(0, 58, 320, 430);
        UIGraphicsBeginImageContext(_middleImage.frame.size); //currentView 当前的view
        CGContextRef cont = UIGraphicsGetCurrentContext();
        CGContextSaveGState(cont);
        UIRectClip(rect);
        [self.view.layer renderInContext:cont];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        _imagebefore = viewImage;
    }
    
    
    
}

-(void)shareandsave{
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger number =  [[accountDefaults objectForKey:@"id"] integerValue]+1;
    [accountDefaults setInteger:number forKey:@"id"];
    CGRect rect  =  CGRectMake(0, 58, 320, 430);
    UIGraphicsBeginImageContext(_middleImage.frame.size); //currentView 当前的view
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSaveGState(cont);
    UIRectClip(rect);
    [self.view.layer renderInContext:cont];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *phtotPathsName = [NSString stringWithFormat:@"edayPhotoBefore%li.png",(long)number];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:phtotPathsName];
    [UIImagePNGRepresentation(viewImage)writeToFile: filePath atomically:YES];
    [CoreDataTool insertInfo:number andCreatTime:[TimeTool getMonthDateHoursAndMin] andPhtotPath:filePath anddtitle:_destributionTitle.text andsentence:_destributionSentence.text];
    
    
    
    ischanged = NO;
    UIViewController* vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"share"];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)backback{
    [self.navigationController popToRootViewControllerAnimated:YES];
     
     }

-(void)setUI{
    //UP
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(0, 0, 51, 22) ;
    UIImage* image = [UIImage imageNamed:@"saveandshare.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//保持原有形态
    [btn1 setImage:image forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(shareandsave) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(0, 0, 45, 23) ;
    UIImage* image2 = [UIImage imageNamed:@"back.png"];
    image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [btn2 setImage:image2 forState:UIControlStateNormal];
    
    [btn2 addTarget:self action:@selector(backback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn2];

    
  //DOWN
    _buttomBackGround = [[UIImageView alloc]initWithFrame:CGRectMake(0, PageH-76, PageW, 76)];
    _buttomBackGround.userInteractionEnabled = YES;//打开用户交互
    _buttomBackGround.image = [UIImage imageNamed:@"greenback.png"];
    [self.view addSubview:_buttomBackGround];
    
    _templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _templateButton.frame = CGRectMake(35, 10, 38, 57);
    [_templateButton setImage:[UIImage imageNamed:@"template.png"]forState:UIControlStateNormal];
    [_templateButton addTarget:self action:@selector(ChickTemplate) forControlEvents:UIControlEventTouchUpInside];
    [_buttomBackGround addSubview:_templateButton];
    
    _binggoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _binggoButton.frame = CGRectMake(PageW-73, 10, 38, 57);
    [_binggoButton setImage:[UIImage imageNamed:@"binggo.png"] forState:UIControlStateNormal];
    [_binggoButton addTarget:self action:@selector(bingo) forControlEvents:UIControlEventTouchUpInside];
    [_buttomBackGround addSubview:_binggoButton];
    
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraButton.frame = CGRectMake(PageW/2-35, 3, 70, 70);
    [_cameraButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [_cameraButton addTarget:self action:@selector(takephotoagain) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttomBackGround addSubview:_cameraButton];

}


//弹出小模版列表
-(void)ChickTemplate{

    if (!chickTemplateOpen) {
        [UIView animateWithDuration:0.3 animations:^{[_tempScroll setFrame:CGRectMake(0, PageH-77*2, PageW, 78)];
        }completion:^(BOOL finished) {
            chickTemplateOpen = YES;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{[_tempScroll setFrame:CGRectMake(0, PageH-76, PageW, 76)];
        }completion:^(BOOL finished) {
            chickTemplateOpen = NO;
        }];
    }
}
-(void)TemplateOne{
    [self removesubview];
    [self initsubview];
    //middle image
    _destributionView.Frame = CGRectMake(15, _middleImage.frame.size.height-150, 190, 55);
    _destributionView.backgroundColor = [UIColor grayColor];
    _destributionView.alpha = 0.3;
    [_middleImage addSubview:_destributionView];
    
    _destributionTitle.Frame = CGRectMake(18,_middleImage.frame.size.height-150, 190, 35);
    _destributionTitle.text = @"表述titile";
    _destributionTitle.alpha = 10;
    _destributionTitle.textColor = [UIColor whiteColor];
    _destributionTitle.font = [UIFont fontWithName:@"Verdana" size:21.0];;
    [_middleImage addSubview:_destributionTitle];
    
    _destributionSentence.Frame = CGRectMake(18, _middleImage.frame.size.height-126, 190, 35);
    _destributionSentence.text = @"表述表述表述表述表述表述表述表述表述";
    _destributionSentence.alpha = 10;
    _destributionSentence.font = [UIFont fontWithName:@"Verdana" size:16.0];;
    [_middleImage addSubview:_destributionSentence];
    
    
    _timeView.Frame=CGRectMake(PageW-90, _middleImage.frame.origin.y-50, 80, 80);
    _timeView.tintColor = [UIColor whiteColor];
//    _timeView.backgroundColor = [UIColor yellowColor];
    [_middleImage addSubview:_timeView];
    
    _monthday.Frame=CGRectMake(0, 0, 80, 35);
    _monthday.textColor = [ UIColor whiteColor];
    _monthday.text = [TimeTool getMonthAndDay];
    _monthday.textAlignment=NSTextAlignmentRight;
    _monthday.font = [UIFont boldSystemFontOfSize:22];
    [_timeView addSubview:_monthday];
    
    _loc.Frame=CGRectMake(0, 28, 80, 25);
    _loc.textColor = [ UIColor whiteColor];
    _loc.text = @"上海";
    _loc.textAlignment = NSTextAlignmentRight;
    _loc.font = [UIFont fontWithName:@"Verdana" size:17.0];
    [_timeView addSubview:_loc];
    
    _hourmin.Frame = CGRectMake(0, 46, 80, 30);
    _hourmin.textColor = [ UIColor whiteColor];
    _hourmin.text = [TimeTool getHoursAndMin];
    _hourmin.textAlignment = NSTextAlignmentRight;
    _hourmin.font = [UIFont fontWithName:@"Verdana" size:15.0];
    [_timeView addSubview:_hourmin];
    
}
-(void)TemplateTwo{
    [self removesubview];
    [self initsubview];
    
    _destributionView .Frame=CGRectMake(15, _middleImage.frame.size.height-290, 55, 200);
    [_middleImage addSubview:_destributionView];
    
    _destributionTitle.Frame = CGRectMake(3,0, 35, 165);
    _destributionTitle.text = @"表\n述\nt\ni\nt\ni\nl\ne";
    _destributionTitle.numberOfLines = [_destributionTitle.text length];
    _destributionTitle.textColor = [UIColor whiteColor];
    _destributionTitle.font = [UIFont boldSystemFontOfSize:20.0];
    [_destributionView addSubview:_destributionTitle];

    _ageimage.frame = CGRectMake(3, 169, 15, 15);
    _ageimage.image = [UIImage imageNamed:@"age.png"];
    [_destributionView addSubview:_ageimage];
    _agelabel.frame = CGRectMake(24, 166, 65, 25);
    _agelabel.text = [NSString stringWithFormat:@"年龄:%@",@"24"];
    _agelabel.textColor = [UIColor whiteColor];
    _agelabel.font = [UIFont fontWithName:@"Verdana" size:13.5];
    [_destributionView addSubview:_agelabel];
    
    _happyimage.frame = CGRectMake(3, 187, 15, 15);
    _happyimage.image = [UIImage imageNamed:@"happy.png"];
    [_destributionView addSubview:_happyimage];
    _happylabel.frame = CGRectMake(24, 185, 65, 25);
    _happylabel.text = [NSString stringWithFormat:@"开心:%@",@"30"];
    _happylabel.textColor = [UIColor whiteColor];
    _happylabel.font = [UIFont fontWithName:@"Verdana" size:13.5];
    [_destributionView addSubview:_happylabel];
    
    

    
    _timeView = [[UIView alloc]initWithFrame:CGRectMake(PageW-90, _middleImage.frame.origin.y-50, 90, 70)];
    [_middleImage addSubview:_timeView];
    _loc.Frame=CGRectMake(0, 48, 80, 25);
    _loc.textColor = [ UIColor whiteColor];
    _loc.text = @"上海";
    _loc.textAlignment = NSTextAlignmentRight;
    _loc.font = [UIFont fontWithName:@"Verdana" size:17.0];
    [_timeView addSubview:_loc];
    
    _locimg.Frame = CGRectMake(25, 50, 20, 20);
    _locimg.image = [UIImage imageNamed:@"iconwhite.png"];
    [_timeView addSubview:_locimg];
    
    _monthday.Frame=CGRectMake(25, 5, 60, 45);
    _monthday.textColor = [ UIColor whiteColor];
    _monthday.text = @"晴天";
    _monthday.textAlignment=NSTextAlignmentRight;
    _monthday.font = [UIFont boldSystemFontOfSize:26];
    [_timeView addSubview:_monthday];
    
    _weather.frame = CGRectMake(-5, 10, 35, 30);
    _weather.image = [UIImage imageNamed:@"sun.png"];
    [_timeView addSubview:_weather];
    
}
-(void)TemplateThree{
    [self removesubview];
    [self initsubview];
    _destributionView.Frame=CGRectMake(0, _middleImage.frame.size.height-155, 300, 70);
    _destributionView.backgroundColor = [UIColor grayColor];
    [_middleImage addSubview:_destributionView];

    _destributionTitle.frame = CGRectMake(20, 3, 100, 35);
    _destributionTitle.textColor = [UIColor whiteColor];
    _destributionTitle.font = [UIFont boldSystemFontOfSize:24.0];
    _destributionTitle.text = @"表述title";
    [_destributionView addSubview:_destributionTitle];
    
    _weather.frame = CGRectMake(0, 35, 110, 1);
    _weather.image = [UIImage  imageNamed:@"line.png"];
    [_destributionView addSubview:_weather];
    
    _ageimage.frame = CGRectMake(51, 40, 26, 21);
    _ageimage.image = [UIImage imageNamed:@"diamond.png"];
    [_destributionView addSubview:_ageimage];
    
    _destributionSentence.frame = CGRectMake(85, 35, PageW, 30);
    _destributionSentence.textColor = [UIColor whiteColor];
    _destributionSentence.font = [UIFont fontWithName:@"" size:23];
    _destributionSentence.text = @"描述描述描述";
    [_destributionView addSubview:_destributionSentence];
    _locimg.Frame = CGRectMake(0, 0, 25, 25);
    _locimg.image = [UIImage imageNamed:@"time.png"];
    [_timeView addSubview:_locimg];
    _monthday.Frame=CGRectMake(27, -5, 80, 35);
    _monthday.textColor = [ UIColor whiteColor];
    _monthday.textAlignment=NSTextAlignmentLeft;
    _monthday.font = [UIFont boldSystemFontOfSize:23];
    NSString *time =[TimeTool getMonthAndDay];
    NSMutableAttributedString *attrString =
    [[NSMutableAttributedString alloc] initWithString:time];
    NSRange rang = [time rangeOfString:@"/"];
    UIColor *color = REDCOLOR;
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:rang];
    _monthday.attributedText = attrString;
    [_timeView addSubview:_monthday];
    
    _timeView.Frame=CGRectMake(20, _middleImage.frame.origin.y-50, 80, 80);
    [_middleImage addSubview:_timeView];
    
    _hourmin.Frame = CGRectMake(27, 5, 80, 60);
    _hourmin.textColor = [ UIColor whiteColor];
    _hourmin.text = [TimeTool getHoursAndMin];
    _hourmin.textAlignment = NSTextAlignmentLeft;
    _hourmin.font = [UIFont fontWithName:@"Verdana" size:19.0];
    [_timeView addSubview:_hourmin];

}
-(void)TemplateFour{
    [self removesubview];
    [self initsubview];
    _backgaryfirst.frame = CGRectMake(0, 20, PageW, 20);
    _backgaryfirst.backgroundColor = [UIColor grayColor];
    _backgaryfirst.alpha = 0.6;
    [_middleImage addSubview:_backgaryfirst];
    
    _backgarysecend.frame = CGRectMake(220, 40, 120, 20);
    _backgarysecend.backgroundColor = [UIColor grayColor];
    _backgarysecend.alpha = 0.2;
    [_middleImage addSubview:_backgarysecend];
    
    _locimg.frame = CGRectMake(200, 20, 17, 20);
    _locimg.image = [UIImage imageNamed:@"locred.png"];
    [_middleImage addSubview:_locimg];
    
    _loc.frame = CGRectMake(220, 20, 120, 20);
    _loc.textAlignment = NSTextAlignmentLeft;
    _loc.text = @"上海";
    _loc.textColor = [UIColor whiteColor];
    _loc.font = [UIFont fontWithName:@"Verdana" size:12];
    [_middleImage addSubview:_loc];
    
    _hourmin.frame = CGRectMake(220, 40, 120, 20);
    _hourmin.text = [TimeTool getYearMonthAndDay];
    _hourmin.font = [UIFont fontWithName:@"" size:11];
    [_middleImage addSubview:_hourmin];
    
    
    _destributionView.frame = CGRectMake(20, PageH-380, 100, 200);
    [_middleImage addSubview:_destributionView];
    
    _destributionTitle.frame = CGRectMake(0, 0, 70, 170);
    _destributionTitle.numberOfLines = [_destributionTitle.text length];
    _destributionTitle.text = @"居\n家\n好\n女\n人\n";
    _destributionTitle.font = [UIFont boldSystemFontOfSize:25];
    _destributionTitle.textColor = [UIColor whiteColor];
    [_destributionView addSubview:_destributionTitle];
    
    
    _destributionSentence.frame = CGRectMake(30, 50, 50, 160);
    _destributionSentence.numberOfLines = [_destributionSentence.text length];
    _destributionSentence.text = @"描\n述\n描\n述\n描\n述\n描\n";
    _destributionSentence.font = [UIFont boldSystemFontOfSize:18];
    [_destributionView addSubview:_destributionSentence];
    
    _monthday.frame = CGRectMake(55, 70, 50, 160);
    _monthday.numberOfLines = [_monthday.text length];
    _monthday.text = @"描\n述\n描\n述\n描\n述\n描\n";
    _monthday.font = [UIFont boldSystemFontOfSize:18];
    [_destributionView addSubview:_monthday];
    
}
-(void)TemplateFive{
    [self removesubview];
    [self initsubview];
    _timeView.frame = CGRectMake(20, 16, 100, 90);
    [_middleImage addSubview:_timeView];
    
    _monthday.frame = CGRectMake(0,-15, 100, 50);
    _monthday.text = [TimeTool getYearMonthAndDay];
    _monthday.textColor = [UIColor whiteColor];
    _monthday.font = [UIFont boldSystemFontOfSize:19];
    [_timeView addSubview:_monthday];
    
    _hourmin.frame = CGRectMake(0, 10, 100, 40);
    _hourmin.text = [TimeTool getHoursAndMin];
    _hourmin.textColor = [UIColor whiteColor];
    _hourmin.font = [UIFont fontWithName:@"Verdana" size:17];
    _hourmin.textAlignment = NSTextAlignmentRight;
    [_timeView addSubview:_hourmin];
    
    _loc.frame = CGRectMake(0, 35, 100, 30);
    _loc.text = @"上海";
    _loc.textAlignment = NSTextAlignmentRight;
    _loc.textColor = [UIColor whiteColor];
    _loc.font = [UIFont boldSystemFontOfSize:16];
    [_timeView addSubview:_loc];
    
    _locimg.frame = CGRectMake(50, 40, 15, 18);
    _locimg.image = [UIImage imageNamed:@"locsnip.png"];
    [_timeView addSubview:_locimg];
    
    
    _destributionView.frame = CGRectMake(0, PageH-210, PageW, 60);
    [_middleImage addSubview:_destributionView];
    
    _happylabel.frame = CGRectMake(210, -3, 110, 35);
    _happylabel.backgroundColor = [UIColor grayColor];
    _happylabel.alpha = 0.2;
    [_destributionView addSubview:_happylabel];
    
    _destributionTitle.frame = CGRectMake(220, -10, 100, 50);
    _destributionTitle.textColor = [UIColor whiteColor];
    _destributionTitle.text = @"描述title";
    _destributionTitle.font = [UIFont boldSystemFontOfSize:23];
    [_destributionView addSubview:_destributionTitle];
    
    _destributionSentence.frame = CGRectMake(0, 20, _destributionView.frame.size.width-20, 50);
    _destributionSentence.textColor = [UIColor whiteColor];
    _destributionSentence.text = @"描述描述描述描述";
    _destributionSentence.font = [UIFont boldSystemFontOfSize:18];
    _destributionSentence.textAlignment = NSTextAlignmentRight;
    [_destributionView addSubview:_destributionSentence];
    

}
-(void)TemplateSix{
    [self removesubview];
    [self initsubview];
    _timeView.frame = CGRectMake(0, 0, 100, 100);
    [_middleImage addSubview:_timeView];
    
    _weather.frame = CGRectMake(20, 5, 40, 30);
    _weather.image = [UIImage imageNamed:@"cloud.png"];
    [_timeView addSubview:_weather];
    
    _loc.frame = CGRectMake(52, -10, 50, 70);
    _loc.textAlignment = NSTextAlignmentRight;
    _loc.font = [UIFont boldSystemFontOfSize:20];
    _loc.textColor = [UIColor whiteColor];
    _loc.text = @"多云";
    [_timeView addSubview:_loc];
    
    _monthday.frame = CGRectMake(0, 25, 100, 40);
    _monthday.textAlignment = NSTextAlignmentRight;
    _monthday.textColor = [UIColor whiteColor];
    _monthday.text = [TimeTool getMonthAndDay];
    _monthday.font = [UIFont fontWithName:@"Verdana" size:18];
    [_timeView addSubview:_monthday];
    
    _hourmin.frame = CGRectMake(0, 45, 100, 40);
    _hourmin.textColor = [UIColor whiteColor];
    _hourmin.textAlignment = NSTextAlignmentRight;
    _hourmin.text = [TimeTool getHoursAndMin];
    _hourmin.font = [UIFont fontWithName:@"Verdana" size:16];
    [_timeView addSubview:_hourmin];

    
    
    _destributionView.frame = CGRectMake(0, PageH-210, PageW, 70);
    _destributionView.backgroundColor = [UIColor grayColor];
    _destributionView.alpha = 0.5;
    [_middleImage addSubview:_destributionView];
    
    _destributionTitle.frame = CGRectMake(PageW-233, PageH-215, 150, 40);
    _destributionTitle.font = [UIFont boldSystemFontOfSize:25];
    _destributionTitle.textColor = [UIColor whiteColor];
    _destributionTitle.text = @"描述title";
    _destributionTitle.textAlignment = NSTextAlignmentRight;
    [_middleImage addSubview:_destributionTitle];
    
    _ageimage.frame = CGRectMake(PageW-160, PageH-180, 15, 15);
    _ageimage.image = [UIImage imageNamed:@"age.png"];
    [_middleImage addSubview:_ageimage];
    
    _agelabel.text = [NSString stringWithFormat:@"年龄:%i",30];
    _agelabel.font = [UIFont fontWithName:@"Verdana" size:15];
    _agelabel.textColor = [UIColor whiteColor];
    _agelabel.frame = CGRectMake(PageW-140, PageH-198, 90, 50);
    [_middleImage addSubview:_agelabel];
    
    _happyimage.frame = CGRectMake(PageW-160, PageH-165, 15, 15);
    _happyimage.image = [UIImage imageNamed:@"happy.png"];
    [_middleImage addSubview:_happyimage];
    
    _happylabel.frame = CGRectMake(PageW-140, PageH-182, 90, 50);
    _happylabel.text = [NSString stringWithFormat:@"开心:%i",50];
    _happylabel.textColor = [UIColor whiteColor];
    _happylabel.font = [UIFont fontWithName:@"Verdana" size:15];
    [_middleImage addSubview:_happylabel];
    
    _locimg.frame = CGRectMake(PageW-70, PageH-205, 50, 60);
    _locimg.image = [UIImage imageNamed:@"hat.png"];
    [_middleImage addSubview:_locimg];

}
-(void)SetTemplate{
    _tempScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, PageH-76, PageW, 76)];
    [_tempScroll showsHorizontalScrollIndicator];
    [_tempScroll setContentSize:CGSizeMake(80*8+20, 76)];
    [self.view addSubview:_tempScroll];
    
    _templateBK = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80*9+20, 76)];
    _templateBK.image = [UIImage imageNamed:@"templateBK.png"];
    _templateBK.userInteractionEnabled = YES;
    [_tempScroll addSubview:_templateBK];
    
    UIButton *template1 = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, 55, 66)];
    template1.tag =1;
    [template1 setImage:[UIImage imageNamed:@"模板_1"] forState:UIControlStateNormal];
    [template1 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template1];
    
    UIButton *template2 = [[UIButton alloc]initWithFrame:CGRectMake(15+80, 5, 55, 66)];
    template2.tag =2;
    [template2 setImage:[UIImage imageNamed:@"模板_2"] forState:UIControlStateNormal];
    [template2 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template2];
    
    
    UIButton *template3 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*2, 5, 55, 66)];
    template3.tag =3;
    [template3 setImage:[UIImage imageNamed:@"模板_4"] forState:UIControlStateNormal];
    [template3 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template3];
    
    UIButton *template4 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*3, 5, 55, 66)];
    template4.tag =4;
    [template4 setImage:[UIImage imageNamed:@"模板_5"] forState:UIControlStateNormal];
    [template4 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template4];
    
    UIButton *template5 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*4, 5, 55, 66)];
    template5.tag =5;
    [template5 setImage:[UIImage imageNamed:@"模板_6"] forState:UIControlStateNormal];
    [template5 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template5];
    
    UIButton *template6 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*5, 5, 55, 66)];
    template6.tag =6;
    [template6 setImage:[UIImage imageNamed:@"模板_7"] forState:UIControlStateNormal];
    [template6 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template6];
    
    UIButton *template7 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*6, 5, 55, 66)];
    template7.tag =7;
    [template7 setImage:[UIImage imageNamed:@"模板_8"] forState:UIControlStateNormal];
    [template7 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template7];
    
    UIButton *template8 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*7, 5, 55, 66)];
    template8.tag =8;
    [template8 setImage:[UIImage imageNamed:@"模板_9"] forState:UIControlStateNormal];
    [template8 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template8];
    
    

}
-(void)chooseTemplate:(UIButton*)sender{
    switch (sender.tag) {
        case 1:
            
            [self TemplateOne];
            [self reloadInputViews];
            break;
        case 2:
            [self TemplateTwo];
            [self reloadInputViews];
            break;
        case 3:
            [self TemplateThree];
            [self reloadInputViews];
            break;
        case 4:
            [self TemplateFour];
            [self reloadInputViews];
            break;
        case 5:
            [self TemplateFive];
            [self reloadInputViews];
            break;
        case 6:
            [self TemplateSix];
            [self reloadInputViews];
            break;
        case 7:
            [self TemplateFour];
            [self reloadInputViews];
            break;
        case 8:
            [self TemplateFour];
            [self reloadInputViews];
            break;
        default:
            break;
    }
}

-(NSDictionary*)getFaceInfo{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger number =  [[accountDefaults objectForKey:@"id"] integerValue]+1;
    [accountDefaults setInteger:number forKey:@"id"];
    UIGraphicsEndImageContext();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *phtotPathsName = [NSString stringWithFormat:@"edayPhotoBefore%li.png",(long)number];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:phtotPathsName];
    
    NSData *data = [NSData ]
    [FaceTool ChickFace:[NSData i]

    return imgInfo;
}

@end
