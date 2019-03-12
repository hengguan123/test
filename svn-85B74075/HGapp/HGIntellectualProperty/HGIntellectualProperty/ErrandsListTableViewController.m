//
//  ErrandsListTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/2.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ErrandsListTableViewController.h"
#import "ErrandTableViewCell.h"
#import "SelectedCityViewController.h"
#import "ErrandFilterViewController.h"
#import "BecomeAgentViewController.h"
#import "NoDataView.h"
@interface ErrandsListTableViewController ()<ErrandTableViewCellDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *secHeaderView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIView *filterBgView;
@property (nonatomic,strong) UIWindow *filterWindow;
@property (nonatomic,strong) ErrandFilterViewController *filterVC;
@property (nonatomic,strong) NoDataView *nodataView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;

@property (nonatomic,strong) UIView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ErrandsListTableViewController
{
    int _page;
    BOOL _isLast;
    NSInteger _indexPathRow;
    NSString *_dwellAddrs,*_classifyDomains,*_errandTypes,*_busiTypes;
    NSString *_searchStr,*_price;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    image.image = [UIImage imageNamed:@"search"];
    image.contentMode = UIViewContentModeCenter;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = image; self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" font:14 target:self action:@selector(filter:)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadListRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadListRefresh:NO];
    }];
    self.searchTextField.delegate = self;
    [self initParametersConfiguration];
    
}
/// 配置默认参数
-(void)initParametersConfiguration
{
    if (!_searchStr) {
        _searchStr = @"";
    }
    if (!_price) {
        _price = @"";
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self initParametersConfiguration];
    
    if ([AppUserDefaults share].isLogin) {
        if ([AppUserDefaults share].isSpecialUser) {
            [self.coverView removeFromSuperview];
            [self loadListRefresh:YES];
            [LoadingManager show];
        }
        else
        {
            [self.view addSubview:self.coverView];
            [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self.view.mas_height).with.offset(0);
                make.width.mas_equalTo(ScreenWidth);
            }];
        }
    }
    else
    {
        [self.view addSubview:self.coverView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.view.mas_height).with.offset(0);
            make.width.mas_equalTo(ScreenWidth);
        }];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}

-(NoDataView *)nodataView
{
    if (!_nodataView) {
        _nodataView = [[[NSBundle mainBundle] loadNibNamed:@"NoDataView" owner:nil options:nil] lastObject];
        _nodataView.frame = CGRectMake((ScreenWidth-250)/2, 100, 250, 215);
        [self.tableView addSubview:_nodataView];
    }
    return _nodataView;
}

-(void)loadListRefresh:(BOOL)refresh{
    if (refresh) {
        _page = 1;
        [RequestManager getFilterErrandListWithDwellAddrs:_dwellAddrs searchStr:_searchStr price:_price classifyDomains:_classifyDomains errandTypes:_errandTypes busiTypes:_busiTypes page:_page successHandler:^(BOOL isLast,NSArray *array,NSNumber *total) {
            [self.dataArray removeAllObjects];
            _isLast = isLast;
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [LoadingManager dismiss];
            [self.tableView.mj_header endRefreshing];
            self.totalLab.text = [NSString stringWithFormat:@"共检索到%ld条结果",[total integerValue]];
            if (array.count == 0) {
//                [SVProgressHUD showInfoWithStatus:@"暂无差事，换个条件试试吧"];
                self.nodataView.hidden = NO;
            }
            else
            {
                self.nodataView.hidden = YES;
            }
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
            [RequestManager getFilterErrandListWithDwellAddrs:_dwellAddrs  searchStr:_searchStr price:_price classifyDomains:_classifyDomains errandTypes:_errandTypes busiTypes:_busiTypes page:_page successHandler:^(BOOL isLast, NSArray *array,NSNumber *total) {
                _isLast = isLast;
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
}

-(void)filterSelAddr:(NSString *)addr typeStrLike:(NSString *)typeStr busiType:(NSString *)busiType
{
    _dwellAddrs = addr;
    _errandTypes = typeStr;
    _busiTypes = busiType;
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ErrandTableViewCell" bundle:nil] forCellReuseIdentifier:@"ErrandTableViewCell"];
    ErrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ErrandTableViewCell"];
    cell.delegate = self;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.secHeaderView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([AppUserDefaults share].isLogin) {
        _indexPathRow = indexPath.row;
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ErrandsDetialTableViewController *vc = [main instantiateViewControllerWithIdentifier:@"ErrandsDetialTableViewController"];
        vc.model = [self.dataArray objectAtIndex:indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        vc.fromList = self;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else
    {
        [self goToLogin];
    }
}

-(void)grabOrderWithErrandTableViewCell:(ErrandTableViewCell *)errandTableViewCell sender:(UIButton *)sender
{
    if ([AppUserDefaults share].isLogin) {
        NSLog(@"抢单了");
        [LoadingManager show];
        if ([AppUserDefaults share].isSpecialUser) {
            sender.enabled = NO;
            [RequestManager grabErrandWithErrandId:errandTableViewCell.model.errandId faciName:[AppUserDefaults share].userName errandTitle:errandTableViewCell.model.errandTitle usrId:errandTableViewCell.model.usrId price:errandTableViewCell.model.price successHandler:^(BOOL success) {
                [LoadingManager dismiss];
                if (success) {
                    [NetPromptBox showWithInfo:@"抢单成功" stayTime:2];
                    [self loadListRefresh:YES];
                }
                sender.enabled = YES;
            } errorHandler:^(NSError *error) {
                sender.enabled = YES;
            }];
        }
        else
        {
            
            [RequestManager identityCheckSuccessHandler:^(NSString *status) {
                [LoadingManager dismiss];
                [self doSomethingWithStatus:status errand:errandTableViewCell.model sender:sender];
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
    else
    {
        [self goToLogin];
    }
}

-(void)doSomethingWithStatus:(NSString *)status errand:(ErrandModel *)model sender:(UIButton *)sender
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
        sender.enabled = NO;
        [RequestManager grabErrandWithErrandId:model.errandId faciName:[AppUserDefaults share].userName errandTitle:model.errandTitle usrId:model.usrId price:model.price successHandler:^(BOOL success) {
            sender.enabled = YES;
            if (success) {
                [NetPromptBox showWithInfo:@"抢单成功" stayTime:2];
                [self loadListRefresh:YES];
            }
            
        } errorHandler:^(NSError *error) {
             sender.enabled = YES;
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


-(void)goToLogin
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark ---- push
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EListPushDetail"]) {
        ErrandsDetialTableViewController *vc = segue.destinationViewController;
        vc.fromList = self;
        vc.model = [self.dataArray objectAtIndex:_indexPathRow];
    }
}


- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)filter:(id)sender {
    [MyApp.window addSubview:self.filterBgView];
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 1;
        self.filterWindow.frame = CGRectMake(100, 0, ScreenWidth-100, ScreenHeight);
    }];
    
}

-(UIView *)filterBgView
{
    if (!_filterBgView) {
        _filterBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _filterBgView.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        _filterBgView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(filterBgViewTab)];
        [_filterBgView addGestureRecognizer:tap];
        
    }
    return _filterBgView;
}
-(UIWindow *)filterWindow
{
    if (!_filterWindow) {
        _filterWindow = [[UIWindow alloc]initWithFrame:CGRectMake(100+ScreenWidth, 0, ScreenWidth-100, ScreenHeight)];
        
        _filterWindow.windowLevel = UIWindowLevelNormal;
        _filterWindow.hidden = NO;
        [_filterWindow makeKeyAndVisible];
        _filterWindow.backgroundColor = [UIColor whiteColor];
        
        _filterWindow.rootViewController = self.filterVC;
    }
    return _filterWindow;
}
-(ErrandFilterViewController *)filterVC
{
    if (!_filterVC) {
        _filterVC = [[ErrandFilterViewController alloc]initWithNibName:@"FilterViewController" bundle:nil];
        _filterVC.view.frame = CGRectMake(0, 0, ScreenWidth-100, ScreenHeight);
        __weak typeof(self) weakSelf = self;
        
        _filterVC.selectItemsBlock = ^(NSString *addrStr, NSString *typeLikeStr, NSString *subTpeyStr) {
            _dwellAddrs = addrStr;
            _errandTypes = typeLikeStr;
            _busiTypes = subTpeyStr;
            [weakSelf finishLoadData];
        };
    }
    return _filterVC;
}

-(void)finishLoadData
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth+100, 0, ScreenWidth-100, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        self.filterWindow = nil;
        
        [self.tableView.mj_header beginRefreshing];

    }];
}

-(void)filterBgViewTab
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth+100, 0, ScreenWidth-100, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        self.filterWindow = nil;
    }];
}

- (IBAction)priceSorting:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _price = @"desc";
    }
    else
    {
        _price = @"asc";
    }
    [LoadingManager show];
    [self loadListRefresh:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchStr = textField.text;
    [self.tableView.mj_header beginRefreshing];
    [textField resignFirstResponder];
    return YES;
}


///非代理人遮盖层
-(UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [_coverView addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"无数据"];
        imageView.contentMode = UIViewContentModeCenter;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(187, 132));
            make.centerX.equalTo(_coverView.mas_centerX).with.offset(0);
            make.top.equalTo(_coverView.mas_top).with.offset(120);
        }];
        UILabel *lab = [[UILabel alloc]init];
        [_coverView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
                make.top.equalTo(imageView.mas_bottom).with.offset(20);
        }];
        lab.textColor = UIColorFromRGB(0x666666);
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = 1;
        lab.text = @"你还不是代理人，请认证后查看";
        
        UIButton *btn = [[UIButton alloc]init];
        [_coverView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 40));
            make.centerX.equalTo(_coverView.mas_centerX).with.offset(0);
            make.bottom.equalTo(_coverView.mas_bottom).with.offset(-60);
        }];
        btn.layer.cornerRadius = 5;
        [btn setTitle:@"认证代理人" forState:UIControlStateNormal];
        btn.backgroundColor = MainColor;
        [btn addTarget:self action:@selector(CertificationAgent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverView;
}
///认证代理人
-(void)CertificationAgent
{
    if ([AppUserDefaults share].isLogin) {
        BecomeAgentViewController *becomeVc = [[BecomeAgentViewController alloc]init];
        becomeVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:becomeVc animated:YES ];
    }
    else
    {
        [self goToLogin];
    }
}

@end
