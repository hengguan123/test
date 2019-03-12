//
//  CopyrightHotView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CopyrightHotView.h"

@interface CopyrightHotView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation CopyrightHotView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.tableView];
    }
    return self;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"copyhotcell"];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"copyhotcell"];
        cell.preservesSuperviewLayoutMargins = NO;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.contentView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    HotSearchModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.keyword;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotSearchModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedHotStr:)]) {
        [self.delegate didSelectedHotStr:model.keyword];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 24)];
    lab.text = @"热门搜索";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = UIColorFromRGB(0x666666);
    [view addSubview:lab];
    return view;
}

-(void)loadDataWithType:(NSString *)type
{
    self.dataArray = nil;
    [self.tableView reloadData];
    [RequestManager hotSearchWithType:type successHandler:^(NSArray *array) {
        self.dataArray = array;
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        
    }];
}

@end
