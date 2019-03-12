//
//  PatentScoreModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PatentScoreModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSNumber *num;
@property(nonatomic,strong)NSNumber *score;
@property(nonatomic,strong)NSArray *texts;

@end

