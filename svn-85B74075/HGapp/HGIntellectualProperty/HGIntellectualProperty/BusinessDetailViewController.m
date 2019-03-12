//
//  BusinessDetailViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/4/27.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "BusinessDetailViewController.h"
#import "BusinessDetailHeaderTableViewCell.h"
#import "BusinessDetailTableViewCell.h"
#import "BusinessProgressViewController.h"

@interface BusinessDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation BusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"业务详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessDetailHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessDetailHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessDetailTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else{
        return self.model.listOrderInfo.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BusinessDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessDetailHeaderTableViewCell"];
        cell.model = self.model;
        return cell;
    }
    else
    {
        BusinessDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessDetailTableViewCell"];
        cell.model = [self.model.listOrderInfo objectAtIndex:indexPath.row];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }
    else
    {
        return 70;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        BusinessProgressViewController *vc = [[BusinessProgressViewController alloc]initWithNibName:@"BusinessProgressViewController" bundle:nil];
        vc.model = [self.model.listOrderInfo objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
