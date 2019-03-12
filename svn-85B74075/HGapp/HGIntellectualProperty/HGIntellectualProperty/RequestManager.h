//
//  RequestManager.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaModel.h"
#import "AFHTTPSessionManager.h"
#import "AgentInfoModel.h"
#import "ErrandModel.h"

@class VersionModel;
@interface RequestManager : NSObject

//获取验证码
+(void)getVerificationCodeWithPhoneNum:(NSString *)phoneNum type:(NSString *)type successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//登录
+(void)loginWithPhoneNum:(NSString *)phone vcode:(NSString *)vcode successHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//三方登录
+(void)loginWithUid:(NSString *)uid userName:(NSString *)userName noType:(NSString *)noType portraitUrl:(NSString *)portraitUrl successHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

+(void)getProvinceListWriteListSuccessHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//查询地区包含子地区
+(void)getAreaWithSuperAddrCode:(NSString *)superAddrCode successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//获取差事类型列表
+(void)getErrandClassSuccessHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//获取详细业务类型列表
+(void)getDetailClassSuccessHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//所属领域列表
+(void)getFieldListSuccessHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//fabu
+(void)publicErrandWithUsrId:(NSNumber *)usrId usrName:(NSString *)usrName dwellAddr:(NSString *)dwellAddr classifyDomain:(NSString *)classifyDomain errandType:(NSString *)errandType busiType:(NSString *)busiType price:(NSNumber *)price title:(NSString *)title phone:(NSString *)phone remark:(NSString *)remark successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//获取城市编码
+(void)getCityCodeByCityName:(NSString *)addrName successHandler:(void(^)(AreaModel *model))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//获取差事列表 首页
+(void)getErrandListWithCityCode:(NSString *)dwellAddr page:(int)page successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//差事详细信息
+(void)getErrandDetailWithErrandId:(NSNumber *)errandId successHandler:(void(^)(ErrandModel *model))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//我发布的
+(void)getMyPublishWith:(NSString *)sortType errandTitle:(NSString *)errandTitle listSuccessHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//修改差事
+(void)changeErrandWithErrandId:(NSNumber *)errandId usrName:(NSString *)usrName dwellAddr:(NSString *)dwellAddr classifyDomain:(NSString *)classifyDomain errandType:(NSString *)errandType busiType:(NSString *)busiType price:(NSNumber *)price title:(NSString *)title phone:(NSString *)phone remark:(NSString *)remark successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//删除
+(void)deleteErrandWithErrandId:(NSNumber *)errandId successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//我抢的
+(void)getMyGrabListWithPage:(int)page dwellAddr:(NSString *)dwellAddr sortType:(NSString *)sortType errandType:(NSString *)errandType successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//筛选列表
+(void)getFilterErrandListWithDwellAddrs:(NSString *)dwellAddrs searchStr:(NSString *)searchStr price:(NSString *)price classifyDomains:(NSString *)classifyDomains errandTypes:(NSString *)errandTypes busiTypes:(NSString *)busiTypes page:(int)page successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *total))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//获取用户信息
+(void)getUserInfoSuccessHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

//身份以及代理人审核进度查询
+(void)identityCheckSuccessHandler:(void(^)(NSString *status))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//抢差事
+(void)grabErrandWithErrandId:(NSNumber *)errandId faciName:(NSString *)faciName errandTitle:(NSString *)errandTitle usrId:(NSNumber *)usrId price:(NSNumber *)price successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

//添加进度
+(void)addProgressWithErrandId:(NSNumber *)errandId endTime:(NSString *)endTime remark:(NSString *)remark errandStatus:(NSString *)errandStatus successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//获取进度列表
+(void)getProgressListWithErrandId:(NSNumber *)errandId successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//完成差事
+(void)finishWithErrandId:(NSNumber *)errandId robId:(NSNumber *)robId errandTitle:(NSString *)errandTitle usrId:(NSNumber *)usrId faciName:(NSString *)faciName price:(NSNumber *)price successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//搜索专利
+(NSURLSessionDataTask *)searchPatentWithContent:(NSString *)content pageNo:(int)pageNo anAdd:(NSString *)anAdd country:(NSString *)country pkind:(NSString *)pkind  successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *totalNum))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//确认完成
+(void)sureErrandWithErrandId:(NSNumber *)errandId faciId:(NSNumber *)faciId errandTitle:(NSString *)errandTitle errandStatus:(NSString *)errandStatus successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//代理人列表
+(void)getAgentListWithPage:(int)page cityCode:(NSString *)cityCode domainCode:(NSString *)domainCode serviceType:(NSString *)serviceType star:(NSInteger)star priceUpDown:(NSString *)priceUpDown successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//系统消息
+(void)getSystemMessageWithPage:(int)page successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//待评价列表
+(void)getBeEvaluatedListPage:(int)page successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//添加评论
+(void)addCommentWithErrandId:(NSNumber *)errandId faciId:(NSNumber *)faciId evalLevel:(int )evalLevel evalContent:(NSString *)evalContent successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//评价我 的
+(void)getCommentListWithPage:(int)page faciId:(NSNumber *)faciId successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//评价我 的
+(void)getCommentListForTwoFaciId:(NSNumber *)faciId successHandler:(void(^)(NSNumber *total,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//修改已读
+(void)changeMessageReadStatusWithMsgId:(NSNumber *)msgId successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//代理人详情
+(void)getAgentInfoSuccessHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//上传图片
+(void)uploadImageWithImageData:(NSData *)data successHandler:(void(^)(NSString *imageUrl))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//修改领域
+(void)changeDomainWithServiceType:(NSString *)serviceType price:(NSNumber *)price delFlag:(NSString *)delFlag rangeId:(NSNumber *)rangeId remark:(NSString *)remark auditStatus:(NSString *)auditStatus successHandler:(void(^)(NSNumber *ID))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//修改类型
//+(void)addOrDeleteTypeWithServiceType:(NSString *)serviceType delFlag:(NSString *)delFlag rangeId:(NSNumber *)rangeId auditStatus:(NSString *)auditStatus successHandler:(void(^)(NSNumber *ID))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//修改详细类型
//+(void)changeSubTypeWithID:(NSNumber *)modelId detailType:(NSString *)detailType rangeId:(NSNumber *)rangeId price:(int)price delFlag:(NSString *)delFlag auditStatus:(NSString *)auditStatus successHandler:(void(^)(NSNumber *ID))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//修改其他信息
+(void)changeAgentInfoWithModel:(AgentInfoModel *)model successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//我以往 的 评价
+(void)getMyCommentListWithPage:(int)page successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
///修改个人头像
+(void)changeUserInfoWithPortraitUrl:(NSString *)portraitUrl successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
///修改个人昵称
+(void)changeUserInfoWithUsrAlias:(NSString *)usrAlias successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//修改接单状态
+(void)changeAgentisReceOrder:(BOOL)isReceOrder facilitatorId:(NSNumber *)facilitatorId successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//修改代理人地址
+(void)changeAgentAddress:(NSString *)dwellAddr facilitatorId:(NSNumber *)facilitatorId successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//修改普通用户地址
+(void)changeUserAddress:(NSString *)dwellAddr detailsId:(NSNumber *)detailsId successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//代付款列表
+(void)getNoPayListWithPage:(int)page successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//指定代理人下单
+(void)assignAgentWithFaciId:(NSString *)FaciId faciName:(NSString *)faciName usrName:(NSString *)usrName dwellAddr:(NSString *)dwellAddr classifyDomain:(NSString *)classifyDomain errandType:(NSString *)errandType busiType:(NSString *)busiType price:(NSString *)price title:(NSString *)title remark:(NSString *)remark phone:(NSString *)phone successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//代理人详情
+(void)getAgentDetailsWithUsrId:(NSNumber *)usrId successHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

//轮播图
+(void)getRotationImageSuccessHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//用户反馈
+(void)feedBackWithFeedbackInfo:(NSString *)feedbackInfo successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//流水记录
+(void)getFundsListWithPage:(int)pageNum successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//提现
+(void)outlayWithBankCardNo:(NSString *)bankCardNo bankOpen:(NSString *)bankOpen bankLocale:(NSString *)bankLocale usrRealName:(NSString *)usrRealName price:(int)optMoney successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//模糊查询公司
-(void)searchCompanyWithCompany:(NSString *)company successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//添加公司
+(void)addCompanyWithName:(NSString *)name successHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//查询我的专利
+(void)lookforMyPatentSuccessHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//编辑我的公司
+(void)editCompantWithKeywordId:(NSNumber *)keywordId selKeyword:(NSString *)selKeyword successHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

//查询差响
+(void)checkMoneySuccessHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

//支付
+(void)wechatPayWithSuperOrderNo:(NSString *)superOrderNo price:(NSNumber *)price errandTitle:(NSString *)errandTitle isInside:(NSString *)isInside SuccessHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//支付完成
+(void)payFinishErrandWithErrandId:(NSNumber *)errandId faciId:(NSNumber *)faciId errandTitle:(NSString *)errandTitle price:(NSNumber *)price faciName:(NSString *)faciName successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
//双向回呼
+(void)callDoublePhoneWithPhone:(NSString *)phone call:(NSString *)call successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
///改手机号
+(void)changePhone:(NSString *)phone detailsId:(NSNumber *)detailsId successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;


/// 热搜
+(void)hotSearchWithType:(NSString *)type successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 加热搜
+(void)addHotSearchWithType:(NSString *)type keyword:(NSString *)keyword successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 搜商标
+(void)searchTrademarkWithContent:(NSString *)content pageNo:(int)pageNo intCls:(NSString *)intCls successHandler:(void(^)(NSString *totalNum,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 头条
+(void)getHeadlinesWithPageNum:(int)pageNum successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 监控公司列表
+(void)getMonitorCompanyListPage:(int)page successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 公司内容监控列表
+(void)getMonitorContentListWithMonitorId:(NSNumber *)monitorId page:(int )page monitorType:(NSString *)monitorType companyName:(NSString *)companyName successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 监控公司
+(void)addCompanyToMonitorWithCompanyName:(NSString *)companyName address:(NSString *)address country:(NSString *)country successHandler:(void(^)(NSNumber *monitorId))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 其他业务 新新新
+(void)getOtherWorkDataSuccessHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 移除监控
+(void)deleteMonitorWithMonitorId:(NSNumber *)monitorId successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 全局搜索
+(NSURLSessionDataTask *)searchAllWithKeyword:(NSString *)keyword anAdd:(NSString *)anAdd country:(NSString *)country successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 公司专利列表
+(void)getCompanyPatentListWithCompany:(NSString *)company page:(int)page country:(NSString *)country pkind:(NSString *)pkind successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *total))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 公司商标列表
+(void)getCompanyTrademarkListWithCompany:(NSString *)company page:(int)page successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *total))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 判断是否监控
+(void)companyIsMonitorWithCompanyName:(NSString *)companyName successHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 未支付详情
+(void)getNoPayInfoWithShopId:(NSNumber *)shopId successHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 获取支付id
+(void)getOrderNumWithShopIds:(NSString *)ids userType:(NSString *)userType successHandler:(void(^)(NSDictionary *orderInfo))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 购物车批量删除
+(void)deleteShopWithShopIds:(NSString *)ids successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 已支付
+(void)getPaidOrderWithPage:(int)page successHandler:(void (^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 待支付
+(void)getNoPayOrderWithPage:(int)page successHandler:(void (^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 查询支付结果
+(void)getPayResultWithOrderNum:(NSString *)superOrderNo successHandler:(void (^)(BOOL))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 获取抢了的差事详情

+(void)getRobErrandInfoWithErrandId:(NSNumber *)errandId successHandler:(void (^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

/// 撤销移除监控
+(void)cancelDeleteMonitorWithMonitorId:(NSNumber *)monitorId successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

///版权详情
+(void)getCopyrightDetailWithId:(NSString *)regid successHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

/// 搜索专利根据专利名
+(NSURLSessionDataTask *)searchPatentWithTITLE:(NSString *)TITLE pageNo:(int)pageNo anAdd:(NSString *)anAdd country:(NSString *)country pkind:(NSString *)pkind PBD:(NSString *)PBD IPC1:(NSString *)IPC1 ISVALID:(NSString *)ISVALID successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *total))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 登录后买买搜索历史
+(void)getMySearchHistorySuccessHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 根据申请号查进度

+(void)getPatentProgressApplyNo:(NSString *)applyNo successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 批量卖专利
+(void)sellPatentsWithListBusi:(NSString *)listBusi successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 公司可查进度专利列表
+(void)getCompanyProgressEnableListWithUUID:(NSString *)compUuid page:(int )page successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *total))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 软件著作权
+(void)searchSoftwareCopyrightWithParameter:(NSDictionary *)parameterDict successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *total))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

/// 作品著作权
+(void)searchWorksCopyrightWithParameter:(NSDictionary *)parameterDict successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *total))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;


/// 专利评分
+(void)getPatentScoreWithPN:(NSString *)PN successHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

/// 资金申报列表
+(void)getInformationListWithPageNum:(int )pageNum pubOrg:(NSString *)pubOrg addr:(NSString *)addr pubDate:(NSString *)pubDate sourceType:(NSString *)sourceType successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *total))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

/// 根据地点获取部门
+(void)getRegionAndOrganizationWithAddrCode:(NSString *)addrCode successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 根据部门查已有地点
+(void)getOrganizationAndRegionWithDepartCode:(NSString *)departCode successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 提交业务信息审核
+(void)submitFaciInfoToReViewWithParameter:(NSString *)parameter successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 其他业务 （待丢弃）
+(void)getOtherWorkDataDiscardSuccessHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 修改代理人头像
+(void)changeAgentInfoWithHeaderImage:(NSString *)imageUrl SuccessHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 修改昵称
+(void)changeAgentInfoWithNickname:(NSString *)nickName SuccessHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 添加专利监控
+(void)addPatentToMonitorListWithPatentID:(NSString *)patentId physicDb:(NSString *)physicDb SuccessHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 获取版本
+(void)getVersionSuccessHandler:(void(^)(VersionModel *model))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 批量监控
+(void)batchMonitoringWithParameter:(NSString *)str SuccessHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 政策信息搜索筛选
+(void)searchPolicyInformationWithNotEqual:(BOOL )notEqual addr:(NSString *)addr source:(NSString *)source title:(NSString *)title info:(NSString *)info orderBy:(NSString *)orderBy sourceType:(NSString *)sourceType page:(int)page successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *total))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

///获取new标识数据组
+(void)getNewStatuDataSuccessHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
///求购信息
+(void)getBuyingInformationWithPage:(int )page businessName:(NSString *)businessName busiQuality:(NSString *)busiQuality isMain:(BOOL)isMain successHandler:(void(^)(BOOL isLast,NSArray *array,NSNumber *total))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 支付宝支付
+ (void)alipayWithOrderId:(NSNumber *)orderId isInside:(NSString *)isInside SuccessHandler:(void(^)(NSString  *orderStr))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 支付宝支付结果查询
+ (void)getAlipayResultWithOrderNo:(NSString *)OrderNo SuccessHandler:(void(^)(NSDictionary *result))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 添加关注
+ (void)addAttentionWithAddrCode:(NSString *)addrCode addrName:(NSString *)addrName departName:(NSString *)departName departCode:(NSString *)departCode  SuccessHandler:(void(^)(NSNumber *modelId))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 移除关注
+ (void)deleteAttentionWithId:(NSNumber *)attentionId SuccessHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 关注分层
+ (void)getLayeredAttentionListSuccessHandler:(void(^)(NSDictionary *dict))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;


///关注列表
+ (void)getAttentionListWithPage:(int)page SuccessHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
///查看标记小红点的数据
+ (void)removeLittleRedDotWith:(NSString *)addr source:(NSString *)source successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
///删除订单
+ (void)deleteOrderWithOrderId:(NSNumber *)orderId orderNum:(NSString *)orderNum
successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
///注册游客用户
+ (void)registeredTouristsWithUUid:(NSString *)uuid successHandler:(void(^)(NSNumber *ykid))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;


///提交位置信息
+ (void)submitPositionWithusrId:(NSNumber *)usrId addrState:(NSString *)addrState addrProvince:(NSString *)addrProvince addrCity:(NSString *)addrCity addrCounty:(NSString *)addrCounty addrDetail:(NSString *)addrDetail addrLoi:(double)addrLoi addrLai:(double)addrLai usrType:(NSString *)usrType successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
///位置信息游客用户关联
+ (void)associatedYKandUserWithUsrId:(NSNumber *)usrId ykId:(NSNumber *)ykId successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
///绑定
+ (void)bindWithwxAccount:(NSString *)wxAccount qqAccount:(NSString *)qqAccount usrAccount:(NSString *)usrAccount nodeCode:(NSString *)nodeCode successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;
/// 解绑
+ (void)unbundledWithwxAccount:(NSString *)wxAccount qqAccount:(NSString *)qqAccount usrAccount:(NSString *)usrAccount nodeCode:(NSString *)nodeCode successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

///我都业务列表
+ (void)getMyBusinessListWithPage:(NSInteger )page successHandler:(void(^)(BOOL isLast,NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

///子业务进度
+ (void)getOrderProcessWith:(NSNumber *)order_info_id successHandler:(void(^)(NSArray *array))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;

///年费代缴
/*
 申请号(patentApplyNo)、联系电话(contactTelNo)、缴费金额(price总金额)、
 通信地址(contactAddr)、申请人名称(applyName)、联系人姓名(contactName)、
 缴费方式(feeType)、特殊要求(specialReq)
 */
+ (void)payAnnualFeeWithPatentApplyNoe:(NSString *)patentApplyNo price:(NSString *)price contactTelNo:(NSString *)contactTelNo contactAddr:(NSString *)contactAddr applyName:(NSString *)applyName contactName:(NSString *)contactName feeType:(NSString *)feeType specialReq:(NSString *)specialReq successHandler:(void(^)(BOOL success))successBlcok errorHandler:(void (^)(NSError *error))errorBlock;


@end
