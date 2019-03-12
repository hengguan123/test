//
//  InviteViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/3/19.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "InviteViewController.h"
#import <CoreImage/CoreImage.h>

@interface InviteViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (nonatomic,assign,getter=isShowNavigation) BOOL showNavigation;

@end

@implementation InviteViewController
{
    NSTimer *_timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    // 2. 给滤镜添加数据
    NSString *string = [NSString stringWithFormat:@"http://m.techhg.com/business/download?fromUid=%@",[AppUserDefaults share].usrId];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    CGFloat codeImageWidth,codeImageX,codeImageY,codeTextY;
    NSInteger codeFont;
    NSString *imageName;
    if (kDevice_Is_iPhoneX) {
        codeImageWidth = 300;
        codeImageX = 412;
        codeImageY = 1507;
        codeTextY =790;
        imageName = @"iPhoneX";
        codeFont = 60;
    }
    else
    {
        codeImageWidth = 200;
        codeImageX = 275;
        codeImageY = 800;
        codeTextY =390;
        imageName = @"邀请";
        codeFont = 40;
    }
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    UIImage *codeImage = [self createNonInterpolatedUIImageFormCIImage:image withSize:codeImageWidth];
    CGImageRef imgRef = codeImage.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    //以1.png的图大小为底图
    UIImage *img1 = [UIImage imageNamed:imageName];
    CGImageRef imgRef1 = img1.CGImage;
    CGFloat w1 = CGImageGetWidth(imgRef1);
    CGFloat h1 = CGImageGetHeight(imgRef1);
    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w1, h1));
    [img1 drawInRect:CGRectMake(0, 0, w1, h1)];
    //先把1.png 画到上下文中
    
    //再把小图放在上下文中
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, codeTextY, w1, 150)];
    lab.text = [NSString stringWithFormat:@"您的邀请码为%@",[AppUserDefaults share].usrId];
    lab.textColor = MainColor;
    lab.backgroundColor = [UIColor yellowColor];
    lab.font = [UIFont systemFontOfSize:codeFont weight:20];
    lab.textAlignment = 1;
    
    [codeImage drawInRect:CGRectMake(codeImageX, codeImageY, w, h)];
    [lab drawTextInRect:CGRectMake(0, codeTextY, w1, codeFont*2)];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    //从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    
    CGImageRelease(imgRef);
    
    self.imageView.image=resultImg;
    
    _showNavigation = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hiddenNaviView) userInfo:nil repeats:NO];
    
}
-(void)hiddenNaviView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationView.frame = CGRectMake(0, -self.navigationView.bounds.size.height, ScreenWidth, self.navigationView.bounds.size.height);
    } completion:^(BOOL finished) {
        self.showNavigation = NO;
    }];
    [self removeTimer];
}
-(void)removeTimer{
    [_timer invalidate];
    _timer =nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isShowNavigation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationView.frame = CGRectMake(0, -self.navigationView.bounds.size.height, ScreenWidth, self.navigationView.bounds.size.height);
        } completion:^(BOOL finished) {
            self.showNavigation = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationView.frame = CGRectMake(0, 0, ScreenWidth, self.navigationView.bounds.size.height);
        } completion:^(BOOL finished) {
            self.showNavigation = YES;
        }];
    }
}

-(void)setShowNavigation:(BOOL)showNavigation
{
    _showNavigation = showNavigation;
    if (showNavigation) {
        [self removeTimer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hiddenNaviView) userInfo:nil repeats:NO];
    }
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage* )image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender {
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
    }];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:self.imageView.image];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

@end
