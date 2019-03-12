//
//  FilterHeaderView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "FilterHeaderView.h"

@interface FilterHeaderView ()
@property (strong, nonatomic)  UIView *domainBgView;
@property (strong, nonatomic)  UIView *typeView;
@property (strong, nonatomic)  UIView *subTypeView;

@property (nonatomic,strong)NSArray *fieldArray;//领域列表
@property (nonatomic,strong)NSArray *errandClassArray;//差事类型
@property (nonatomic,strong)NSArray *detailClassArray;//业务类型

@property (nonatomic,strong)NSMutableString *typeStr;

@end

@implementation FilterHeaderView
static FilterHeaderView *_headerView;
+(instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _headerView = [[FilterHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-100, 140)];
        _headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [_headerView loadView];
    });
    return _headerView;
}

-(void)loadView
{
    NSArray *dataArray = @[
                            @{
                                @"dictionaryCode":@"",
                                @"dictionaryName":@"专利",
                                @"listSerTypeInfo":@[
                                        @{
                                            @"dictionaryCode":@"",
                                            @"dictionaryName":@"专利"
                                            },
                                        @{
                                            @"dictionaryCode":@"",
                                            @"dictionaryName":@"商标"
                                            },
                                        @{
                                            @"dictionaryCode":@"",
                                            @"dictionaryName":@"版权"
                                            }
                                        ]
                                },
                            @{
                                @"dictionaryCode":@"",
                                @"dictionaryName":@"商标"
                                },
                            @{
                                @"dictionaryCode":@"",
                                @"dictionaryName":@"版权"
                                }
                           ];
    NSArray *modelArray = [MTLJSONAdapter modelsOfClass:[ErrandClassModel class] fromJSONArray:dataArray error:nil];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FilterWidth, 40)];
    view1.backgroundColor = UIColorFromRGB(0xffffff);
    [_headerView addSubview:view1];
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 150, 22)];
    lab1.textColor = UIColorFromRGB(0x666666);
    lab1.font = [UIFont systemFontOfSize:12];
    lab1.text = @"业务类型：";
    [view1 addSubview:lab1];
    
    for (int i=0; i<modelArray.count; i++) {
        ErrandClassModel *model = [modelArray objectAtIndex:i];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+70*i, 47, 60, 24)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 5;
        btn.tag = 101;
        [btn setTitle:model.dictionaryName forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:btn];
    }
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, FilterWidth, 40)];
    view2.backgroundColor = UIColorFromRGB(0xffffff);
    [_headerView addSubview:view2];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 150, 22)];
    lab2.textColor = UIColorFromRGB(0x666666);
    lab2.font = [UIFont systemFontOfSize:12];
    lab2.text = @"业务类型：";
    [view2 addSubview:lab2];
    
}

#pragma mark --- btn
- (void)btnClcik:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.tag == 100) {
        [FilterHeaderView share].frame = CGRectMake(0, 0, ScreenWidth-100, 180);
    }
    else if (sender.tag == 101)
    {
        [FilterHeaderView share].frame = CGRectMake(0, 0, ScreenWidth-100, 140);
    }
    else if (sender.tag == 102)
    {
        [FilterHeaderView share].frame = CGRectMake(0, 0, ScreenWidth-100, 140);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadHeaderView)] ) {
        [self.delegate reloadHeaderView];
    }
}

- (void)typeBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSMutableArray *array = [NSMutableArray new];
    for (UIView *view in _typeView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.isSelected) {
                ErrandClassModel *model = [self.errandClassArray objectAtIndex:btn.tag-200];
                [array addObject:model.dictionaryCode];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedTypeWithArray:)]) {
        [self.delegate selectedTypeWithArray:array];
    }

}

- (void)subTypeBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSMutableArray *array = [NSMutableArray new];
    for (UIView *view in _subTypeView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.isSelected) {
                ErrandClassModel *model = [self.detailClassArray objectAtIndex:btn.tag-300];
                [array addObject:model.dictionaryCode];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedSubtypeWithArray:)]) {
        [self.delegate selectedSubtypeWithArray:array];
    }
}

-(void)reSet
{
    for (UIView *view in _domainBgView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            
            btn.selected = NO;
        }
    }
    for (UIView *view in _typeView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            
            btn.selected = NO;
        }
    }
    for (UIView *view in _subTypeView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            
            btn.selected = NO;
        }
    }
}

@end
