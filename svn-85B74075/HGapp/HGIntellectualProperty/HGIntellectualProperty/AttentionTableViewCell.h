//
//  AttentionTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/11/2.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AttentionTableViewCellelegate <NSObject>



@end;

@interface AttentionTableViewCell : UITableViewCell

@property (nonatomic,strong)AttentionModel *model;

@end
