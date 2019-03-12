//
//  AttentionListViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/31.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AttentionListViewController.h"
#import "AttentionTableViewCell.h"
#import "InformationViewController.h"

@interface AttentionListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *noResultView;
@end

@implementation AttentionListViewController
{
    int _page;
    BOOL _isLast;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBarBg"]]];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(0);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        [RequestManager getAttentionListWithPage:_page SuccessHandler:^(BOOL isLast, NSArray *array) {
            [self.dataArray removeAllObjects];
            _isLast = isLast;
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (array.count==0) {
                [self.view addSubview:self.noResultView];
            }
            else
            {
                [self.noResultView removeFromSuperview];
            }
        } errorHandler:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
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
            [RequestManager getAttentionListWithPage:_page SuccessHandler:^(BOOL isLast, NSArray *array) {
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

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor =UIColorFromRGB(0xf2f2f2);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"AttentionTableViewCell" bundle:nil] forCellReuseIdentifier:@"AttentionTableViewCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData:YES];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadData:NO];
        }];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentionTableViewCell"];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([model.flag isEqualToString:@"0"]) {
        [RequestManager removeLittleRedDotWith:model.addrName source:model.departName successHandler:^(BOOL success) {
            
        } errorHandler:^(NSError *error) {
            
        }];
    }
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InformationViewController *vc = [main instantiateViewControllerWithIdentifier:@"InformationViewController"];
    vc.model = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

-(UIView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, ScreenWidth)];
//        _noResultView.backgroundColor = MainColor;
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [_noResultView addSubview:imageView];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [UIImage imageNamed:@"未关注"];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 130));
            make.centerX.equalTo(_noResultView.mas_centerX).with.offset(0);
            make.top.equalTo(_noResultView.mas_top).with.offset(0);
        }];
        
        UILabel *lab =[[UILabel alloc]init];
        [_noResultView addSubview:lab];
        lab.textAlignment = 1;
        lab.text =@"您还没有关注过任何机构！何不去逛逛~";
        lab.numberOfLines = 0;
        lab.textColor = UIColorFromRGB(0x999999);
        lab.font = [UIFont systemFontOfSize:14];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 30));
            make.top.equalTo(_noResultView.mas_top).with.offset(140);
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        [_noResultView addSubview:btn];
        [btn setTitle:@"去逛逛" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.borderWidth = 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        btn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.top.equalTo(_noResultView.mas_top).with.offset(180);
            make.centerX.equalTo(_noResultView.mas_centerX).with.offset(0);

        }];
        [btn addTarget:self action:@selector(gotoList) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _noResultView;
}

-(void)gotoList
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InformationViewController *vc = [main instantiateViewControllerWithIdentifier:@"InformationViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
