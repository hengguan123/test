//
//  PayAnnualFeeViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/8/8.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "PayAnnualFeeViewController.h"

@interface PayAnnualFeeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *applyNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *applyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *invoiceInfoTextField;
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;

@property (weak, nonatomic) IBOutlet UIButton *a_btn;
@property (weak, nonatomic) IBOutlet UIButton *b_btn;

@end

@implementation PayAnnualFeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"年费代缴";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" font:13 target:self action:@selector(submit:)];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submit:(id)sender {
    
}

- (IBAction)typeClick:(UIButton *)sender {
    sender.selected = YES;
    if (sender == self.a_btn) {
        self.b_btn.selected = NO;
    }
    else{
        self.a_btn.selected = NO;
    }
}


@end
