//
//  PatentProgressModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/31.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PatentProgressModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *agentPerson;
@property(nonatomic,copy)NSString *applyDate;
@property(nonatomic,copy)NSString *applyNo;
@property(nonatomic,copy)NSString *applyPerson;
@property(nonatomic,copy)NSString *caseClientName;
@property(nonatomic,copy)NSString *caseNo;
@property(nonatomic,copy)NSString *caseProc;
@property(nonatomic,copy)NSString *caseSourcePerson;
@property(nonatomic,copy)NSString *caseStatus;
@property(nonatomic,copy)NSString *clientCode;
@property(nonatomic,copy)NSString *clientNo;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *disposePerson;
@property(nonatomic,copy)NSString *eleParts;
@property(nonatomic,copy)NSString *examinant;
@property(nonatomic,copy)NSString *fetchDate;
@property(nonatomic,copy)NSString *fetchPerson;
@property(nonatomic,copy)NSString *fileName;
@property(nonatomic,copy)NSString *forwardDate;
@property(nonatomic,copy)NSString *forwardStatus;
@property(nonatomic,copy)NSString *inventPerson;
@property(nonatomic,copy)NSString *isOfficial;
@property(nonatomic,copy)NSString *officeDispatchNo;
@property(nonatomic,copy)NSString *patentName;
@property(nonatomic,copy)NSString *pd;
@property(nonatomic,copy)NSString *pn;
@property(nonatomic,copy)NSString *pubDate;
@property(nonatomic,copy)NSString *receOrgAgency;
@property(nonatomic,copy)NSString *receOrgOff;
@property(nonatomic,copy)NSString *receiveDate;
@property(nonatomic,copy)NSString *receivedClient;
@property(nonatomic,copy)NSString *receivedType;
@property(nonatomic,copy)NSString *receivedWay;
@property(nonatomic,copy)NSString *registrant;
@property(nonatomic,copy)NSString *updateDate;
@property(nonatomic,strong)NSNumber *modelId;

@end
