//
//  OrgInfoTypeTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/17.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrgInfoTypeTableViewCell : UITableViewCell

@property(nonatomic,strong)OrganizationModel *orgmodel;
@property(nonatomic,strong)OrgAreaModel *areamodel;
/// type  YES选中  NO未选中
@property(nonatomic,assign)BOOL isSel;

@property(nonatomic,assign)BOOL isNew;


@end
