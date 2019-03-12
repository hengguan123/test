//
//  MyBusinessViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/4/26.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "MyBusinessViewController.h"
#import "MyBusinessTableViewCell.h"
#import "BusinessDetailViewController.h"
#import "NoPayInfoTableViewController.h"
@interface MyBusinessViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation MyBusinessViewController
{
    BOOL _isLast;
    NSInteger _page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的业务";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyBusinessTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyBusinessTableViewCell"];
    [self loadDataRefresh:YES];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadDataRefresh:(BOOL)refresh{
    if (refresh) {
        _page = 1;
        [RequestManager getMyBusinessListWithPage:_page successHandler:^(BOOL isLast, NSArray *array) {
            _isLast = isLast;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        if (_isLast) {
            [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            _page ++;
            [RequestManager getMyBusinessListWithPage:_page successHandler:^(BOOL isLast, NSArray *array) {
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
    // Dispose of any resources that can be recreated.
}
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
    MyBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBusinessTableViewCell"];
    cell.orderModel = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.errandId) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NoPayInfoTableViewController *vc = [main instantiateViewControllerWithIdentifier:@"NoPayInfoTableViewController"];
        vc.model = model;
        vc.payStatus = NO;
        vc.fromList = self;
        [self showViewController:vc sender:self];
    }
    else
    {
        BusinessDetailViewController *vc = [[BusinessDetailViewController alloc]initWithNibName:@"BusinessDetailViewController" bundle:nil];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
