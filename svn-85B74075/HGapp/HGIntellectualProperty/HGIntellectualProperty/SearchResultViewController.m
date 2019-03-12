//
//  SearchResultViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/14.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SearchResultViewController.h"
#import "PatentTableViewCell.h"
#import "RequestURL.h"
#import "SearchCompanyTableViewCell.h"
#import "TrademarkTableViewCell.h"
#import "ClassificationQueryViewController.h"
#import "CampanyContentViewController.h"
#import "FilterCountryViewController.h"
#import "AssociateView.h"
#import "PatentScoreViewController.h"
#import "CompanyCopyrightViewController.h"
#import "VerifyPhoneView.h"
#import "BundPhoneViewController.h"



#define CurrentFilterWidth ScreenWidth*3/4

@interface SearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SearchCompanyTableViewCellDelegare,AssociateViewDelegate,VerifyPhoneViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *textFieldBgView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong) UIView *filterBgView;
@property (nonatomic,strong) UIWindow *filterWindow;
@property (nonatomic,strong) FilterCountryViewController *filterVC;

@property (nonatomic ,strong) AssociateView *associateView;
@property (nonatomic ,strong) VerifyPhoneView *verifyPhoneView;

@end

@implementation SearchResultViewController
{
    int _page;
    BOOL _isLast;
    SearchAllModel *_selModel;
    NSString *_provinceName;
    NSString *_countryCode;
    NSURLSessionDataTask *_task;
    NSString *_pkindStr;
    NSString *_trademarkType;
    BOOL _isCompany;
    TrademarkModel *_selTrademarkModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.textFieldBgView.frame = CGRectMake(0, 0, ScreenWidth-90, 36);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" font:13 target:self action:@selector(search:)];
    _provinceName = @"";
    _pkindStr = @"";
    _countryCode = @"CHN";
    _trademarkType = @"0";
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
            self.searchTextField.placeholder = @"搜专利评分";
            break;
        default:
            break;
    }
    self.tableView.tableFooterView = [UIView new];
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
    self.searchTextField.text = self.searchStr;
    [self loadDataRefresh:YES];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).with.offset(0);
        make.left.mas_equalTo(0);
        //            make.height.equalTo(self.view.mas_height).with.offset(0);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(0); make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(0);
        } else {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        }
    }];
    
}

//验证手机
//-(VerifyPhoneView *)verifyPhoneView
//{
//    if (!_verifyPhoneView) {
//        _verifyPhoneView = [[[NSBundle mainBundle]loadNibNamed:@"VerifyPhoneView" owner:nil options:nil] lastObject];
//        _verifyPhoneView.delegate = self;
//    }
//    return _verifyPhoneView;
//}
/////验证通过
//-(void)verificationPassedWithPhone:(NSString *)phone
//{
//    [CutoverManager openTrademarkDetailWithFromController:self regNo:_selTrademarkModel.regNo intCls:_selTrademarkModel.intCls name:_selTrademarkModel.tmName owner:_selTrademarkModel.applicantCn usrPhone:phone];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
    [LoadingManager dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存爆掉啦");
}

-(void)loadDataRefresh:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        _isLast = NO;
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [_task cancel];
        [LoadingManager show];
    }
    else
    {
        _page ++;
    }
    if (_isLast) {
        _page --;
        [SVProgressHUD showInfoWithStatus:@"没有更多了"];
        [self.tableView.mj_footer endRefreshing];
    }
    else
    {
        if (self.type == HotSearchViewTypeAll) {
            
            [RequestManager searchAllWithKeyword:self.searchStr anAdd:_provinceName country:_countryCode successHandler:^(NSArray *array) {
                _isLast = YES;
                [LoadingManager dismiss];
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }];
        }
        else if (self.type == HotSearchViewTypePatent||self.type == HotSearchViewTypePatentScore)
        {
             _task = [RequestManager searchPatentWithContent:[self searchPatentReplace:self.searchStr] pageNo:_page anAdd:_provinceName country:_countryCode pkind:_pkindStr successHandler:^(BOOL isLast, NSArray *array,NSNumber *totalNum) {
                    if (_page==1) {
                        self.tableView.tableHeaderView = [[ResultNumView alloc]initWithNum:totalNum];
                    }
                    [LoadingManager dismiss];
                    _isLast = isLast;
                    [self.dataArray addObjectsFromArray:array];
                    [self.tableView reloadData];
                    if (self.dataArray.count==0) {
                        [SVProgressHUD showInfoWithStatus:@"未查询到专利数据，请更换关键字后重试!"];
                    }
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_header endRefreshing];
                } errorHandler:^(NSError *error) {
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_header endRefreshing];
            }];
            
        }
        else if (self.type == HotSearchViewTypeTrademark)
        {
            [RequestManager searchTrademarkWithContent:self.searchStr pageNo:_page intCls:_trademarkType successHandler:^(NSString *totalNum, NSArray *array) {
                [LoadingManager dismiss];
                if (_page==1) {
                    self.tableView.tableHeaderView = [[ResultNumView alloc]initWithNum:@([totalNum integerValue])];
                }
                if (_page*20<[totalNum intValue]) {
                    _isLast = NO;
                }
                else
                {
                    _isLast = YES;
                }
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];                if (self.dataArray.count==0) {
                    [SVProgressHUD showInfoWithStatus:@"未查询到商标数据，请更换关键字后重试!"];
                }

            } errorHandler:^(NSError *error) {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }];
        }
    }
}

-(NSString *)searchPatentReplace:(NSString *)searchStr
{
    
    if ([searchStr.uppercaseString hasPrefix:@"ZL"]) {
        NSMutableString *mutStr = [[NSMutableString alloc]initWithString:searchStr];
        [mutStr replaceCharactersInRange:NSMakeRange(0, 2) withString:@"CN"];
        return mutStr;
    }
    return searchStr.uppercaseString;
}


#pragma mark tableView
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
//    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == HotSearchViewTypeAll) {
        return 100;
    }
    else if (self.type == HotSearchViewTypePatent)
    {
        return 140;
    }
    else if (self.type == HotSearchViewTypeTrademark)
    {
        return 140;
    }
    else if (self.type == HotSearchViewTypePatentScore)
    {
        return 140;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == HotSearchViewTypeAll) {
        [self.tableView registerNib:[UINib nibWithNibName:@"SearchCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchCompanyTableViewCell"];
        SearchCompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCompanyTableViewCell"];
        cell.delegate = self;
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (self.type == HotSearchViewTypePatent)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"PatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatentTableViewCell"];
        PatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatentTableViewCell"];
        cell.searchStr = self.searchStr;
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (self.type == HotSearchViewTypeTrademark)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"TrademarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"TrademarkTableViewCell"];
        TrademarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrademarkTableViewCell"];
        cell.searchStr = self.searchStr;
        cell.hiddenTag = YES;
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (self.type == HotSearchViewTypePatentScore)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"PatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatentTableViewCell"];
        PatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatentTableViewCell"];
        cell.searchStr = self.searchTextField.text;
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == HotSearchViewTypeAll) {
        _selModel = [self.dataArray objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"CampanyPushDetail" sender:self];
        return;
    }
    else if (self.type == HotSearchViewTypePatent)
    {
        PatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
        
        [CutoverManager openPatendDetailWithFromController:self techId:model.ID physicDb:model.PHYSIC_DB PKINDS:model.PKIND_S monitorId:nil title:model.TITLE subTitle:model.AN share:YES];
    }
    else if (self.type == HotSearchViewTypeTrademark)
    {
        _selTrademarkModel = [self.dataArray objectAtIndex:indexPath.row];
        if ([AppUserDefaults share].isLogin) {
            if ([AppUserDefaults share].phone == nil ||[[AppUserDefaults share].phone isEqualToString:@""]) {
                BundPhoneViewController *vc = [[BundPhoneViewController alloc]initWithNibName:@"BundPhoneViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [CutoverManager openTrademarkDetailWithFromController:self regNo:_selTrademarkModel.regNo intCls:_selTrademarkModel.intCls name:_selTrademarkModel.tmName owner:_selTrademarkModel.applicantCn usrPhone:[AppUserDefaults share].phone];
            }
        }
        else
        {
            [self goToLogin];
        }
    }
    else if (self.type == HotSearchViewTypePatentScore)
    {
        PatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PatentScoreViewController *vc = [main instantiateViewControllerWithIdentifier:@"PatentScoreViewController"];
        vc.model = model;
        [self showViewController:vc sender:self];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CampanyPushDetail"]) {
        CampanyContentViewController *vc = [segue destinationViewController];
        vc.model = _selModel;
        vc.country = _countryCode;
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length>0) {
        [self.searchTextField resignFirstResponder];
        [self.associateView removeFromSuperview];
        self.searchStr = textField.text;
        [self loadDataRefresh:YES];
        [RequestManager addHotSearchWithType:[NSString stringWithFormat:@"%ld",self.type] keyword:textField.text successHandler:^(BOOL success) {
            
        } errorHandler:^(NSError *error) {
            
        }];
        [[DBManager share]addKeyWord:textField.text toTableWithType:self.type];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"搜索不能为空"];
    }
    
    return YES;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goToLogin
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark tableviewcelldelegate
-(void)patentListWithSearchCompanyTableViewCell:(SearchCompanyTableViewCell *)cell
{
    ClassificationQueryViewController *vc = [[ClassificationQueryViewController alloc]initWithNibName:@"ClassificationQueryViewController" bundle:nil];
    vc.type =1;
    vc.companyName = cell.model.companyName;
    vc.country = _countryCode;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)trademarkListWithSearchCompanyTableViewCell:(SearchCompanyTableViewCell *)cell
{
    ClassificationQueryViewController *vc = [[ClassificationQueryViewController alloc]initWithNibName:@"ClassificationQueryViewController" bundle:nil];
    vc.type =2;
    vc.companyName = cell.model.companyName;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)copyrightListWithSearchCompanyTableViewCell:(SearchCompanyTableViewCell *)cell
{
    CompanyCopyrightViewController *vc = [[CompanyCopyrightViewController alloc]initWithNibName:@"CompanyCopyrightViewController" bundle:nil];
    vc.companyName = cell.model.companyName;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark filter
- (IBAction)search:(id)sender {
    
    [MyApp.window addSubview:self.filterBgView];
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 1;
        self.filterWindow.frame = CGRectMake(ScreenWidth-CurrentFilterWidth, 0, CurrentFilterWidth, ScreenHeight);
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
        _filterWindow = [[UIWindow alloc]initWithFrame:CGRectMake(100+ScreenWidth, 0, CurrentFilterWidth, ScreenHeight)];
        
        _filterWindow.windowLevel = UIWindowLevelNormal;
        _filterWindow.hidden = NO;
        [_filterWindow makeKeyAndVisible];
        _filterWindow.backgroundColor = [UIColor whiteColor];
        
        _filterWindow.rootViewController = self.filterVC;
    }
    return _filterWindow;
}
-(FilterCountryViewController *)filterVC
{
    if (!_filterVC) {
        _filterVC = [[FilterCountryViewController alloc]initWithNibName:@"FilterCountryViewController" bundle:nil];
        _filterVC.type = self.type;
        _filterVC.view.frame = CGRectMake(0, 0, CurrentFilterWidth, ScreenHeight);
        __weak typeof(self) weakSelf = self;
        
        _filterVC.sureSelBlock = ^(BOOL ischina, NSString *addrcodes, NSString *typecodes) {
            if (ischina) {
                _countryCode = @"CHN";
                _provinceName = addrcodes;
                if ([addrcodes isEqualToString:@"全国"]) {
                    _provinceName = @"";
                }
            }
            else{
                _provinceName = @"";
                _countryCode = addrcodes;
            }
            _pkindStr = typecodes;
            [weakSelf hiddenFilter];
        };
        _filterVC.selTrademarkTypeBlock = ^(NSString *typeStr) {
            _trademarkType = typeStr;
            [weakSelf hiddenFilter];
        };
    }
    return _filterVC;
}

-(void)hiddenFilter
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth+100, 0, CurrentFilterWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        self.filterWindow = nil;
        [self loadDataRefresh:YES];
    }];

}

-(void)filterBgViewTab
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth+100, 0, CurrentFilterWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        self.filterWindow = nil;
    }];
}


-(void)clearTextField
{
    self.searchTextField.text = @"";
    [self.associateView removeFromSuperview];
}

#pragma mark 模糊提示框
-(AssociateView *)associateView
{
    if (!_associateView) {
        _associateView = [[AssociateView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) type:self.type presentView:self.view];
        _associateView.delegate = self;
    }
    return _associateView;
}

-(void)associateView:(AssociateView *)view didSelectedCompanyName:(NSString *)companyName
{
    self.searchTextField.text = companyName;
    self.searchStr = companyName;
    [self loadDataRefresh:YES];
}


-(void)associateView:(AssociateView *)view didSelectedKeyStr:(NSString *)keyStr
{
    self.searchTextField.text = keyStr;
    self.searchStr = keyStr;
    [self loadDataRefresh:YES];
}
-(void)duringScrolling
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}
- (IBAction)valueChange:(id)sender {
    if (self.type == HotSearchViewTypePatent) {
        NSLog(@"%@",self.searchTextField.text);
        if (self.searchTextField.text.length>=4) {
            [self.associateView searchStrChange:self.searchTextField.text];
        }
        else
        {
            [self.associateView removeFromSuperview];
        }
    }
}
@end
