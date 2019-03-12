//
//  MyCompanyTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MyCompanyTableViewCell.h"

@interface MyCompanyTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *companyName;




@end


@implementation MyCompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MyCompanyModel *)model
{
    _model = model;
    self.companyName.text = model.selKeyword;
    
}


- (IBAction)edit:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editWithMyCompanyTableViewCell:)]) {
        [self.delegate editWithMyCompanyTableViewCell:self];
    }
}
- (IBAction)delete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWithMyCompanyTableViewCell:)]) {
        [self.delegate deleteWithMyCompanyTableViewCell:self];
    }
}



@end
