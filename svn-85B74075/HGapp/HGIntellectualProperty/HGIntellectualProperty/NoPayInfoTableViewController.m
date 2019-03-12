//
//  NoPayInfoTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "NoPayInfoTableViewController.h"
#import "PayViewController.h"
#import "AgentDetialTableViewController.h"

@interface NoPayInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *faciNameLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *pubTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *grabTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *domainLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *subTypeLab;
@property (weak, nonatomic) IBOutlet UITextView *remarkLab;

@property (nonatomic,strong)ErrandModel *errandModel;

@end

@implementation NoPayInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",self.model.orderNo];
    if (self.payStatus) {
        self.orderTimeLab.text = [NSString stringWithFormat:@"创建时间:%@",self.model.createTime];
    }
    else
    {
        self.orderTimeLab.text = [NSString stringWithFormat:@"支付时间:%@",self.model.payTime];
        self.tableView.tableFooterView = nil;
    }
    self.priceLab.text = [NSString stringWithFormat:@"总额:%@元",self.model.orderPrice];
    [self loadDate];
}

-(void)loadDate
{
    [RequestManager getRobErrandInfoWithErrandId:self.model.errandId successHandler:^(NSDictionary *dict) {
        self.errandModel = [MTLJSONAdapter modelOfClass:[ErrandModel class] fromJSONDictionary:dict error:nil];
    } errorHandler:^(NSError *error) {
        
    }];
}

- (void)setErrandModel:(ErrandModel *)errandModel
{
    _errandModel = errandModel;
    self.titleLab.text = [NSString stringWithFormat:@"差事标题:%@",errandModel.errandTitle];
    self.faciNameLab.text = errandModel.faciName;
    self.nameLab.text = errandModel.usrName;
    self.cityLab.text = errandModel.dwellAddrName;
    self.domainLab.text = errandModel.domainName;
    self.typeLab.text = errandModel.errandTypeName;
    self.subTypeLab.text = errandModel.busiTypeName;
    self.remarkLab.text = errandModel.remark;
    
    self.pubTimeLab.text = errandModel.createTime;
    self.grabTimeLab.text = errandModel.robTime;
    
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
    return 11;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        HTMLViewController *view = [[HTMLViewController alloc]init];
        view.htmlUrl = [HTTPURL stringByAppendingFormat:@"/faci/faciInfo?faciId=%@&phone=%@&code=%@&code1=%@",self.errandModel.faciId,[AppUserDefaults share].phone,@"",@""];
        view.titleStr = @"代理人详情";
        //        view.canShare = YES;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chat:(id)sender {
    WebViewController *vc= [[WebViewController alloc]init];
    vc.titleStr = @"咨询平台";
    vc.urlStr = CustomerServiceUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)pay:(id)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PayViewController *vc = [main instantiateViewControllerWithIdentifier:@"PayViewController"];
    vc.fromList = self.fromList;
    vc.model = self.model;
    vc.isInside = [AppUserDefaults share].isInside;
    [self showViewController:vc sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"OrderDetailPushAgentDetail"])
//    {
//        AgentDetialTableViewController *vc = segue.destinationViewController;
//        vc.usrId = self.errandModel.faciId;
//    }
}


@end
