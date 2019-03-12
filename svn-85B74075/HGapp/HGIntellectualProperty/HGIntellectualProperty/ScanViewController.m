//
//  ScanViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/10.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ScanViewController.h"
#import <ZXingObjC/ZXingObjC.h>
#import "SearchResultViewController.h"
#import "BecomeAgentViewController.h"


@interface ScanViewController ()<ZXCaptureDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, weak) IBOutlet UIView *scanRectView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *moveImage;

@property (nonatomic,copy) NSString *resultStr;

@property (weak, nonatomic) IBOutlet UIView *cameraBgView;

@end

@implementation ScanViewController
{
    CGAffineTransform _captureSizeTransform;
    NSTimer *_timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (SIMULATOR) {
        NSLog(@"模拟器");
    }
    else
    {
        NSLog(@"真机");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            self.capture = [[ZXCapture alloc] init];
            self.capture.camera = self.capture.back;
            self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            self.capture.delegate = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self applyOrientation];
                [self.cameraBgView.layer addSublayer:self.capture.layer];
            });
        });
    }
//
}
- (void)dealloc {
    [self.capture.layer removeFromSuperlayer];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self removeTimer];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _resultStr = nil;
    if (self.capture) {
        [self applyOrientation];
        self.capture.delegate = self;
        [self.capture start];
    }
    if (self.capture.running) {
        [self addTimer];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self.capture stop];
    [self.capture hard_stop];
}
/** 播放音效文件 */
- (void)playSoundEffect:(NSString *)name {
    // 获取音效
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@",name];
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
-(void)addTimer
{
    if (_timer) {
        [self removeTimer];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
}

-(void)timerEvent
{
    __block CGRect frame = self.moveImage.frame ;
    CGFloat maxY = self.scanRectView.frame.size.height-60;
    if (frame.origin.y > maxY) {
        frame.origin.y = 30;
        self.moveImage.frame = frame ;
    }
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [UIView animateWithDuration:0.05 animations:^{
            frame.origin.y += 5;
            self.moveImage.frame = frame ;
        } completion:^(BOOL finished) {
            
        }];
    });
}

-(void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/// 闪光灯
- (IBAction)openFlash:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected == YES) { //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
    }else{//关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self applyOrientation];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self applyOrientation];
     }];
}

#pragma mark - Private
- (void)applyOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float scanRectRotation;
    float captureRotation;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            captureRotation = 90;
            scanRectRotation = 180;
            break;
        case UIInterfaceOrientationLandscapeRight:
            captureRotation = 270;
            scanRectRotation = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            captureRotation = 180;
            scanRectRotation = 270;
            break;
        default:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
    }
    [self applyRectOfInterest:orientation];
    CGAffineTransform transform = CGAffineTransformMakeRotation((CGFloat) (captureRotation / 180 * M_PI));
    [self.capture setTransform:transform];
    [self.capture setRotation:scanRectRotation];
//    NSLog(@"%f---%f",self.view.frame.size.height,self.view.frame.origin.y);
    self.capture.layer.frame = self.view.bounds;
}

- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation {
    CGFloat scaleVideo, scaleVideoX, scaleVideoY;
    CGFloat videoSizeX, videoSizeY;
    CGRect transformedVideoRect = self.scanRectView.frame;
    if([self.capture.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        videoSizeX = 1080;
        videoSizeY = 1920;
    } else {
        videoSizeX = 720;
        videoSizeY = 1280;
    }
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        scaleVideoX = self.view.frame.size.width / videoSizeX;
        scaleVideoY = self.view.frame.size.height / videoSizeY;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeY - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeX - self.view.frame.size.width) / 2;
        }
    } else {
        scaleVideoX = self.view.frame.size.width / videoSizeY;
        scaleVideoY = self.view.frame.size.height / videoSizeX;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeX - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeY - self.view.frame.size.width) / 2;
        }
    }
    _captureSizeTransform = CGAffineTransformMakeScale(1/scaleVideo, 1/scaleVideo);
    self.capture.scanRect = CGRectApplyAffineTransform(transformedVideoRect, _captureSizeTransform);
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods
- (void)captureCameraIsReady:(ZXCapture *)capture
{
    if (_timer) {
        [self removeTimer];
    }
    [self addTimer];
    
}
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result)
        return;
    if (self.resultStr==nil) {
        self.resultStr = result.text;
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self playSoundEffect:@"begin_record.caf"];
        [self removeTimer];

    }
    
        [self.capture stop];
}



#pragma mark 相册
- (IBAction)photo:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
////该代理方法仅适用于只选取图片时
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
//{
////    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
//    [picker dismissViewControllerAnimated:YES completion:^{
//        [self getUserInfoWithImage:image ];
//    }];
//    
//}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [self getUserInfoWithImage:portraitImg ];
    }];
}

/// 获取图片信息
-(void)getUserInfoWithImage:(UIImage *)image
{
    [SVProgressHUD showWithStatus:@"识别中"];
    CGImageRef imageToDecode=[image CGImage];
    
    ZXLuminanceSource * source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap * bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    NSError *error = nil;
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    ZXMultiFormatReader * reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap hints:hints error:&error];
    
    if (result) {
        NSString *contents = result.text;
//        NSLog(@"解析成功：%@",contents);
        if (!self.resultStr) {
            self.resultStr = contents;
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self playSoundEffect:@"begin_record.caf"];
            [self removeTimer];
            [self.capture stop];
            //进行自己业务处理
        }
        
    }else{
//          NSLog(@" --- 解析失败");
        [SVProgressHUD showErrorWithStatus:@"未识别到二维码/条形码"];
    }
}

#pragma mark getResult
-(void)setResultStr:(NSString *)resultStr
{
    _resultStr = resultStr;
    NSLog(@"识别结果：%@",resultStr);
    if ([resultStr hasPrefix:@"HG"]) {
        if (self.resultBlock) {
            self.resultBlock(resultStr);
        }
        if (self.isFromProgressList) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProgressSearchViewController *vc = [main instantiateViewControllerWithIdentifier:@"ProgressSearchViewController"];
            vc.srearchStr = resultStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (resultStr.length == 13)
    {
        NSMutableString *str = [[NSMutableString alloc]initWithString:resultStr];
        [str insertString:@"." atIndex:12];
        [str insertString:@"CN" atIndex:0];
        [self goToSearchPatentResultWithResult:str];
    }
    else if ([resultStr containsString:@"TMZC"])
    {
        NSArray *array = [resultStr componentsSeparatedByString:@"ZC"];
        NSMutableString *str ;
        if (array.count>3) {
            str = [[NSMutableString alloc]initWithString:[array objectAtIndex:1]];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"无效的扫描结果"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.capture start];
                [self addTimer];
                _resultStr = nil;
            });
            return;
        }
        while ([[str substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"0"]) {
            [str replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        [self gotoSearchTrademarkResultWithResult:str];
    }
    else if ([resultStr containsString:@"http://m.techhg.com/business/download?fromUid="])
    {
        BecomeAgentViewController *becomeVc = [[BecomeAgentViewController alloc]init];
        becomeVc.fromInvite = YES;
        NSArray *array = [resultStr componentsSeparatedByString:@"="];
        becomeVc.fromUid = array.lastObject;
        [self.navigationController pushViewController:becomeVc animated:YES ];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"无效的扫描结果"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.capture start];
            [self addTimer];
            _resultStr = nil;
        });
        return;
    }
}

-(void)goToSearchPatentResultWithResult:(NSString *)str
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchResultViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    vc.type = HotSearchViewTypePatent;
    vc.searchStr = str;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoSearchTrademarkResultWithResult:(NSString *)str
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchResultViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    vc.type = HotSearchViewTypeTrademark;
    vc.searchStr = str;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
