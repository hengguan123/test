//
//  PatentCollectionViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/31.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PatentCollectionViewCell;
@protocol PatentCollectionViewCellDelegate <NSObject>

-(void)buyPatentWithPatentCollectionViewCell:(PatentCollectionViewCell *)cell;

@end

@interface PatentCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)PatentModel *model;
@property(nonatomic,weak)id<PatentCollectionViewCellDelegate>delegate;

@end
