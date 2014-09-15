//
//  mainViewController.m
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "mainViewController.h"
#import "FaceTool.h"
#import "tempViewController.h"
#import "TimeTool.h"
#import "CoreDataTool.h"
#import "shareViewController.h"
#import "detailImageViewController.h"
#import "ImageTool.h"
#import "Internet.h"
#import "UMFeedbackViewController.h"

#define PageH [[UIScreen mainScreen] bounds].size.height
#define PageW [[UIScreen mainScreen] bounds].size.width
#define GREENCOLOR	([UIColor colorWithRed:102.0f/255 green:217.0f/255 blue:165.0f/255 alpha:1.0])

@interface mainViewController () <DetailCellDelegate>
@property (strong, nonatomic) NSMutableArray *creatTimes;
@property (strong, nonatomic) NSArray *creatTimeData;



@end


@implementation mainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadData];
    [_maintable reloadData];

    if ([_creatTimes count] != 0) {
        _hintimage.hidden = YES;
    }else _hintimage.hidden = NO;
    
    
    if ([_creatTimes count]==0) {
        _garyline.hidden =YES;
    }else _garyline.hidden = NO;
    _umFeedback.delegate = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];

    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    
//    if ([Internet ChickInternet]==0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"关闭飞行模式或者使用无线局域网来来进行人脸识别" message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles:@"设置",nil];
//        [alertView  show];
//    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex==0) {
//            NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
//            [[UIApplication sharedApplication] openURL:url];
        }
}

- (void)dealloc {
    _umFeedback.delegate = nil;
}
-(void)reloadData{
    _creatTimes = [NSMutableArray new];
    
    _creatTimeData = [CoreDataTool getCreateTimes];
    for ( int i=0; i<[_creatTimeData count]; i++) {
        NSDate *timelist = [TimeTool stringFromDate:[_creatTimeData objectAtIndex:i]];
        NSString *timelistString = [TimeTool GetTime:timelist];
        [_creatTimes addObject:timelistString];
    }

    

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_creatTimes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simple=@"simple";
    DetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simple];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"DetailTableViewCell" owner:self options:nil]lastObject];
    }
    
    if (indexPath.row%2==0) {
        cell.photoChange.frame= CGRectMake(14, 22, 52, 52);
        cell.photoOriginal.frame = CGRectMake(74, 22, 52, 52);
        cell.timeLabel.frame = CGRectMake(195, 22, 105, 52);

    }
    
    cell.backgroundColor = [UIColor clearColor];
    NSString *pathbefore = [CoreDataTool getImageBeforePathByCreatetime:[_creatTimeData objectAtIndex:indexPath.row]];
    NSData* filebeforeData = [NSData dataWithContentsOfFile:pathbefore];
    UIImage * imagebefroe = [UIImage imageWithData:filebeforeData];
    if (!pathbefore) {
        cell.photoOriginal.hidden = YES;
    }else
        cell.photoOriginal.hidden = NO;
    [cell.photoOriginal setImage:imagebefroe forState:UIControlStateNormal];
    

    
    NSString *pathafter = [CoreDataTool getImageAfterPathByCreatetime:[_creatTimeData objectAtIndex:indexPath.row]];
    if (!pathafter) {
        cell.photoChange.hidden = YES;
    }else
        cell.photoChange.hidden = NO;
    NSData* fileafterData = [NSData dataWithContentsOfFile:pathafter];
    UIImage * imageafter = [UIImage imageWithData:fileafterData];
    [cell.photoChange setImage:imageafter forState:UIControlStateNormal];


        
    cell.timeLabel.text = [_creatTimes objectAtIndex:indexPath.row];
        cell.delegate = self;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
////    [tableView resignFirstResponder];
//}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0){
    return NO;
}

-(void)turnDetailController:(DetailTableViewCell *)cell and:(UIButton *)sender {
    NSIndexPath* indexPath = [self.maintable indexPathForCell:cell];
    
    NSData   *fileData = [[NSData alloc]init];
    if (sender.tag == 1) {
        NSString *pathbefore = [CoreDataTool getImageBeforePathByCreatetime:[_creatTimeData objectAtIndex:indexPath.row]];
        fileData = [NSData dataWithContentsOfFile:pathbefore];
    } else if (sender.tag == 2) {
        NSString *pathafter = [CoreDataTool getImageAfterPathByCreatetime:[_creatTimeData objectAtIndex:indexPath.row]];
        fileData = [NSData dataWithContentsOfFile:pathafter];
    }
    
    NSLog(@"%i",sender.tag);
            detailImageViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
            detail.middleimage = [UIImage imageWithData:fileData];
            detail.creattime = [_creatTimeData objectAtIndex:indexPath.row];
            detail.type = sender.tag;
            [self.navigationController pushViewController:detail animated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)takePhoto{

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//        picker.allowsEditing = YES;  //是否可编辑
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.delegate = self;
        picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
//        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
    

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:
(NSDictionary *)info{
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:YES completion:nil];
    UIGraphicsBeginImageContext(image.size);
    [picker.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *imaged = [self rotateImage:viewImage];
    
    NSData* fileData = UIImagePNGRepresentation(imaged);
    
    tempViewController* vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"temp"];
    vc.imagebefore = image;
    vc.imageData = fileData;
    [self.navigationController pushViewController:vc animated:YES];
}




-(void)setUI{
    UIButton *btnsuggest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnsuggest.frame = CGRectMake(0, 0, 40, 18) ;
    [btnsuggest addTarget:self action:@selector(suggest) forControlEvents:UIControlEventTouchUpInside];
    [btnsuggest setTitle:@"反馈  " forState:UIControlStateNormal];
//    btn2.titleLabel.textColor = [UIColor whiteColor];
    [btnsuggest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [btnsuggest setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnsuggest];

    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"反馈" style:UIBarButtonItemStyleBordered target:self action:@selector(suggest)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"greenback.png"] forBarMetrics:UIBarMetricsDefault];
    CGRect labelframe = CGRectMake(0, 0, 60, 70);
    UILabel *Mylabel = [[UILabel alloc]initWithFrame:labelframe];
    Mylabel.textColor = [UIColor whiteColor];
    Mylabel.font = [UIFont fontWithName:@"Verdana" size:19];
    Mylabel.text = @"元气魔镜";
    self.navigationItem.titleView = Mylabel;
    _garyline = [[UIImageView alloc]initWithFrame:CGRectMake(PageW/2-0.5, 64, 1, PageH)];
    _garyline.image = [UIImage imageNamed:@"grayline.png"];
    [self.view addSubview:_garyline];
    
    _maintable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PageW, PageH-64) style:UITableViewStylePlain];
    _maintable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _maintable.delegate = self;
    _maintable.dataSource = self;
    _maintable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_maintable];

    
    _buttonAdd  = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"add.png"];
    [_buttonAdd setImage:img forState:UIControlStateNormal];
    [_buttonAdd addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    _buttonAdd.frame = CGRectMake(PageW/2-26, PageH-70, 52, 52);
    [self.view addSubview:_buttonAdd];
    
    UILabel * updatelabel = [UILabel new];
    updatelabel.backgroundColor = [UIColor whiteColor];
    updatelabel.frame = CGRectMake(0, -100, 320, 100);
    updatelabel.text = @"正在刷新...";
    updatelabel.textAlignment = NSTextAlignmentCenter;
    updatelabel.font = [UIFont boldSystemFontOfSize:15];
    updatelabel.textColor = [UIColor grayColor];
    [_maintable addSubview:updatelabel];
    
    
    _hintimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, PageH/2+70, PageW, 80)];
    _hintimage.image = [UIImage imageNamed:@"hint.png"];
    [self.view addSubview:_hintimage];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat{
    if (scrollerviewY > scrollView.contentOffset.y) {
//        [self reloadData];
//        [_maintable reloadData];
        [UIView animateWithDuration:0.6 animations:^{
            [_buttonAdd setFrame:CGRectMake(PageW/2-26, PageH-70, 52, 52)];

        }];
    }else {
        [UIView animateWithDuration:0.6 animations:^{
            [_buttonAdd setFrame:CGRectMake(PageW/2-26, PageH, 52, 52)];
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    scrollerviewY = scrollView.contentOffset.y;

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


- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
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

-(void)suggest{
    UMFeedback *umFeedbacks = [UMFeedback sharedInstance];
    [umFeedbacks setAppkey:@"5408147ffd98c5cd1d00c9df" delegate:self];
    [self showNativeFeedbackWithAppkey:@"5408147ffd98c5cd1d00c9df"];
    
//    [UMFeedback showFeedback:self withAppkey:@"5408147ffd98c5cd1d00c9df"];
    
}
- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = appkey;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    navigationController.navigationBar.translucent = NO;
    //    [self presentModalViewController:navigationController animated:YES];
    [self presentViewController:navigationController animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
