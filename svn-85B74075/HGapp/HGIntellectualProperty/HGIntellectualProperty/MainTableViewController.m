//
//  MainTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MainTableViewController.h"
#import "UserInfo.h"
#import "BecomeAgentViewController.h"
#import "OutlayViewController.h"
#import "PendingPaymentViewController.h"
#import "PersonalInformationTableViewController.h"
#import "TradingCenterViewController.h"
#import "AccountSetViewController.h"
#import "PayAnnualFeeViewController.h"


@interface MainTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *integralLab;
@property (weak, nonatomic) IBOutlet UIButton *orderSwitchBtn;
@property (weak, nonatomic) IBOutlet UILabel *finishLab;
@property (weak, nonatomic) IBOutlet UILabel *doingLab;
@property (weak, nonatomic) IBOutlet UILabel *robNumLab;
@property (weak, nonatomic) IBOutlet UILabel *publishNumLab;
@property (weak, nonatomic) IBOutlet UILabel *noEvalNumLab;
@property (weak, nonatomic) IBOutlet UILabel *noPayNumLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;

@property (weak, nonatomic) IBOutlet UILabel *givenMeNumLab;
@property (weak, nonatomic) IBOutlet UILabel *MyRobLab;

@property (weak, nonatomic) IBOutlet UILabel *myPublishLab;

@property(nonatomic,strong)UserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@property (weak, nonatomic) IBOutlet UILabel *noReadNumLab;

@property (weak, nonatomic) IBOutlet UIButton *patentStatus;
@property (weak, nonatomic) IBOutlet UIButton *phoneStatus;
@property (weak, nonatomic) IBOutlet UIButton *wchatStatus;
@property (weak, nonatomic) IBOutlet UIButton *qqStatus;



@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
    } else {
        // Fallback on earlier versions
    }
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBarBg"]]];
    self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBarBg"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    [self.patentStatus addTarget:self action:@selector(patentStatusClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneStatus addTarget:self action:@selector(bundClick) forControlEvents:UIControlEventTouchUpInside];
    [self.wchatStatus addTarget:self action:@selector(bundClick) forControlEvents:UIControlEventTouchUpInside];
    [self.qqStatus addTarget:self action:@selector(bundClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)bundClick{
    AccountSetViewController *vc = [[AccountSetViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)patentStatusClick:(UIButton *)btn{
    if (btn.selected) {
        BecomeAgentViewController *becomeVc = [[BecomeAgentViewController alloc]init];
        becomeVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:becomeVc animated:YES ];
    }
    else
    {
        [NetPromptBox showWithInfo:@"您已经是代理人" stayTime:2];
    }
}

-(void)setUserInfo:(UserInfo *)userInfo
{
    if (userInfo) {
        _userInfo = userInfo;
        MyApp.userInfo = userInfo;
        AppUserDefaults.share.isInside = userInfo.isInside;
        if (![userInfo.portraitUrl isEqualToString:@""]) {
            NSString *url = [userInfo.portraitUrl hasPrefix:@"http"]?userInfo.portraitUrl:ImageURL(userInfo.portraitUrl);
            [self.userImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        }
        else
        {
            [self.userImageView setImage:[UIImage imageNamed:@"defaultImage"]];
        }
        
        self.nickNameLab.text = userInfo.usrAlias;
        
        self.integralLab.text = [NSString stringWithFormat:@"总积分:%@",userInfo.integral];
        
        self.finishLab.text = [NSString stringWithFormat:@"完成%@个差事",userInfo.finishCount];
        self.doingLab.text = [NSString stringWithFormat:@"%@个进行中的差事",userInfo.underwayCount];
        self.robNumLab.text = [NSString stringWithFormat:@"%@",userInfo.payCount];
        ///////////
        self.publishNumLab.text = [NSString stringWithFormat:@"%@",userInfo.unPayCount];
        self.noEvalNumLab.text = [NSString stringWithFormat:@"%@",userInfo.unEvalCount];
        self.givenMeNumLab.text = [NSString stringWithFormat:@"%@",userInfo.evalMeCount];
        self.noPayNumLab.text = [NSString stringWithFormat:@"%@",userInfo.shopCount];
        self.MyRobLab.text = [NSString stringWithFormat:@"%@/%@",userInfo.robErrandCount,userInfo.faciUnderwayCount];
        self.myPublishLab.text = [NSString stringWithFormat:@"%@/%@",userInfo.publishCount,userInfo.generalUnderwayCount];
        self.moneyLab.text = [NSString stringWithFormat:@"￥%@/%ld",userInfo.soldPay,[userInfo.soldPay integerValue]-[userInfo.unWithdrawPrice integerValue]];
        self.noReadNumLab.text = [NSString stringWithFormat:@"%@",userInfo.unReadCount];
        NSInteger unread = [userInfo.unReadCount integerValue];
        if (unread == 0)
        {
            UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
            [item setImage:[UIImage imageNamed:@"SystemMassageReaded"]];
        }
        else
        {
            UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
            [item setImage:[UIImage imageNamed:@"SystemMassage"]];
        }
//        [JPUSHService setBadge:unread];
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:unread];
        if ([userInfo.usrType boolValue]) {
            self.cityLab.text = userInfo.faciCity;
        }
        else
        {
            self.cityLab.text = userInfo.userCity;
        }
        self.orderSwitchBtn.selected= [userInfo.isReceOrder isEqualToString:@"0"]?YES:NO;
        if (userInfo.usrAccount.length>0) {
            self.phoneStatus.selected = NO;
        }
        else
        {
            self.phoneStatus.selected = YES;
        }
        
        if (userInfo.qqAccount.length>0) {
            self.qqStatus.selected = NO;
        }
        else
        {
            self.qqStatus.selected = YES;
        }
        if (userInfo.wxAccount.length>0) {
            self.wchatStatus.selected = NO;
        }
        else{
            self.wchatStatus.selected = YES;
        }
        if ([userInfo.usrType isEqualToString:@"1"]) {
            self.patentStatus.selected = NO;
        }
        else
        {
            self.patentStatus.selected = YES;
        }
        
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
//    NSLog(@"高%f",self.tableView.bounds.size.height);
    self.tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49);
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    [self.tableView reloadData];
}

- (void)loadData
{
    [RequestManager getUserInfoSuccessHandler:^(NSDictionary *dict) {
        self.userInfo = [MTLJSONAdapter modelOfClass:[UserInfo class] fromJSONDictionary:dict error:nil];
        [self.tableView.mj_header endRefreshing];
    } errorHandler:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        SelectedCityViewController *vc = [[SelectedCityViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        __weak typeof(self) weakSelf = self;
        vc.block = ^(AreaModel *cityModel) {
            NSLog(@"%@",cityModel);
            weakSelf.cityLab.text = cityModel.addrName;
            if ([weakSelf.userInfo.usrType boolValue]) {
                [RequestManager changeAgentAddress:cityModel.addrCode facilitatorId:self.userInfo.facilitatorId successHandler:^(BOOL success) {
                    [weakSelf loadData];
                } errorHandler:^(NSError *error) {
                    
                }];
            }
            else
            {
                [RequestManager changeUserAddress:cityModel.addrCode detailsId:self.userInfo.detailsId successHandler:^(BOOL success) {
                    [weakSelf loadData];
                } errorHandler:^(NSError *error) {
                    
                }];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 5){
        
            PayAnnualFeeViewController *vc = [[PayAnnualFeeViewController alloc]initWithNibName:@"PayAnnualFeeViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 12)
    {
        NSLog(@"客服");
        WebViewController *vc= [[WebViewController alloc]init];
        vc.titleStr = @"官方客服";
        vc.urlStr = CustomerServiceUrl;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 7)
    {
        TradingCenterViewController *vc = [[TradingCenterViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
#pragma mark xib
- (IBAction)switchBtn:(UIButton *)sender {
    if ([AppUserDefaults share].isSpecialUser) {
        if(self.userInfo)
        {
            sender.selected = !sender.isSelected;
            [RequestManager changeAgentisReceOrder:!sender.isSelected  facilitatorId:self.userInfo.facilitatorId successHandler:^(BOOL success) {
                
            } errorHandler:^(NSError *error) {
                
            }];

        }
    }
    else
    {
        [RequestManager identityCheckSuccessHandler:^(NSString *status) {
            [SVProgressHUD dismiss];
            [self doSomethingWithStatus:status];
        } errorHandler:^(NSError *error) {
            
        }];
    }
}
-(void)doSomethingWithStatus:(NSString *)status
{
    if ([status isEqualToString:@"-1"]) {
        NotAgentPromptViewController *vc = [[NotAgentPromptViewController alloc]initWithNibName:@"NotAgentPromptViewController" bundle:nil];
        vc.infoStr = @"您还不是代理人,快去认证吧！";
        [self addChildViewController:vc];
        vc.view.frame = self.view.bounds;
        vc.block = ^{
            BecomeAgentViewController *becomeVc = [[BecomeAgentViewController alloc]init];
            becomeVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:becomeVc animated:YES ];
        };
        [self.view addSubview:vc.view];
    }
    else if([status isEqualToString:@"0"])
    {
        [SVProgressHUD showInfoWithStatus:@"审核中，请耐心等待"];
    }
    else if([status isEqualToString:@"1"])
    {
        [AppUserDefaults share].specialUser = YES;
        self.orderSwitchBtn.selected  =  !self.orderSwitchBtn.isSelected;
        [RequestManager changeAgentisReceOrder:!self.orderSwitchBtn.isSelected  facilitatorId:self.userInfo.facilitatorId successHandler:^(BOOL success) {
            
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else if([status isEqualToString:@"2"])
    {
        NotAgentPromptViewController *vc = [[NotAgentPromptViewController alloc]initWithNibName:@"NotAgentPromptViewController" bundle:nil];
        vc.infoStr = @"审核不通过,请重新提交";
        [self addChildViewController:vc];
        vc.view.frame = self.view.bounds;
        vc.block = ^{
            BecomeAgentViewController *becomeVc = [[BecomeAgentViewController alloc]init];
            becomeVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:becomeVc animated:YES ];
        };
        [self.view addSubview:vc.view];
    }
}


- (IBAction)headerViewTap:(id)sender {
    [self performSegueWithIdentifier:@"MainPushAgentDetails" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MainPushAgentDetails"])
    {
        PersonalInformationTableViewController *vc = segue.destinationViewController;
        vc.userInfo = self.userInfo;
    }
    else if ([segue.identifier isEqualToString:@"MainPushOutlay"])
    {
        OutlayViewController *vc = segue.destinationViewController;
        vc.bankLocale = self.userInfo.bankLocale;
        vc.bankOpen = self.userInfo.bankOpen;
        vc.bankCardNo = self.userInfo.bankCardNo;
    }
    else if ([segue.identifier isEqualToString:@"MainPushShopping"])
    {
        PendingPaymentViewController *vc = segue.destinationViewController;
        vc.usrType = self.userInfo.usrType;
    }
}




@end
