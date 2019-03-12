//
//  SearchAllViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SearchAllViewController.h"
#import "HotSearchView.h"
#import "SearchResultViewController.h"
#import "CopyrightResultViewController.h"
#import "AssociateView.h"

@interface SearchAllViewController ()<UITextFieldDelegate,HotSearchViewDelegate,AssociateViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet HotSearchView *hotView;

@property (nonatomic ,strong) AssociateView *associateView;

@end

@implementation SearchAllViewController
{
    NSString *_keyword;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = nil;
    self.searchBgView.frame = CGRectMake(0, 0, ScreenWidth-20, 36);
    [self modifiedTextField];
    [self.searchTextField becomeFirstResponder];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    [self.hotView defaultConfigType:self.type];
    self.hotView.actionDelegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}

-(AssociateView *)associateView
{
    if (!_associateView) {
        _associateView = [[AssociateView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) type:self.type presentView:self.view];
        _associateView.delegate = self;
    }
    return _associateView;
}

//修饰搜索框
- (void)modifiedTextField
{
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    leftView.image = [UIImage imageNamed:@"searchLogo"];
    leftView.contentMode = UIViewContentModeCenter;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = leftView;
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    [clearBtn setImage:[UIImage imageNamed:@"clearTextField"] forState:UIControlStateNormal];
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    [clearBtn addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];
    self.searchTextField.rightView = clearBtn;
    
    switch (self.type) {
        case HotSearchViewTypeAll:
            self.searchTextField.placeholder = @"输入公司名、专利名、商标名等关键词";
            break;
        case HotSearchViewTypePatent:
            self.searchTextField.placeholder = @"输入专利名、公司名、专利号等关键词";
            break;
        case HotSearchViewTypeTrademark:
            self.searchTextField.placeholder = @"请输入商标名、企业名称查询";
            break;
        case HotSearchViewTypePatentScore:
            self.searchTextField.placeholder = @"输入专利名、公司名、专利号等关键词";
            break;
        default:
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
    [self.hotView reloadDataWithType:self.type];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchWithKeyword:textField.text];
    return NO;
}

-(void)clearTextField
{
    self.searchTextField.text = @"";
    [self.associateView removeFromSuperview];
}

- (IBAction)back:(id)sender {
    [self.searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark delegate

-(void)didSelectedKeyWord:(NSString *)keyword
{
    self.searchTextField.text = keyword;
    [self.searchTextField resignFirstResponder];
    [self searchWithKeyword:keyword];
}
-(void)duringScrolling
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}
-(void)associateView:(AssociateView *)view didSelectedKeyStr:(NSString *)keyStr
{
    self.searchTextField.text = keyStr;
    [self.searchTextField resignFirstResponder];
    [self searchWithKeyword:keyStr];
}

-(void)associateView:(AssociateView *)view didSelectedCompanyName:(NSString *)companyName
{
    self.searchTextField.text = companyName;
    [self.searchTextField resignFirstResponder];
    [self searchWithKeyword:companyName];
}


-(void)searchWithKeyword:(NSString *)keyword
{
    if (keyword.length>0) {
        [RequestManager addHotSearchWithType:[NSString stringWithFormat:@"%ld",self.type] keyword:keyword successHandler:^(BOOL success) {
            
        } errorHandler:^(NSError *error) {
            
        }];
        [[DBManager share]addKeyWord:keyword toTableWithType:self.type];
        [self.hotView reloadDataWithType:self.type];

    }
    
    
        _keyword = keyword;
    if (self.type==HotSearchViewTypeProperty) {
        HTMLViewController *web = [[HTMLViewController alloc]init];
        web.htmlUrl = [NSString stringWithFormat:@"%@/analysis/patAnalyze?content=%@",HTTPURL,keyword];
        web.rightItem = YES;
        web.titleStr = [keyword stringByAppendingString:@"知产分析"];
        [self.searchTextField resignFirstResponder];
        [self.navigationController pushViewController:web animated:YES];
    }
    else
    {
        [self.searchTextField resignFirstResponder];
        [self performSegueWithIdentifier:@"SearchPushResult" sender:self];
    }
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchPushResult"]) {
        SearchResultViewController *vc = segue.destinationViewController;
        vc.type = self.type;
        vc.searchStr = _keyword;
    }
    else if ([segue.identifier isEqualToString:@"SearchPushCopyrightResult"])
    {
        CopyrightResultViewController *vc = segue.destinationViewController;
        vc.keystr = _keyword;
    }
}


- (IBAction)valueChange:(id)sender {
    NSLog(@"%@",self.searchTextField.text);
    if (self.searchTextField.text.length>=4) {
        [self.associateView searchStrChange:self.searchTextField.text];
    }
    else
    {
        [self.associateView removeFromSuperview];
    }
}


@end
