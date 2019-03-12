//
//  BusinessTypeCollectionViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BusinessTypeCollectionViewCell;
@protocol BusinessTypeCollectionViewCellDelegate <NSObject>

-(void)selBtnClickWithBusinessTypeCollectionViewCell:(BusinessTypeCollectionViewCell *)cell;
-(void)cancelSelBtnWithBusinessTypeCollectionViewCell:(BusinessTypeCollectionViewCell *)cell;


@end

@interface BusinessTypeCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)BusinessModel *model;
@property(nonatomic,assign)BOOL canEdit;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,weak)id<BusinessTypeCollectionViewCellDelegate>delegate;


@end
