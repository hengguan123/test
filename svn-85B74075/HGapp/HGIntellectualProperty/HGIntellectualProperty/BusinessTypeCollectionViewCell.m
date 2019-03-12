//
//  BusinessTypeCollectionViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "BusinessTypeCollectionViewCell.h"

@interface BusinessTypeCollectionViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UIView *starBgVIew;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIImageView *ReviewImageView;

@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;

@property (weak, nonatomic) IBOutlet UIImageView *star3;

@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;


@end

@implementation BusinessTypeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceTextField.background = [self imageWithSize:self.priceTextField.bounds.size borderColor:[UIColor blackColor] borderWidth:1];
}

-(void)setModel:(BusinessModel *)model
{
    _model = model;
    [self.titleBtn setTitle:model.dictionaryName forState:UIControlStateNormal];
}

-(void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    self.titleBtn.selected = canEdit;
    
}

-(void)setstarWithNum:(NSInteger )num
{
    switch (num) {
        case 0:
        {
            self.star1.image = [UIImage imageNamed:@"star_nor"];
            self.star2.image = [UIImage imageNamed:@"star_nor"];
            self.star3.image = [UIImage imageNamed:@"star_nor"];
            self.star4.image = [UIImage imageNamed:@"star_nor"];
            self.star5.image = [UIImage imageNamed:@"star_nor"];
        }
            break;
        case 1:
        {
            self.star1.image = [UIImage imageNamed:@"star_sel"];
            self.star2.image = [UIImage imageNamed:@"star_nor"];
            self.star3.image = [UIImage imageNamed:@"star_nor"];
            self.star4.image = [UIImage imageNamed:@"star_nor"];
            self.star5.image = [UIImage imageNamed:@"star_nor"];
        }
            break;
        case 2:
        {
            self.star1.image = [UIImage imageNamed:@"star_sel"];
            self.star2.image = [UIImage imageNamed:@"star_sel"];
            self.star3.image = [UIImage imageNamed:@"star_nor"];
            self.star4.image = [UIImage imageNamed:@"star_nor"];
            self.star5.image = [UIImage imageNamed:@"star_nor"];
        }
            break;
        case 3:
        {
            self.star1.image = [UIImage imageNamed:@"star_sel"];
            self.star2.image = [UIImage imageNamed:@"star_sel"];
            self.star3.image = [UIImage imageNamed:@"star_sel"];
            self.star4.image = [UIImage imageNamed:@"star_nor"];
            self.star5.image = [UIImage imageNamed:@"star_nor"];
        }
            break;
        case 4:
        {
            self.star1.image = [UIImage imageNamed:@"star_sel"];
            self.star2.image = [UIImage imageNamed:@"star_sel"];
            self.star3.image = [UIImage imageNamed:@"star_sel"];
            self.star4.image = [UIImage imageNamed:@"star_sel"];
            self.star5.image = [UIImage imageNamed:@"star_nor"];
        }
            break;
        case 5:
        {
            self.star1.image = [UIImage imageNamed:@"star_sel"];
            self.star2.image = [UIImage imageNamed:@"star_sel"];
            self.star3.image = [UIImage imageNamed:@"star_sel"];
            self.star4.image = [UIImage imageNamed:@"star_sel"];
            self.star5.image = [UIImage imageNamed:@"star_sel"];
        }
            break;
        default:
            break;
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
- (IBAction)btnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selBtnClickWithBusinessTypeCollectionViewCell:)]) {
        [self.delegate selBtnClickWithBusinessTypeCollectionViewCell:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.model.price = @([textField.text integerValue]);
}


@end
