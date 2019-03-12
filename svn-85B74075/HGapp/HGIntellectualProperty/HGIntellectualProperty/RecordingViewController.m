//
//  RecordingViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "RecordingViewController.h"
#import "RecordingTableViewCell.h"


@interface RecordingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation RecordingViewController
{
    BOOL _isLast;
    int _page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecordingTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecordingTableViewCell"];
    [self loadDataRefresh:YES];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];
}


-(void)loadDataRefresh:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        [RequestManager getFundsListWithPage:_page successHandler:^(BOOL isLast,NSArray *array) {
            _isLast = isLast;
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } errorHandler:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }
    else
    {
        if (_isLast) {
            [SVProgressHUD showInfoWithStatus:@"到底儿啦"];
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            _page +=1;
            [RequestManager getFundsListWithPage:_page successHandler:^(BOOL isLast,NSArray *array) {
                _isLast = isLast;
                [_dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordingTableViewCell"];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordingModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model.optType intValue]==1) {
        model.open = !model.isOpen;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordingModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.isOpen) {
        return 160;
    }
    else
    {
        return 110;
    }
}

@end
