//
//  FilterTypeView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterTypeModel;
@protocol FilterTypeViewDelegate <NSObject>

-(void)reloadFrame;


@end

@interface FilterTypeView : UIView

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,weak)id<FilterTypeViewDelegate>delegate;
@property (nonatomic,strong) FilterTypeModel *selModel1;
@property (nonatomic,strong) FilterTypeModel *selModel2;
@property (nonatomic,strong) FilterTypeModel *selModel3;
@property (nonatomic,strong) NSArray *areaArray;

-(void)reset;


@end
