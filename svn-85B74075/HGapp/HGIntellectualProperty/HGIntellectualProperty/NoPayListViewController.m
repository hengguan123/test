//
//  NoPayListViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "NoPayListViewController.h"
#import "PayMentTableViewCell.h"
#import "PayViewController.h"

#import "NoPayInfoTableViewController.h"
#import "OrderInfoTableViewController.h"


@interface NoPayListViewController ()<UITableViewDelegate,UITableViewDataSource,PayMentTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation NoPayListViewController
{
    int _page;
    BOOL _isLast;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PayMentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PayMentTableViewCell"];
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
    
//    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 34)];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadDataRefresh:YES];
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
    
    [RequestManager getNoPayOrderWithPage:_page successHandler:^(BOOL isLast, NSArray *array) {
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
    cell.delegate = self;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)payWithPayMentTableViewCell:(PayMentTableViewCell *)cell
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PayViewController *vc = [main instantiateViewControllerWithIdentifier:@"PayViewController"];
    vc.model = cell.model;
    if (cell.model.errandId) {
        vc.isInside = [AppUserDefaults share].isInside;
    }
    else
    {
        vc.isInside = @"0";
    }
    [self showViewController:vc sender:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = [self.dataArray objectAtIndex:indexPath.row];
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (model.errandId) {
        NoPayInfoTableViewController *vc = [main instantiateViewControllerWithIdentifier:@"NoPayInfoTableViewController"];
        vc.model = model;
        vc.payStatus = YES;
        vc.fromList = self;
        [self showViewController:vc sender:self];
    }
    else
    {
        OrderInfoTableViewController *vc = [main instantiateViewControllerWithIdentifier:@"OrderInfoTableViewController"];
        vc.model = model;
        vc.payStatus = YES;
        vc.fromList = self;
        [self showViewController:vc sender:self];
    }
    
}

/**
 *  只要实现了这个方法，左滑出现按钮的功能就有了
 (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        OrderModel *model = [self.dataArray objectAtIndex:indexPath.row];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"确认删除当前订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [LoadingManager show];
            if (model.errandId) {
                [RequestManager deleteErrandWithErrandId:model.errandId successHandler:^(BOOL success) {
                    [self loadDataRefresh:YES];
                    [LoadingManager dismiss];
                } errorHandler:^(NSError *error) {
                    
                }];
            }
            else
            {
                [RequestManager deleteOrderWithOrderId:model.orderId orderNum:model.orderNo successHandler:^(BOOL success) {
                    [self loadDataRefresh:YES];
                    [LoadingManager dismiss];
                } errorHandler:^(NSError *error) {
                    [LoadingManager dismiss];
                }];
            }
        }];
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    return @[action1];
}






- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
