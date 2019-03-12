//
//  Request.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "Request.h"
#import "AFHTTPSessionManager.h"

@interface Request ()

@property(nonatomic,strong)AFHTTPSessionManager *manager;

@end

@implementation Request

+(Request *)share
{
    static Request *request = nil;
    static dispatch_once_t onceToken3;
    dispatch_once(&onceToken3, ^{
        request = [[Request alloc] init];
    });
    return request;
}
-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = nil;
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        //[NSSet setWithObjects:@"text/html",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    }
    return _manager;
}

-(NSURLSessionDataTask *)postVariablesToURL:(NSString *)url variables:(NSDictionary *)parameterDict successHandler:(void (^)(id json))successBlock errorHandler:(void (^)(NSError *error))errorBlock
{
    NSURLSessionDataTask *task=[self.manager POST:url parameters:parameterDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (![AppUserDefaults share].isShowVersion) {
            //        NSString *str = [error.userInfo objectForKey:@"_kCFStreamErrorCodeKey"];
            NSString *errorInfo = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (errorInfo == nil) {
                //            NSError *suberror = [error.userInfo objectForKey:@"NSUnderlyingError"];
                //            errorInfo = [suberror.userInfo objectForKey:@"NSLocalizedDescription"];
                [LoadingManager dismiss];
                [SVProgressHUD showErrorWithStatus:@"服务器错误"];
                NSLog(@"*************************************");
                NSLog(@"*************************************");
                NSLog(@"**************接口报错了***************");
                NSLog(@"URL:%@",url);
                NSLog(@"*************************************");
                NSLog(@"*************************************");
                NSLog(@"*************************************");

            }
            else
            {
                if ([errorInfo isEqualToString:@"已取消"]) {
                    
                }
                else{
                    [SVProgressHUD showInfoWithStatus:errorInfo];
                }
            }
        }
        errorBlock(error);
        
    }];
    return task;
}


@end
