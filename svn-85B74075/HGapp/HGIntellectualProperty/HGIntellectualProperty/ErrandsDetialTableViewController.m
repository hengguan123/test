//
//  ErrandsDetialTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ErrandsDetialTableViewController.h"

@interface ErrandsDetialTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *domainLab;
@property (weak, nonatomic) IBOutlet UILabel *classLab;
@property (weak, nonatomic) IBOutlet UILabel *subClassLab;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLab;


@end

@implementation ErrandsDetialTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if (self.model)
    {
        if ([self.model.isInside isEqualToString:@"1"]) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[@"[官方]" stringByAppendingString:self.model.errandTitle]];
            [attrStr addAttribute:NSForegroundColorAttributeName value:MainColor range: NSMakeRange(0, 4)];
            self.titleLab.attributedText = attrStr;
        }
        else
        {
            self.titleLab.text = self.model.errandTitle;
        }
        self.priceLab.text = [NSString stringWithFormat:@"%@",self.model.price ];
        self.userName.text = self.model.usrName;
        self.cityLab.text = self.model.dwellAddrName;
        self.timeLab.text = self.model.createTime;
        self.classLab.text = self.model.errandTypeName;
        self.subClassLab.text = self.model.busiTypeName;
        self.domainLab.text = self.model.domainName;
        if (self.model.remark) {
            self.remarkTextView.text = self.model.remark;
        }
        if ([self.model.usrId isEqualToNumber:[AppUserDefaults share].usrId]) {
            [self.functionBtn setTitle:@"修改" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"delete_icon_big"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteErrand)],[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"咨询"] style:UIBarButtonItemStyleDone target:self action:@selector(consultationPlatform)],];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ask:(id)sender {
    NSLog(@"咨询平台");
    
    [self consultationPlatform];
}

- (void)deleteErrand
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"您确认撤销发布并删除此差事吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除然后刷新");
        [RequestManager deleteErrandWithErrandId:self.model.errandId successHandler:^(BOOL success) {
            [SVProgressHUD showSuccessWithStatus:@"删除差事成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } errorHandler:^(NSError *error) {
            
        }];
    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)consultationPlatform
{
    WebViewController *vc= [[WebViewController alloc]init];
    vc.titleStr = @"咨询平台";
    vc.urlStr = CustomerServiceUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)functionClick:(UIButton *)sender {
    
    if ([self.model.usrId isEqualToNumber:[AppUserDefaults share].usrId]) {
        NSLog(@"修改");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PublishErrandTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PublishErrandTableViewController"];
        vc.fromList = self.fromList;
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        NSLog(@"抢单");
        sender.enabled = NO;
        [LoadingManager show];
        [RequestManager grabErrandWithErrandId:self.model.errandId faciName:[AppUserDefaults share].userName errandTitle:self.model.errandTitle usrId:self.model.usrId price:self.model.price successHandler:^(BOOL success) {
            [LoadingManager dismiss];
            if (success) {
                [NetPromptBox showWithInfo:@"抢单成功" stayTime:2];
                [self.navigationController popViewControllerAnimated:YES];
            }
            sender.enabled = YES;
        } errorHandler:^(NSError *error) {
            sender.enabled = YES;
        }];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }
    else if (indexPath.row == 1)
    {
        return 70;
    }
    else if (indexPath.row == 2)
    {
        return 54;
    }
    else if (indexPath.row == 3)
    {
        return 54;
    }
    else if (indexPath.row == 4)
    {
        return 54;
    }
    else if (indexPath.row == 5)
    {
        if ([self.model.errandType isEqualToString:TrademarkCode]||[self.model.errandType isEqualToString:CopyrightCode]) {
            return 0;
        }
        else
        {
            return 54;
        }
    }
    else if (indexPath.row == 6)
    {
        return 54;
    }
    else if (indexPath.row == 7)
    {
        return 54;
    }
    else if (indexPath.row == 8)
    {
        return 94;
    }
    return 0;
}


@end
