    //
//  RequestManager.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "RequestManager.h"
#import "Request.h"
#import "RequestURL.h"
#import <YYModel/YYModel.h>



@implementation RequestManager
{
    NSURLSessionDataTask *_searchCompantTask;
}
+(void)getVerificationCodeWithPhoneNum:(NSString *)phoneNum type:(NSString *)type successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"note":type,@"mobileNum":phoneNum};
    [Request.share postVariablesToURL:GetVCode variables:parameterDict successHandler:^(id json) {
        if (json) {
            successBlcok(YES);
        }
//        else
//        {
//            [SVProgressHUD showInfoWithStatus:@"发生操作失败"];
//        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)loginWithPhoneNum:(NSString *)phone vcode:(NSString *)vcode successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrAccount":phone,@"nodeCode":vcode};
    [Request.share postVariablesToURL:Login variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            [LoadingManager dismiss];
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
            
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+ (void)loginWithUid:(NSString *)uid userName:(NSString *)userName noType:(NSString *)noType portraitUrl:(NSString *)portraitUrl successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict ;
    if ([noType isEqualToString:@"1"]) {
        parameterDict = @{@"usrAlias":userName,@"qqAccount":uid,@"portraitUrl":portraitUrl};
    }
    else if([noType isEqualToString:@"2"]) {
        parameterDict = @{@"usrAlias":userName,@"wxAccount":uid,@"portraitUrl":portraitUrl};
    }
    
    [Request.share postVariablesToURL:Login variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];

}

+(void)getProvinceListWriteListSuccessHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"superAddrCode":@"CHN"};
    [Request.share postVariablesToURL:City variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingString:@"/Area.plist"];
            NSArray *array = [json objectForKey:@"body"];
            successBlcok([array writeToFile:fileName atomically:YES]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getAreaWithSuperAddrCode:(NSString *)superAddrCode successHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"superAddrCode":superAddrCode};
    NSLog(@"%@",superAddrCode);
    [Request.share postVariablesToURL:City variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getErrandClassSuccessHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"superDictionaryCode":@"YWLX02-04"};
    [Request.share postVariablesToURL:BaseDataInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelsOfClass:[ErrandClassModel class] fromJSONArray:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}
+(void)getDetailClassSuccessHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"superDictionaryCode":@"YWLX01-09"};
    [Request.share postVariablesToURL:BaseDataInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelsOfClass:[ErrandClassModel class] fromJSONArray:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getFieldListSuccessHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"superDictionaryCode":@"FWFL01-01"};
    [Request.share postVariablesToURL:BaseDataInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelsOfClass:[ErrandClassModel class] fromJSONArray:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)publicErrandWithUsrId:(NSNumber *)usrId usrName:(NSString *)usrName dwellAddr:(NSString *)dwellAddr classifyDomain:(NSString *)classifyDomain errandType:(NSString *)errandType busiType:(NSString *)busiType price:(NSNumber *)price title:(NSString *)title phone:(NSString *)phone remark:(NSString *)remark successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":usrId,@"usrName":usrName,@"dwellAddr":dwellAddr,@"classifyDomain":classifyDomain,@"errandType":errandType,@"busiType":busiType,@"price":price,@"errandTitle":title,@"remark":remark,@"publishStatus":@"1",@"reseField1":phone,@"reseField2":AppUserDefaults.share.isInside?:@"0"};
    [Request.share postVariablesToURL:Publish variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getCityCodeByCityName:(NSString *)addrName successHandler:(void (^)(AreaModel *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"addrName":addrName,@"addrLevel":@"3"};
    [Request.share postVariablesToURL:AddrCode variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelOfClass:[AreaModel class] fromJSONDictionary:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            successBlcok(nil);
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getErrandListWithCityCode:(NSString *)dwellAddr page:(int)page successHandler:(void (^)(BOOL isLast,NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict ;
    if (dwellAddr) {
       parameterDict = @{@"dwellAddr":dwellAddr,@"publishStatus":@"1",@"isRobOrder":@"0",@"pageNum":@(page),@"pageSize":@(20),@"delFlag":@"0"};
    }
    else
    {
        parameterDict = @{@"publishStatus":@"1",@"isRobOrder":@"0",@"pageNum":@(page),@"pageSize":@(20),@"delFlag":@"0"};
    }
    
    [Request.share postVariablesToURL:ErrandList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[ErrandModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
             NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getErrandDetailWithErrandId:(NSNumber *)errandId successHandler:(void (^)(ErrandModel *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"errandId":errandId};
    [Request.share postVariablesToURL:ErrandDetail variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelOfClass:[ErrandModel class] fromJSONDictionary:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getMyPublishWith:(NSString *)sortType errandTitle:(NSString *)errandTitle listSuccessHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"publishStatus":@"1",@"usrId":[AppUserDefaults share].usrId,@"delFlag":@"0",@"sortType":sortType,@"errandTitle":errandTitle?:@""};
    [Request.share postVariablesToURL:ErrandListNoPage variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelsOfClass:[ErrandModel class] fromJSONArray:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)changeErrandWithErrandId:(NSNumber *)errandId usrName:(NSString *)usrName dwellAddr:(NSString *)dwellAddr classifyDomain:(NSString *)classifyDomain errandType:(NSString *)errandType busiType:(NSString *)busiType price:(NSNumber *)price title:(NSString *)title phone:(NSString *)phone remark:(NSString *)remark successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"errandId":errandId,@"usrId":[AppUserDefaults share].usrId,@"usrName":usrName,@"dwellAddr":dwellAddr,@"classifyDomain":classifyDomain,@"errandType":errandType,@"busiType":busiType,@"price":price,@"errandTitle":title,@"remark":remark,@"reseField1":phone};
    [Request.share postVariablesToURL:Publish variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)deleteErrandWithErrandId:(NSNumber *)errandId successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"errandId":errandId,@"usrId":[AppUserDefaults share].usrId,@"delFlag":@"1"};
    [Request.share postVariablesToURL:Publish variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getMyGrabListWithPage:(int)page dwellAddr:(NSString *)dwellAddr sortType:(NSString *)sortType errandType:(NSString *)errandType successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock
{
    NSDictionary *parameterDict;
    if ([dwellAddr isEqualToString:@"CHN"]) {
        parameterDict = @{@"faciId":[AppUserDefaults share].usrId,@"pageNum":@(page),@"pageSize":@(20),@"dwellAddrLike":@"CHN",@"errandTypes":errandType?errandType:@"",@"sortType":sortType};
    }
    else
    {
        parameterDict = @{@"faciId":[AppUserDefaults share].usrId,@"pageNum":@(page),@"pageSize":@(20),@"dwellAddrs":dwellAddr?dwellAddr:@"",@"errandTypes":errandType?errandType:@"",@"sortType":sortType};
    }
    
    [Request.share postVariablesToURL:GrabList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[ErrandModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getFilterErrandListWithDwellAddrs:(NSString *)dwellAddrs searchStr:(NSString *)searchStr price:(NSString *)price classifyDomains:(NSString *)classifyDomains errandTypes:(NSString *)errandTypes busiTypes:(NSString *)busiTypes page:(int)page successHandler:(void (^)(BOOL, NSArray *,NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict;
    if ([dwellAddrs isEqualToString:@"CHN"]) {
        parameterDict = @{@"usrId":[AppUserDefaults share].isLogin?[AppUserDefaults share].usrId:@"",@"isInside":[AppUserDefaults share].isLogin?[AppUserDefaults share].isInside:@"",@"publishStatus":@"1",@"isRobOrder":@"0",@"pageNum":@(page),@"pageSize":@(20),@"delFlag":@"0",@"dwellAddrLike":@"CHN",@"classifyDomains":classifyDomains?classifyDomains:@"",@"errandTypeLike":errandTypes?errandTypes:@"",@"busiTypes":busiTypes?busiTypes:@"",@"errandTitle":searchStr,@"price":price};
    }
    else
    {
        parameterDict = @{@"usrId":[AppUserDefaults share].isLogin?[AppUserDefaults share].usrId:@"",@"isInside":[AppUserDefaults share].isLogin?[AppUserDefaults share].isInside:@"",@"publishStatus":@"1",@"isRobOrder":@"0",@"pageNum":@(page),@"pageSize":@(20),@"delFlag":@"0",@"dwellAddrs":dwellAddrs?dwellAddrs:@"",@"classifyDomains":classifyDomains?classifyDomains:@"",@"errandTypeLike":errandTypes?errandTypes:@"",@"busiTypes":busiTypes?busiTypes:@"",@"errandTitle":searchStr,@"price":price};
    }
    NSLog(@"*****************************");
    NSLog(@"%@",parameterDict);
    NSLog(@"*****************************");
    [Request.share postVariablesToURL:ErrandList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[ErrandModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil],[dict objectForKey:@"total"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];

}

+(void)getUserInfoSuccessHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId};
    [Request.share postVariablesToURL:UserInfoURL variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok(dict);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)identityCheckSuccessHandler:(void (^)(NSString *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId};
    [Request.share postVariablesToURL:IdentityCheck variables:parameterDict successHandler:^(id json) {
        successBlcok([json objectForKey:@"body"]);
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];

}
+(void)grabErrandWithErrandId:(NSNumber *)errandId faciName:(NSString *)faciName errandTitle:(NSString *)errandTitle usrId:(NSNumber *)usrId price:(NSNumber *)price successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"faciId":[AppUserDefaults share].usrId,@"errandId":errandId,@"faciName":faciName,@"errandTitle":errandTitle,@"usrId":usrId,@"price":price};
    [Request.share postVariablesToURL:GrabErrand variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:[json objectForKey:@"info"]];
            successBlcok(NO);
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
//        [SVProgressHUD dismiss];
    }];
}

+(void)addProgressWithErrandId:(NSNumber *)errandId endTime:(NSString *)endTime remark:(NSString *)remark errandStatus:(NSString *)errandStatus successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"errandId":errandId,@"endTime":endTime,@"remark":remark,@"addAccounts":AppUserDefaults.share.usrId,@"errandStatus":errandStatus};
    [Request.share postVariablesToURL:AddErrandRecording variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getProgressListWithErrandId:(NSNumber *)errandId successHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"errandId":errandId};
    [Request.share postVariablesToURL:ErrandProgressList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelsOfClass:[ProgressModel class] fromJSONArray:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)finishWithErrandId:(NSNumber *)errandId robId:(NSNumber *)robId errandTitle:(NSString *)errandTitle usrId:(NSNumber *)usrId faciName:(NSString *)faciName price:(NSNumber *)price successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"errandId":errandId,@"errandTitle":errandTitle,@"usrId":usrId,@"faciName":faciName,@"isReply":@"1",@"id":robId,@"faciId":[AppUserDefaults share].usrId,@"price":price};
    [Request.share postVariablesToURL:GrabErrand variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(NSURLSessionDataTask *)searchPatentWithContent:(NSString *)content pageNo:(int)pageNo anAdd:(NSString *)anAdd country:(NSString *)country pkind:(NSString *)pkind  successHandler:(void (^)(BOOL , NSArray *,NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"DATABASE:(%@)",country];
    NSArray *array = [content componentsSeparatedByString:@" "];
    for (NSString *comStr in array) {
        if(![comStr isEqualToString:@""])
        {
            [str appendFormat:@" AND ALL:(%@)",comStr];
        }
    }
    if(pkind.length)
    {
        [str appendFormat: @" AND PKIND:(%@)",pkind];
    }
    if (anAdd.length)
    {
        [str appendFormat: @" AND AN_ADD:(%@)",anAdd];
    }
    NSDictionary *parameterDict = @{@"keyswords":str,@"pageNo":@(pageNo)};
    NSURLSessionDataTask *dataTask =[Request.share postVariablesToURL:CompanyPatentList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[PatentModel class] fromJSONArray:[dict objectForKey:@"content"] error:nil],[dict objectForKey:@"total"]);
            }
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
    return dataTask;
}

+(void)sureErrandWithErrandId:(NSNumber *)errandId faciId:(NSNumber *)faciId errandTitle:(NSString *)errandTitle errandStatus:(NSString *)errandStatus successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"errandId":errandId,@"errandStatus":errandStatus,@"faciId":faciId,@"usrId":[AppUserDefaults share].usrId,@"errandTitle":errandTitle};
    [Request.share postVariablesToURL:Publish variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}


+(void)getAgentListWithPage:(int)page cityCode:(NSString *)cityCode domainCode:(NSString *)domainCode serviceType:(NSString *)serviceType star:(NSInteger)star priceUpDown:(NSString *)priceUpDown successHandler:(void (^)(BOOL, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"auditStatus":@"1",@"delFlag":@"0",@"dwellAddr":cityCode?cityCode:@"",@"classifyCode":domainCode?domainCode:@"",@"pageNum":@(page),@"serviceType":serviceType,@"starService":@(star),@"total":priceUpDown};
    [Request.share postVariablesToURL:AgentList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[AgentModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getSystemMessageWithPage:(int)page successHandler:(void (^)(BOOL, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"pageNum":@(page),@"pageSize":@"10",@"usrId":[AppUserDefaults share].usrId};
    [Request.share postVariablesToURL:SystemMessage variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[SystemMessageModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getBeEvaluatedListPage:(int)page successHandler:(void (^)(BOOL, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"errandStatus":@"CSZT01-06",@"pageNum":@(page),@"pageSize":@(20),@"delFlag":@"0"}; ;
    
    [Request.share postVariablesToURL:ErrandList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[ErrandModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)addCommentWithErrandId:(NSNumber *)errandId faciId:(NSNumber *)faciId evalLevel:(int)evalLevel evalContent:(NSString *)evalContent successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"errandId":errandId,@"evalLevel":[NSString stringWithFormat:@"%d",evalLevel],@"evalContent":evalContent,@"faciId":faciId};
    
    [Request.share postVariablesToURL:AddComment variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getCommentListWithPage:(int)page faciId:(NSNumber *)faciId successHandler:(void (^)(BOOL, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"faciId":faciId,@"pageNum":@(page)}; ;
    
    [Request.share postVariablesToURL:CommentMeList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[CommentModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getCommentListForTwoFaciId:(NSNumber *)faciId successHandler:(void (^)(NSNumber *, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"faciId":faciId,@"pageNum":@1}; ;
    
    [Request.share postVariablesToURL:CommentMeList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([dict objectForKey:@"total"],[MTLJSONAdapter modelsOfClass:[CommentModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)changeMessageReadStatusWithMsgId:(NSNumber *)msgId successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"msgId":msgId,@"readStatus":@"1"}; ;
    
    [Request.share postVariablesToURL:MessageStatusChange variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];

}

+(void)getAgentInfoSuccessHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId}; ;
    
    [Request.share postVariablesToURL:AgentInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)uploadImageWithImageData:(NSData *)data successHandler:(void (^)(NSString *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    [SVProgressHUD showWithStatus:@"图片正在上传"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    [manager POST:UploadImage parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data
                                    name:@"fileName"
                                fileName:@"1.jpg" mimeType:@"image/jpeg"];
        // etc.
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
//        NSLog(@"%@",uploadProgress);
//        uploadProgressBlock(uploadProgress);
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"图片正在上传"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if([[responseObject objectForKey:@"success"]boolValue])
        {
            [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
            NSString *imageUrl = [[responseObject objectForKey:@"body"]objectForKey:@"path"];
            successBlcok(imageUrl);
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"info"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *errorInfo = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (errorInfo == nil) {
            //            NSError *suberror = [error.userInfo objectForKey:@"NSUnderlyingError"];
            //            errorInfo = [suberror.userInfo objectForKey:@"NSLocalizedDescription"];
            [SVProgressHUD showErrorWithStatus:@"服务器错误"];
        }
        else
        {
            if ([errorInfo isEqualToString:@"已取消"]) {
                
            }
            else{
                [SVProgressHUD showInfoWithStatus:errorInfo];
            }
        }
    }];
}

+(void)changeDomainWithServiceType:(NSString *)serviceType price:(NSNumber *)price delFlag:(NSString *)delFlag rangeId:(NSNumber *)rangeId remark:(NSString *)remark auditStatus:(NSString *)auditStatus successHandler:(void (^)(NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]initWithDictionary:@{@"usrId":[AppUserDefaults share].usrId,@"facilitatorId":[AppUserDefaults share].facilitatorId,@"classifyCode":serviceType,@"price":price,@"delFlag":delFlag,@"remark":remark?:@"",@"auditStatus":auditStatus}] ;
    if (rangeId) {
        [parameterDict setObject:rangeId forKey:@"id"];
    }
    
    [Request.share postVariablesToURL:ChangeDomain variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(@([[json objectForKey:@"body"] integerValue]));
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

//+(void)addOrDeleteTypeWithServiceType:(NSString *)serviceType delFlag:(NSString *)delFlag rangeId:(NSNumber *)rangeId auditStatus:(NSString *)auditStatus successHandler:(void (^)(NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
//{
//    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]initWithDictionary:@{@"usrId":[AppUserDefaults share].usrId,@"facilitatorId":[AppUserDefaults share].facilitatorId,@"serviceType":serviceType,@"delFlag":delFlag,@"pp":@(0),@"auditStatus":auditStatus}] ;
//    if (rangeId) {
//        [parameterDict setObject:rangeId forKey:@"rangeId"];
//    }
//    [SVProgressHUD show];
//    [Request.share postVariablesToURL:ChangeType variables:parameterDict successHandler:^(id json) {
//        if([[json objectForKey:@"success"]boolValue])
//        {
//            [SVProgressHUD dismiss];
//            successBlcok(@([[json objectForKey:@"body"] integerValue]));
//        }
//        else
//        {
//            NSString *info = [json objectForKey:@"info"];
//            if (info==nil || [info isKindOfClass:[NSNull class]]) {
//                [SVProgressHUD showInfoWithStatus:@"操作失败"];
//            }
//            else
//            {
//                [SVProgressHUD showInfoWithStatus:info];
//            }
//        }
//    } errorHandler:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        errorBlock(error);
//    }];
//}
//
//+(void)changeSubTypeWithID:(NSNumber *)modelId detailType:(NSString *)detailType rangeId:(NSNumber *)rangeId price:(int)price delFlag:(NSString *)delFlag auditStatus:(NSString *)auditStatus successHandler:(void (^)(NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
//{
//    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]initWithDictionary:@{@"usrId":[AppUserDefaults share].usrId,@"facilitatorId":[AppUserDefaults share].facilitatorId,@"detailType":detailType,@"delFlag":delFlag,@"rangeId":rangeId,@"price":@(price),@"auditStatus":auditStatus}] ;
//    if (modelId) {
//        [parameterDict setObject:modelId forKey:@"id"];
//    }
//    
//    [Request.share postVariablesToURL:ChangeSubType variables:parameterDict successHandler:^(id json) {
//        if([[json objectForKey:@"success"]boolValue])
//        {
//            successBlcok(@([[json objectForKey:@"body"] integerValue]));
//        }
//        else
//        {
//            NSString *info = [json objectForKey:@"info"];
//            if (info==nil || [info isKindOfClass:[NSNull class]]) {
//                [SVProgressHUD showInfoWithStatus:@"操作失败"];
//            }
//            else
//            {
//                [SVProgressHUD showInfoWithStatus:info];
//            }
//        }
//    } errorHandler:^(NSError *error) {
//        errorBlock(error);
//    }];
//}

+(void)changeAgentInfoWithModel:(AgentInfoModel *)model successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"facilitatorId":model.facilitatorId,@"serveManifesto":model.serveManifesto,@"serveBrief":model.serveBrief,@"mobilePhone":model.mobilePhone,@"qq":model.qq,@"bankCardNo":model.bankCardNo,@"bankOpen":model.bankOpen,@"bankLocale":model.bankLocale,@"credUrl":model.credUrl,@"fileUrl1":model.fileUrl1,@"fileUrl2":model.fileUrl2,@"ortherInfo":model.ortherInfo,@"dwellAddr":model.dwellAddr,@"realName":model.realName,@"companyName":model.companyName,@"organNo":model.organNo,@"qualCertNo":model.qualCertNo,@"practCertNo":model.practCertNo,@"annualStatus":model.annualStatus};
    
    [Request.share postVariablesToURL:ChangeAgentInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
    
}

+(void)getMyCommentListWithPage:(int)page successHandler:(void (^)(BOOL, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"pageNum":@(page)}; ;
    
    [Request.share postVariablesToURL:CommentMeList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[CommentModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)changeUserInfoWithPortraitUrl:(NSString *)portraitUrl successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"portraitUrl":portraitUrl}; ;
    
    [Request.share postVariablesToURL:ChangeUserInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}
+(void)changeUserInfoWithUsrAlias:(NSString *)usrAlias successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"usrAlias":usrAlias}; ;
    
    [Request.share postVariablesToURL:ChangeUserInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}
+(void)changeAgentisReceOrder:(BOOL)isReceOrder facilitatorId:(NSNumber *)facilitatorId successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"facilitatorId":facilitatorId?facilitatorId:@0,@"isReceOrder":[NSString stringWithFormat:@"%d",isReceOrder]};
    
    [Request.share postVariablesToURL:ChangeAgentInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}
+(void)changeAgentAddress:(NSString *)dwellAddr facilitatorId:(NSNumber *)facilitatorId successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"facilitatorId":facilitatorId?facilitatorId:@0,@"dwellAddr":dwellAddr};
    
    [Request.share postVariablesToURL:ChangeAgentInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)changeUserAddress:(NSString *)dwellAddr detailsId:(NSNumber *)detailsId successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"detailsId":detailsId?detailsId:@0,@"dwellAddr":dwellAddr};
    
    [Request.share postVariablesToURL:ChangeUserAddress variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];

}

+(void)getNoPayListWithPage:(int)page successHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"page":@(page),@"usrId":[AppUserDefaults share].usrId};
    [Request.share postVariablesToURL:NoPay variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([MTLJSONAdapter modelsOfClass:[NoPayModel class] fromJSONArray:[dict objectForKey:@"listShopInfo"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];

}
+(void)assignAgentWithFaciId:(NSString *)FaciId faciName:(NSString *)faciName usrName:(NSString *)usrName dwellAddr:(NSString *)dwellAddr classifyDomain:(NSString *)classifyDomain errandType:(NSString *)errandType busiType:(NSString *)busiType price:(NSString *)price title:(NSString *)title remark:(NSString *)remark phone:(NSString *)phone successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"faciId":FaciId,@"faciName":faciName,@"usrName":usrName,@"dwellAddr":dwellAddr,@"classifyDomain":classifyDomain,@"errandType":errandType,@"busiType":busiType,@"price":price,@"errandTitle":title,@"remark":remark,@"publishStatus":@"1",@"reseField1":phone,@"reseField2":AppUserDefaults.share.isInside?:@""};
    [Request.share postVariablesToURL:Publish variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getAgentDetailsWithUsrId:(NSNumber *)usrId successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":usrId};
    [Request.share postVariablesToURL:AgentDetial variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getRotationImageSuccessHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    
    [Request.share postVariablesToURL:RotationImage variables:nil successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelsOfClass:[BannerModel class] fromJSONArray:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)feedBackWithFeedbackInfo:(NSString *)feedbackInfo successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"feedbackInfo":feedbackInfo};
    [Request.share postVariablesToURL:FeedBack variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getFundsListWithPage:(int)pageNum successHandler:(void (^)(BOOL,NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"pageNum":@(pageNum)};
    [Request.share postVariablesToURL:FundsFlow variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[RecordingModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)outlayWithBankCardNo:(NSString *)bankCardNo bankOpen:(NSString *)bankOpen bankLocale:(NSString *)bankLocale usrRealName:(NSString *)usrRealName price:(int)optMoney successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"optType":@"1",@"bankCardNo":bankCardNo,@"bankOpen":bankOpen,@"bankLocale":bankLocale,@"usrRealName":usrRealName,@"optMoney":@(optMoney)};
    [Request.share postVariablesToURL:Outlay variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [LoadingManager dismiss];
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

-(void)searchCompanyWithCompany:(NSString *)company successHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    [_searchCompantTask cancel];
    NSDictionary *parameterDict = @{@"company":company};
    _searchCompantTask = [Request.share postVariablesToURL:SearchCompany variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)addCompanyWithName:(NSString *)name successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"selKeyword":name,@"usrId":[AppUserDefaults share].usrId};
    [Request.share postVariablesToURL:AddCompany variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)lookforMyPatentSuccessHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId};
    [Request.share postVariablesToURL:MyPatent variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];

}
+(void)editCompantWithKeywordId:(NSNumber *)keywordId selKeyword:(NSString *)selKeyword successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"keywordId":keywordId,@"selKeyword":selKeyword};
    [Request.share postVariablesToURL:EditCompany variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)checkMoneySuccessHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId};
    [Request.share postVariablesToURL:CheckMoney variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)wechatPayWithSuperOrderNo:(NSString *)superOrderNo price:(NSNumber *)price errandTitle:(NSString *)errandTitle isInside:(NSString *)isInside SuccessHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"superOrderNo":superOrderNo,@"price":price,@"title":errandTitle?:@"",@"isInside":isInside};
    [Request.share postVariablesToURL:Pay variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)payFinishErrandWithErrandId:(NSNumber *)errandId faciId:(NSNumber *)faciId errandTitle:(NSString *)errandTitle price:(NSNumber *)price faciName:(NSString *)faciName successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"errandId":errandId,@"errandStatus":@"CSZT01-04",@"faciId":faciId,@"usrId":[AppUserDefaults share].usrId,@"errandTitle":errandTitle,@"price":price,@"faciName":faciName};
    [Request.share postVariablesToURL:Publish variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)callDoublePhoneWithPhone:(NSString *)phone call:(NSString *)call successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"phone":phone,@"call":call};
    
    [Request.share postVariablesToURL:DoubleCall variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)changePhone:(NSString *)phone detailsId:(NSNumber *)detailsId successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"reseField1":phone,@"detailsId":detailsId?detailsId:@0};
    
    [Request.share postVariablesToURL:ChangeUserAddress variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

/// hotSearch
+(void)hotSearchWithType:(NSString *)type successHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"type":type};
    
    [Request.share postVariablesToURL:HotSearch variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([MTLJSONAdapter modelsOfClass:[HotSearchModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)addHotSearchWithType:(NSString *)type keyword:(NSString *)keyword successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict;
    if ([AppUserDefaults share].isLogin) {
        parameterDict = @{@"type":type,@"keyword":keyword,@"usrId":[AppUserDefaults share].usrId};
    }
    else
    {
        parameterDict = @{@"type":type,@"keyword":keyword};
    }
    [Request.share postVariablesToURL:AddHotSearch variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];

}
+
(void)searchTrademarkWithContent:(NSString *)content pageNo:(int)pageNo intCls:(NSString *)intCls successHandler:(void (^)(NSString *, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"content":content,@"pageNo":@(pageNo),@"intCls":intCls};
    [Request.share postVariablesToURL:SearchTrademark variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([dict objectForKey:@"allRecords"],[MTLJSONAdapter modelsOfClass:[TrademarkModel class] fromJSONArray:[dict objectForKey:@"results"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getHeadlinesWithPageNum:(int)pageNum successHandler:(void (^)(BOOL, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"pageNum":@(pageNum),@"pageSize":@(10)};
    [Request.share postVariablesToURL:Headlines variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[HeadlinesModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(BOOL)isLast:(NSDictionary *)dict
{
    int currentpage = [[dict objectForKey:@"pageNum"]intValue];
    int paegs = [[dict objectForKey:@"pages"]intValue];
    if (currentpage>=paegs) {
        return YES;
    }
    return NO;
}

+(void)getMonitorCompanyListPage:(int)page successHandler:(void (^)(BOOL, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"pageNum":@(page),@"usrId":[AppUserDefaults share].usrId,@"monitorStatus":@"1"};
    [Request.share postVariablesToURL:MonitorCompanyList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[MonitorCompanyModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getMonitorContentListWithMonitorId:(NSNumber *)monitorId page:(int)page monitorType:(NSString *)monitorType companyName:(NSString *)companyName successHandler:(void (^)(BOOL, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{
                                    @"pageNum":@(page),@"usrId":[AppUserDefaults share].usrId,
//                                    @"monitorId":monitorId,
                                    @"monitorType":monitorType,
//                                    @"companyName":companyName
                                    };
    [Request.share postVariablesToURL:MonitorContentList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[MonitorContentModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)addCompanyToMonitorWithCompanyName:(NSString *)companyName address:(NSString *)address country:(NSString *)country successHandler:(void (^)(NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"address":address,@"usrId":[AppUserDefaults share].usrId,@"companyName":companyName,@"country":country};
    [Request.share postVariablesToURL:AddCompanyToMonitor variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getOtherWorkDataSuccessHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    [Request.share postVariablesToURL:OtherWork variables:nil successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)deleteMonitorWithMonitorId:(NSNumber *)monitorId successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"id":monitorId,@"usrId":[AppUserDefaults share].usrId,@"monitorStatus":@"0"};
    [Request.share postVariablesToURL:DeleteMonitor variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(NSURLSessionDataTask *)searchAllWithKeyword:(NSString *)keyword anAdd:(NSString *)anAdd country:(NSString *)country successHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"keyword":keyword,@"anAdd":anAdd,@"country":country};
    
    NSURLSessionDataTask *task= [Request.share postVariablesToURL:SearchAll variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelsOfClass:[SearchAllModel class] fromJSONArray:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }

        }
    } errorHandler:^(NSError *error) {
        
    }];
    
    return task;
}

+(void)getCompanyPatentListWithCompany:(NSString *)company page:(int)page country:(NSString *)country pkind:(NSString *)pkind successHandler:(void (^)(BOOL, NSArray *,NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"DATABASE:(TOTALDB)"];
    NSArray *array = [company componentsSeparatedByString:@" "];
    for (NSString *comStr in array) {
        if(![comStr isEqualToString:@""])
        {
            [str appendFormat:@" AND ALL:(%@)",comStr];
        }
    }
    if(pkind.length)
    {
        [str appendFormat: @" AND PKIND:(%@)",pkind];
    }
    NSDictionary *parameterDict = @{@"keyswords":str,@"pageNo":@(page)};
    [Request.share postVariablesToURL:CompanyPatentList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[PatentModel class] fromJSONArray:[dict objectForKey:@"content"] error:nil],[dict objectForKey:@"total"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}
+(void)getCompanyTrademarkListWithCompany:(NSString *)company page:(int)page successHandler:(void (^)(BOOL, NSArray *,NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"company":company,@"pageNo":@(page)};
    [Request.share postVariablesToURL:CompanyTrademarkList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([[dict objectForKey:@"pages"]isEqualToNumber:[dict objectForKey:@"pageNo"]],[MTLJSONAdapter modelsOfClass:[TrademarkModel class] fromJSONArray:[dict objectForKey:@"listData"] error:nil],[dict objectForKey:@"total"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)companyIsMonitorWithCompanyName:(NSString *)companyName successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"companyName":companyName,@"usrId":[AppUserDefaults share].usrId};
    [Request.share postVariablesToURL:CompanyIsMonitor variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getNoPayInfoWithShopId:(NSNumber *)shopId successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"shopId":shopId};
    [Request.share postVariablesToURL:NoPayInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getOrderNumWithShopIds:(NSString *)ids userType:(NSString *)userType successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"userType":userType,@"ids":ids};
    [Request.share postVariablesToURL:GetOrderNum variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)deleteShopWithShopIds:(NSString *)ids successHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"id":ids};
    [Request.share postVariablesToURL:DelShop variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([MTLJSONAdapter modelsOfClass:[NoPayModel class] fromJSONArray:[dict objectForKey:@"listShopInfo"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getNoPayOrderWithPage:(int)page successHandler:(void (^)(BOOL ,NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"flag":@"0",@"pageNum":@(page),@"delFlag":@"0"};
    [Request.share postVariablesToURL:OrderList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([[dict objectForKey:@"pages"]isEqualToNumber:[dict objectForKey:@"pageNum"]],[MTLJSONAdapter modelsOfClass:[OrderModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}
+(void)getPaidOrderWithPage:(int)page successHandler:(void (^)(BOOL ,NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"flag":@"1",@"pageNum":@(page)};
    [Request.share postVariablesToURL:OrderList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([[dict objectForKey:@"pages"]isEqualToNumber:[dict objectForKey:@"pageNum"]],[MTLJSONAdapter modelsOfClass:[OrderModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}


+(void)getPayResultWithOrderNum:(NSString *)superOrderNo successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"superOrderNo":superOrderNo};
    [Request.share postVariablesToURL:GetPayResult variables:parameterDict successHandler:^(id json) {
        NSDictionary *dict = [json objectForKey:@"body"];
        if ([[dict objectForKey:@"trade_state"]isEqualToString:@"SUCCESS"]) {
            successBlcok(YES);
        }
        else
        {
            successBlcok(NO);
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getRobErrandInfoWithErrandId:(NSNumber *)errandId successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"errandId":errandId};
    [Request.share postVariablesToURL:FaciErrandInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([dict objectForKey:@"errandInfo"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}
+(void)cancelDeleteMonitorWithMonitorId:(NSNumber *)monitorId successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"id":monitorId,@"usrId":[AppUserDefaults share].usrId,@"monitorStatus":@"1"};
    [Request.share postVariablesToURL:DeleteMonitor variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getCopyrightDetailWithId:(NSString *)regid successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"copyId":regid};
    [Request.share postVariablesToURL:CopyRightInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok(dict);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(NSURLSessionDataTask *)searchPatentWithTITLE:(NSString *)TITLE pageNo:(int)pageNo anAdd:(NSString *)anAdd country:(NSString *)country pkind:(NSString *)pkind PBD:(NSString *)PBD IPC1:(NSString *)IPC1 ISVALID:(NSString *)ISVALID successHandler:(void (^)(BOOL, NSArray *,NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"TITLE":TITLE?:@"",@"pageNo":@(pageNo),@"anAdd":anAdd,@"country":country,@"pkind":pkind,@"PBD":PBD,@"IPC1":IPC1,@"VALID":ISVALID};
    NSURLSessionDataTask *dataTask =[Request.share postVariablesToURL:SearchPatent variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSError *error;
                successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[PatentModel class] fromJSONArray:[dict objectForKey:@"content"] error:&error],[dict objectForKey:@"total"]);
//                NSLog(@"%@",error);
            }
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
    return dataTask;

}

+(void)getMySearchHistorySuccessHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"type":@"6"};
    [Request.share postVariablesToURL:HotByUsrId variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([MTLJSONAdapter modelsOfClass:[HotSearchModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getPatentProgressApplyNo:(NSString *)applyNo successHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"applyNo":applyNo};
    [Request.share postVariablesToURL:PatentProgress variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([MTLJSONAdapter modelsOfClass:[PatentProgressModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)sellPatentsWithListBusi:(NSString *)listBusi successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"listBusi":listBusi};
    [Request.share postVariablesToURL:SellPatents variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getCompanyProgressEnableListWithUUID:(NSString *)compUuid page:(int)page successHandler:(void (^)(BOOL, NSArray *, NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"compUuid":compUuid,@"pageNo":@(page)};
    [Request.share postVariablesToURL:CompanyPatentProgressList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[CompanyEnableProgressPatentModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil],[dict objectForKey:@"total"]);
            }
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
   
}

+(void)searchSoftwareCopyrightWithParameter:(NSDictionary *)parameterDict successHandler:(void (^)(BOOL, NSArray *, NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    [Request.share postVariablesToURL:SoftwareCopyright variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            if([dict isKindOfClass:[NSNull class]])
            {
                [SVProgressHUD showErrorWithStatus:@"获取结果失败"];
                errorBlock(nil);
            }
            else
            {
                NSDictionary *result = [dict objectForKey:@"result"];
                
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    successBlcok([[result objectForKey:@"page"] integerValue]>=[[result objectForKey:@"totalPages"]integerValue],[MTLJSONAdapter modelsOfClass:[SoftwareCopyrightModel class] fromJSONArray:[result objectForKey:@"crList"] error:nil],[result objectForKey:@"total"]);
                }
            }
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}
+(void)searchWorksCopyrightWithParameter:(NSDictionary *)parameterDict successHandler:(void (^)(BOOL, NSArray *, NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSLog(@"%@",parameterDict);
    [Request.share postVariablesToURL:WorksCopyright variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            if([dict isKindOfClass:[NSNull class]])
            {
                NSLog(@"%@",json);
                [SVProgressHUD showErrorWithStatus:@"获取结果失败"];
                errorBlock(nil);
            }
            else
            {
                NSDictionary *result = [dict objectForKey:@"result"];
                NSInteger page = [[result objectForKey:@"page"] integerValue];
                NSInteger totalPage = [[result objectForKey:@"totalPages"]integerValue];
                BOOL isLast = page>=totalPage;
                successBlcok(isLast,[MTLJSONAdapter modelsOfClass:[WorksCopyrightModel class] fromJSONArray:[result objectForKey:@"worksList"] error:nil],[result objectForKey:@"total"]);
            }
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getPatentScoreWithPN:(NSString *)PN successHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"PN":PN};
    [Request.share postVariablesToURL:PatentScore variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getInformationListWithPageNum:(int)pageNum pubOrg:(NSString *)pubOrg addr:(NSString *)addr pubDate:(NSString *)pubDate sourceType:(NSString *)sourceType successHandler:(void (^)(BOOL, NSArray *, NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"source":pubOrg,@"pageNum":@(pageNum),@"addr":addr,@"flag":pubDate,@"sourceType":sourceType};
    [Request.share postVariablesToURL:GovernmentInformationList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                successBlcok([self isLast:dict],[MTLJSONAdapter modelsOfClass:[HeadlinesModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil],[dict objectForKey:@"total"]);
            }
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getRegionAndOrganizationWithAddrCode:(NSString *)addrCode successHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"addrCode":addrCode};
    [Request.share postVariablesToURL:DeptByAddr variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelsOfClass:[OrgAreaModel class] fromJSONArray:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getOrganizationAndRegionWithDepartCode:(NSString *)departCode successHandler:(void (^)(NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"departCode":departCode};
    [Request.share postVariablesToURL:AddrByDept variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([MTLJSONAdapter modelsOfClass:[OrganizationModel class] fromJSONArray:[json objectForKey:@"body"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)submitFaciInfoToReViewWithParameter:(NSString *)parameter successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"param":parameter};
    [Request.share postVariablesToURL:ReviewFaciInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getOtherWorkDataDiscardSuccessHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    [Request.share postVariablesToURL:OtherDataDiscard variables:nil successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];

}
+(void)changeAgentInfoWithNickname:(NSString *)nickName SuccessHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"facilitatorId":MyApp.userInfo.facilitatorId,@"facilitatorName":nickName,};
    [Request.share postVariablesToURL:ChangeAgentInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}
+(void)changeAgentInfoWithHeaderImage:(NSString *)imageUrl SuccessHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"facilitatorId":[AppUserDefaults share].facilitatorId,@"portraitUrl":imageUrl};
    
    [Request.share postVariablesToURL:ChangeAgentInfo variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)addPatentToMonitorListWithPatentID:(NSString *)patentId physicDb:(NSString *)physicDb SuccessHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"id":patentId,@"physicDb":physicDb};
    
    [Request.share postVariablesToURL:AddPatentToMonitor variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getVersionSuccessHandler:(void (^)(VersionModel *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    
    
    [Request.share postVariablesToURL:GetVersion variables:@{@"useType":@"1"} successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSArray *array = [MTLJSONAdapter modelsOfClass:[VersionModel class] fromJSONArray:[json objectForKey:@"body"] error:nil];
            successBlcok(array.firstObject);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}


+(void)batchMonitoringWithParameter:(NSString *)str SuccessHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"list":str};
    
    [Request.share postVariablesToURL:BatchMonitoring variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)searchPolicyInformationWithNotEqual:(BOOL)notEqual addr:(NSString *)addr source:(NSString *)source title:(NSString *)title info:(NSString *)info orderBy:(NSString *)orderBy sourceType:(NSString *)sourceType page:(int)page successHandler:(void (^)(BOOL, NSArray *, NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict;
    NSString *url;
    if ([addr isEqualToString:@""]&&[source isEqualToString:@""]&&[title isEqualToString:@""]&&[sourceType isEqualToString:@""]) {
         parameterDict=@{
            @"pageNum":@(page),
            @"flag":orderBy,
            @"pageSize":@20,
        };
        url = PolicyInformationForSearch;
    }
    else
    {
        url = PolicyInformationForSearchNew;
        if (notEqual) {
            parameterDict = @{
                              @"notEqual":@"1",
                              @"notAddr":addr,
                              @"notSource":source,
                              @"title":title,
                              @"info":info,
                              @"flag":orderBy,
                              @"notSourceType":sourceType,
                              @"pageNum":@(page),
                              @"dim":title,
                              };
        }
        else
        {
            parameterDict = @{
                              @"notEqual":@"",
                              @"addr":addr,
                              @"source":source,
                              @"title":title,
                              @"info":info,
                              @"flag":orderBy,
                              @"sourceType":sourceType,
                              @"pageNum":@(page),
                              @"dim":title,
                              };
        }
    }
    
    [Request.share postVariablesToURL:url variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            
            NSDictionary *dict = [json objectForKey:@"body"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                successBlcok([self isLast:dict],[NSArray yy_modelArrayWithClass:[HeadlinesModel class] json:[dict objectForKey:@"list"]],[dict objectForKey:@"total"]);
            }
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
    
}

+(void)getNewStatuDataSuccessHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary * parameterDict = @{@"usrId":[AppUserDefaults share].isLogin?[AppUserDefaults share].usrId:@""};
    [Request.share postVariablesToURL:NewStatusData variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok(dict);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getBuyingInformationWithPage:(int)page businessName:(NSString *)businessName busiQuality:(NSString *)busiQuality isMain:(BOOL)isMain successHandler:(void (^)(BOOL,NSArray *,NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict ;
    if (isMain) {
        parameterDict = @{@"pageNum":@(page),@"busiQuality":busiQuality,@"businessName":businessName,@"usrId":[AppUserDefaults share].usrId};
    }
    else
    {
        parameterDict = @{@"pageNum":@(page),@"busiQuality":busiQuality,@"businessName":businessName};
    }
    
    [Request.share postVariablesToURL:BuyingInformation variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[NSArray yy_modelArrayWithClass:[BuyInformationModel class] json:[dict objectForKey:@"list"]],[dict objectForKey:@"total"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)alipayWithOrderId:(NSNumber *)orderId isInside:(NSString *)isInside SuccessHandler:(void (^)(NSString *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"orderId":orderId,@"isInside":isInside};
    
    [Request.share postVariablesToURL:Alipay variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSString *orderStr = [json objectForKey:@"body"];
            successBlcok(orderStr);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getAlipayResultWithOrderNo:(NSString *)OrderNo SuccessHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"superOrderNo":OrderNo};
    
    [Request.share postVariablesToURL:AlipayResult variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *orderResu = [json objectForKey:@"body"];
            successBlcok(orderResu);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)addAttentionWithAddrCode:(NSString *)addrCode addrName:(NSString *)addrName departName:(NSString *)departName departCode:(NSString *)departCode SuccessHandler:(void (^)(NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"addrCode":addrCode,@"departCode":departCode,@"departName":departName,@"addrName":addrName};
    
    [Request.share postVariablesToURL:AddAttention variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSNumber *modelId = [json objectForKey:@"body"];
            successBlcok(modelId);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)deleteAttentionWithId:(NSNumber *)attentionId SuccessHandler:(void (^)(BOOL ))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"id":attentionId};
    
    [Request.share postVariablesToURL:DeleteAttention variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)getLayeredAttentionListSuccessHandler:(void (^)(NSDictionary *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId};
    
    [Request.share postVariablesToURL:LayeredAttentionList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}


+(void)getAttentionListWithPage:(int)page SuccessHandler:(void (^)(BOOL, NSArray *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"pageNum":@(page),@"pageSize":@20};
    
    [Request.share postVariablesToURL:AttentionListPage variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([self isLast:dict],[NSArray yy_modelArrayWithClass:[AttentionModel class] json:[dict objectForKey:@"list"]]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)removeLittleRedDotWith:(NSString *)addr source:(NSString *)source successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"source":source,@"addr":addr};
    [Request.share postVariablesToURL:RemoveLittleRedDot variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
//            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)deleteOrderWithOrderId:(NSNumber *)orderId orderNum:(NSString *)orderNum successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{@"usrId":[AppUserDefaults share].usrId,@"orderId":orderId,@"orderNo":orderNum,@"delFlag":@"1"};
    [Request.share postVariablesToURL:DeleteOrder variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            //            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)registeredTouristsWithUUid:(NSString *)uuid successHandler:(void (^)(NSNumber *))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    if (!uuid) {
        return;
    }
    NSDictionary *parameterDict = @{@"uuid":uuid};
    [Request.share postVariablesToURL:RegisteredTourist variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            //            NSDictionary *dict = [json objectForKey:@"body"];
            AppUserDefaults.share.ykId = [json objectForKey:@"body"];
            successBlcok([json objectForKey:@"body"]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)submitPositionWithusrId:(NSNumber *)usrId addrState:(NSString *)addrState addrProvince:(NSString *)addrProvince addrCity:(NSString *)addrCity addrCounty:(NSString *)addrCounty addrDetail:(NSString *)addrDetail addrLoi:(double)addrLoi addrLai:(double)addrLai usrType:(NSString *)usrType successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{
                                    @"usrId":usrId,
                                    @"addrState":addrState?:@"",
                                    @"addrProvince":addrProvince?:@"",
                                    @"addrCity":addrCity?:@"",
                                    @"addrCounty":addrCounty?:@"",
                                    @"addrDetail":addrDetail?:@"",
                                    @"addrLoi":@(addrLoi),
                                    @"addrLai":@(addrLai),
                                    @"usrType":usrType,
                                    @"accountType":@"0",
                                    @"sourceType":@"2",
                                    @"usrPhone":[AppUserDefaults share].phone?:@"",
                                    };
    [Request.share postVariablesToURL:SubmitPosition variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
//        else
//        {
//            NSString *info = [json objectForKey:@"info"];
//            if (info==nil || [info isKindOfClass:[NSNull class]]) {
//                [SVProgressHUD showInfoWithStatus:@"操作失败"];
//            }
//            else
//            {
//                [SVProgressHUD showInfoWithStatus:info];
//            }
//        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)associatedYKandUserWithUsrId:(NSNumber *)usrId ykId:(NSNumber *)ykId successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSDictionary *parameterDict = @{
                                    @"usrId":usrId,
                                    @"ykId":ykId,
                                    @"usrPhone":@""
                                    };
    [Request.share postVariablesToURL:YKPositiongToUser variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+(void)bindWithwxAccount:(NSString *)wxAccount qqAccount:(NSString *)qqAccount usrAccount:(NSString *)usrAccount nodeCode:(NSString *)nodeCode successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock
{
    NSMutableDictionary *parameterDict = [NSMutableDictionary new];
    [parameterDict setValue:[AppUserDefaults share].usrId forKey:@"usrId"];
    if (wxAccount) {
        [parameterDict setValue:wxAccount forKey:@"wxAccount"];
    }
    if (qqAccount) {
        [parameterDict setValue:qqAccount forKey:@"qqAccount"];
    }
    if (usrAccount) {
        [parameterDict setValue:usrAccount forKey:@"usrAccount"];
        [parameterDict setValue:nodeCode forKey:@"nodeCode"];
    }
    [Request.share postVariablesToURL:BindAccount variables:parameterDict successHandler:^(id json) {
        [LoadingManager dismiss];
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        [LoadingManager dismiss];
        errorBlock(error);
    }];
}
+(void)unbundledWithwxAccount:(NSString *)wxAccount qqAccount:(NSString *)qqAccount usrAccount:(NSString *)usrAccount nodeCode:(NSString *)nodeCode successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *))errorBlock{
    NSMutableDictionary *parameterDict = [NSMutableDictionary new];
    [parameterDict setValue:[AppUserDefaults share].usrId forKey:@"usrId"];
    if (wxAccount) {
        [parameterDict setValue:wxAccount forKey:@"wxAccount"];
    }
    if (qqAccount) {
        [parameterDict setValue:qqAccount forKey:@"qqAccount"];
    }
    if (usrAccount) {
        [parameterDict setValue:usrAccount forKey:@"usrAccount"];
        [parameterDict setValue:nodeCode forKey:@"nodeCode"];
    }
    [Request.share postVariablesToURL:UnBindAccount variables:parameterDict successHandler:^(id json) {
        [LoadingManager dismiss];
        if([[json objectForKey:@"success"]boolValue])
        {
            successBlcok(YES);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        [LoadingManager dismiss];
        errorBlock(error);
    }];
}

///我都业务列表
+ (void)getMyBusinessListWithPage:(NSInteger )page successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock{
    NSDictionary *parameterDict = @{
                                    @"buyUsrId":[AppUserDefaults share].usrId,
                                    @"delFlag":@"0",
                                    @"pageNum":@(page)
                                    };
    [Request.share postVariablesToURL:CRMOrderList variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"body"];
            successBlcok([[dict objectForKey:@"pages"]isEqualToNumber:[dict objectForKey:@"pageNum"]],[MTLJSONAdapter modelsOfClass:[OrderModel class] fromJSONArray:[dict objectForKey:@"list"] error:nil]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

///子业务进度
+ (void)getOrderProcessWith:(NSNumber *)order_info_id successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock{
    NSDictionary *parameterDict = @{
                                    @"order_info_id":order_info_id};
    [Request.share postVariablesToURL:CRMOrderProcess variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *data = [json objectForKey:@"body"];
            successBlcok([NSArray yy_modelArrayWithClass:[CRMOrderProcessModel class] json:[data objectForKey:@"list"]]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

+ (void)payAnnualFeeWithPatentApplyNoe:(NSString *)patentApplyNo price:(NSString *)price contactTelNo:(NSString *)contactTelNo contactAddr:(NSString *)contactAddr applyName:(NSString *)applyName contactName:(NSString *)contactName feeType:(NSString *)feeType specialReq:(NSString *)specialReq successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock{
    NSDictionary *parameterDict = @{
                                    @"patentApplyNo":patentApplyNo,@"price":price,@"contactTelNo":contactTelNo,@"contactAddr":contactAddr,@"usrId":[AppUserDefaults share].usrId,@"applyName":applyName,@"contactName":contactName,@"feeType":feeType};
    [Request.share postVariablesToURL:PayAnnualFee variables:parameterDict successHandler:^(id json) {
        if([[json objectForKey:@"success"]boolValue])
        {
            NSDictionary *data = [json objectForKey:@"body"];
            successBlcok([NSArray yy_modelArrayWithClass:[CRMOrderProcessModel class] json:[data objectForKey:@"list"]]);
        }
        else
        {
            NSString *info = [json objectForKey:@"info"];
            if (info==nil || [info isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showInfoWithStatus:@"操作失败"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:info];
            }
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}


@end

