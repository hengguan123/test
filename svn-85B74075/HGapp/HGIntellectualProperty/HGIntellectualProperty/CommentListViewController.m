//
//  CommentListViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/19.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentTableViewCell.h"

@interface CommentListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation CommentListViewController
{
    int _page;
    BOOL _isLast;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    if (self.model) {
        [self loadDataWithRefresh:YES];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadDataWithRefresh:YES];
        }];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadDataWithRefresh:NO];
        }];
    }
    else
    {
        [self loadMyDataWithRefresh:YES];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadMyDataWithRefresh:YES];
        }];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadMyDataWithRefresh:NO];
        }];
    }
    
}


-(void)loadMyDataWithRefresh:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        [RequestManager getMyCommentListWithPage:_page successHandler:^(BOOL isLast, NSArray *array) {
            [self.dataArray removeAllObjects];
            _isLast = isLast;
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } errorHandler:^(NSError *error) {
            
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
            _page++;
            [RequestManager getMyCommentListWithPage:_page successHandler:^(BOOL isLast, NSArray *array) {
                _isLast = isLast;
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];

            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
}

-(void)loadDataWithRefresh:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        [RequestManager getCommentListWithPage:_page faciId:self.model.usrId successHandler:^(BOOL isLast, NSArray *array) {
            [self.dataArray removeAllObjects];
            _isLast = isLast;
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
        } errorHandler:^(NSError *error) {
            
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
            [RequestManager getCommentListWithPage:_page faciId:self.model.usrId successHandler:^(BOOL isLast, NSArray *array) {
                _isLast = isLast;
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
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
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
    //        cell.delegate = self;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}




@end
