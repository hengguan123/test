//
//  InformationViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "InformationViewController.h"
#import "HeadlinesTableViewCell.h"
#import "FilterManager.h"
#import "InformationFilterViewController.h"

@interface InformationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)FilterManager *filterManager;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLab;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic,strong)NSMutableArray *otherDataArray;

@end

@implementation InformationViewController
{
    BOOL _isLast;
    int _page;
    int _otherPage;
    NSString *_addr;
    NSString *_pubOrg;
    NSString *_orgType;
    NSString *_timeSort;
    NSString *_searchTitle;
    NSString *_searchInfo;
    BOOL _searchAll;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" font:13 target:self action:@selector(filter:)];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 70)];
    [btn setTitle:@"标题" forState:UIControlStateNormal];
    btn.backgroundColor = MainColor;
    [btn setTitle:@"全文" forState:UIControlStateSelected];
//    [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(searchFrom:) forControlEvents:UIControlEventTouchUpInside];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView =btn;
    self.searchTextField.placeholder = @"请输入搜索关键词";
    self.searchTextField.textColor = UIColorFromRGB(0x666666);
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    if (self.model) {
        _addr = self.model.addrName;
        _pubOrg = self.model.departName;
    }
    else
    {
        _addr = @"";
        _pubOrg = @"";
    }
    _orgType = @"";
    _timeSort = @"";
    _searchTitle = @"";
    _searchInfo = @"";
    _otherPage = 0;
    [LoadingManager show];
    [self loadDataRefresh:YES];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];
}

///切换搜索源
-(void)searchFrom:(UIButton *)btn
{
    btn.selected  = !btn.isSelected;
    _searchAll = btn.isSelected;
}


- (IBAction)timeSort:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        _timeSort = @"0";
    }
    else
    {
        _timeSort = @"1";
    }
    [self loadDataRefresh:YES];
}

- (void)filter:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:HomeFilterReloaddateNoti object:nil];
    [self.filterManager show];
}

#pragma mark tableView

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(NSMutableArray *)otherDataArray
{
    if (!_otherDataArray) {
        _otherDataArray = [NSMutableArray new];
    }
    return _otherDataArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }
    else
    {
        return self.otherDataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadlinesTableViewCell" bundle:nil] forCellReuseIdentifier:@"HeadlinesTableViewCell"];
    HeadlinesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadlinesTableViewCell"];
    if (indexPath.section == 0) {
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
    }
    else
    {
        cell.model = [self.otherDataArray objectAtIndex:indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
    {
        if (self.otherDataArray.count) {
            return 40;
        }
        else
            return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1&&self.otherDataArray.count) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        view.backgroundColor = UIColorFromRGB(0xf2f2f2);
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 30)];
        lab.text = @"———— 以下为其他地区部门信息 ————";
        lab.textColor = MainColor;
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = 1;
        [view addSubview:lab];
        
        return view;
    }
    else
    {
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeadlinesModel *model;
    if (indexPath.section == 0) {
        model = [self.dataArray objectAtIndex:indexPath.row];
    }
    else
    {
        model = [self.otherDataArray objectAtIndex:indexPath.row];
    }
    HTMLViewController *view = [[HTMLViewController alloc]init];
    view.htmlUrl = [HTTPURL stringByAppendingFormat:@"/granoti/info?id=%@&addr=%@&source=%@",model.articleId,model.addr,model.source];
    view.titleStr = model.title;
    view.canShare = YES;
    view.addr = model.addr;
    view.source = model.source;
    view.pubtime = model.pubDate;
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];

}

-(void)loadDataRefresh:(BOOL)refresh
{
    if (_searchAll) {
        _searchInfo = _searchTitle;
    }
    else
    {
        _searchInfo = @"";
    }
    if (refresh) {
        _otherPage = 0;
        _page = 1;
        [self.otherDataArray removeAllObjects];
        
        [RequestManager searchPolicyInformationWithNotEqual:NO addr:_addr source:_pubOrg title:_searchTitle info:_searchInfo orderBy:_timeSort sourceType:_orgType page:_page successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
            _isLast = isLast;
            [self.dataArray removeAllObjects];
            [LoadingManager dismiss];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.totalNumLab.text = [NSString stringWithFormat:@"共检索到%@条结果",total];
            if ([total integerValue]<6) {
                [self getOtherHeaderlinesFirst:YES];
            }
        } errorHandler:^(NSError *error) {
            [LoadingManager dismiss];
            [self.tableView.mj_header endRefreshing];
        }];
    }
    else
    {
        if (_isLast) {
            [self getOtherHeaderlinesFirst:NO];
        }
        else
        {
            _page++;
            [RequestManager searchPolicyInformationWithNotEqual:NO addr:_addr source:_pubOrg title:_searchTitle info:_searchInfo orderBy:_timeSort sourceType:_orgType page:_page successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
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

-(void)getOtherHeaderlinesFirst:(BOOL)isFirst
{
    if ([_addr isEqualToString:@""]&&[_pubOrg isEqualToString:@""]) {
        return;
    }
    _otherPage ++ ;
    if (_searchAll) {
        _searchInfo = _searchTitle;
    }
    else
    {
        _searchInfo = @"";
    }
    [RequestManager searchPolicyInformationWithNotEqual:YES addr:_addr source:_pubOrg title:_searchTitle info:_searchInfo orderBy:@"" sourceType:_orgType page:_otherPage successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
        [self.otherDataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } errorHandler:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}


-(FilterManager *)filterManager
{
    if (!_filterManager) {
        InformationFilterViewController *vc = [[InformationFilterViewController alloc]initWithNibName:@"InformationFilterViewController" bundle:nil];
        vc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        __weak typeof(self) weakSelf = self;        
        vc.hiddenBlcok = ^{
            [weakSelf.filterManager hidden];
        };
        
        vc.selFinishBlcok = ^(NSString *orgStr, NSString *areaStr ,NSString *orgTypeStr) {
            NSLog(@"地址:%@\n组织:%@",areaStr,orgStr);
            _addr = areaStr;
            _pubOrg = orgStr;
            _orgType = orgTypeStr;
            [weakSelf.filterManager sureCompletion:^(BOOL finished) {
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
        };
        
        
        _filterManager = [[FilterManager alloc]initWithFilterVc:vc];
        
    }
    return _filterManager;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _searchTitle = textField.text;
    [self loadDataRefresh:YES];
    return YES;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
