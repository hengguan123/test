//
//  Copyright2ViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/24.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "Copyright2ViewController.h"
#import "WorksCopyrightTableViewCell.h"


@interface Copyright2ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,copy)NSString *searchStr;
@property (nonatomic,assign)NSInteger type;
@property (weak, nonatomic) IBOutlet UIView *resultView;

@end

@implementation Copyright2ViewController
{
    int _page;
    BOOL _isLast;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WorksCopyrightTableViewCell" bundle:nil] forCellReuseIdentifier:@"WorksCopyrightTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.searchStr) {
            [self loadDataRefresh:NO];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchWithSearchStr:(NSString *)searchStr type:(NSInteger)type
{
    _searchStr = searchStr;
    _type = type;
    
    [self loadDataRefresh:YES];
    
}



-(void)loadDataRefresh:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        NSDictionary *dict;
        if (self.type==1) {
            dict = @{
                     @"q":self.searchStr?:@"",
                     @"c":@"name",
                     @"pageNo":@(_page),
                     };
        }
        else if (self.type==2)
        {
            dict = @{
                     @"q":self.searchStr?:@"",
                     @"c":@"number",
                     @"pageNo":@(_page),
                     };
        }
        else if (self.type==3)
        {
            dict = @{
                     @"q":self.searchStr?:@"",
                     @"c":@"owner",
                     @"pageNo":@(_page),
                     };
        }
        [RequestManager searchWorksCopyrightWithParameter:dict successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            if (array.count==0) {
                self.resultView.hidden = NO;
            }
            else
            {
                self.resultView.hidden = YES;
            }
            [self.tableView.mj_header endRefreshing];
            _isLast = isLast;
            if (self.numBlock) {
                self.numBlock(total);
            }
        } errorHandler:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];

        }];
    }
    else
    {
        if (_isLast) {
            [SVProgressHUD showInfoWithStatus:@"到底啦"];
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            _page++;
            NSDictionary *dict;
            if (self.type==1) {
                dict = @{
                         @"q":self.searchStr?:@"",
                         @"c":@"name",
                         @"pageNo":@(_page),
                         };
            }
            else if (self.type==2)
            {
                dict = @{
                         @"q":self.searchStr?:@"",
                         @"c":@"number",
                         @"pageNo":@(_page),
                         };
            }
            else if (self.type==3)
            {
                dict = @{
                         @"q":self.searchStr?:@"",
                         @"c":@"owner",
                         @"pageNo":@(_page),
                         };
            }
            [RequestManager searchWorksCopyrightWithParameter:dict successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                [self.tableView.mj_footer endRefreshing];
                _isLast = isLast;
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_footer endRefreshing];

            }];
        }
    }
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
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorksCopyrightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorksCopyrightTableViewCell"];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CutoverManager openCopyrightDetailWithFromController:self softwareModel:nil worksModel:[self.dataArray objectAtIndex:indexPath.row]];
}

@end
