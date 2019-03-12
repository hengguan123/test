//
//  SelProvinceTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SelProvinceTableViewController.h"

@interface SelProvinceTableViewController ()
@property (nonatomic,strong)NSArray *provinceArray;

@end

@implementation SelProvinceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"选择地区";
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.provinceArray = [AppUserDefaults share].provinceArray;
    
    

    [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else
    {
        return self.provinceArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"provinceCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"provinceCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==0) {
        cell.textLabel.text = @"全国";
    }
    else
    {
        AreaModel *model = [self.provinceArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.addrName;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60;
    }
    else
    {
        return 34;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    view.backgroundColor = [UIColor redColor];
    if (section == 0) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 24)];
        lab.text = @"专利类型:";
        [view addSubview:lab];
    }
    else
    {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 24)];
        lab.text = @"所属区域";
        [view addSubview:lab];
    }
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
