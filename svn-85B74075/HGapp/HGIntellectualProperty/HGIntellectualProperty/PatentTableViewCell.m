//
//  PatentTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/14.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@interface PatentTableViewCell ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UIImageView *patentImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *changeLab;
@property (weak, nonatomic) IBOutlet UILabel *applicantLab;
@property (weak, nonatomic) IBOutlet UILabel *pubTimeLab;

@end

@implementation PatentTableViewCell
{
    NSURLSessionTask *_task;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(PatentModel *)model
{
    
    _model = model;
    if (self.searchStr) {
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:model.TITLE];
        [attrStr
         addAttribute:NSForegroundColorAttributeName value:MainColor range:[model.TITLE rangeOfString:self.searchStr]];
        self.titleLab.attributedText = attrStr;
    }
    else
    {
        self.titleLab.text =model.TITLE;
    }
    self.codeLab.text = [NSString stringWithFormat:@"公开号:%@",model.PN];
    self.pubTimeLab.text = [NSString stringWithFormat:@"公开日期:%@",model.PBD];
    NSString *anStr = [NSString stringWithFormat:@"申请人:%@",model.AN];
    if (self.searchStr) {
        NSMutableAttributedString * anAttrStr = [[NSMutableAttributedString alloc]initWithString:anStr];
        [anAttrStr
         addAttribute:NSForegroundColorAttributeName value:MainColor range:[anStr rangeOfString:self.searchStr]];
        self.applicantLab.attributedText = anAttrStr;
    }
    else
    {
        self.applicantLab.text = anStr;
    }
    self.statusLab.text = model.VALID;
    if ([@"ABC" containsString:model.PKIND_S]) {
        self.typeLab.text = @"类型：发明专利";
    }
    else if ([@"DS" containsString:model.PKIND_S])
    {
        self.typeLab.text = @"类型：外观设计";
    }
    else if ([@"UY" containsString:model.PKIND_S])
    {
        self.typeLab.text = @"类型：实用新型";
    }
    
    self.changeLab.text = @"";
    
    UIImage *image=[self readData:model.GIF_URL];
    if (image) {
        [self.patentImageView setImage:image];
    }
    else
    {
        [self setimageWithUrl:model.GIF_URL];
    }
}

-(void)setimageWithUrl:(NSString *)imageurl
{
    NSURL *url = [NSURL URLWithString:imageurl];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 可以不必创建请求直接用url进行获取，但是只能应用于get请求
    
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
                    
                    self.patentImageView.image = [UIImage imageNamed:@"loadbad"];
                    
                });
                
            }
            
            else
                
            {
                
                UIImage *endImage = [self OriginImage:image scaleToSize:CGSizeMake(90, 90)];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.patentImageView.image = endImage;
                    
                });
                
                [self saveImage:endImage withUrl:imageurl];
                
                NSLog(@"image%@",endImage);
                
            }
            
            CGImageRelease(imageRef);
            
        }
        
        else
            
        {
            
            self.patentImageView.image = [UIImage imageNamed:@"loadbad"];
            
        }
        
    }];
    
    [_task resume];
}


-(void)setMoniModel:(MonitorContentModel *)moniModel
{
    _moniModel = moniModel;
    self.titleLab.text = moniModel.title;
    self.codeLab.text = [NSString stringWithFormat:@"公开号:%@",moniModel.pn];
    self.pubTimeLab.text = [NSString stringWithFormat:@"公开日期:%@",moniModel.pbd];
    
    
    self.statusLab.text = [self cutStr:moniModel.nwLegal];
    if ([moniModel.busiType isEqualToString:@"YWLX01-04-01"]) {
        self.typeLab.text = @"类型：发明专利";
    }
    else if ([moniModel.busiType isEqualToString:@"YWLX01-04-03"])
    {
        self.typeLab.text = @"类型：外观设计";
    }
    else if ([moniModel.busiType isEqualToString:@"YWLX01-04-02"])
    {
        self.typeLab.text = @"类型：实用新型";
    }
    self.applicantLab.text = [NSString stringWithFormat:@"申请人:%@",moniModel.companyName];
    if (moniModel.remark==nil||[moniModel.remark isEqualToString:@""]) {
        self.changeLab.text = @"暂无动态";
    }
    else
    {
        self.changeLab.text = moniModel.remark;
    }
    UIImage *image=[self readData:moniModel.imgUrl];
    if (image) {
        [self.patentImageView setImage:image];
    }
    else
    {
        [self setimageWithUrl:moniModel.imgUrl];
    }
}


-(NSString *)cutStr:(NSString *)str
{
    NSMutableString *statusStr = [[NSMutableString alloc]initWithString:str];
    if (str==nil||str.length==0) {
        return @"暂无状态";
    }
    if ([statusStr containsString:@"发明专利"]) {
        [statusStr deleteCharactersInRange:[statusStr rangeOfString:@"发明专利"]];
    }
    else if ([statusStr containsString:@"外观专利"])
    {
        [statusStr deleteCharactersInRange:[statusStr rangeOfString:@"发明专利"]];
    }
    else if ([statusStr containsString:@"实用新型"])
    {
        [statusStr deleteCharactersInRange:[statusStr rangeOfString:@"实用新型"]];
    }
    return statusStr;

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
