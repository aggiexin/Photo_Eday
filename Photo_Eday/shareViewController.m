//
//  shareViewController.m
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "shareViewController.h"
#import "ShareSDK/ShareSDK.h"
#import "WXApi.h"
#import "AppDelegate.h"

//#import "WeiboApi.h"
//#import "ShareManage.h"
#define PageH [[UIScreen mainScreen] bounds].size.height
#define PageW [[UIScreen mainScreen] bounds].size.width
@interface shareViewController ()
@property (strong, nonatomic) NSOperationQueue* myQueue;

@end

@implementation shareViewController

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
    [self setUI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if(self->wbapi == nil)
//    {
//        self->wbapi = [[WeiboApi alloc]initWithAppKey:@"801529182" andSecret:@"b404955465ad5a18097fcb25c631e042" andRedirectUri:nil] ;
//        
//        
//  
//
//    }

}
-(void)backCamera{

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)setUI{
//navigationBar.barTintColor
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn2];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backCamera)];
//    self.navigationItem.leftBarButtonItem.style = UIBarButtonSystemItemAdd;
//    UIImageView *savedLabel = [[UIImageView alloc]initWithFrame:CGRectMake(PageW/2-60, 99, 116, 20)];
//    savedLabel.image = [UIImage imageNamed:@"saved.png"];
//    [self.view addSubview:savedLabel];
//    
    UIView *shareActions = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 320, PageH-110)];
//    shareActions.backgroundColor  = [UIColor grayColor];
    [self.view addSubview:shareActions];

    
    UIButton *qq = [UIButton buttonWithType:UIButtonTypeCustom];
    [qq setImage:[UIImage imageNamed:@"QQ-2.png"] forState:UIControlStateNormal];
    [qq addTarget:self action:@selector(goQQ) forControlEvents:UIControlEventTouchUpInside];
//    qq.frame = CGRectMake(95, 100, 55, 75);
    qq.frame = CGRectMake(20, 0, 55, 75);
    [shareActions addSubview:qq];
    
    UIButton *wx = [UIButton buttonWithType:UIButtonTypeCustom];
    [wx setImage:[UIImage imageNamed:@"WX.png"] forState:UIControlStateNormal];
    wx.frame = CGRectMake(95, 0, 55, 75);
    [wx addTarget:self action:@selector(goWX:) forControlEvents:UIControlEventTouchUpInside];
    [shareActions addSubview:wx];
    
    UIButton *pyquan = [UIButton buttonWithType:UIButtonTypeCustom];
    [pyquan setImage:[UIImage imageNamed:@"pyquan.png"] forState:UIControlStateNormal];
    [pyquan addTarget:self action:@selector(gopyquan) forControlEvents:UIControlEventTouchUpInside];
    pyquan.frame = CGRectMake(shareActions.frame.size.width-150, 0, 55, 75);
    [shareActions addSubview:pyquan];
    
    UIButton *sinaWB = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaWB setImage:[UIImage imageNamed:@"sinaWB.png"] forState:UIControlStateNormal];
    [sinaWB addTarget:self action:@selector(gosinaWB) forControlEvents:UIControlEventTouchUpInside];
    sinaWB.frame = CGRectMake(shareActions.frame.size.width-75, 0, 55, 75);
    [shareActions addSubview:sinaWB];
    
    UIButton *tcWB = [UIButton buttonWithType:UIButtonTypeCustom];
    [tcWB setImage:[UIImage imageNamed:@"tcWB.png"] forState:UIControlStateNormal];
    [tcWB addTarget:self action:@selector(gotcwb) forControlEvents:UIControlEventTouchUpInside];
    tcWB.frame = CGRectMake(20, 100, 55, 75);
    [shareActions addSubview:tcWB];
    

    
//    UIButton *instagram = [UIButton buttonWithType:UIButtonTypeCustom];
//    [instagram setImage:[UIImage imageNamed:@"Instagram-2.png"] forState:UIControlStateNormal];
//    instagram.frame = CGRectMake(shareActions.frame.size.width-156, 100, 67, 75);
//    [shareActions addSubview:instagram];
    

}
-(void)goQQspace{
    
    
//    //创建分享内容
//    id<ISSContent> publishContent = [ShareSDK content:nil
//                                       defaultContent:nil
//                                                image:[ShareSDK pngImageWithImage:_image]
//                                                title:NSLocalizedString(@"元气魔镜", @"Hello")
//                                                  url:[NSURL URLWithString:_imagePath]
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeImage];
//    
//    id<ISSContent> content = [ShareSDK content:nil
//                                defaultContent:nil
//                                         image:[ShareSDK pngImageWithImage:_image]
//                                         title:nil
//                                           url:nil
//                                   description:nil
//                                     mediaType:SSPublishContentMediaTypeImage];
//    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
//    
//    
//    
//    [ShareSDK shareContent:publishContent
//                      type:ShareTypeQQSpace
//               authOptions:authOptions
//             statusBarTips:YES
//                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                        
//                        if (state == SSPublishContentStateSuccess)
//                        {
//                            NSLog(@"success");
//                        }
//                        else if (state == SSPublishContentStateFail)
//                        {
//                            if ([error errorCode] == -22003)
//                            {
//                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
//                                                                                    message:[error errorDescription]
//                                                                                   delegate:nil
//                                                                          cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
//                                                                          otherButtonTitles:nil];
//                                [alertView show];
//                            }
//                        }
//                    }];

//
//    NSData *imgData = UIImagePNGRepresentation(_image);
//    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
//                                               previewImageData:imgData
//                                                          title:nil
//                                                    description:nil];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
//    //将内容分享到qq
//    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];

    
    
    
//    NSString *code = [NSString stringWithFormat:@"https://graph.qq.com/photo/upload_pic"];
//    //第一步，创建URL
//    NSURL *url = [NSURL URLWithString:code];
//    //第二步，创建请求
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    
//    
//    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
//    NSData *data = UIImagePNGRepresentation(_image);
//    [request setHTTPBody:data];
//    //第三步，连接服务器
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    
//    
//    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    [self TEST2];
}

-(void)TEST2{
    
    _oauth = [[TencentOAuth alloc] initWithAppId:@"1101960550"
                                     andDelegate:self];
//
    NSArray *permissions = [NSArray arrayWithObjects:@"all",nil];
    if ( YES ==[_oauth authorize:permissions inSafari:NO]) {
        NSLog(@"登录成功");
    }
    

    TCUploadPicDic *params = [TCUploadPicDic dictionary];
    params.paramPicture = _image;
    params.paramTitle = @"风云乔布斯";
    params.paramPhotodesc = @"比天皇巨星还天皇巨星的天皇巨星";
    params.paramMobile = @"1";
    params.paramNeedfeed = @"1";
//    params.paramX = @"39.909407";
//    params.paramY = @"116.397521";
    
    if (NO == [_oauth uploadPicWithParams:params])
    {
        NSLog(@"分享失败");
//        [sdkCall showInvalidTokenOrOpenIDMessage];
    };


}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.myQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}
-(void)gopyquan{
    //发送内容给微信
    id<ISSContent> content = [ShareSDK content:nil
                                defaultContent:nil
                                         image:[ShareSDK pngImageWithImage:_image]
                                         title:nil
                                           url:nil
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeImage];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    

    
    [ShareSDK shareContent:content
                      type:ShareTypeWeixiTimeline
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"success");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            if ([error errorCode] == -22003)
                            {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
                                                                                    message:[error errorDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
                                                                          otherButtonTitles:nil];
                                [alertView show];
                            }
                        }
                    }];
}
-(void)gosinaWB{
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:nil
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:_image]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    

    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
     }
-(void)gotcwb{
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:nil
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:_image]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    

    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    

    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeTencentWeibo
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@") , [error errorCode], [error errorDescription]);
                                 }
                             }];
}
-(void)goWX:(id)sender{
    
//    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:_image];
//    
//    WXImageObject *ext = [WXImageObject object];
//    NSString *filePath = _imagePath;
//    NSLog(@"filepath :%@",filePath);
//    ext.imageData = UIImagePNGRepresentation(_image);
//    
//    //UIImage* image = [UIImage imageWithContentsOfFile:filePath];
//    UIImage* image = [UIImage imageWithData:ext.imageData];
//    ext.imageData = UIImagePNGRepresentation(image);
//    
//    //    UIImage* image = [UIImage imageNamed:@"res5thumb.png"];
//    //    ext.imageData = UIImagePNGRepresentation(image);
//    
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = 0;
//    
//    [WXApi sendReq:req];
    //发送内容给微信
    id<ISSContent> content = [ShareSDK content:nil
                                defaultContent:nil
                                         image:[ShareSDK pngImageWithImage:_image]
                                         title:nil
                                           url:nil
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeImage];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    
    [ShareSDK shareContent:content
                      type:ShareTypeWeixiSession
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"success");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            if ([error errorCode] == -22003)
                            {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
                                                                                    message:[error errorDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
                                                                          otherButtonTitles:nil];
                                [alertView show];
                            }
                        }
                    }];

    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goQQ{
    
    id<ISSContent> content = [ShareSDK content:@"desc"
                                defaultContent:nil
                                         image:[ShareSDK pngImageWithImage:_image]
                                         title:@"元气墨镜"
                                           url:nil
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeImage];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    
    [ShareSDK shareContent:content
                      type:ShareTypeQQ
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"success");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"fail");
                        }
                    }];
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
