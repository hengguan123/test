//
//  ToBeEvaluatedListViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ToBeEvaluatedListViewController.h"
#import "MyGrapTableViewCell.h"
#import "WriteReviewTableViewController.h"

@interface ToBeEvaluatedListViewController ()<UITableViewDelegate,UITableViewDataSource,MyGrapTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation ToBeEvaluatedListViewController
{
    int _page;
    BOOL _isLast;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyGrapTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyGrapTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    [self loadDataWithRefresh:YES];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithRefresh:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithRefresh:NO];
    }];
}


-(void)loadDataWithRefresh:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        [RequestManager getBeEvaluatedListPage:_page successHandler:^(BOOL isLast, NSArray *array) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            _isLast = isLast;
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
            [RequestManager getBeEvaluatedListPage:_page successHandler:^(BOOL isLast, NSArray *array) {
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                _isLast = isLast;
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

#pragma mark ---tableView
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
    MyGrapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyGrapTableViewCell"];
    cell.type = ErrandTableViewCellTypeToCommented;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RobbedDetialTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RobbedDetialTableViewController"];
    vc.type = GrabDetialFunctionTypeComment;
    vc.model = [self.dataArray objectAtIndex:indexPath.row];
    vc.fromList = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)writeReviewTableViewCell:(MyGrapTableViewCell *)cell
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WriteReviewTableViewController *vc = [story instantiateViewControllerWithIdentifier:@"WriteReviewTableViewController"];
    vc.model = cell.model;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
