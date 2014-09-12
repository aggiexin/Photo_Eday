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

#define PageH [[UIScreen mainScreen] bounds].size.height
#define PageW [[UIScreen mainScreen] bounds].size.width
#define GREENCOLOR	([UIColor colorWithRed:102.0f/255 green:217.0f/255 blue:165.0f/255 alpha:1.0])

@interface mainViewController () <DetailCellDelegate>
@property (strong, nonatomic) NSArray *photoBeforeCompletePath;
@property (strong, nonatomic) NSMutableArray  *photoChangedCompletePath;
@property (strong, nonatomic) NSArray *creatTimes;

@end
int temp;

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
    
}
- (void)viewDidLoad
{

    [self reloadData];
    [super viewDidLoad];
    [self setUI];



    // Do any additional setup after loading the view.
}

-(void)reloadData{
    _creatTimes = [NSMutableArray new];
    _testarr = [NSMutableArray new];
    _changedarr = [NSMutableArray new];
    _photochange = [NSMutableArray new];
    _photoChangedCompletePath = [NSMutableArray new];
    _photoBeforeCompletePath = [CoreDataTool getphoto];
    _photochange = [CoreDataTool getchanged];//得到数字
    
    NSInteger number = [CoreDataTool getPhtotCount];
    
    
    NSArray *photochangedPath = [CoreDataTool getchangedcompletepath];
    
    int j = 0;
    
    if (number!=0) {
        for (int i =0; i<number; i++) {
            
            if (j!=[_photochange count]) {
                if (i == [[_photochange objectAtIndex:j] intValue]) {
                    [_photoChangedCompletePath addObject:[photochangedPath objectAtIndex:j]];
                    j++;
                }else
                    [_photoChangedCompletePath addObject:@" "];
            }else
                [_photoChangedCompletePath addObject:@" "];
            
        }
    }else {
        for (int i =0; i<[_photochange count]; i++) {
            
            if (j!=[_photochange count]) {
                if (i == [[_photochange objectAtIndex:j] intValue]) {
                    [_photoChangedCompletePath addObject:[photochangedPath objectAtIndex:j]];
                    j++;
                }else
                    [_photoChangedCompletePath addObject:@" "];
            }else
                [_photoChangedCompletePath addObject:@" "];
            
        }

    
    }
    
    
    if (![_photoBeforeCompletePath count] ==0) {
        for (int i =0; i<[_photoBeforeCompletePath count]; i++) {
            NSData* filebeforeData = [NSData dataWithContentsOfFile:[_photoBeforeCompletePath objectAtIndex:i]];
            UIImage * imagebefroe = [UIImage imageWithData:filebeforeData];
            [_testarr  addObject:imagebefroe];
            
            
            NSData* fileData = [NSData dataWithContentsOfFile:[_photoChangedCompletePath objectAtIndex:i]];
            UIImage * image = [UIImage imageWithData:fileData];
            if (image) {
                [_changedarr addObject:image];
            }
            
            
        }
    }else{
        for (int i =0; i<[_photochange count]; i++) {
            
            NSData* fileData = [NSData dataWithContentsOfFile:[_photoChangedCompletePath objectAtIndex:i]];
            UIImage * image = [UIImage imageWithData:fileData];
            if (image) {
                [_changedarr addObject:image];
            }
            
            
        }

    
    }
    
    
    _creatTimes = [CoreDataTool getCreateTimes];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([_testarr count] == 0 ) {
//        return [_photochange count];
//    }else return [_testarr count];
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

    
    NSLog(@"第%i行",indexPath.row);
    if (indexPath.row%2==0) {
        cell.photoChange.frame= CGRectMake(14, 22, 52, 52);
        cell.photoOriginal.frame = CGRectMake(74, 22, 52, 52);
        cell.timeLabel.frame = CGRectMake(195, 22, 105, 52);

    }
    if ([_testarr count] != 0 &&[_testarr count]-1< indexPath.row) {
        [cell.photoOriginal setImage:[_testarr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    }

//    NSArray *photochange = [CoreDataTool getchanged];

        if (temp!=[_photochange count]) {
             
            if (indexPath.row == [[_photochange objectAtIndex:temp] intValue]) {
                [cell.photoChange setImage:[_changedarr objectAtIndex:temp] forState:UIControlStateNormal];
                temp++;
            }
        }else
        temp = 0;
        
    cell.timeLabel.text = [_creatTimes objectAtIndex:indexPath.row];

       // Configure the cell...
    
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (void)didDeleteImageWithCell:(DetailTableViewCell *)cell
                        and:(UIButton *)sender
{
    NSIndexPath* indexPath = [self.maintable indexPathForCell:cell];
    
    if (sender.tag == 1) {
        NSString *path = [_photoBeforeCompletePath objectAtIndex:indexPath.row];
        [CoreDataTool DeletInfo:path];
    }else if(sender.tag == 2){
        NSString *path = [_photoChangedCompletePath objectAtIndex:indexPath.row];
        [CoreDataTool DeletInfo:path];
    }
    NSLog(@"%i",sender.tag);
    //    self.testarr[indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)takePhoto{

//       [self performSegueWithIdentifier:@"camera" sender:self];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;  //是否可编辑
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.delegate = self;

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
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *imaged = [self rotateImage:image];
    NSData* fileData = UIImagePNGRepresentation(imaged);
    NSDictionary * imgInfo=  [FaceTool ChickFace:fileData];
    tempViewController* vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"temp"];
    vc.imagemiddle = image;
    vc.age = [NSString stringWithFormat:@"%li",(long)[FaceTool getAge:imgInfo] ];
    vc.happy = [NSString stringWithFormat:@"%li",(long)[FaceTool getHappy:imgInfo] ];
    vc.desSentence = [FaceTool getDescriptionSentence:imgInfo];
    vc.desTitle = [FaceTool getDescriptionTitle:imgInfo];
    vc.creattime = [NSDate date];
    [self.navigationController pushViewController:vc animated:YES];
}


-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}



-(void)setUI{

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"greenback.png"] forBarMetrics:UIBarMetricsDefault];
    CGRect labelframe = CGRectMake(0, 0, 60, 70);
    
    UILabel *Mylabel = [[UILabel alloc]initWithFrame:labelframe];
    
    Mylabel.textColor = [UIColor whiteColor];
    
    Mylabel.font = [UIFont fontWithName:@"Verdana" size:19];
    
    Mylabel.text = @"元气魔镜";
    
    self.navigationItem.titleView = Mylabel;
    
    
    _maintable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PageW, PageH-64) style:UITableViewStylePlain];
    _maintable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _maintable.delegate = self;
    _maintable.dataSource = self;
    [self.view addSubview:_maintable];
    
    
    UIButton *buttonAdd  = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"add.png"];
    [buttonAdd setImage:img forState:UIControlStateNormal];
    [buttonAdd addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    buttonAdd.frame = CGRectMake(PageW/2-26, PageH-70, 52, 52);
    [self.view addSubview:buttonAdd];
    
    UILabel * updatelabel = [UILabel new];
    updatelabel.frame = CGRectMake(0, -100, 320, 100);
    updatelabel.text = @"正在刷新...";
    updatelabel.textAlignment = NSTextAlignmentCenter;
    updatelabel.font = [UIFont boldSystemFontOfSize:15];
    updatelabel.textColor = [UIColor grayColor];
    [_maintable addSubview:updatelabel];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat{
    
    if (scrollView.contentOffset.y < 0) {
        temp=0;
        [self reloadData];
        [_maintable reloadData];
    }
    
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
