//
//  SellTableView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SellTableViewDelegate <NSObject>

-(void)goToAddPatentWithCurrentNum:(NSInteger)currentNum;
-(void)goToSellViewControllerWithModel:(BuyInformationModel *)model;

@end

@interface SellTableView : UITableView

-(instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,weak)id<SellTableViewDelegate>sellDelegate;
@property(nonatomic,copy)NSString *searchStr;
-(void)addPatentModelArray:(NSArray *)modelarray;

@end
