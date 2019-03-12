//
//  PaidViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PaidViewController.h"
#import "PayMentTableViewCell.h"
#import "NoPayInfoTableViewController.h"
#import "OrderInfoTableViewController.h"


@interface PaidViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PaidViewController

{
    int _page;
    BOOL _isLast;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PayMentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PayMentTableViewCell"];
    [self loadDataRefresh:YES];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadDataRefresh:(BOOL)refresh
{
    if (refresh) {
        [self.dataArray removeAllObjects];
        _page = 1;
        _isLast = NO;
    }
    else
    {
        _page++;
    }
    if (_isLast) {
        _page--;
        [SVProgressHUD showInfoWithStatus:@"没有更多了"];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    [RequestManager getPaidOrderWithPage:_page successHandler:^(BOOL isLast, NSArray *array) {
        _isLast = isLast;
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } errorHandler:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark tableview

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
    PayMentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayMentTableViewCell"];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    cell.payHidden= YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = [self.dataArray objectAtIndex:indexPath.row];
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (model.errandId) {
        NoPayInfoTableViewController *vc = [main instantiateViewControllerWithIdentifier:@"NoPayInfoTableViewController"];
        vc.model = model;
        [self showViewController:vc sender:self];
    }
    else
    {
        OrderInfoTableViewController *vc = [main instantiateViewControllerWithIdentifier:@"OrderInfoTableViewController"];
        vc.model = model;
        [self showViewController:vc sender:self];
    }
    
}




- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
