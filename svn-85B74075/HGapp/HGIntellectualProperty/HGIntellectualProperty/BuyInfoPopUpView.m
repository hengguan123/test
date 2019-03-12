//
//  BuyInfoPopUpView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/25.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "BuyInfoPopUpView.h"

@implementation BuyInfoPopUpView
{
    UIView *_view;
    UITextField *_nameTextField;
    UITextField *_phoneTextField;
    UITextField *_priceTextField;
    PatentModel *_model;
}
-(instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.2);
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 280)];
        _view.backgroundColor = [UIColor whiteColor];
        _view.center = self.center;
        _view.layer.cornerRadius = 5;
        [self addSubview:_view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(256, 0, 44, 44)];
        [btn setImage:[UIImage imageNamed:@"close-1"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:btn];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, 100, 20)];
        title.text = @"信息填写";
        title.textColor = UIColorFromRGB(0x666666);
        title.font = [UIFont systemFontOfSize:14];
        [_view addSubview:title];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 44, 280, 1)];
        line.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [_view addSubview:line];
        
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 80, 20)];
        nameLab.text = @"联系人姓名:";
        nameLab.textAlignment = 2;
//        nameLab.backgroundColor = MainColor;
        nameLab.textColor = UIColorFromRGB(0x666666);
        nameLab.font = [UIFont systemFontOfSize:13];
        [_view addSubview:nameLab];
        
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 64, 180, 32)];
        _nameTextField.placeholder = @"请输入联系人姓名";
        _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
        _nameTextField.font = [UIFont systemFontOfSize:13];
        _nameTextField.delegate = self;
        _nameTextField.returnKeyType = UIReturnKeyDone;
        [_view addSubview:_nameTextField];
        
        UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 80, 20)];
        phoneLab.textColor = UIColorFromRGB(0x666666);

        NSMutableAttributedString * anAttrStr = [[NSMutableAttributedString alloc]initWithString:@"*联系电话:"];
        [anAttrStr
         addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0, 1)];
        phoneLab.attributedText = anAttrStr;
        phoneLab.textAlignment = 2;
//        phoneLab.backgroundColor = MainColor;
        phoneLab.font = [UIFont systemFontOfSize:13];
        [_view addSubview:phoneLab];
        
        _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 114, 180, 32)];
        _phoneTextField.placeholder = @"请输入联系电话或手机号";
        _phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
        _phoneTextField.font = [UIFont systemFontOfSize:13];
        _phoneTextField.delegate = self;
        _priceTextField.keyboardType = UIKeyboardTypeNumberPad;
        if ([AppUserDefaults share].phone) {
            _phoneTextField.text = [AppUserDefaults share].phone;
        }
        [_view addSubview:_phoneTextField];
        
        UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 80, 20)];
        priceLab.textColor = UIColorFromRGB(0x666666);
        NSMutableAttributedString * priceAttrStr = [[NSMutableAttributedString alloc]initWithString:@"*出价金额:"];
        [priceAttrStr
         addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0, 1)];
        priceLab.attributedText = priceAttrStr;
        priceLab.textAlignment = 2;
//        priceLab.backgroundColor = MainColor;
        priceLab.font = [UIFont systemFontOfSize:13];
        [_view addSubview:priceLab];
        
        _priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 164, 180, 32)];
        _priceTextField.placeholder = @"请输入出价金额:";
        _priceTextField.borderStyle = UITextBorderStyleRoundedRect;
        _priceTextField.font = [UIFont systemFontOfSize:13];
        _priceTextField.delegate = self;
        _priceTextField.returnKeyType = UIReturnKeyDone;
        [_view addSubview:_priceTextField];
        
        UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(100, 220, 100, 30)];
        submit.backgroundColor = MainColor;
        submit.layer.cornerRadius = 5;
        [submit setTitle:@"提交" forState:UIControlStateNormal];
        submit.titleLabel.font = [UIFont systemFontOfSize:14];
        [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:submit];
        
    }
    return self;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)buyWithErrandModel:(PatentModel *)model
{
    _model = model;
}

-(void)show
{
    [MyApp.window addSubview:self];
}
-(void)dismiss
{
    [self removeFromSuperview];
}

-(void)tap
{
    [_phoneTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_priceTextField resignFirstResponder];
}
-(void)submit
{
    if ([_phoneTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"联系人电话不能为空"];
        return;
    }
    else if ([_priceTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"出价不能为空"];
        return;
    }
    else if (![GGTool isContainNumStr:_priceTextField.text])
    {
        [SVProgressHUD showInfoWithStatus:@"出价不符合规则"];
        return;
    }
    else
    {
        NSString *businessDesc=[NSString stringWithFormat:@"标题:%@<br/>专利号:%@<br/>法律状态:%@<br/>申请人:%@<br/>出价:%@",_model.TITLE,_model.APN,_model.VALID,_model.AN,_priceTextField.text];
        NSDictionary *dict = @{@"usrId":[AppUserDefaults share].usrId,@"usrPhone":_phoneTextField.text,@"busiQuality":@"8",@"typeCode":@"YWLX01-04",@"businessDesc":businessDesc,@"price":_priceTextField.text,@"usrName":_nameTextField.text,@"businessName":[NSString stringWithFormat:@"求购%@",_model.TITLE]};
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@[dict]
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        [RequestManager sellPatentsWithListBusi:jsonString successHandler:^(BOOL success) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self dismiss];
        } errorHandler:^(NSError *error) {
            
        }];
    }
}

@end
