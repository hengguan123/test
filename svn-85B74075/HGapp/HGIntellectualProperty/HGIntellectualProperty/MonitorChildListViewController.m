//
//  MonitorChildListViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MonitorChildListViewController.h"
#import "PatentTableViewCell.h"
#import "TrademarkTableViewCell.h"
#import "MonitorCopyrightTableViewCell.h"
#import "CopyrightDetailsViewController.h"

@interface MonitorChildListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *filterBgView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MonitorChildListViewController
{
    int _page;
    BOOL _isLast;
    NSInteger _selType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    _selType = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"PatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TrademarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"TrademarkTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MonitorCopyrightTableViewCell" bundle:nil] forCellReuseIdentifier:@"MonitorCopyrightTableViewCell"];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    
    [self loadDataRefresh:YES];

}

-(void)loadDataRefresh:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        _isLast = NO;
        [self.dataArray removeAllObjects];
        
    }
    else
    {
        _page++;
    }
    if (_isLast) {
        [SVProgressHUD showInfoWithStatus:@"到底啦"];
        _page--;
        [self.tableView.mj_footer endRefreshing];
    }
    else
    {
        [RequestManager getMonitorContentListWithMonitorId:self.model.monitorId page:_page monitorType:[NSString stringWithFormat:@"%ld",_selType] companyName:self.model.companyName successHandler:^(BOOL isLast, NSArray *array) {
            _isLast = isLast;
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (_page == 1) {
                [self.tableView setContentOffset:CGPointMake(0, 0)];
            }
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        } errorHandler:^(NSError *error) {
            
        } ];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)filter:(id)sender {
    CGRect frame = self.filterBgView.frame;
    if (frame.origin.y==0) {
        frame.origin.y=-44;
    }
    else{
        frame.origin.y =0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.filterBgView.frame = frame;
    }];
    
}
- (IBAction)selType:(UIButton *)sender {
    
    for (UIView *view in self.filterBgView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn == sender) {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    _selType = sender.tag -100;
    CGRect frame = self.filterBgView.frame;
    frame.origin.y =-44;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.filterBgView.frame = frame;
    }];
    
    [self loadDataRefresh:YES];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MonitorContentModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model.monitorType isEqualToString:@"1"]) {
        PatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatentTableViewCell"];
        cell.moniModel = model;
        return cell;
    }
    else if ([model.monitorType isEqualToString:@"2"])
    {
        TrademarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrademarkTableViewCell"];
        cell.moniModel = model;
        return cell;
    }
    else if ([model.monitorType isEqualToString:@"3"])
    {
        MonitorCopyrightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorCopyrightTableViewCell"];
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MonitorContentModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model.monitorType isEqualToString:@"1"]) {
        NSString *pkind ;
        if ([model.busiType isEqualToString:@"YWLX01-04-01"]) {
            pkind = @"A";
        }
        else if ([model.busiType isEqualToString:@"YWLX01-04-03"])
        {
            pkind = @"D";
        }
        else if ([model.busiType isEqualToString:@"YWLX01-04-02"])
        {
            pkind = @"U";
        }
        
        [CutoverManager openPatendDetailWithFromController:self techId:model.uniquelyid physicDb:model.dbName PKINDS:pkind monitorId:model.monitorId title:nil subTitle:nil share:NO];
    }
    else if ([model.monitorType isEqualToString:@"2"])
    {
        
    }
    else if ([model.monitorType isEqualToString:@"3"])
    {
        
//        CopyrightDetailsViewController *vc = [[CopyrightDetailsViewController alloc]initWithNibName:@"CopyrightDetailsViewController" bundle:nil];
//        vc.regId = model.uniquelyid;
//        [self showViewController:vc sender:self];
    }
}






@end
