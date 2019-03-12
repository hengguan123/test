//
//  FeedbackViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/22.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *prompt;
@property (weak, nonatomic) IBOutlet UITextView *feedbacktextView;
@property (weak, nonatomic) IBOutlet UILabel *num;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.prompt.hidden = NO;
    }
    else
    {
        self.prompt.hidden = YES;
        NSInteger num = textView.text.length;
        if (num>200) {
            num = 200;
            [SVProgressHUD showInfoWithStatus:@"超出最大输入数"];
            self.feedbacktextView.text = [textView.text substringToIndex:num];
        }
        self.num.text = [NSString stringWithFormat:@"%ld",200-num];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.feedbacktextView resignFirstResponder];
}

- (IBAction)submit:(id)sender {
    [self.feedbacktextView resignFirstResponder];
    if ([self.feedbacktextView.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"输入不能为空"];
    }
    else
    {
        [LoadingManager show];
        [RequestManager feedBackWithFeedbackInfo:self.feedbacktextView.text successHandler:^(BOOL success) {
            [LoadingManager dismiss];
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } errorHandler:^(NSError *error) {
            
        }];
    }
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
