//
//  TransactionListViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "TransactionListViewController.h"

@interface TransactionListViewController ()

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation TransactionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
