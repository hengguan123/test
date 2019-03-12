//
//  Request.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject


@property(nonatomic,strong)NSURLSessionDataTask *task;

+(Request *)share;


-(NSURLSessionDataTask *)postVariablesToURL:(NSString *)url variables:(NSDictionary *)parameterDict successHandler:(void(^)(id json))successBlock errorHandler:(void(^)(NSError *error))errorBlock;



@end
