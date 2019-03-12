//
//  WriteReviewTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "WriteReviewTableViewController.h"

@interface WriteReviewTableViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *classLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *promptLab;



@end

@implementation WriteReviewTableViewController
{
    int _evalLevel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    _evalLevel = 5;
    if (self.model) {
        self.priceLab.text = [NSString stringWithFormat:@"%@",self.model.price];
        self.titleLab.text = self.model.errandTitle;
        self.classLab.text = [NSString stringWithFormat:@"%@%@%@",self.model.domainName,self.model.errandTypeName,self.model.busiTypeName];
        if ([self.model.provinceName isEqualToString:self.model.dwellAddrName]) {
            self.addressLab.text = self.model.dwellAddrName;
        }
        else
        {
            self.addressLab.text = [NSString stringWithFormat:@"%@%@",self.model.provinceName,self.model.dwellAddrName];
        }
        self.statusLab.text = self.model.errandStatusName;
    }
    UITapGestureRecognizer *starTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starTap:)];
    [self.starBgView addGestureRecognizer:starTap];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)starTap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.starBgView];
    int num = point.x / 21 +1;
    
    [self starWithNum:num];
}
-(void)starWithNum:(int)num
{
    int starNum = MIN(5, num);
    _evalLevel = starNum;
    switch (starNum) {
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

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.promptLab.hidden = NO;
    }
    else
    {
        self.promptLab.hidden = YES;
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)comment:(id)sender {
    [RequestManager addCommentWithErrandId:self.model.errandId faciId:self.model.faciId evalLevel:_evalLevel evalContent:self.commentTextView.text successHandler:^(BOOL success) {
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } errorHandler:^(NSError *error) {
        
    }];
}


@end
