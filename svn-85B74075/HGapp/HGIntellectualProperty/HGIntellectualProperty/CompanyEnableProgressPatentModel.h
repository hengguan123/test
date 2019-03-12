//
//  CompanyEnableProgressPatentModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/11.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CompanyEnableProgressPatentModel : MTLModel<MTLJSONSerializing>


@property(nonatomic,copy)NSString *patentName;
@property(nonatomic,copy)NSString *caseType;
@property(nonatomic,copy)NSString *applyDate;
@property(nonatomic,copy)NSString *applyPerson;
@property(nonatomic,copy)NSString *applyNo;
@property(nonatomic,copy)NSString *caseStatus;
@property(nonatomic,copy)NSString *insetUrl;
@property(nonatomic,copy)NSString *compUuid;
@property(nonatomic,copy)NSString *caseUuid;


@end
