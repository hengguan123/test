//
//  PendingPaymentViewController.m
//  HGIntellectualProperty
//  购物车
//  Created by 耿广杰 on 2017/6/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PendingPaymentViewController.h"
#import "ShoppingTableViewCell.h"
#import "PayViewController.h"
#import "NoPayInfoTableViewController.h"


@interface PendingPaymentViewController ()<UITableViewDelegate,UITableViewDataSource,ShoppingTableViewCellDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *selAllBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *settlementBtn;

@property (nonatomic,strong)NSMutableArray *selArray;

@end

@implementation PendingPaymentViewController
{
    BOOL _isLast;
    int _page;
    NoPayModel *_currentModel;
    NSInteger _indexPathRow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShoppingTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    
    self.tableView.tableFooterView = [UIView new];
    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self loadDataRefresh:NO];
//    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [LoadingManager show];
    [self loadDataRefresh:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}

- (void)loadDataRefresh:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        [RequestManager getNoPayListWithPage:_page successHandler:^(NSArray *array) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self checkSelAll];
            [self.tableView.mj_header endRefreshing];
            [LoadingManager dismiss];
        } errorHandler:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingTableViewCell"];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.delegate = self;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tapSelBtnShoppingTableViewCell:(ShoppingTableViewCell *)cell
{
    [self checkSelAll];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoPayModel *model = [self.dataArray objectAtIndex:indexPath.row];
    model.selected = !model.isSelected;
    [tableView reloadData];
    [self checkSelAll];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 删除数据源的数据,self.cellData是你自己的数据
        NoPayModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [self deleteSingleWithId:[NSString stringWithFormat:@"%@",model.modelId]];
        NSLog(@"删除");
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";//默认文字为 Delete
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)settlement:(id)sender {
    
    if (self.selArray.count) {
        NSMutableString *ids = [NSMutableString new];
        for (NoPayModel *model in self.selArray) {
            if ([ids isEqualToString:@""]) {
                [ids appendFormat:@"%@",model.modelId];
            }
            else
            {
                [ids appendFormat:@",%@",model.modelId];
            }
        }
        [LoadingManager show];
        [RequestManager getOrderNumWithShopIds:ids userType:MyApp.userInfo.usrType successHandler:^(NSDictionary *orderInfo) {
            [self.selArray removeAllObjects];
            [LoadingManager dismiss];
            [self gotoPayWithInfo:orderInfo];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"请先勾选结算项目"];
    }
    
}

-(void)gotoPayWithInfo:(NSDictionary *)dict
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PayViewController *vc = [main instantiateViewControllerWithIdentifier:@"PayViewController"];
    OrderModel *model = [OrderModel new];
    model.orderPrice = [dict objectForKey:@"orderPrice"];
    model.title = [dict objectForKey:@"orderTitle"];
    model.orderNo = [dict objectForKey:@"orderNo"];
    model.orderId = [dict objectForKey:@"orderId"];
    vc.model = model;
    vc.isInside = @"0";
    [self showViewController:vc sender:self];
}

-(NSMutableArray *)selArray
{
    if (!_selArray) {
        _selArray = [NSMutableArray new];
    }
    return _selArray;
}
- (IBAction)selAll:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSInteger _totalPrcie=0;
    [self.selArray removeAllObjects];
    for (NoPayModel *model in self.dataArray) {
        model.selected = sender.selected;
        if (sender.isSelected) {
            _totalPrcie += [model.price integerValue];
            
            [self.selArray addObjectsFromArray:self.dataArray];
        }
    }
    self.totalPriceLab.text = [NSString stringWithFormat:@"%ld元",_totalPrcie];
    [self.tableView reloadData];
}
- (void)checkSelAll
{
    BOOL _selAll = YES;
    [self.selArray removeAllObjects];
    NSInteger _totalPrcie=0;
    for (NoPayModel *model in self.dataArray) {
        if (model.isSelected) {
            [self.selArray addObject:model];
            _totalPrcie += [model.price integerValue];
        }
        else
        {
            _selAll = NO;
            self.selAllBtn.selected = NO;
        }
    }
    if (_selAll) {
        self.selAllBtn.selected = YES;
    }
    self.totalPriceLab.text = [NSString stringWithFormat:@"%ld元",_totalPrcie];
}
- (IBAction)deleteSel:(id)sender {
    if (self.selArray.count) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"确认删除选中项目吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        UIAlertAction *sureSction =[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self delShop];
        }];
        [alert addAction:sureSction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"请先勾选删除项目"];
    }
}

-(void)delShop
{
    NSMutableString *ids = [NSMutableString new];
    for (NoPayModel *model in self.selArray) {
        [ids appendFormat:@",%@",model.modelId];
    }
    [ids deleteCharactersInRange:NSMakeRange(0, 1)];
    
    [RequestManager deleteShopWithShopIds:ids successHandler:^(NSArray *array) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self checkSelAll];
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
    } errorHandler:^(NSError *error) {
        
    }];
}

-(void)deleteSingleWithId:(NSString *)idStr
{
    [RequestManager deleteShopWithShopIds:idStr successHandler:^(NSArray *array) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self checkSelAll];
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
    } errorHandler:^(NSError *error) {
        
    }];
}

@end
