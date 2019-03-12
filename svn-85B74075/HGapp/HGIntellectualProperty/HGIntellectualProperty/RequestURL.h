//
//  RequestURL.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#ifndef RequestURL_h
#define RequestURL_h

//#define HTTPURL @"http://192.168.1.126:8502"
//#define HTTPURL @"http://iprhg.cn"
//#define HTTPURL @"http://192.168.1.206:9595"
//#define HTTPURL @"http://app.techhg.com"
#define HTTPURL @"http://47.93.218.239:8087"

#define GetVCode [NSString stringWithFormat:@"%@%@",HTTPURL,@"/note/sendNoteCode"]
#define Login [NSString stringWithFormat:@"%@%@",HTTPURL,@"/dl/login"]
#define City [NSString stringWithFormat:@"%@%@",HTTPURL,@"/base/listAddr"]
#define BaseDataInfo [NSString stringWithFormat:@"%@%@",HTTPURL,@"/base/listDict"]
#define Publish [NSString stringWithFormat:@"%@%@",HTTPURL,@"/errand/addOrModifyErrand"]
#define ErrandList [NSString stringWithFormat:@"%@%@",HTTPURL,@"/errand/pageErrandByUsr"]
#define ErrandListNoPage [NSString stringWithFormat:@"%@%@",HTTPURL,@"/errand/queryListErrand"]
#define AddrCode [NSString stringWithFormat:@"%@%@",HTTPURL,@"/base/getCodeByName"]
#define ErrandDetail [NSString stringWithFormat:@"%@%@",HTTPURL,@"/errand/queryErrand"]

#define UserInfoURL [NSString stringWithFormat:@"%@%@",HTTPURL,@"/user/queryPersonByUsrId"]
#define GrabList [NSString stringWithFormat:@"%@%@",HTTPURL,@"/errand/pageRobOrder"]
#define IdentityCheck [NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/verifyPhone"]
#define GrabErrand [NSString stringWithFormat:@"%@%@",HTTPURL,@"/errand/addOrModifyRobORder"]
#define ErrandProgressList [NSString stringWithFormat:@"%@%@",HTTPURL,@"/errand/queryListErrandRecord"]
#define AddErrandRecording [NSString stringWithFormat:@"%@%@",HTTPURL,@"/errand/addErrandRecord"]
#define SearchPatent [NSString stringWithFormat:@"%@%@",HTTPURL,@"/patent/list"]
#define AgentList [NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/faciListAll"]
#define SystemMessage [NSString stringWithFormat:@"%@%@",HTTPURL,@"/msg/pageMsg"]

#define AddComment [NSString stringWithFormat:@"%@%@",HTTPURL,@"/errand/addErrandEval"]
#define CommentMeList [NSString stringWithFormat:@"%@%@",HTTPURL,@"/errand/pageErrandEval"]
#define MessageDetail [NSString stringWithFormat:@"%@%@",HTTPURL,@"/msg/queryMsg"]
#define MessageStatusChange [NSString stringWithFormat:@"%@%@",HTTPURL,@"/msg/modifyMsg"]
#define AgentInfo [NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/queryFaciInfo"]
#define UploadImage [NSString stringWithFormat:@"%@%@",HTTPURL,@"/upload/savePhoneFile"]
#define ChangeDomain [NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/modifyCla"]
#define ChangeSubType [NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/modifyType"]
#define ChangeType [NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/modifyRange"]
#define ChangeAgentInfo [NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/addOrModify"]
#define ChangeUserInfo [NSString stringWithFormat:@"%@%@",HTTPURL,@"/user/modify"]
#define ChangeUserAddress [NSString stringWithFormat:@"%@%@",HTTPURL,@"/user/modifyUsrDetails"]
#define AgentDetial [NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/queryFaci"]
#define RotationImage [NSString stringWithFormat:@"%@%@",HTTPURL,@"/base/carousel"]
#define FeedBack [NSString stringWithFormat:@"%@%@",HTTPURL,@"/feedback/add"] 
#define FundsFlow [NSString stringWithFormat:@"%@%@",HTTPURL,@"/sold/queryPageSold"]
//#define Outlay [NSString stringWithFormat:@"%@%@",HTTPURL,@"/sold/cash"]
#define Outlay [NSString stringWithFormat:@"%@%@",HTTPURL,@"/sold/addOrModify"]
#define SearchCompany [NSString stringWithFormat:@"%@%@",HTTPURL,@"/patent/queryListCompany"]
#define AddCompany [NSString stringWithFormat:@"%@%@",HTTPURL,@"/patent/addKeyword"]
#define MyPatent [NSString stringWithFormat:@"%@%@",HTTPURL,@"/patent/queryListMyPatent"]
#define EditCompany [NSString stringWithFormat:@"%@%@",HTTPURL,@"/patent/updateKeyword"]

#define CheckMoney [NSString stringWithFormat:@"%@%@",HTTPURL,@"/user/querySoldPay"]

#define Pay [NSString stringWithFormat:@"%@%@",HTTPURL,@"/pay/WXPay"]
#define DoubleCall [NSString stringWithFormat:@"%@%@",HTTPURL,@"/note/call"]
#define HotSearch [HTTPURL stringByAppendingString:@"/hot/page"]
#define AddHotSearch [HTTPURL stringByAppendingString:@"/hot/add"]
#define SearchTrademark [HTTPURL stringByAppendingString:@"/trademark/list"]
#define Headlines [HTTPURL stringByAppendingString:@"/news/page"]

#define MonitorCompanyList [HTTPURL stringByAppendingString:@"/monitor/pageCom"]
#define MonitorContentList [HTTPURL stringByAppendingString:@"/monitor/pageData"]
#define AddCompanyToMonitor [HTTPURL stringByAppendingString:@"/monitor/add"]
#define OtherWork [HTTPURL stringByAppendingString:@"/errand/otherBusiType"]
#define DeleteMonitor [HTTPURL stringByAppendingString:@"/monitor/modifyData"]
#define SearchAll [HTTPURL stringByAppendingString:@"/hot/search"]

#define CompanyPatentList [HTTPURL stringByAppendingString:@"/patent/queryList"]
#define CompanyTrademarkList [HTTPURL stringByAppendingString:@"/trademark/queryListTradeByCom"]
#define NoPay [HTTPURL stringByAppendingString:@"/shop/shoplist"]

#define CompanyIsMonitor [HTTPURL stringByAppendingString:@"/monitor/verifyCom"]
#define NoPayInfo [HTTPURL stringByAppendingString:@"/shop/shopinfo"]

#define GetOrderNum [HTTPURL stringByAppendingString:@"/order/addorder"]
#define DelShop [HTTPURL stringByAppendingString:@"/shop/batchdelshop"]

#define OrderList [HTTPURL stringByAppendingString:@"/order/paylist"]
#define GetPayResult [HTTPURL stringByAppendingString:@"/pay/queryorder"]
#define FaciErrandInfo [HTTPURL stringByAppendingString:@"/errand/queryRobOrder"]

#define CopyRightInfo [HTTPURL stringByAppendingString:@"/copy/query"]
#define HotByUsrId [HTTPURL stringByAppendingString:@"/hot/searchByUsrId"]
#define PatentProgress [HTTPURL stringByAppendingString:@"/hot/flow"]
#define SellPatents [HTTPURL stringByAppendingString:@"/business/batchAdd"]

#define CompanyPatentProgressList [HTTPURL stringByAppendingString:@"/hot/flow"]

#define SoftwareCopyright [HTTPURL stringByAppendingString:@"/copy/queryListSoftware"]
#define WorksCopyright [HTTPURL stringByAppendingString:@"/copy/queryListWorks"]
#define PatentScore [HTTPURL stringByAppendingString:@"/patent/patentEval"]

#define GovernmentInformationList [HTTPURL stringByAppendingString:@"/granoti/list"]
#define GetIPCList [HTTPURL stringByAppendingString:@"/base/list"]
#define DeptByAddr [HTTPURL stringByAppendingString:@"/base/listDept2ByAddr"]
#define AddrByDept [HTTPURL stringByAppendingString:@"/base/listAddrByDept2"]
#define ReviewFaciInfo [HTTPURL stringByAppendingString:@"/faci/batchNewAddRangData"]

#define OtherDataDiscard [HTTPURL stringByAppendingString:@"/errand/other"]
#define AddPatentToMonitor [HTTPURL stringByAppendingString:@"/monitor/addPatentData"]
/// 获取版本
#define GetVersion @"http://admin.techhg.com/version"

/// 批量监控
#define BatchMonitoring [HTTPURL stringByAppendingString:@"/monitor/batchAddPatentData"]
/// 政策信息新街口  --不附带搜索排序
#define PolicyInformationForSearch [HTTPURL stringByAppendingString:@"/granoti/list"]
/// 政策信息新街口  --附带搜索排序
#define PolicyInformationForSearchNew [HTTPURL stringByAppendingString:@"/granoti/listNew"]
/// 获取’新‘标识数据
#define NewStatusData [HTTPURL stringByAppendingString:@"/granoti/listNewData"]
/// 求购信息
#define BuyingInformation [HTTPURL stringByAppendingString:@"/business/list"]
#define Alipay [HTTPURL stringByAppendingString:@"/alipay/pay"]

#define AlipayResult [HTTPURL stringByAppendingString:@"/alipay/queryorder"]
/// 添加关注
#define AddAttention [HTTPURL stringByAppendingString:@"/granoti/addNoticed"]
/// 删除关注
#define DeleteAttention [HTTPURL stringByAppendingString:@"/granoti/delNoticed"]

/// 分层关注
#define LayeredAttentionList [HTTPURL stringByAppendingString:@"/granoti/listNoticed"]
/// 关注列表
#define AttentionListPage [HTTPURL stringByAppendingString:@"/granoti/pageGrabNoticed"]
/// 点击观看小红点后移除小红点
#define RemoveLittleRedDot [HTTPURL stringByAppendingString:@"/usrnewnoti/add"]
////删除订单
#define DeleteOrder [HTTPURL stringByAppendingString:@"/order/modifyOrder"]
///注册游客
#define RegisteredTourist [HTTPURL stringByAppendingString:@"/usraction/addTourist"]
///提交位置信息
#define SubmitPosition [HTTPURL stringByAppendingString:@"/usraction/addAction"]
///游客数据转客户
#define YKPositiongToUser [HTTPURL stringByAppendingString:@"/usraction/modifyUsrAction"]
///绑定 接口
#define BindAccount [HTTPURL stringByAppendingString:@"/dl/binding"]
///解绑定 接口
#define UnBindAccount [HTTPURL stringByAppendingString:@"/dl/cancel"]

///业务列表（订单列表）
#define CRMOrderList [HTTPURL stringByAppendingString:@"/order/crmOrderList"]

///子业务流程
#define CRMOrderProcess [HTTPURL stringByAppendingString:@"/orderFlowStatus/query"]

///
#define PayAnnualFee [HTTPURL stringByAppendingString:@"/business/payAnnualFee"]




#endif /* RequestURL_h */
