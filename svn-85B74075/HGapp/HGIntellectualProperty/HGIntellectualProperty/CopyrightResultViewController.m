//
//  CopyrightResultViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/24.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CopyrightResultViewController.h"
#import "Copyright1ViewController.h"
#import "Copyright2ViewController.h"
#import "YCXMenu.h"
#import "CopyrightHotView.h"


@interface CopyrightResultViewController ()<UITextFieldDelegate,CopyrightHotViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBgView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic,strong)Copyright1ViewController *vc1;
@property (nonatomic,strong)Copyright2ViewController *vc2;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)CopyrightHotView *hotView;

@property (nonatomic,assign)NSInteger resultWorks;
@property (nonatomic,assign)NSInteger resultSoftwear;

@end

@implementation CopyrightResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = nil;
    self.scrollBgView.contentSize = CGSizeMake(ScreenWidth *2, 0);
    
    self.titleBgView.frame = CGRectMake(8, 0, ScreenWidth-16, 33);
    
    self.type = 1;
    
    [self.scrollBgView addSubview:self.vc1.view];
    [self.scrollBgView addSubview:self.vc2.view];
    [self.view addSubview:self.hotView];
    [self.hotView loadDataWithType:@"7"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
}

-(Copyright1ViewController *)vc1
{
    if (!_vc1) {
        _vc1 = [[Copyright1ViewController alloc]initWithNibName:@"Copyright1ViewController" bundle:nil];
        [self addChildViewController:_vc1];
        _vc1.view.frame = self.scrollBgView.bounds;
        __weak typeof(self) weakSelf = self;
        _vc1.numBlock = ^(NSNumber *num) {
            [weakSelf.btn1 setTitle:[NSString stringWithFormat:@"软件著作权(%@)",num] forState:UIControlStateNormal];
            [weakSelf getResultConut:num withType:1];
        };
    }
    return _vc1;
}
-(Copyright2ViewController *)vc2
{
    if (!_vc2) {
        _vc2 = [[Copyright2ViewController alloc]initWithNibName:@"Copyright2ViewController" bundle:nil];
        [self addChildViewController:_vc2];
        _vc2.view.frame = CGRectMake(ScreenWidth, 0, self.scrollBgView.bounds.size.width, self.scrollBgView.bounds.size.height);
        __weak typeof(self) weakSelf = self;
        _vc2.numBlock = ^(NSNumber *num) {
            [weakSelf.btn2 setTitle:[NSString stringWithFormat:@"作品著作权(%@)",num] forState:UIControlStateNormal];
            [weakSelf getResultConut:num withType:2];
        };
    }
    return _vc2;
}

-(void)getResultConut:(NSNumber *)num withType:(NSInteger )type
{
    if (type == 1) {
        if ([num integerValue]>0) {
            [self btnClick:self.btn1];
        }
        self.resultSoftwear = [num integerValue];
    }
    else if (type == 2)
    {
        if (self.resultSoftwear==0&&[num integerValue]>0) {
            [self btnClick:self.btn2];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.searchTextField resignFirstResponder];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender == self.btn1) {
        self.btn1.selected = YES;
        self.btn2.selected = NO;
        [self.scrollBgView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        [self.scrollBgView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.center = CGPointMake(sender.center.x, self.lineView.center.y);
    }];
}

- (IBAction)selectedSearchType:(id)sender {
    //set title
    
    if ([YCXMenu isShow]) {
        [YCXMenu dismissMenu];
    }
    else
    {
        NSArray *items = @[
                           [YCXMenuItem menuItem:@"全称"
                                           image:nil
                                             tag:100
                                        userInfo:@{@"title":@"Menu"}],
                           [YCXMenuItem menuItem:@"登记号"
                                           image:nil
                                             tag:101
                                        userInfo:@{@"title":@"Menu"}],
                           [YCXMenuItem menuItem:@"拥有者"
                                           image:nil
                                             tag:102
                                        userInfo:@{@"title":@"Menu"}],
                           ];
        [YCXMenu setSelectedColor:MainColor];
        [YCXMenu setTitleFont:[UIFont systemFontOfSize:14]];
        [YCXMenu showMenuInView:MyApp.window fromRect:CGRectMake(8, 55, 40, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
//            NSLog(@"%@",item);
            self.type = item.tag-99;
            self.typeLab.text = item.title;
            if (self.searchTextField.text.length >0) {
                [self searchWithStr:self.searchTextField.text];
            }
            [self.hotView loadDataWithType:[NSString stringWithFormat:@"%ld",self.type+6]];
            if ([self.searchTextField.text isEqualToString:@""]) {
                [self.view addSubview:self.hotView];
            }
            else
            {
                [self.hotView removeFromSuperview];
            }
        }];
    }
}

#pragma mark textFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.text.length) {
        [self searchWithStr:self.searchTextField.text];
    }
    
    return YES;
}

-(void)searchWithStr:(NSString *)searchStr
{
    [self.hotView removeFromSuperview];
    [RequestManager addHotSearchWithType:[NSString stringWithFormat:@"%ld",self.type+6] keyword:searchStr successHandler:^(BOOL success) {
        
    } errorHandler:^(NSError *error) {
        
    }];
    self.resultSoftwear = 0;
    self.resultWorks = 0;
    [self.vc1 searchWithSearchStr:searchStr type:self.type];
    [self.vc2 searchWithSearchStr:searchStr type:self.type];
}



#pragma mark hotView
-(CopyrightHotView *)hotView
{
    if (!_hotView) {
        _hotView = [[CopyrightHotView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        _hotView.backgroundColor = MainColor;
        _hotView.delegate =self;
    }
    return _hotView;
}
-(void)didSelectedHotStr:(NSString *)hotStr
{
    self.searchTextField.text = hotStr;
    [self.searchTextField resignFirstResponder];
    [self searchWithStr:hotStr];
}

- (IBAction)valueChange:(UITextField *)sender {
    if ([sender.text isEqualToString:@""]) {
        [self.view addSubview:self.hotView];
    }
}



@end
