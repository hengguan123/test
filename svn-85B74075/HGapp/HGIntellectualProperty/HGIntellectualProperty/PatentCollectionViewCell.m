//
//  PatentCollectionViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/31.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentCollectionViewCell.h"

@interface PatentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation PatentCollectionViewCell
{
    NSURLSessionTask *_task;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setModel:(PatentModel *)model
{
    _model = model;
    
    self.titleLab.text = model.TITLE;
    if (model.value&&![model.value isEqualToString:@""]) {
        self.priceLab.text = [NSString stringWithFormat:@"￥%@",model.value];
    }
    else
    {
        self.priceLab.text = @"暂无报价";
    }
    UIImage *image = [self readData:model.GIF_URL];
    if (image) {
        [self.imageView setImage:image];
    }
    else
    {
        [self setimageWithUrl:model.GIF_URL];
    }
}
- (IBAction)buy:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyPatentWithPatentCollectionViewCell:)]) {
        [self.delegate buyPatentWithPatentCollectionViewCell:self];
    }
}

-(void)setimageWithUrl:(NSString *)imageurl
{
    NSURL *url = [NSURL URLWithString:imageurl];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 可以不必创建请求直接用url进行获取，但是只能应用于get请求
    self.imageView.image = [UIImage imageNamed:@"loading"];
    _task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            
            NSLog(@"%f",data.length/1024.0/1024);
            
            CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
            
            //2. 将gif分解为一帧帧
            
            size_t count = CGImageSourceGetCount(source);
            
            NSLog(@"%zu",count);
            
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
            
            //3. 将单帧数据转为UIImage
            
            UIImage * image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            
            if (image == nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.imageView.image = [UIImage imageNamed:@"loadbad"];
                    
                });
                
            }
            
            else
                
            {
                
                UIImage *endImage = [self OriginImage:image scaleToSize:CGSizeMake(200,200)];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.imageView.image = endImage;
                    
                });
                
                [self saveImage:endImage withUrl:imageurl];
                
                NSLog(@"image%@",endImage);
                
            }
            
            CGImageRelease(imageRef);
            
        }
        
        else
            
        {
            
            self.imageView.image = [UIImage imageNamed:@"loadbad"];
            
        }
        
    }];
    
    [_task resume];
}
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size

{
    
    //    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;  //返回的就是已经改变的图片
    
}

-(void)saveImage:(UIImage *)image withUrl:(NSString *)url

{
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * documentPath = arr.firstObject;
    
    //        指定新建文件夹路径
    
    NSString * iageDocument = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    
    NSLog(@"%@",iageDocument);
    
    [[NSFileManager new] createDirectoryAtPath:iageDocument withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filePath = [iageDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[GGTool md5:url]]];  // 保存文件的名称
    
    if([UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES])
        
    {
        
        NSLog(@"写入成功");
        
    }
    
    else
        
    {
        
        NSLog(@"写入失败");
        
    }
    
}

-(UIImage *)readData:(NSString *)url

{
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * documentPath = arr.firstObject;
    
    //        指定新建文件夹路径
    
    NSString * iageDocument = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    
    NSString *filePath = [iageDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[GGTool md5:url]]];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath]){//判断createPath路径文件夹是否已存在，不存在直接返回
        
        return nil;
        
    }
    
    else
        
    {
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        
        return image;
        
    }
    
}




@end
