//
//  ChildBusinessCollectionViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/4/27.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "ChildBusinessCollectionViewCell.h"

@interface ChildBusinessCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@end

@implementation ChildBusinessCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ChildOrderModel *)model
{
    _model = model;
//    if (model.type) {
        self.typeImageView.image = [UIImage imageNamed:model.type];
//    }
//    else
//    {
//        self.typeImageView.image = [UIImage imageNamed:@"其他"];
//    }
    
}

@end
