//
//  AgentTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AgentTableViewCell;
@protocol AgentTableViewCellDelegate <NSObject>

-(void)phoneWithAgentTableViewCell:(AgentTableViewCell *)cell;

@end


@interface AgentTableViewCell : UITableViewCell

@property (nonatomic,strong)AgentModel *model;
@property(nonatomic,weak)id<AgentTableViewCellDelegate>delegate;

@end
