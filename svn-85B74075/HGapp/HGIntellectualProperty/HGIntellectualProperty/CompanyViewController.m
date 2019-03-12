//
//  CompanyViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CompanyViewController.h"
#import "PatentTableViewCell.h"
#import "TrademarkTableViewCell.h"

@interface CompanyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation CompanyViewController
{
    int _page;
    BOOL _isLast;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.companyName;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self loadDataRefresh:YES];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(void)loadDataRefresh:(BOOL)refresh
{
    if (refresh) {
        _page =1;
        if (self.type == 1) {
            [RequestManager getCompanyPatentListWithCompany:self.companyName page:_page country:self.dbname?:@"" pkind:@"" successHandler:^(BOOL isLast, NSArray *array,NSNumber *total) {
                self.tableView.tableHeaderView =[[ResultNumView alloc]initWithNum:total];
                _isLast = isLast;
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
            }];
        }
        else
        {
            [RequestManager getCompanyTrademarkListWithCompany:self.companyName page:_page successHandler:^(BOOL isLast, NSArray *array ,NSNumber *total) {
                self.tableView.tableHeaderView = [[ResultNumView alloc]initWithNum:total];
                _isLast = isLast;
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
            }];
        }
    }
    else
    {
        if (_isLast) {
            [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            _page++;
            if (self.type == 1) {
                [RequestManager getCompanyPatentListWithCompany:self.companyName page:_page country:self.dbname?:@"" pkind:@"" successHandler:^(BOOL isLast, NSArray *array,NSNumber *total) {
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
                [RequestManager getCompanyTrademarkListWithCompany:self.companyName page:_page successHandler:^(BOOL isLast, NSArray *array,NSNumber *total) {
                    _isLast = isLast;
                    [self.dataArray addObjectsFromArray:array];
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                } errorHandler:^(NSError *error) {
                    [self.tableView.mj_header endRefreshing];
                }];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        [self.tableView registerNib:[UINib nibWithNibName:@"PatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatentTableViewCell"];
        PatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatentTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (self.type == 2)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"TrademarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"TrademarkTableViewCell"];
        
        TrademarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrademarkTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
        
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        PatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
        
        [CutoverManager openPatendDetailWithFromController:self techId:model.ID physicDb:model.PHYSIC_DB PKINDS:model.PKIND_S monitorId:nil title:model.TITLE subTitle:model.AN share:YES];
    }
    else
    {
        TrademarkModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [CutoverManager openTrademarkDetailWithFromController:self regNo:model.regNo intCls:model.intCls name:model.tmName owner:model.applicantCn usrPhone:[AppUserDefaults share].phone];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
