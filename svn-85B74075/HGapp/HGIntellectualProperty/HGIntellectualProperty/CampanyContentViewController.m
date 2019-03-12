//
//  CampanyContentViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/11.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CampanyContentViewController.h"
#import "PatentTableViewCell.h"
#import "TrademarkTableViewCell.h"
#import "SoftwareCopyrightTableViewCell.h"
#import "WorksCopyrightTableViewCell.h"

@interface CampanyContentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *filterBgView;

@property (nonatomic,strong)NSMutableArray *patentArray;
@property (nonatomic,strong)NSMutableArray *trademarkArray;
@property (nonatomic,strong)NSMutableArray *copyrightArraySoftware;
@property (nonatomic,strong)NSMutableArray *copyrightArrayWorks;


@property (weak, nonatomic) IBOutlet UIImageView *monitorImageView;
@property (weak, nonatomic) IBOutlet UILabel *monitorStatusLab;


@end

@implementation CampanyContentViewController
{
    NSInteger _currentType;
    int _page;
    BOOL _isLast;
    NSInteger _selType;
    BOOL _monitorStatus;
    NSNumber *_monitorId;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self loadDataRefresh:YES];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];
    
    
}

- (void)loadDataRefresh:(BOOL)refresh
{
    if (refresh) {//刷新
        if (_selType ==0) {//没筛选
            _currentType = 1;
        }
        else//筛选
        {
            _currentType = _selType;
        }
        _page = 1;
        _isLast = NO;
        [self.copyrightArraySoftware removeAllObjects];
        [self.copyrightArrayWorks removeAllObjects];
        [self.trademarkArray removeAllObjects];
        [self.patentArray removeAllObjects];
        [self.tableView reloadData];
    }
    else//加载更多
    {
        if (_isLast) {//是最后一页
            if (_selType==0) {//没筛选
                if (_currentType>=3) {
                    [SVProgressHUD showInfoWithStatus:@"到底了"];
                    [self.tableView.mj_footer endRefreshing];
                    return;
                }
                else{
                    _currentType++;
                    _page = 1;
                    _isLast = NO;
                }
                
            }
            else //筛选
            {
                [SVProgressHUD showInfoWithStatus:@"到底了"];
                [self.tableView.mj_footer endRefreshing];
                return;
            }
        }
        else
        {
            _page++;
        }
    }
    if (_currentType ==1) {
        [self loadPatentList];
    }
    else if(_currentType ==2)
    {
        [self loadTrademarkList];
    }
//    else if (_currentType==3)
//    {
//        [self loadCopyrightList];
//    }
}
-(void)loadPatentList
{
    [RequestManager getCompanyPatentListWithCompany:self.model.companyName page:_page country:self.country pkind:@"" successHandler:^(BOOL isLast, NSArray *array,NSNumber *total) {
        _isLast = isLast;
        if (isLast) {
            if (_selType==0) {
                _page = 1;
                _currentType = 2;
                [self loadTrademarkList];
            }
        }
        [self.patentArray addObjectsFromArray:array];
        [self.tableView reloadData];
        if (_page == 1) {
            [self.tableView setContentOffset:CGPointMake(0, 0)];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } errorHandler:^(NSError *error) {
        
    }];
}
-(void)loadTrademarkList
{
    [RequestManager getCompanyTrademarkListWithCompany:self.model.companyName page:_page successHandler:^(BOOL isLast, NSArray *array,NSNumber *total) {
        _isLast = isLast;
//        if (isLast) {
//            if (_selType==0) {
//                _page = 1;
//                _currentType= 3;
//                [self loadCopyrightList];
//            }
//        }
        [self.trademarkArray addObjectsFromArray:array];
        [self.tableView reloadData];
        if (_page == 1&&_selType==2) {
            [self.tableView setContentOffset:CGPointMake(0, 0)];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } errorHandler:^(NSError *error) {
        
    }];
}

-(void)loadCopyrightList
{
    [RequestManager searchSoftwareCopyrightWithParameter:@{
                                                           @"q":self.model.companyName,
                                                           @"c":@"owner",
                                                           @"pageNo":@(_page),
                                                           } successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
        if (isLast) {
            [self loadCopyrightList];

        }
        [self.copyrightArraySoftware addObjectsFromArray:array];
        [self.tableView reloadData];
        if (_page == 1&&_selType==3) {
            [self.tableView setContentOffset:CGPointMake(0, 0)];
        }
    } errorHandler:^(NSError *error) {
        
    }];
}

-(void)loadWorkCopuright
{
    
    [RequestManager searchWorksCopyrightWithParameter:@{
                                                        @"q":self.model.companyName,
                                                        @"c":@"owner",
                                                        @"pageNo":@(_page),
                                                        } successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
        [self.copyrightArrayWorks addObjectsFromArray:array];
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)filter:(UIBarButtonItem *)sender {
    CGRect frame = self.filterBgView.frame;
    if (frame.origin.y==0) {
        frame.origin.y=-44;
    }
    else{
        frame.origin.y =0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.filterBgView.frame = frame;
    }];
}

/// 回首页
- (IBAction)backHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/// 监控
- (IBAction)monitor:(id)sender {
    if ([AppUserDefaults share].isLogin) {
        if (_monitorStatus) {
            if (_monitorId) {
                [SVProgressHUD show];
                [RequestManager deleteMonitorWithMonitorId:_monitorId successHandler:^(BOOL success) {
                    [SVProgressHUD dismiss];
                    self.monitorStatusLab.text = @"监控";
                    self.monitorImageView.image = [UIImage imageNamed:@"未监控"];
                    _monitorStatus = NO;
                } errorHandler:^(NSError *error) {
                    
                }];
            }
            
        }
        else
        {
            [SVProgressHUD show];
            [RequestManager addCompanyToMonitorWithCompanyName:self.model.companyName address:self.model.address country:self.country successHandler:^(NSNumber *monitorId) {
                _monitorId = monitorId;
                [SVProgressHUD dismiss];
                self.monitorStatusLab.text = @"已监控";
                self.monitorImageView.image = [UIImage imageNamed:@"已监控"];
                _monitorStatus = YES;
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
    else
    {
        [self goToLogin];
    }
}
/// 分析
- (IBAction)analyze:(id)sender {
    WebViewController *webview = [[WebViewController alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@/analysis/patAnalyze?content=%@",HTTPURL,self.model.companyName];
    webview.urlStr = url;
    webview.titleStr = @"知产分析";
    [self.navigationController pushViewController:webview animated:YES];
}
- (IBAction)selType:(UIButton *)sender {
    for (UIView *view in self.filterBgView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn == sender) {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    _selType = sender.tag -100;
    CGRect frame = self.filterBgView.frame;
    frame.origin.y =-44;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.filterBgView.frame = frame;
    }];
    
    [self loadDataRefresh:YES];
    
}



#pragma mark tableView
- (NSMutableArray *)patentArray
{
    if (!_patentArray) {
        _patentArray = [NSMutableArray new];
    }
    return _patentArray;
}
-(NSMutableArray *)trademarkArray
{
    if (!_trademarkArray) {
        _trademarkArray = [NSMutableArray new];
    }
    return _trademarkArray;
}
-(NSMutableArray *)copyrightArraySoftware
{
    if (!_copyrightArraySoftware) {
        _copyrightArraySoftware = [NSMutableArray new];
    }
    return _copyrightArraySoftware;
}
-(NSMutableArray *)copyrightArrayWorks
{
    if (!_copyrightArrayWorks) {
        _copyrightArrayWorks = [NSMutableArray new];
    }
    return _copyrightArrayWorks;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.patentArray.count;
    }
    else if (section == 1)
    {
        return self.trademarkArray.count;
    }
    else if (section == 2)
    {
        return self.copyrightArraySoftware.count;
    }
    else if (section == 3)
    {
        return self.copyrightArrayWorks.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [self.tableView registerNib:[UINib nibWithNibName:@"PatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatentTableViewCell"];
        PatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatentTableViewCell"];
        cell.model = [self.patentArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.section ==1)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"TrademarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"TrademarkTableViewCell"];
        
        TrademarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrademarkTableViewCell"];
        cell.model = [self.trademarkArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.section == 2)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"SoftwareCopyrightTableViewCell" bundle:nil] forCellReuseIdentifier:@"SoftwareCopyrightTableViewCell"];
        SoftwareCopyrightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoftwareCopyrightTableViewCell"];
        cell.model = [self.copyrightArraySoftware objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.section == 3)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"WorksCopyrightTableViewCell" bundle:nil] forCellReuseIdentifier:@"WorksCopyrightTableViewCell"];
        WorksCopyrightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorksCopyrightTableViewCell"];
        cell.model = [self.copyrightArrayWorks objectAtIndex:indexPath.row];
        return cell;
    }
    else
        return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PatentModel *model = [self.patentArray objectAtIndex:indexPath.row];
        [CutoverManager openPatendDetailWithFromController:self techId:model.ID physicDb:model.PHYSIC_DB PKINDS:model.PKIND_S monitorId:nil title:model.TITLE subTitle:model.AN share:YES];
    }
    else if (indexPath.section ==1)
    {
        TrademarkModel *model = [self.trademarkArray objectAtIndex:indexPath.row];
        [CutoverManager openTrademarkDetailWithFromController:self regNo:model.regNo intCls:model.intCls name:model.tmName owner:model.applicantCn usrPhone:[AppUserDefaults share].phone];
    }
    else if (indexPath.section==2)
    {
        [CutoverManager openCopyrightDetailWithFromController:self softwareModel:[self.copyrightArraySoftware objectAtIndex:indexPath.row] worksModel:nil];
    }
    else if (indexPath.section == 3)
    {
        [CutoverManager openCopyrightDetailWithFromController:self softwareModel:[self.copyrightArrayWorks objectAtIndex:indexPath.row] worksModel:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 140;
    }
    else if (indexPath.section==1)
    {
        return 140;
    }
    else
    {
        return 190;
    }
}

-(void)goToLogin
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
