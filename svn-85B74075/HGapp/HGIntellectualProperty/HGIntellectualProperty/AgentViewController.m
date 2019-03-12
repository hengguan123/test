//
//  AgentViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AgentViewController.h"
#import "AgentTableViewCell.h"
#import "AgentDetialTableViewController.h"
#import "DomainViewController.h"
#import "SelectedErrandTypeViewController.h"
#import "AgentFilterViewController.h"
#import "FilterManager.h"


@interface AgentViewController ()<UITableViewDelegate,UITableViewDataSource,AgentTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)FilterManager *filterManager;

@end

@implementation AgentViewController
{
    int _page;
    BOOL _isLast;
    NSString *_cityCode;
    NSString *_typeCode;
    NSString *_domainTypeCode;
    NSString *_detailTypeCode;
    AgentModel *_selModel;
    NSString *_reduce;
    NSInteger _star;
    NSString *_up;
    UIButton *_softBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _up = @"";
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" font:13 target:self action:@selector(filter:)];
    [self.tableView registerNib:[UINib nibWithNibName:@"AgentTableViewCell" bundle:nil] forCellReuseIdentifier:@"AgentTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    _typeCode = [self.dict objectForKey:@"typeCode"];
    _domainTypeCode = [self.dict objectForKey:@"dictionaryCode"];
    _reduce=[self.dict objectForKey:@"slow"];
    [self loadListRefresh:YES];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadListRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadListRefresh:NO];
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}
-(void)loadListRefresh:(BOOL)refresh{
    if (refresh) {
        _page = 1;
        [RequestManager getAgentListWithPage:_page cityCode:_cityCode domainCode:_domainTypeCode serviceType:_typeCode star:_star priceUpDown:_up successHandler:^(BOOL isLast, NSArray *array) {
            [self.dataArray removeAllObjects];
            _isLast = isLast;
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } errorHandler:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }
    else
    {
        if (_isLast) {
            [SVProgressHUD showInfoWithStatus:@"到底了"];
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            _page ++;
            [RequestManager getAgentListWithPage:_page cityCode:_cityCode domainCode:_domainTypeCode serviceType:_typeCode star:_star priceUpDown:_up successHandler:^(BOOL isLast, NSArray *array) {
                _isLast = isLast;
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_footer endRefreshing];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 筛选

- (IBAction)filter:(id)sender {
    [self.filterManager show];
}

-(FilterManager *)filterManager
{
    if (!_filterManager) {
        AgentFilterViewController *filterVc= [[ AgentFilterViewController alloc]initWithNibName:@"AgentFilterViewController" bundle:nil];
        filterVc.view.frame = [UIScreen mainScreen].bounds;
        filterVc.selCityCode = _cityCode;
        filterVc.selTypeCode = _typeCode;
        filterVc.selDomainCode = _domainTypeCode;
        filterVc.star = _star;
        __weak typeof(self) weakSelf = self;
        filterVc.dismissBlock = ^{
            [weakSelf.filterManager hidden];
        };
        filterVc.sureSelBlock = ^(NSString *addrcodes, NSString *typecodes, NSInteger star, NSString *domaincodes) {
            [weakSelf.filterManager hidden];
            _cityCode = addrcodes;
            _typeCode = typecodes;
            _domainTypeCode = domaincodes;
            _star = star;
            [self.tableView.mj_header beginRefreshing];
        };
        _filterManager = [[FilterManager alloc]initWithFilterVc:filterVc];
    }
    return _filterManager;
}

#pragma mark ---- tableView
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AgentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgentTableViewCell"];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([AppUserDefaults share].isLogin) {
        AgentModel *model = [self.dataArray objectAtIndex:indexPath.row];
        HTMLViewController *view = [[HTMLViewController alloc]init];
        view.htmlUrl = [HTTPURL stringByAppendingFormat:@"/faci/faciInfo?faciId=%@&phone=%@&code=%@&code1=%@&slow=%@",model.facilitatorId,[AppUserDefaults share].phone,_typeCode,_domainTypeCode,_reduce?:@""];
        view.titleStr = @"代理人详情";
//        view.canShare = YES;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        [self goToLogin];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 24)];
    lab.text = @"价格排序";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = UIColorFromRGB(0x666666);
    [view addSubview:lab];
    if (!_softBtn) {
        _softBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-44, 0, 44, 43)];
        [_softBtn setImage:[UIImage imageNamed:@"timeDown"] forState:UIControlStateNormal];
        [_softBtn setImage:[UIImage imageNamed:@"timeUp"] forState:UIControlStateSelected];
        
        [_softBtn addTarget:self action:@selector(sorting:) forControlEvents:UIControlEventTouchUpInside];
    }
    [view addSubview:_softBtn];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    line.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [view addSubview:line];
    return view;
}

#pragma mark AgentTableViewCellDelegate
-(void)phoneWithAgentTableViewCell:(AgentTableViewCell *)cell
{
    if (AppUserDefaults.share.isLogin) {
//        [SVProgressHUD showInfoWithStatus:@"暂未开通"];
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入当前使用手机号" preferredStyle:UIAlertControllerStyleAlert];
        //定义第一个输入框；
        [alertvc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入您手机号";
            textField.textAlignment = 1;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            if ([AppUserDefaults.share.phone isEqualToString:@""]||AppUserDefaults.share.phone==nil) {
                
            }
            else
            {
                textField.text = AppUserDefaults.share.phone;
            }
        }];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *phoneTextField = alertvc.textFields.firstObject;
            if ([GGTool isMobileNumber:phoneTextField.text]) {
                [LoadingManager show];
                [RequestManager callDoublePhoneWithPhone:phoneTextField.text call:cell.model.mobilePhone successHandler:^(BOOL success) {
                    [SVProgressHUD showSuccessWithStatus:@"呼叫申请成功，请等待呼叫"];
                    [LoadingManager dismiss];
                } errorHandler:^(NSError *error) {
                    
                }];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"请输入正确手机号"];
            }
            
            
        } ];
        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertvc addAction:sure];
        [alertvc addAction:cancel];
        [self presentViewController:alertvc animated:YES completion:^{
            
        }];
    }
    else
    {
        [self goToLogin];
    }
}

#pragma mark 排序
-(void)sorting:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        _up  =  @"11";
    }
    else
    {
        _up = @"";
    }
    [self loadListRefresh:YES];
}

-(void)goToLogin
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AgentListPushDetial"]) {
        AgentDetialTableViewController *vc = segue.destinationViewController;
        if ([_reduce isEqualToString:@"1"]||[_reduce isEqualToString:@"2"]) {
            vc.reduce = YES;
        }
        vc.usrId = _selModel.usrId;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
