//
//  AccountSetViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/1/31.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "AccountSetViewController.h"
#import "AccountSetTableViewCell.h"
#import "GetCodeViewController.h"
#import "BundPhoneViewController.h"

@interface AccountSetViewController ()<UITableViewDataSource,UITableViewDelegate,AccountSetTableViewCellDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UserInfo *userInfo;

@end

@implementation AccountSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定设置";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    _userInfo = MyApp.userInfo;
    [self.view addSubview:self.tableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self reladData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"AccountSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccountSetTableViewCell"];
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AccountSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountSetTableViewCell"];
    cell.delegate = self;
    if (indexPath.row == 0) {
        if (self.userInfo.usrAccount.length>0) {
            cell.sel = YES;
        }
        else
        {
            cell.sel = NO;
        }
        
    }
    else if (indexPath.row == 1)
    {
        if (self.userInfo.wxAccount.length>0) {
            cell.sel = YES;
        }
        else
        {
            cell.sel = NO;
        }
    }
    else if (indexPath.row == 2)
    {
        if (self.userInfo.qqAccount.length>0) {
            cell.sel = YES;
        }
        else
        {
            cell.sel = NO;
        }
    }
    
    cell.index = indexPath.row;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

///
-(void)btnClickAccountSetTableViewCell:(AccountSetTableViewCell *)cell
{
    if (cell.index == 0) {
        if (cell.sel) {
            if (MyApp.userInfo.wxAccount.length > 0 || MyApp.userInfo.qqAccount.length > 0)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认要解除登录手机号绑定？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    GetCodeViewController *vc = [[GetCodeViewController alloc]initWithNibName:@"GetCodeViewController" bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"未绑定其他账号，不可解绑当前账号"];
            }
        }
        else
        {
            BundPhoneViewController *vc = [[BundPhoneViewController alloc]initWithNibName:@"BundPhoneViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (cell.index == 1)
    {
        if (cell.sel) {
            if (MyApp.userInfo.usrAccount.length > 0 || MyApp.userInfo.qqAccount.length > 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定要解除微信绑定？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
                        if (error) {
                            if (error.code == 2009) {
                                [NetPromptBox showWithInfo:@"用户已取消" stayTime:2];
                            }
                        }
                        else
                        {
                            UMSocialUserInfoResponse *resp = result;
                            if ([resp.unionId isEqualToString:MyApp.userInfo.wxAccount]) {
                                [LoadingManager show];
                                [RequestManager unbundledWithwxAccount:resp.unionId qqAccount:nil usrAccount:nil nodeCode:nil successHandler:^(BOOL success) {
                                    [self reladData];
                                    [NetPromptBox showWithInfo:@"解绑成功" stayTime:2];
                                } errorHandler:^(NSError *error) {
                                    
                                }];
                            }
                            else {
                                [SVProgressHUD showErrorWithStatus:@"绑定微信与验证微信不一致"];
                            }
                            
                        }
                    }];
                }];
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"未绑定其他账号，不可解绑当前账号"];
            }
        }
        else
        {
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    if (error.code == 2009) {
                        [NetPromptBox showWithInfo:@"用户已取消" stayTime:2];
                    }
                }
                else
                {
                    UMSocialUserInfoResponse *resp = result;
                    [LoadingManager show];
                    [RequestManager bindWithwxAccount:resp.unionId qqAccount:nil usrAccount:nil nodeCode:nil successHandler:^(BOOL success) {
                        [self reladData];
                        [NetPromptBox showWithInfo:@"绑定成功" stayTime:2];
                    } errorHandler:^(NSError *error) {
                        
                    }];
                }
            }];
        }
    }
    else if (cell.index == 2)
    {
        if (cell.sel) {
            if (MyApp.userInfo.usrAccount.length > 0 || MyApp.userInfo.qqAccount.length > 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定要解除QQ绑定？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
                        if (error) {
                            if (error.code == 2009) {
                                [NetPromptBox showWithInfo:@"用户已取消" stayTime:2];
                            }
                        }
                        else
                        {
                            UMSocialUserInfoResponse *resp = result;
                            if ([resp.unionId isEqualToString:MyApp.userInfo.qqAccount]) {
                                [LoadingManager show];
                                [RequestManager unbundledWithwxAccount:nil qqAccount:resp.unionId usrAccount:nil nodeCode:nil successHandler:^(BOOL success) {
                                     [self reladData];
                                    [NetPromptBox showWithInfo:@"解绑成功" stayTime:2];
                                } errorHandler:^(NSError *error) {
                                    
                                }];
                            }
                            else {
                                [SVProgressHUD showErrorWithStatus:@"绑定QQ与验证QQ不一致"];
                            }
                            
                        }
                    }];
                }];
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"未绑定其他账号，不可解绑当前账号"];
            }
        }
        else
        {
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    if (error.code == 2009) {
                        [NetPromptBox showWithInfo:@"用户已取消" stayTime:2];
                    }
                }
                else
                {
                    UMSocialUserInfoResponse *resp = result;
                    [LoadingManager show];
                    [RequestManager bindWithwxAccount:nil qqAccount:resp.unionId usrAccount:nil nodeCode:nil successHandler:^(BOOL success) {
                        [self reladData];
                        [NetPromptBox showWithInfo:@"绑定成功" stayTime:2];
                    } errorHandler:^(NSError *error) {
                        
                    }];
                }
            }];
        }
    }
}

-(void)reladData{
    [RequestManager getUserInfoSuccessHandler:^(NSDictionary *dict) {
        
        MyApp.userInfo = [MTLJSONAdapter modelOfClass:[UserInfo class] fromJSONDictionary:dict error:nil];
        self.userInfo = MyApp.userInfo;
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
    }];
}



@end
