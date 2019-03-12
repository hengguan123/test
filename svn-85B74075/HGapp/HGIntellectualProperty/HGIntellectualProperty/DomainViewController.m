//
//  DomainViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "DomainViewController.h"

@interface DomainViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property(nonatomic,strong)NSArray *fieldArray;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation DomainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择领域";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self loadData];
    
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)loadData
{
    [RequestManager getFieldListSuccessHandler:^(NSArray *array) {
        self.fieldArray = array;
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fieldArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"domaincell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"domaincell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.preservesSuperviewLayoutMargins = NO;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    ErrandClassModel *model = [self.fieldArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.dictionaryName;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ErrandClassModel *model = [self.fieldArray objectAtIndex:indexPath.row];
    if (self.block) {
        self.block(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
