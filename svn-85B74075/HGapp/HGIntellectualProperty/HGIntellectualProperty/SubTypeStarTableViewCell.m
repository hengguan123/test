//
//  SubTypeStarTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SubTypeStarTableViewCell.h"

@interface SubTypeStarTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (weak, nonatomic) IBOutlet UIImageView *revieIamgeView;

@end
@implementation SubTypeStarTableViewCell
{
    int _price;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceTextField.background = [self imageWithSize:self.priceTextField.bounds.size borderColor:[UIColor blackColor] borderWidth:1];
}

-(void)setModel:(BusinessModel *)model
{
    _model = model;
     _price = [model.price intValue];
    self.selBtn.selected = ![model.delFlag boolValue];
    if ([model.auditStatus boolValue]&&[model.delFlag isEqualToString:@"0"]) {
        self.priceLab.hidden = NO;
        self.priceTextField.hidden = NO;
    }
    else
    {
        self.priceLab.hidden = YES;
        self.priceTextField.hidden = YES;
    }
    if (self.index==0) {
        self.titleLab.text = @"新申请";
    }
    else
    {
        self.titleLab.text = model.dictionaryName;
    }
    self.priceTextField.text = [NSString stringWithFormat:@"%@",model.price];
    
    self.revieIamgeView.hidden = [model.delFlag boolValue];
    
    if ([model.auditStatus isEqualToString:@"0"]) {
        self.revieIamgeView.image = [UIImage imageNamed:@"审核中"];
    }
    else if ([model.auditStatus isEqualToString:@"1"])
    {
        self.revieIamgeView.image = [UIImage imageNamed:@"审核通过"];
    }
    else if ([model.auditStatus isEqualToString:@"2"])
    {
        self.revieIamgeView.image = [UIImage imageNamed:@"审核未通过"];
    }
    
    for (UIView *view in self.starBgView.subviews) {
        [view removeFromSuperview];
    }
    NSInteger x=0;
    for (int i=0; i<model.listStar.count; i++) {
        BusinessModel *starmodel = [model.listStar objectAtIndex:i];
        if ([starmodel.isSel boolValue]) {
            x = i+1;
            break;
        }
    }
    
    for (int i=0; i<model.listStar.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16*i, 0, 16, 16)];
        if (i<x) {
            imageView.image = [UIImage imageNamed:@"star_sel"];
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"star_nor"];
        }
        [self.starBgView addSubview:imageView];
    }
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
        self.model.price = @(_price);
        
    }
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
