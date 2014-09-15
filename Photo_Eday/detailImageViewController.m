//
//  detailImageViewController.m
//  Photo_Eday
//
//  Created by dongl on 14-8-28.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "detailImageViewController.h"
#import "shareViewController.h"
#import "CoreDataTool.h"
#import "ImageTool.h"
#define PageH [[UIScreen mainScreen] bounds].size.height
#define PageW [[UIScreen mainScreen] bounds].size.width
#define GREENCOLOR	([UIColor colorWithRed:102.0f/255 green:217.0f/255 blue:165.0f/255 alpha:1.0])
@interface detailImageViewController ()

@end

@implementation detailImageViewController

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
    if (_type ==3) {
    _photocount = [CoreDataTool getallphoto];
    }else{
    _photocount = [CoreDataTool getImageByCreatetime:_creattime];
    }
    [self setImage];
    [self setUI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backback{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setUI{
    

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"greenback.png"] forBarMetrics:UIBarMetricsDefault];
//    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
//    delete.frame = CGRectMake(10, 0, 24.5, 28) ;
//    [delete addTarget:self action:@selector(deletePhtot) forControlEvents:UIControlEventTouchUpInside];
//    [delete setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:delete];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletePhtot)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, 35, 35) ;
    UIImage* image = [UIImage imageNamed:@"turnback.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backback) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backback)];

//    UIButton *goback = [UIButton buttonWithType:UIButtonTypeCustom];
//    goback.frame = CGRectMake(0, 0, 40, 18) ;
//    [goback addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
//    [goback setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:goback];

    _footView = [[UIImageView alloc]initWithFrame:CGRectMake(0, PageH-64, PageW, 64)];
    _footView.image = [UIImage imageNamed:@"greenback.png"];
    _footView.userInteractionEnabled = YES;
    [self.view addSubview:_footView];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"savec.png" ] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(turnShare) forControlEvents:UIControlEventTouchUpInside];
    shareButton.frame = CGRectMake(PageW/2-30,2.5, 60, 60);
    [_footView addSubview:shareButton];
    
}


-(void)setImage{

    _scrollview = [[UIScrollView alloc]init];
    _scrollview.frame = [ImageTool setRect];
    _scrollview.contentSize = CGSizeMake(PageW*[_photocount count],_scrollview.frame.size.height);
    _scrollview.backgroundColor = [UIColor grayColor];
    
    _scrollview.pagingEnabled = YES;
    _scrollview.delegate = self;
    
    if (_type ==1 ) {
        [_scrollview  setContentOffset:CGPointMake(0,0) animated:YES];
    }else if (_type==2&&[_photocount count]==2){
        [_scrollview  setContentOffset:CGPointMake(320,0) animated:YES];
    }
    
    
    
    for (int i =0; i<[_photocount count]; i++) {
        UIImageView *image = [[UIImageView alloc]init];
        image = [ImageTool setImageSizeDetailImageView:image andPhotoCount:i+1];
        NSData *imagedata = [NSData dataWithContentsOfFile:[_photocount objectAtIndex:i]];
        image.image =  [UIImage imageWithData:imagedata];
        [_scrollview addSubview:image];
    }
    
    
    if (PageH ==480) {
        _scrollview.userInteractionEnabled = YES;
        UITapGestureRecognizer *chick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chickImage)];
        [_scrollview addGestureRecognizer:chick];
    }

    
    [self.view addSubview:_scrollview];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    
    NSLog(@"%f ",scrollView.contentOffset.x);
    float  numer = scrollView.contentOffset.x/320 ;
    _photoindex = numer ;
    _type =3;
    
}


-(void)deletePhtot{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲,真的要删吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

-(void)goback{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)turnShare{
    
    shareViewController* vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"share"];
    
    if (_type ==3) {
        NSString *path = [_photocount objectAtIndex:_photoindex];
        NSData *imageData = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage imageWithData:imageData];
        vc.image = image;
    }else{
    vc.image = _middleimage;
    }
    
    [self.navigationController pushViewController:vc animated:YES];


}

-(void)chickImage{
    if (!isChickImage) {
        [UIView animateWithDuration:0.3 animations:^{[_footView setFrame:CGRectMake(0, PageH, PageW, 78)];
        }completion:^(BOOL finished) {
            isChickImage = YES;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{[_footView setFrame:CGRectMake(0, PageH-64, PageW, 64)];
        }completion:^(BOOL finished) {
            isChickImage = NO;
        }];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==1) {
        if (_type == 1) {
            NSString *path = [CoreDataTool getImageBeforePathByCreatetime:_creattime];
            [CoreDataTool DeletInfo:path];
        }else if(_type == 2){
            NSString *path = [CoreDataTool getImageAfterPathByCreatetime:_creattime];
            [CoreDataTool DeletInfo:path];
        }else if(_type == 3){
            NSString *path = [_photocount objectAtIndex:_photoindex];
            [CoreDataTool DeletInfo:path];

        }

    }
    [self.navigationController popViewControllerAnimated:YES];

    
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
