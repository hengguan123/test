//
//  PatentModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/14.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PatentModel : MTLModel <MTLJSONSerializing>

//@property(nonatomic,copy)NSString *ABST;
@property(nonatomic,copy)NSString *AN;
//@property(nonatomic,copy)NSString *AN_ADD;
@property(nonatomic,copy)NSString *APD;
@property(nonatomic,copy)NSString *APN;
//@property(nonatomic,copy)NSString *DATASET;
@property(nonatomic,copy)NSString *GIF_URL;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *IN;
//@property(nonatomic,copy)NSString *IPC;
@property(nonatomic,copy)NSString *PBD;
@property(nonatomic,copy)NSString *PHYSIC_DB;
@property(nonatomic,copy)NSString *PKIND_S;
@property(nonatomic,copy)NSString *PN;
@property(nonatomic,copy)NSString *TITLE;
@property(nonatomic,copy)NSString *VALID;

@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *value;

@property(nonatomic,assign)BOOL selStatus;



@end
