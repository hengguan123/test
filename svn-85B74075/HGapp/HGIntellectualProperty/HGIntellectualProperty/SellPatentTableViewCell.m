//
//  SellPatentTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SellPatentTableViewCell.h"

@interface SellPatentTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *patentTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *patentID;
@property (weak, nonatomic) IBOutlet UILabel *patentStatus;
@property (weak, nonatomic) IBOutlet UILabel *patentOwner;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;


@end

@implementation SellPatentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)deletePatent:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deletePatentModelWithCell:)]) {
        [self.delegate deletePatentModelWithCell:self];
    }
}
-(void)setSellPatentModel:(PatentModel *)sellPatentModel
{
    _sellPatentModel = sellPatentModel;
    if (sellPatentModel) {
        self.patentTitleLab.text = sellPatentModel.TITLE;
        self.patentID.text = sellPatentModel.PN;
        self.patentStatus.text = sellPatentModel.VALID;
        self.patentOwner.text= sellPatentModel.AN;
        if (sellPatentModel.price) {
            self.priceTextField.text = sellPatentModel.price;
        }
        else{
            self.priceTextField.text = nil;
        }
    }
}

- (IBAction)valueChange:(UITextField *)sender {
    self.sellPatentModel.price = sender.text;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.sellPatentModel.price = textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
