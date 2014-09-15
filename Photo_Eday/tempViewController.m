//
//  tempViewController.m
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "tempViewController.h"
#import "TimeTool.h"
#import "ImgHistory.h"
#import "CoreDataTool.h"
#import <objc/runtime.h>
#import "FaceTool.h"
#import "shareViewController.h"
#import "ImageTool.h"
#import "LocationTool.h"
#import "SVProgressHUD.h"
#import "Internet.h"
#define PageH ([[UIScreen mainScreen] bounds].size.height)
#define PageW ([[UIScreen mainScreen] bounds].size.width)
#define GREENCOLOR	([UIColor colorWithRed:102.0f/255 green:217.0f/255 blue:165.0f/255 alpha:1.0])

#define REDCOLOR	([UIColor colorWithRed:232.0f/255 green:85.0f/255 blue:85.0f/255 alpha:1.0])
@interface tempViewController ()
@property (strong, nonatomic) NSOperationQueue* myQueue;
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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.myQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"人脸识别中请稍后..."];

    self.view.userInteractionEnabled= NO;
    
    _middleImage.image = _imagebefore;


}
-(void)viewDidAppear:(BOOL)animated{
    NSInteger internetType = [Internet ChickInternet];
    
    if (internetType==0) {
        [SVProgressHUD dismiss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲,当前没网络哦" message:nil delegate:self cancelButtonTitle:@"返回主页" otherButtonTitles:nil];
        alertView.tag = 0;
        [alertView show];
    }else{
    _imgInfo=  [FaceTool ChickFace:_imageData];
    NSArray *faceArr  = [_imgInfo objectForKey:@"face"];
    
    
    
    if ([faceArr count]==0 && isbacktomain==NO) {
//        [SVProgressHUD showErrorWithStatus:@"识别失败"];
        [SVProgressHUD dismiss];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲,没找到人脸哦" message:nil delegate:self cancelButtonTitle:@"重新拍一张" otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"识别成功"];

        _agevalue = [FaceTool getAge:_imgInfo] ;
        _happyvalue = [FaceTool getHappy:_imgInfo];
        _desSentence = [FaceTool getDescriptionSentence:_imgInfo];
        _desTitle = [FaceTool getDescriptionTitle:_imgInfo];
        _creattime = [NSDate date];
        [self TemplateThree];
        [self getcity];
           }
    }
    self.view.userInteractionEnabled = YES;
}

-(void)getweather:(NSString*)city{

    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * codeCity =  [accountDefaults objectForKey:@"cityCode"];
    NSString *code = [NSString stringWithFormat:@"http://www.weather.com.cn/data/cityinfo/%@.html",[codeCity objectForKey:city] ];
    
    NSString *googleURL =code;
    
    NSURL *url = [NSURL URLWithString:googleURL];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    
    [NSURLConnection sendAsynchronousRequest:request queue:self.myQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *weatherinfo = [dict objectForKey:@"weatherinfo"];
        NSString *weather = [weatherinfo objectForKey:@"weather"];
        NSString *weatherfk = @"多云";
        NSRange range=[weather rangeOfString:@"转"];
        if (range.length != 0 ) {
         weatherfk = [weather substringWithRange:NSMakeRange(range.location+1,weather.length-range.location-1)];
        }else{
            weatherfk =weather;
        }
        if ([weatherfk isEqualToString:@"晴"]) {
            _weatherimage = [UIImage imageNamed:@"sunny.png"];
        }else if([weatherfk isEqualToString:@"多云"]) {
            _weatherimage = [UIImage imageNamed:@"cloud.png"];
        }else if([weatherfk isEqualToString:@"阴"]){
            _weatherimage = [UIImage imageNamed:@"nosun.png"];
        }else if([weatherfk isEqualToString:@"多云"]) {
            _weatherimage = [UIImage imageNamed:@"cloud.png"];
        }else if([weatherfk isEqualToString:@"小雨"]) {
            _weatherimage = [UIImage imageNamed:@"rain1.png"];
        }else if([weatherfk isEqualToString:@"中雨"]) {
            _weatherimage = [UIImage imageNamed:@"rain2.png"];
        }else if([weatherfk isEqualToString:@"大雨"]) {
            _weatherimage = [UIImage imageNamed:@"rain3.png"];
        }else if([weatherfk isEqualToString:@"暴雨"]) {
            _weatherimage = [UIImage imageNamed:@"rain4.png"];
        }else if([weatherfk isEqualToString:@"阵雨"]) {
            _weatherimage = [UIImage imageNamed:@"rain5.png"];
        }else if([weatherfk isEqualToString:@"雷阵雨"]) {
            _weatherimage = [UIImage imageNamed:@"rain6.png"];
        }else if([weatherfk isEqualToString:@"小雪"]) {
            _weatherimage = [UIImage imageNamed:@"snow1.png"];
        }else if([weatherfk isEqualToString:@"中雪"]) {
            _weatherimage = [UIImage imageNamed:@"snow2.png"];
        }else if([weatherfk isEqualToString:@"大雪"]) {
            _weatherimage = [UIImage imageNamed:@"snow3.png"];
        }else if([weatherfk isEqualToString:@"雨夹雪"]) {
            _weatherimage = [UIImage imageNamed:@"snowrain.png"];
        }else if([weatherfk isEqualToString:@"阵雪"]) {
            _weatherimage = [UIImage imageNamed:@"snow4.png"];
        }else if([weatherfk isEqualToString:@"沙尘暴"]) {
            _weatherimage = [UIImage imageNamed:@"gotodead.png"];
        }else{
            _weatherimage = [UIImage imageNamed:@"deadagain.png"];
        }
    
        _weatherstring = weatherfk;
}];
    

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag ==1) {
        if (buttonIndex==0) {
            [self takephotoagain];
        }
    }else if (alertView.tag ==0){
        if (buttonIndex==0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backMain) name:@"backmain" object:nil];
    [self getlocation];
    _middleImage  = [[UIImageView alloc]init];
    _middleImage = [ImageTool setImageSize:_middleImage];
    _middleImage.image = _imagebefore;
    
    [self.view addSubview:_middleImage];
    [self SetTemplate];
    [self setUI];

    chickTemplateOpen = NO;
    ischanged = NO;
    
    

    [super viewDidLoad];

    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)backMain{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    _watermark =[UIImageView new];
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
    [_watermark removeFromSuperview];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [self.navigationController popToRootViewControllerAnimated:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"backmain" object:nil];
    isbacktomain = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)takephotoagain{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//        picker.allowsEditing = YES;  //是否可编辑
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.delegate = self;        //摄像头
//        [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];

    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    isbacktomain =NO;
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    _imagebefore = image;
    isSecendtake = YES;
    if (ischanged) {
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger number =  [[accountDefaults objectForKey:@"id"] integerValue];
        number =  [[accountDefaults objectForKey:@"id"] integerValue]+1;
        [accountDefaults setInteger:number forKey:@"id"];
        [accountDefaults synchronize];

    }
    ischanged = NO;
    
//    if(UIGraphicsBeginImageContextWithOptions != NULL)
//    {
//        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
//    } else {
//        UIGraphicsBeginImageContext(image.size);
//    }
    UIGraphicsBeginImageContext(image.size);
    [picker.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIImage *imaged = [self rotateImage:image];
    NSData* fileData = UIImagePNGRepresentation(viewImage);
    _imageData = fileData;
//    NSDictionary * imgInfo=  [FaceTool ChickFace:fileData];
//    _agevalue = [FaceTool getAge:imgInfo];
//    _happyvalue = [FaceTool getHappy:imgInfo];
//    _desSentence = [FaceTool getDescriptionSentence:imgInfo];
//    _desTitle = [FaceTool getDescriptionTitle:imgInfo];

    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)bingo{
    self.view.userInteractionEnabled = NO;
//        UIImage *turnimage = _middleImage.image;
//    UIGraphicsEndImageContext();
    if (!ischanged ) {
        [self addwatermark];

        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(_middleImage.frame.size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(_middleImage.frame.size);
        }
//    UIGraphicsBeginImageContext(_middleImage.frame.size);
    [_middleImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
        _middleImage.image = [FaceTool getImage:_imgInfo];
        _imagebeforechanged = viewImage;
        _imageafter = [FaceTool getImage:_imgInfo];
        ischanged =YES;
        bingochange =YES;
        [_watermark removeFromSuperview];
    }else if (bingochange == YES){
        UIGraphicsBeginImageContext(_middleImage.bounds.size);
        //2.把显示内容渲染进画布
        [_middleImage.layer renderInContext:UIGraphicsGetCurrentContext()];
        //3.把图片从画布中取出来
        UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
        _imageafterchanged = viewImage;
        _middleImage.image = _imagebefore;
        bingochange = NO;
    }else if (bingochange == NO){
        _middleImage.image =  _imageafter;
        bingochange = YES;
    }
    
    self.view.userInteractionEnabled = YES;
}

-(void)shareandsave{

    [self addwatermark];
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger number =  [[accountDefaults objectForKey:@"id"] integerValue];
    

//    ischanged=bingochange;

    NSString *phtotPathsName = @" ";
    if (bingochange) {
        
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(_middleImage.frame.size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(_middleImage.frame.size);
        }
        
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0);
        //1.创建画布
//        UIGraphicsBeginImageContext(_middleImage.bounds.size);
        //2.把显示内容渲染进画布
        [_middleImage.layer renderInContext:UIGraphicsGetCurrentContext()];
        //3.把图片从画布中取出来
        _imageafterchanged = UIGraphicsGetImageFromCurrentImageContext();
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *beforephotoPathsName = [NSString stringWithFormat:@"edayPhotoBefore%li.png",(long)number];
        NSString *filePathbefore = [[paths objectAtIndex:0] stringByAppendingPathComponent:beforephotoPathsName]; // 保存文件的名称,照片的路径
        [UIImagePNGRepresentation(_imagebeforechanged)writeToFile:filePathbefore atomically:YES]; // 保存成功会返回YES
        [CoreDataTool insertInfo:number andCreatTime:[TimeTool getCreatTime: _creattime] andPhtotPath:filePathbefore anddtitle:_destributionTitle.text andsentence:_destributionSentence.text];
        
            phtotPathsName = [NSString stringWithFormat:@"edayPhotoAfter%li.png",(long)number];
        
            number =  [[accountDefaults objectForKey:@"id"] integerValue]+1;
            [accountDefaults setInteger:number forKey:@"id"];
            [accountDefaults synchronize];
            NSString *filePathafter = [[paths objectAtIndex:0] stringByAppendingPathComponent:phtotPathsName];
            [UIImagePNGRepresentation(_imageafterchanged)writeToFile: filePathafter atomically:YES];
            [CoreDataTool insertInfo:number andCreatTime:[TimeTool getCreatTime: _creattime] andPhtotPath:filePathafter anddtitle:_destributionTitle.text andsentence:_destributionSentence.text];
    

        ischanged = NO;
        shareViewController* vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"share"];
        vc.image = _imageafterchanged;
        vc.imagePath = filePathafter;
        [self.navigationController pushViewController:vc animated:YES];
    }else{

//        UIGraphicsBeginImageContext(_middleImage.frame.size);
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(_middleImage.frame.size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(_middleImage.frame.size);
        }
        [_middleImage.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
        _imagebeforechanged = viewImage;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        phtotPathsName = [NSString stringWithFormat:@"edayPhotoBefore%li.png",(long)number];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:phtotPathsName];
        _imagebefore = [self rotateImage:_imagebefore];
        [UIImagePNGRepresentation(_imagebeforechanged)writeToFile: filePath atomically:YES];
        [CoreDataTool insertInfo:number andCreatTime:[TimeTool getCreatTime: _creattime] andPhtotPath:filePath anddtitle:_destributionTitle.text andsentence:_destributionSentence.text];
        
        
        if (ischanged) {
            phtotPathsName = [NSString stringWithFormat:@"edayPhotoAfter%li.png",(long)number];

            NSString *filePathafter = [[paths objectAtIndex:0] stringByAppendingPathComponent:phtotPathsName];
            [UIImagePNGRepresentation(_imageafterchanged)writeToFile: filePathafter atomically:YES];
            [CoreDataTool insertInfo:number andCreatTime:[TimeTool getCreatTime: _creattime] andPhtotPath:filePathafter anddtitle:_destributionTitle.text andsentence:_destributionSentence.text];
        }
        number =  [[accountDefaults objectForKey:@"id"] integerValue]+1;
        [accountDefaults setInteger:number forKey:@"id"];
        [accountDefaults synchronize];
        
        ischanged = NO;
        shareViewController* vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"share"];
        vc.image = _imagebeforechanged;
        vc.imagePath = filePath;
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}

-(void)backback{
    if (ischanged) {
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger number =  [[accountDefaults objectForKey:@"id"] integerValue];
        number =  [[accountDefaults objectForKey:@"id"] integerValue]+1;
        [accountDefaults setInteger:number forKey:@"id"];
        [accountDefaults synchronize];
    }

    
    [self.navigationController popToRootViewControllerAnimated:YES];
     
     }

-(void)bakmain{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setUI{
    //UP
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(0, 0, 66, 18) ;
//    UIImage* image = [UIImage imageNamed:@"saveandshare.png"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//保持原有形态
//    [btn1 setImage:image forState:UIControlStateNormal];
////    [btn1 setTitle:@"保存与分享" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(shareandsave) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
//    self.navigationController.navigationItem.leftBarButtonItem.title = @"返回";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存  " style:UIBarButtonItemStyleBordered target:self action:@selector(shareandsave)];

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(bakmain)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(bakmain)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake(-10, -3, 46, 19) ;
//    UIImage* image = [UIImage imageNamed:@"back.png"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [btn setImage:image forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(backback) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backback)];

    
  //DOWN
    _buttomBackGround = [[UIImageView alloc]initWithFrame:CGRectMake(0, PageH-64, PageW, 64)];
    _buttomBackGround.userInteractionEnabled = YES;//打开用户交互
    _buttomBackGround.image = [UIImage imageNamed:@"greenback.png"];
    [self.view addSubview:_buttomBackGround];
    
    _templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _templateButton.frame = CGRectMake(35, 3.5, 36, 54);
    [_templateButton setImage:[UIImage imageNamed:@"template.png"]forState:UIControlStateNormal];
    [_templateButton addTarget:self action:@selector(ChickTemplate) forControlEvents:UIControlEventTouchUpInside];
    [_buttomBackGround addSubview:_templateButton];
    
    _binggoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _binggoButton.frame = CGRectMake(PageW-73, 3.5, 36, 54);
    [_binggoButton setImage:[UIImage imageNamed:@"binggo.png"] forState:UIControlStateNormal];
    [_binggoButton addTarget:self action:@selector(bingo) forControlEvents:UIControlEventTouchUpInside];
    [_buttomBackGround addSubview:_binggoButton];
    
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraButton.frame = CGRectMake(PageW/2-35, 3, 60, 60);
    [_cameraButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [_cameraButton addTarget:self action:@selector(takephotoagain) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttomBackGround addSubview:_cameraButton];

}


//弹出小模版列表
-(void)ChickTemplate{

    if (!chickTemplateOpen) {
        [UIView animateWithDuration:0.3 animations:^{[_tempScroll setFrame:CGRectMake(0, PageH-64-76, PageW, 78)];
        }completion:^(BOOL finished) {
            chickTemplateOpen = YES;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{[_tempScroll setFrame:CGRectMake(0, PageH-64, PageW, 76)];
        }completion:^(BOOL finished) {
            chickTemplateOpen = NO;
        }];
    }
}
-(void)addwatermark{
        _watermark =[UIImageView new];
        _watermark.image = [UIImage imageNamed:@"watermark.png"];

    switch (_templete) {
        case templeteOne:
            _watermark.frame = CGRectMake(0, 0, 70, 20);
            break;
        case templeteTwo:
            _watermark.frame = CGRectMake(0, 0, 70, 20);
            break;
        case templeteThree:
            _watermark.frame = CGRectMake(PageW-70, 0, 70, 20);
            break;
        case templeteFour:
            if (PageH ==568) {
                _watermark.frame = CGRectMake(PageW-70, _middleImage.frame.size.height-20, 70, 20);
                
            }else{
                _watermark.frame = CGRectMake(PageW-70, PageH-84, 70, 20);
                
            }
            break;
        case templeteFive:
            _watermark.frame = CGRectMake(PageW-70, 0, 70, 20);
            break;
        case templeteSix:
            _watermark.frame = CGRectMake(PageW-70, 0, 70, 20);
            break;
            
        default:
            break;
    }
    [_middleImage addSubview:_watermark];


}
-(void)TemplateOne{
    [self removesubview];
    [self initsubview];
    _templete = templeteOne;
    //middle image
    _destributionView.frame = CGRectMake(15, _middleImage.frame.size.height-150, 240, 90);
    _destributionView.backgroundColor = [UIColor grayColor];
    _destributionView.alpha = 0.2;
    [_middleImage addSubview:_destributionView];
    
    _destributionTitle.frame = CGRectMake(18,_middleImage.frame.size.height-150, 140, 35);
    _destributionTitle.text = _desTitle;
    _destributionTitle.alpha = 10;
    _destributionTitle.textColor = [UIColor whiteColor];
    _destributionTitle.font = [UIFont fontWithName:@"Verdana" size:21.0];;
    [_middleImage addSubview:_destributionTitle];
    
    _destributionSentence.Frame = CGRectMake(18, _middleImage.frame.size.height-126, 240, 50);
    _destributionSentence.numberOfLines = 2;
        _destributionSentence.text = _desSentence;

    _destributionSentence.textColor = [UIColor whiteColor];
    _destributionSentence.alpha = 10;
    _destributionSentence.font = [UIFont fontWithName:@"Verdana" size:16.0];;
    [_middleImage addSubview:_destributionSentence];
    
    
    _timeView.Frame=CGRectMake(PageW-90, _middleImage.frame.origin.y-50, 80, 80);
    _timeView.tintColor = [UIColor whiteColor];
    [_middleImage addSubview:_timeView];
    
    _monthday.Frame=CGRectMake(0, 0, 80, 35);
    _monthday.textColor = [ UIColor whiteColor];
    _monthday.text = [TimeTool getMonthAndDay];
    _monthday.textAlignment=NSTextAlignmentRight;
    _monthday.font = [UIFont boldSystemFontOfSize:22];
    [_timeView addSubview:_monthday];
    
    _loc.Frame=CGRectMake(0, 28, 80, 25);
    _loc.textColor = [ UIColor whiteColor];
    _loc.text = _city;
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
    _templete = templeteTwo;
    
    _destributionView .Frame=CGRectMake(15, _middleImage.frame.size.height-285, 55, 170);
    [_middleImage addSubview:_destributionView];
    
    _destributionTitle.Frame = CGRectMake(3,0, 40, 165);
    _destributionTitle.text = _desTitle;
    _destributionTitle.numberOfLines = [_destributionTitle.text length];
    _destributionTitle.textColor = [UIColor whiteColor];
    _destributionTitle.font = [UIFont boldSystemFontOfSize:25.0];
    [_destributionView addSubview:_destributionTitle];

    _ageimage.frame = CGRectMake(3, 169, 15, 15);
    _ageimage.image = [UIImage imageNamed:@"age.png"];
    [_destributionView addSubview:_ageimage];
    _agelabel.frame = CGRectMake(24, 166, 65, 25);
    _agelabel.text = [NSString stringWithFormat:@"年龄:%i", _agevalue];
    _agelabel.textColor = [UIColor whiteColor];
    _agelabel.font = [UIFont fontWithName:@"Verdana" size:13.5];
    [_destributionView addSubview:_agelabel];
    
    _happyimage.frame = CGRectMake(3, 187, 15, 15);
    _happyimage.image = [UIImage imageNamed:@"happy.png"];
    [_destributionView addSubview:_happyimage];
    _happylabel.frame = CGRectMake(24, 185, 65, 25);
    _happylabel.text = [NSString stringWithFormat:@"开心:%i",_happyvalue];
    _happylabel.textColor = [UIColor whiteColor];
    _happylabel.font = [UIFont fontWithName:@"Verdana" size:13.5];
    [_destributionView addSubview:_happylabel];
    
    

    
    _timeView = [[UIView alloc]initWithFrame:CGRectMake(PageW-90, _middleImage.frame.origin.y-50, 90, 70)];
    [_middleImage addSubview:_timeView];
    _loc.Frame=CGRectMake(0, 48, 80, 25);
    _loc.textColor = [ UIColor whiteColor];
    _loc.text = _city;
    _loc.textAlignment = NSTextAlignmentRight;
    _loc.font = [UIFont fontWithName:@"Verdana" size:17.0];
    [_timeView addSubview:_loc];
    
    _locimg.Frame = CGRectMake(25, 50, 20, 20);
    _locimg.image = [UIImage imageNamed:@"iconwhite.png"];
    [_timeView addSubview:_locimg];
    
    _monthday.Frame=CGRectMake(25, 5, 60, 45);
    _monthday.textColor = [ UIColor whiteColor];
    _monthday.text = _weatherstring;
    _monthday.textAlignment=NSTextAlignmentRight;
    _monthday.font = [UIFont boldSystemFontOfSize:26];
    [_timeView addSubview:_monthday];
    
    _weather.frame = CGRectMake(-5, 10, 40, 35);
    _weather.image = _weatherimage;
    [_timeView addSubview:_weather];
    
}
-(void)TemplateThree{
    [self removesubview];
    [self initsubview];
    _templete = templeteThree;
    _destributionView.Frame=CGRectMake(0, _middleImage.frame.size.height-165, 300, 70);
    [_middleImage addSubview:_destributionView];

    _destributionTitle.frame = CGRectMake(20, 3, 150, 35);
    _destributionTitle.textColor = [UIColor whiteColor];
    _destributionTitle.font = [UIFont boldSystemFontOfSize:24.0];
    _destributionTitle.text = _desTitle;
    [_destributionView addSubview:_destributionTitle];
    
    _weather.frame = CGRectMake(0, 35, 160, 1);
    _weather.image = [UIImage  imageNamed:@"line.png"];
    [_destributionView addSubview:_weather];
    
    _ageimage.frame = CGRectMake(51, 40, 26, 21);
    _ageimage.image = [UIImage imageNamed:@"diamond.png"];
    [_destributionView addSubview:_ageimage];
    
    _destributionSentence.frame = CGRectMake(85, 35, PageW-85, 50);
    _destributionSentence.numberOfLines = 2;
    _destributionSentence.textColor = [UIColor whiteColor];
    _destributionSentence.font = [UIFont fontWithName:@"" size:23];
    _destributionSentence.text = _desSentence;
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
    
    _hourmin.Frame = CGRectMake(27, 5, 120, 80);
    _hourmin.textColor = [ UIColor whiteColor];
    _hourmin.text = [TimeTool getHoursAndMin];
    _hourmin.textAlignment = NSTextAlignmentLeft;
    _hourmin.font = [UIFont fontWithName:@"Verdana" size:18.5];
    [_timeView addSubview:_hourmin];

}
-(void)TemplateFour{
    [self removesubview];
    [self initsubview];
    _templete = templeteFour;
    
    _backgaryfirst.frame = CGRectMake(0, 20, PageW, 20);
    _backgaryfirst.backgroundColor = [UIColor grayColor];
    _backgaryfirst.alpha = 0.3;
    [_middleImage addSubview:_backgaryfirst];
    
    _backgarysecend.frame = CGRectMake(190, 40, PageW-160, 20);
    _backgarysecend.backgroundColor = [UIColor grayColor];
    _backgarysecend.alpha = 0.2;
    [_middleImage addSubview:_backgarysecend];
    
    _locimg.frame = CGRectMake(200, 20, 17, 17);
    _locimg.image = [UIImage imageNamed:@"locred.png"];
    [_middleImage addSubview:_locimg];
    
    _loc.frame = CGRectMake(220, 20, 120, 20);
    _loc.textAlignment = NSTextAlignmentLeft;
    _loc.text = _city;
    _loc.textColor = [UIColor whiteColor];
    _loc.font = [UIFont fontWithName:@"Verdana" size:12];
    [_middleImage addSubview:_loc];
    
    _hourmin.frame = CGRectMake(160, 40, PageW-160, 20);
    _hourmin.textAlignment = NSTextAlignmentRight;
    _hourmin.text = [TimeTool getMonthDateHoursAndMin:_creattime];
    _hourmin.font = [UIFont fontWithName:@"" size:11];
    [_middleImage addSubview:_hourmin];
    
    
    _destributionView.frame = CGRectMake(20, PageH-420, 100, 200);
    [_middleImage addSubview:_destributionView];
    
    _destributionTitle.frame = CGRectMake(0, 0, 35, 170);
    _destributionTitle.numberOfLines = [_destributionTitle.text length];
    
    _destributionTitle.text = _desTitle;
    _destributionTitle.font = [UIFont boldSystemFontOfSize:25];
    _destributionTitle.textColor = [UIColor whiteColor];
    [_destributionView addSubview:_destributionTitle];
    
    
    _destributionSentence.frame = CGRectMake(30, 50, 20, 200);
    _destributionSentence.numberOfLines = [_destributionSentence.text length];
    
    if (_desSentence.length>10) {
        NSRange rang = NSMakeRange(0, 10);
        NSString *stringfirst = [_desSentence substringWithRange:rang];
        _destributionSentence.text = stringfirst;
        _destributionSentence.font = [UIFont boldSystemFontOfSize:14];
        _destributionSentence.textColor = [UIColor whiteColor];
        [_destributionView addSubview:_destributionSentence];

        
        
        if (_desSentence.length - 10 >10) {
            
            NSRange rangg1 = NSMakeRange(10, 10);
            _monthday.frame = CGRectMake(55, 70, 20, 200);
            NSString *stringsec = [_desSentence substringWithRange:rangg1];
            _monthday.text = stringsec;
            _monthday.textColor = [UIColor whiteColor];
            _monthday.numberOfLines = [_monthday.text length];
            _monthday.font = [UIFont boldSystemFontOfSize:14];
            [_destributionView addSubview:_monthday];
            
            
            NSRange rangg = NSMakeRange(10, _desSentence.length-10-10);
            _agelabel.frame = CGRectMake(80, 90, 20, 200);
            NSString *stringthird = [_desSentence  substringWithRange:rangg];
            _agelabel.text = stringthird;
            _agelabel.textColor = [UIColor whiteColor];
            _agelabel.numberOfLines = [_monthday.text length];
            _agelabel.font = [UIFont boldSystemFontOfSize:14];
            [_destributionView addSubview:_monthday];
        }else{
            NSRange rangg = NSMakeRange(10, _desSentence.length-10);
            _monthday.frame = CGRectMake(55, 70, 20, 200);
            NSString *stringsec = [_desSentence substringWithRange:rangg];
            _monthday.text = stringsec;
            _monthday.textColor = [UIColor whiteColor];
            _monthday.numberOfLines = [_monthday.text length];
            _monthday.font = [UIFont boldSystemFontOfSize:14];
            [_destributionView addSubview:_monthday];
        }

        
        
     

        
    }
    else{
        _destributionSentence.text = _desSentence;
        _destributionSentence.font = [UIFont boldSystemFontOfSize:16.5];
        _destributionSentence.textColor = [UIColor whiteColor];
        [_destributionView addSubview:_destributionSentence];
    }
    
    
    
}
-(void)TemplateFive{
    [self removesubview];
    [self initsubview];
    _templete = templeteFive;
    
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
    _hourmin.font = [UIFont fontWithName:@"Verdana" size:16];
    _hourmin.textAlignment = NSTextAlignmentRight;
    [_timeView addSubview:_hourmin];
    
    _loc.frame = CGRectMake(0, 35, 100, 30);
    _loc.text = _city;
    _loc.textAlignment = NSTextAlignmentRight;
    _loc.textColor = [UIColor whiteColor];
    _loc.font = [UIFont boldSystemFontOfSize:16];
    [_timeView addSubview:_loc];
    
    _locimg.frame = CGRectMake(50, 40, 15, 18);
    _locimg.image = [UIImage imageNamed:@"locsnip.png"];
    [_timeView addSubview:_locimg];
    
    
    _destributionView.frame = CGRectMake(0, PageH-230, PageW, 60);
    [_middleImage addSubview:_destributionView];
    
    _happylabel.frame = CGRectMake(180, -3, PageW-180, 35);
    _happylabel.backgroundColor = [UIColor grayColor];
    _happylabel.alpha = 0.2;
    [_destributionView addSubview:_happylabel];
    
    _destributionTitle.frame = CGRectMake(180, -10, 140, 50);
    _destributionTitle.textColor = [UIColor whiteColor];
    _destributionTitle.text = _desTitle;
    _destributionTitle.font = [UIFont boldSystemFontOfSize:23];
    [_destributionView addSubview:_destributionTitle];
    
    _destributionSentence.frame = CGRectMake(0, 20, _destributionView.frame.size.width-20, 80);
    _destributionSentence.numberOfLines = 2;
    _destributionSentence.textColor = [UIColor whiteColor];
    _destributionSentence.text = _desSentence;
    _destributionSentence.font = [UIFont boldSystemFontOfSize:18];
    _destributionSentence.textAlignment = NSTextAlignmentRight;
    [_destributionView addSubview:_destributionSentence];
    

}
-(void)TemplateSix{
    [self removesubview];
    [self initsubview];
    
    _templete = templeteSix;

    
    _timeView.frame = CGRectMake(0, 0, 100, 100);
    [_middleImage addSubview:_timeView];
    
    _weather.frame = CGRectMake(20, 5, 40, 35);
    _weather.image = _weatherimage;
    [_timeView addSubview:_weather];
    
    _loc.frame = CGRectMake(52, -10, 50, 70);
    _loc.textAlignment = NSTextAlignmentRight;
    _loc.font = [UIFont boldSystemFontOfSize:20];
    _loc.textColor = [UIColor whiteColor];
    _loc.text = _weatherstring;
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
    _destributionTitle.text = [NSString stringWithFormat:@"%@", _desTitle];
    _destributionTitle.textAlignment = NSTextAlignmentRight;
    [_middleImage addSubview:_destributionTitle];
    
    _ageimage.frame = CGRectMake(PageW-160, PageH-180, 15, 15);
    _ageimage.image = [UIImage imageNamed:@"age.png"];
    [_middleImage addSubview:_ageimage];
    
    _agelabel.text = [NSString stringWithFormat:@"年龄:%i",_agevalue];
    _agelabel.font = [UIFont fontWithName:@"Verdana" size:15];
    _agelabel.textColor = [UIColor whiteColor];
    _agelabel.frame = CGRectMake(PageW-140, PageH-198, 90, 50);
    [_middleImage addSubview:_agelabel];
    
    _happyimage.frame = CGRectMake(PageW-160, PageH-165, 15, 15);
    _happyimage.image = [UIImage imageNamed:@"happy.png"];
    [_middleImage addSubview:_happyimage];
    
    _happylabel.frame = CGRectMake(PageW-140, PageH-182, 90, 50);
    _happylabel.text = [NSString stringWithFormat:@"开心:%i",_happyvalue];
    _happylabel.textColor = [UIColor whiteColor];
    _happylabel.font = [UIFont fontWithName:@"Verdana" size:15];
    [_middleImage addSubview:_happylabel];
    
    _locimg.frame = CGRectMake(PageW-70, PageH-205, 50, 60);
    _locimg.image = [UIImage imageNamed:@"hat.png"];
    [_middleImage addSubview:_locimg];

}
-(void)SetTemplate{
    _tempScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, PageH-64, PageW, 76)];
    [_tempScroll showsHorizontalScrollIndicator];
    _tempScroll.backgroundColor = [UIColor blackColor];
    _tempScroll.alpha = 0.6;
    [_tempScroll setContentSize:CGSizeMake(80*6+20, 76)];
    [self.view addSubview:_tempScroll];
    
    _templateBK = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80*9+20, 76)];
//    _templateBK.image = [UIImage imageNamed:@"templateBK.png"];
    _templateBK.userInteractionEnabled = YES;
    [_tempScroll addSubview:_templateBK];
    
    UIButton *template1 = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, 55, 66)];
    template1.tag =1;
    [template1 setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [template1 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template1];
    
    UIButton *template2 = [[UIButton alloc]initWithFrame:CGRectMake(15+80, 5, 55, 66)];
    template2.tag =2;
    [template2 setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [template2 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template2];
    
    
    UIButton *template3 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*2, 5, 55, 66)];
    template3.tag =3;
    [template3 setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [template3 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template3];
    
    UIButton *template4 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*3, 5, 55, 66)];
    template4.tag =4;
    [template4 setImage:[UIImage imageNamed:@"5"] forState:UIControlStateNormal];
    [template4 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template4];
    
    UIButton *template5 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*4, 5, 55, 66)];
    template5.tag =5;
    [template5 setImage:[UIImage imageNamed:@"6"] forState:UIControlStateNormal];
    [template5 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template5];
    
    UIButton *template6 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*5, 5, 55, 66)];
    template6.tag =6;
    [template6 setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
    [template6 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [_templateBK addSubview:template6];
    
//    UIButton *template7 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*6, 5, 55, 66)];
//    template7.tag =7;
//    [template7 setImage:[UIImage imageNamed:@"模板_8"] forState:UIControlStateNormal];
//    [template7 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
//    [_templateBK addSubview:template7];
//    
//    UIButton *template8 = [[UIButton alloc]initWithFrame:CGRectMake(15+80*7, 5, 55, 66)];
//    template8.tag =8;
//    [template8 setImage:[UIImage imageNamed:@"模板_9"] forState:UIControlStateNormal];
//    [template8 addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
//    [_templateBK addSubview:template8];
    
    

}
-(void)chooseTemplate:(UIButton*)sender{
    [UIView animateWithDuration:0.3 animations:^{[_tempScroll setFrame:CGRectMake(0, PageH-64, PageW, 76)];
    }completion:^(BOOL finished) {
        chickTemplateOpen = NO;
    }];

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
        default:
            break;
    }
}

-(void)getlocation{
    
    //初始化CLLocationManager
    locationManager =[[CLLocationManager alloc]init];
    //设置当前委托，此委托CLLocationManagerDelegate
    locationManager.delegate = self;
    //设置精准度为忧
    locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    //设置距离筛选器,告知位置管理器直到iphone从以前报告的位置移动至少100米才通知委托。
    locationManager.distanceFilter = 100.0f;
    //开始更新数据
    [locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    currLat =  newLocation.coordinate.latitude;
    currLog =  newLocation.coordinate.longitude;
    
}
-(void)getcity{
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:currLat longitude:currLog];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *array, NSError *error) {
        
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            _city = placemark.administrativeArea;
            NSRange range = NSMakeRange(0, placemark.administrativeArea.length-1);
            NSString *city = [placemark.administrativeArea substringWithRange:range];
            _city = city;
            [self getweather:city];
        }
    }];
    
    
}


- (UIImage*)rotateImage:(UIImage *)image
{
    int kMaxResolution = 960; // Or whatever
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


@end
