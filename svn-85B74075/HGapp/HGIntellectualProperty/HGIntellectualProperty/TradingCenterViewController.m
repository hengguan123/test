//
//  TradingCenterViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/11/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "TradingCenterViewController.h"
#import "BuyInfoTableViewCell.h"


@interface TradingCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UIView *noDataView;

@end

@implementation TradingCenterViewController
{
    int _page;
    BOOL _isLast;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"交易中心";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self.view addSubview:self.tableView];
    [self loadData:YES];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:YES];
    } ];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [self loadData:NO];
    }];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadData:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        [RequestManager getBuyingInformationWithPage:_page businessName:@"" busiQuality:@"9" isMain:YES successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
            _isLast = isLast;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (array.count) {
                [self.noDataView removeFromSuperview];
            }
            else
            {
                [self.view addSubview:self.noDataView];
            }
        } errorHandler:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }
    else
    {
        if (_isLast) {
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"没有更多了"];
        }
        else
        {
            _page++;
            [RequestManager getBuyingInformationWithPage:_page businessName:@"" busiQuality:@"9" isMain:NO successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
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

-(UIView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, ScreenWidth, 180)];
//        _noDataView.backgroundColor = [UIColor redColor];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [_noDataView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(141, 138));
            make.centerX.equalTo(_noDataView.mas_centerX).with.offset(0);
            make.top.mas_equalTo(0);
        }];
        [imageView setImage:[UIImage imageNamed:@"nodata"]];
        
        UILabel *lab = [[UILabel alloc]init];
        [_noDataView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 30));
        }];
        lab.textColor = UIColorFromRGB(0x666666);
        lab.textAlignment = 1;
        lab.font = [UIFont systemFontOfSize:14];
        lab.text = @"你还没有交易信息，快去发布吧";
        
    }
    return _noDataView;
}


#pragma mark  tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"BuyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"BuyInfoTableViewCell"];
    BuyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyInfoTableViewCell"];
    
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyInformationModel *model = [self.dataArray objectAtIndex:indexPath.row];
    HTMLViewController *vc = [[HTMLViewController alloc]init];
    vc.titleStr = @"交易信息";
    vc.htmlUrl = [NSString stringWithFormat:@"%@/business/intentionList?id=%@&usrPhone=%@&busiQuality=9",HTTPURL,model.modelId,[AppUserDefaults share].phone?[AppUserDefaults share].phone:@""];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
