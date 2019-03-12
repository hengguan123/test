//
//  MonitorListViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MonitorListViewController.h"
#import "MonitorPatentTableViewCell.h"
#import "MonitorChildListViewController.h"
#import "SearchToSellViewController.h"



@interface MonitorListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MonitorPatentTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIView *noDataBgView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation MonitorListViewController
{
    int _page;
    BOOL _isLast;
    MonitorCompanyModel *_selModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBarBg"]]];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    image.contentMode = UIViewContentModeCenter;
    image.frame = CGRectMake(0, 0, 36, 36);
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView =image;
    
    
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!UIView.areAnimationsEnabled) {
        [UIView setAnimationsEnabled:YES];
    }
    [self loadDataRefresh:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}
-(void)loadDataRefresh:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        [RequestManager getMonitorContentListWithMonitorId:nil page:_page monitorType:@"1" companyName:nil successHandler:^(BOOL isLast, NSArray *array) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            _isLast = isLast;
            if (array.count) {
                self.noDataBgView.hidden = YES;
            }
            else
            {
                self.noDataBgView.hidden = NO;
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } errorHandler:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }
    else
    {
        if (_isLast) {
            [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            _page ++;
            [RequestManager getMonitorContentListWithMonitorId:nil page:_page monitorType:@"1" companyName:nil successHandler:^(BOOL isLast, NSArray *array) {
                [self.dataArray addObjectsFromArray:array];
                _isLast = isLast;
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_footer endRefreshing];
            }];
        }
    }
}

#pragma mark tableView
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
    [self.tableView registerNib:[UINib nibWithNibName:@"MonitorPatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MonitorPatentTableViewCell"];
    MonitorPatentTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorPatentTableViewCell"];
    cell.moniModel = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MonitorContentModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *pkind = [model.pn substringFromIndex:model.pn.length-1];
    NSMutableString *url = [[NSMutableString alloc]initWithFormat:@"%@%@%@",HTTPURL,@"/patent/info?usrId=",[AppUserDefaults share].usrId];
    [url appendFormat:@"&techId=%@&physicDb=%@&PKINDS=%@&reviewInfo=1&userPhone=%@",model.uniquelyid,model.dbName,pkind,[AppUserDefaults share].phone?:@""];
    HTMLViewController *webview = [[HTMLViewController alloc]init];
    webview.htmlUrl = url;
    webview.titleStr = @"费用信息";
    webview.physicDb = model.dbName;
    webview.hidesBottomBarWhenPushed = YES;
    [self showViewController:webview sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 160;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchTextField resignFirstResponder];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchTextField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self performSegueWithIdentifier:@"MonitorPushAddPatent" sender:self];
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MonitorPushAddPatent"]) {
        SearchToSellViewController *vc = [segue destinationViewController];
        __weak typeof(self) weakSelf = self;
        vc.selArrayBlock = ^(NSArray *modelArray) {
            [LoadingManager show];
            NSMutableArray *arr = [NSMutableArray new];
            for (PatentModel *model in modelArray) {
                NSDictionary *dict = @{@"id":model.ID ,@"physicDb":model.PHYSIC_DB};
                [arr addObject:dict];
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [RequestManager batchMonitoringWithParameter:jsonString SuccessHandler:^(BOOL success) {
                [LoadingManager dismiss];
                [weakSelf loadDataRefresh:YES];
            } errorHandler:^(NSError *error) {
                
            }];
        };
    }
}

- (IBAction)gotoadd:(id)sender {
    [self performSegueWithIdentifier:@"MonitorPushAddPatent" sender:self];
}




@end
