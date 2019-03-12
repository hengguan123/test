//
//  ProgressListViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ProgressListViewController.h"
#import "ProgressTableViewCell.h"
#import "WriteReviewTableViewController.h"
#import "PayViewController.h"


@interface ProgressListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end

@implementation ProgressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = self.model.errandTitle;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProgressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProgressTableViewCell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(0);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        }
    }];
//    [self loadData];
    if ([self.model.usrId isEqualToNumber:[AppUserDefaults share].usrId]) {
        
        if ([self.model.errandStatus isEqualToString:@"CSZT01-02"]) {
            [self.sureBtn setTitle:@"确认完成" forState:UIControlStateNormal];
            self.sureBtn.hidden = NO;
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-48);
                } else {
                    make.bottom.equalTo(self.view.mas_bottom).with.offset(-48);
                }
            }];
        }
        else if ([self.model.errandStatus isEqualToString:@"CSZT01-03"])
        {
            [self.sureBtn setTitle:@"去付款" forState:UIControlStateNormal];
            self.sureBtn.hidden = YES;
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(0);
                } else {
                    make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
                }
                
            }];
            
        }
        else if ([self.model.errandStatus isEqualToString:@"CSZT01-06"])
        {
            [self.sureBtn setTitle:@"去评价" forState:UIControlStateNormal];
            self.sureBtn.hidden = NO;
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-48);
                } else {
                    make.bottom.equalTo(self.view.mas_bottom).with.offset(-48);
                }
                
            }];
            
        }
        else
        {
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(0);
                } else {
                    make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
                }
                
            }];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}
-(void)loadData
{
    [RequestManager getProgressListWithErrandId:self.model.errandId successHandler:^( NSArray *array) {
        self.dataArray = array;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } errorHandler:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ask:(id)sender {
    NSLog(@"咨询平台");
    
    [self consultationPlatform];
    
}

-(void)consultationPlatform
{
    WebViewController *vc= [[WebViewController alloc]init];
    vc.titleStr = @"咨询平台";
    vc.urlStr = CustomerServiceUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProgressTableViewCell"];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)sure:(id)sender {
    
    if ([self.model.errandStatus isEqualToString:@"CSZT01-02"]) {
        [LoadingManager show];
        [RequestManager sureErrandWithErrandId:self.model.errandId faciId:self.model.faciId errandTitle:self.model.errandTitle errandStatus:@"CSZT01-06" successHandler:^(BOOL success) {
            if (self.fromList) {
                [self.navigationController popToViewController:self.fromList animated:YES];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [LoadingManager dismiss];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else if ([self.model.errandStatus isEqualToString:@"CSZT01-03"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PayViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PayViewController"];
        OrderModel *model = [OrderModel new];
        model.orderNo = self.model.superOrderNo;
        model.title = [self.model.errandTitle stringByAppendingString:@"差事"];
        model.orderPrice = self.model.price;
        vc.model = model;
        vc.fromList = self.fromList;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.model.errandStatus isEqualToString:@"CSZT01-06"])
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WriteReviewTableViewController *vc = [story instantiateViewControllerWithIdentifier:@"WriteReviewTableViewController"];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
