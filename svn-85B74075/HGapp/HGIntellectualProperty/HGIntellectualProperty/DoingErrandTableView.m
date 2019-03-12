//
//  DoingErrandTableView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/8/24.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "DoingErrandTableView.h"
#import "MyGrapTableViewCell.h"


@interface DoingErrandTableView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation DoingErrandTableView
{
    int _page;
    BOOL _isLast;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if(self = [super initWithFrame:frame style:style])
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MyGrapTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyGrapTableViewCell"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self loadDataRefresh:YES];
    }
    return self;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(void)loadDataRefresh:(BOOL)refresh{
    if (refresh) {
        _page = 1;
        [RequestManager getMyGrabListWithPage:_page dwellAddr:_cityCode sortType:@"1" errandType:_typeCode successHandler:^(BOOL isLast, NSArray *array) {
            [self.dataArray removeAllObjects];
            _isLast = isLast;
            [self.dataArray addObjectsFromArray:array];
            [self reloadData];
            [SVProgressHUD dismiss];
            [self.mj_header endRefreshing];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        _page ++;
        [RequestManager getMyGrabListWithPage:_page dwellAddr:_cityCode sortType:@"1" errandType:_typeCode successHandler:^(BOOL isLast, NSArray *array) {
            _isLast = isLast;
            [self.dataArray addObjectsFromArray:array];
            [self reloadData];
            [self.mj_footer endRefreshing];
        } errorHandler:^(NSError *error) {
            
        }];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyGrapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyGrapTableViewCell"];
    cell.type = ErrandTableViewCellTypeMyGrap;
    cell.delegate = self;
//    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

@end