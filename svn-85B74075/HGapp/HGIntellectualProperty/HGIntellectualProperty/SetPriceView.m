//
//  SetPriceView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SetPriceView.h"

@interface SetPriceView ()<UITextFieldDelegate>

@end

@implementation SetPriceView
{
    UITextField *_textField;
    UILabel *_nameLab;
    UILabel *_promptLab;
    UIButton *_selectedBtn;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedView)];
//        [self addGestureRecognizer:tap];
        self.userInteractionEnabled=YES;
        _selectedBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 20, frame.size.height)];
        [_selectedBtn setImage:[UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateSelected];
        _selectedBtn.contentMode = UIViewContentModeCenter;
        [_selectedBtn addTarget:self action:@selector(selectedView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectedBtn];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, ScreenWidth/2, frame.size.height)];
        _nameLab.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:_nameLab];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-60, 3, 50, 18)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:12];
        _textField.text = @"0";
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
//        _textField.backgroundColor = [UIColor greenColor];
        _textField.textAlignment = 1;
        [_textField addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.background = [self imageWithSize:_textField.bounds.size borderColor:[UIColor blackColor] borderWidth:1];
        
        _promptLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-120, 0, 60, frame.size.height)];
        _promptLab.font = [UIFont systemFontOfSize:12];
        _promptLab.text = @"设定价格";
//        _promptLab.backgroundColor = [UIColor redColor];
        [self addSubview:_promptLab];
        
        
        
    }
    return self;
}

- (void)setModel:(ErrandClassModel *)model
{
    _model = model;
    _nameLab.text = model.dictionaryName;
    if (![model.delFlag boolValue]) {
        _selectedBtn.selected = YES;
        _promptLab.hidden = NO;
        _textField.hidden = NO;
    }
    else
    {
        _selectedBtn.selected = NO;
        _promptLab.hidden = YES;
        _textField.hidden = YES;
    }
    if ([model.dictionaryName isEqualToString:@"其他"]) {
//        self.backgroundColor = [UIColor redColor];
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(60, 3, ScreenWidth-180, 20)];
        textField.delegate = self;
        textField.tag = 2017;
        if (model.remark.length) {
            textField.text = [NSString stringWithFormat:@"(%@)",model.remark];
        }
        textField.font = [UIFont systemFontOfSize:12];
        textField.returnKeyType = UIReturnKeyDone;
//        textField.backgroundColor = MainColor;
        textField.textColor = UIColorFromRGB(0x666666);
        [self addSubview:textField];
    }
    _textField.text = [NSString stringWithFormat:@"%@",model.price];
}

- (void)selectedView
{
    if (self.type == 3) {
        [self changeInfoWithDelete:_selectedBtn.isSelected];
    }
    _selectedBtn.selected = !_selectedBtn.isSelected;
    self.model.delFlag = [NSString stringWithFormat:@"%d",_selectedBtn.isSelected];
    if (self.type == 2) {
        BOOL isSelect=NO;
        for (ErrandClassModel *model in self.supperModel.listSerTypeInfo) {
            if (![model.delFlag boolValue]) {
                if ([self.supperModel.delFlag boolValue]) {
                    [self changeInfoWithDelete:!_selectedBtn.isSelected];

                    return;
                }
                else
                {
                    self.supperModel.delFlag = @"1";
                    isSelect=YES;
                    self.fatherView.model = self.supperModel;
//                    [RequestManager addOrDeleteTypeWithServiceType:self.supperModel.dictionaryCode delFlag:@"0" rangeId:self.supperModel.rangeId successHandler:^(NSNumber *ID) {
//                        self.supperModel.rangeId = ID;
//                        [self changeInfoWithDelete:!_selectedBtn.isSelected];
//                    } errorHandler:^(NSError *error) {
//                        
//                    }];
                    return;
                }
            }
        }
        if (!isSelect) {
            [self changeInfoWithDelete:!_selectedBtn.isSelected];

            if ([self.supperModel.delFlag boolValue]) {
                self.supperModel.delFlag = @"0";
                self.fatherView.model = self.supperModel;
//                [RequestManager addOrDeleteTypeWithServiceType:self.supperModel.dictionaryCode delFlag:@"1" rangeId:self.supperModel.rangeId successHandler:^(NSNumber *ID) {
//                    
//                } errorHandler:^(NSError *error) {
//                    
//                }];
                return;
            }
            return;
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    
//    if ([self.model.dictionaryName isEqualToString:@"其他"])
//    {
//        if (textField.tag==2017) {
//            if (textField.text.length) {
//                textField.text = [textField.text substringWithRange:NSMakeRange(1, textField.text.length-2)];
//            }
//            self.model.isSelect = @"1";
//            [self changeInfoWithDelete:NO];
//            _selectedBtn.selected = YES;
//        }
//    }
//}



-(void)changeInfoWithDelete:(BOOL)delete
{
    if (self.type ==2) {
//        [RequestManager changeSubTypeWithID:self.model.modelId detailType:self.model.dictionaryCode rangeId:self.supperModel.rangeId price:[_textField.text intValue] delFlag:[NSString stringWithFormat:@"%d",delete] successHandler:^(NSNumber *ID) {
//            self.model.modelId = ID;
//        } errorHandler:^(NSError *error) {
//            
//        }];
    }
    else if(self.type == 3)
    {
//        [RequestManager changeDomainWithServiceType:self.model.dictionaryCode price:@([_textField.text integerValue]) delFlag:[NSString stringWithFormat:@"%d",delete] rangeId:self.model.modelId remark:self.model.remark successHandler:^(NSNumber * ID) {
//            self.model.modelId = ID;
//        } errorHandler:^(NSError *error) {
//            
//        }];
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
//    if (textField.tag==2017) {
//        if (textField.text.length) {
//            if ([self.model.dictionaryName isEqualToString:@"其他"]) {
//                self.model.remark = textField.text;
//            }
//            textField.text = [NSString stringWithFormat:@"(%@)",textField.text];
//        }
//    }
    [self changeInfoWithDelete:NO];
    return YES;
}
-(void)valueChange
{
    NSInteger price= [_textField.text integerValue];
    _textField.text = [NSString stringWithFormat:@"%ld",price];
}

@end
