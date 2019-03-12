//
//  OrganizationTypeTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/30.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrganizationTypeTableViewCell;
@protocol OrganizationTypeTableViewCellDelegate <NSObject>

-(void)organizationTypeTableViewCell:(OrganizationTypeTableViewCell *)cell beFollowedWithBtnSelected:(BOOL)selected;

@end

@interface OrganizationTypeTableViewCell : UITableViewCell

@property(nonatomic,strong)OrganizationModel *orgmodel;
/// type  YES选中  NO未选中
@property(nonatomic,assign)BOOL isSel;
@property(nonatomic,weak)id<OrganizationTypeTableViewCellDelegate>delegate;
@property(nonatomic,assign)BOOL isNew;

@property(nonatomic,assign)BOOL isAttention;
@property(nonatomic,strong)NSNumber *attentionId;


@end
