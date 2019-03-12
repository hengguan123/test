//
//  HotSearchView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HotSearchView.h"
#import "RequestURL.h"
@interface HotSearchView ()

@property(nonatomic,strong)UILabel *headerTitleLab;

@property(nonatomic,strong)NSArray *dataArray;

@end
@implementation HotSearchView
{
    UIButton *_deleteBtn;
    HotSearchViewType _type;
}
-(void)defaultConfigType:(HotSearchViewType)type
{
    _type = type;
    self.dataSource = self;
    self.delegate = self;
    if (@available(iOS 11.0, *))
    {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.headerTitleLab];
    _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, 0, 44, 50)];
    [_deleteBtn setImage:[UIImage imageNamed:@"deleteHistory"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
//    _deleteBtn.backgroundColor = [UIColor redColor];
    [headerView addSubview:_deleteBtn];
    self.headerTitleLab.text = @"热门搜索";
    self.tableHeaderView = headerView;
    self.tableFooterView = [UIView new];
    [self reloadDataWithType:type];
    
}
-(void)clearHistory
{
    [[DBManager share]deleteDataWithTableType:_type];
    [self reloadDataWithType:_type];
}
-(void)reloadDataWithType:(int)type
{
    self.dataArray = [[DBManager share]getDataWithTableType:type];
    if (self.dataArray.count==0) {
        self.headerTitleLab.text = @"热门搜索";
        _deleteBtn.hidden = YES;
        [RequestManager hotSearchWithType:[NSString stringWithFormat:@"%d",type] successHandler:^(NSArray *array) {
            self.dataArray = array;
            [self reloadData];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        _deleteBtn.hidden = NO;
        self.headerTitleLab.text = @"搜索历史";
        [self reloadData];
    }
}

-(UILabel *)headerTitleLab
{
    if (!_headerTitleLab) {
        _headerTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 50)];
        _headerTitleLab.font = [UIFont systemFontOfSize:12];
        _headerTitleLab.textColor = UIColorFromRGB(0x333333);
    }
    return _headerTitleLab;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotSearchModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(didSelectedKeyWord:)]) {
        [self.actionDelegate didSelectedKeyWord:model.keyword];
    }
    [self reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotSearchCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotSearchCell"];
        cell.preservesSuperviewLayoutMargins = NO;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.contentView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    HotSearchModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.keyword;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.actionDelegate) {
        [self.actionDelegate duringScrolling];
    }
}


@end
