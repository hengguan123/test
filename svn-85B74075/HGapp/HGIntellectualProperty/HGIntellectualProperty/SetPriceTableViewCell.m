//
//  SetPriceTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/29.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SetPriceTableViewCell.h"

@interface SetPriceTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIImageView *reviewImageView;

@end

@implementation SetPriceTableViewCell
{
    int _price;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.priceTextField.background = [self imageWithSize:self.priceTextField.bounds.size borderColor:[UIColor blackColor] borderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBusiModel:(BusinessModel *)busiModel
{
    _busiModel = busiModel;
    _price = [busiModel.price intValue];
    self.selBtn.selected = ![busiModel.delFlag boolValue];
    if ([busiModel.auditStatus boolValue]&&[busiModel.delFlag isEqualToString:@"0"]) {
        self.priceLab.hidden = NO;
        self.priceTextField.hidden = NO;
    }
    else
    {
        self.priceLab.hidden = YES;
        self.priceTextField.hidden = YES;
    }
    self.reviewImageView.hidden = [busiModel.delFlag boolValue];
    if ([busiModel.auditStatus isEqualToString:@"0"]) {
        self.reviewImageView.image = [UIImage imageNamed:@"审核中"];
    }
    else if ([busiModel.auditStatus isEqualToString:@"1"])
    {
        self.reviewImageView.image = [UIImage imageNamed:@"审核通过"];
    }
    else if ([busiModel.auditStatus isEqualToString:@"2"])
    {
        self.reviewImageView.image = [UIImage imageNamed:@"审核未通过"];
    }
    self.titleLab.text = busiModel.dictionaryName;
    self.priceTextField.text = [NSString stringWithFormat:@"%@",busiModel.price];
}

- (UIImage *)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (_price != [textField.text intValue]) {
        _price = [textField.text intValue];
        self.busiModel.price = @(_price);
        
    }
    return YES;
}

- (IBAction)valueChange:(UITextField *)sender {
    
    sender.text = [NSString stringWithFormat:@"%d",[sender.text intValue]];
}
@end
