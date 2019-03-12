//
//  OrderInfoTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OrderInfoTableViewController.h"
#import "ChildOrderTableViewCell.h"
#import "PayViewController.h"

@interface OrderInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation OrderInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView registerNib:[UINib nibWithNibName:@"ChildOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChildOrderTableViewCell"];
    self.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",self.model.orderNo];
    if (self.payStatus) {
        self.orderTimeLab.text = [NSString stringWithFormat:@"创建时间:%@",self.model.createTime];
        
    }
    else
    {
        self.orderTimeLab.text = [NSString stringWithFormat:@"支付时间:%@",self.model.payTime];
        self.tableView.tableFooterView = [UIView new];

    }
    self.priceLab.text = [NSString stringWithFormat:@"总额:%@元",self.model.orderPrice];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.listOrderInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChildOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildOrderTableViewCell"];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.model = [self.model.listOrderInfo objectAtIndex:indexPath.row];
    return cell;
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pay:(id)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PayViewController *vc = [main instantiateViewControllerWithIdentifier:@"PayViewController"];
    vc.fromList = self.fromList;
    vc.model = self.model;
    vc.isInside = @"0";
    [self showViewController:vc sender:self];
}
- (IBAction)chat:(id)sender {
    WebViewController *vc= [[WebViewController alloc]init];
    vc.titleStr = @"咨询平台";
    vc.urlStr = CustomerServiceUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
