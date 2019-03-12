//
//  MyPublishListViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MyPublishListViewController.h"
#import "MyPublishTableViewCell.h"
#import "PublishErrandTableViewController.h"
#import "ErrandsDetialTableViewController.h"
#import "ProgressListViewController.h"
#import "RobbedDetialTableViewController.h"


@interface MyPublishListViewController ()<UITableViewDelegate,UITableViewDataSource,MyPublishTableViewCellDelegate,UITextFieldDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@end

@implementation MyPublishListViewController
{
    ///1发布中  2进行中  3待确认  4已完成
    NSString *_sortType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    _sortType = @"1";
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    image.contentMode = UIViewContentModeCenter;
    image.frame = CGRectMake(0, 0, 36, 36);
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView =image;
    self.searchTextField.placeholder = @"输入差事标题检索";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyPublishTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyPublishTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self loadData];
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}
- (void)loadData
{
    [RequestManager getMyPublishWith:_sortType errandTitle:self.searchTextField.text listSuccessHandler:^(NSArray *array) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray: array];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [LoadingManager dismiss];
    } errorHandler:^(NSError *error) {
        [LoadingManager dismiss];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --cellDelegate

-(void)deleteErrandMyPublishTableViewCell:(MyPublishTableViewCell *)cell
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"您确认撤销发布并删除此差事吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除然后刷新");
        [RequestManager deleteErrandWithErrandId:cell.model.errandId successHandler:^(BOOL success) {
            [SVProgressHUD showSuccessWithStatus:@"删除差事成功"];
            [self loadData];
        } errorHandler:^(NSError *error) {
            
        }];
    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)changeErrandMyPublishTableViewCell:(MyPublishTableViewCell *)cell
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PublishErrandTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PublishErrandTableViewController"];
    vc.model = cell.model;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)lookoverProgressPublishTableViewCell:(MyPublishTableViewCell *)cell
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProgressListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProgressListViewController"];
    vc.model = cell.model;
    vc.fromList = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ----tableView
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPublishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPublishTableViewCell"];
    cell.delegate = self;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ErrandModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model.isRobOrder boolValue]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RobbedDetialTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RobbedDetialTableViewController"];
        vc.type = GrabDetialFunctionTypeProgress;
        vc.model = model;
        vc.fromList = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ErrandsDetialTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ErrandsDetialTableViewController"];
        vc.model = model;
        vc.fromList = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //第二组可以左滑删除
    
    ErrandModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model.errandStatus isEqualToString:@"CSZT01-04"]||[model.errandStatus isEqualToString:@"CSZT01-05"]||[model.errandStatus isEqualToString:@"CSZT01-06"]||[model.errandStatus isEqualToString:@"CSZT01-07"]) {
        return NO;
    }
    else
    {
        return YES;
    }
}
/**
 *  只要实现了这个方法，左滑出现按钮的功能就有了
 (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        ErrandModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if ([model.errandStatus isEqualToString:@"CSZT01-04"]||[model.errandStatus isEqualToString:@"CSZT01-05"]||[model.errandStatus isEqualToString:@"CSZT01-06"]||[model.errandStatus isEqualToString:@"CSZT01-07"]) {
            [SVProgressHUD showInfoWithStatus:@"该订单不可删除"];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"确认删除当前差事吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [LoadingManager show];
                [RequestManager deleteErrandWithErrandId:model.errandId successHandler:^(BOOL success) {
                    [self loadData];
                } errorHandler:^(NSError *error) {
                    
                }];
            }];
            [alert addAction:cancelAction];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    return @[action1];
}




- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)changeType:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _sortType = @"1";
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [LoadingManager show];
        [self loadData];
    }
    else if (sender.selectedSegmentIndex ==1)
    {
        _sortType = @"2";
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [LoadingManager show];
        [self loadData];
    }
}

- (IBAction)typeClick:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected = YES;
        if (sender == self.btn1) {
            self.btn2.selected = NO;
            self.btn3.selected = NO;
            self.btn4.selected = NO;
            _sortType = @"1";
        }
        else if (sender == self.btn2){
            self.btn1.selected = NO;
            self.btn3.selected = NO;
            self.btn4.selected = NO;
            _sortType = @"2";
        }
        else if (sender == self.btn3){
            self.btn2.selected = NO;
            self.btn1.selected = NO;
            self.btn4.selected = NO;
            _sortType = @"3";
        }
        else if (sender == self.btn4){
            self.btn2.selected = NO;
            self.btn3.selected = NO;
            self.btn1.selected = NO;
            _sortType = @"4";
        }
        [self loadData];
    }
}





@end
