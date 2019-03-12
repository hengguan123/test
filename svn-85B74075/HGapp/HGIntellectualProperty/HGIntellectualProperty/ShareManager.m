//
//  ShareManager.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager
{
    NSString *_url;
    NSString *_title;
    NSString *_subTitle;
    UIImage *_image;
}
+(instancetype)share
{
    static ShareManager *manger = nil;
    static dispatch_once_t onceTokenShare;
    dispatch_once(&onceTokenShare, ^{
        manger = [[ShareManager alloc] init];
    });
    return manger;
}

-(void)shareWithShareUrl:(NSString *)url title:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image
{
    _url = url;
    _title = title;
    _subTitle = subTitle;
    _image = image;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_title descr:[_subTitle stringByAppendingString:@"  点击查看详情"] thumImage:_image?:[UIImage imageNamed:@"logoImage"]];
    //    设置网页地址·
    shareObject.webpageUrl = _url;
    
    
    //    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //    //如果有缩略图，则设置缩略图
    //    shareObject.thumbImage = [UIImage imageNamed:@"logoImage"];
    //    [shareObject setShareImage:[self getTableViewimage]];
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}




@end
