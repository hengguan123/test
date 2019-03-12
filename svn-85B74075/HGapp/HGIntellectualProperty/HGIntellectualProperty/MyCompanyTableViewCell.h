//
//  MyCompanyTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCompanyModel.h"

@class MyCompanyTableViewCell;
@protocol MyCompanyTableViewCellDelegate <NSObject>

-(void)editWithMyCompanyTableViewCell:(MyCompanyTableViewCell *)cell;
-(void)deleteWithMyCompanyTableViewCell:(MyCompanyTableViewCell *)cell;

@end

@interface MyCompanyTableViewCell : UITableViewCell

@property(nonatomic,strong)MyCompanyModel *model;
@property(nonatomic,weak)id<MyCompanyTableViewCellDelegate>delegate;


@end
