//
//  OtherProfessionalWorkViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/30.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OtherProfessionalWorkViewController.h"
#import "OtherWorkTableViewCell.h"





@interface OtherProfessionalWorkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation OtherProfessionalWorkViewController
{
    OtherWorkModel *_selModel1;
    OtherWorkModel *_selModel2;
    OtherWorkModel *_selModel3;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadData];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"OtherWorkTableViewCell" bundle:nil] forCellReuseIdentifier:@"OtherWorkTableViewCell"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"OtherWorkTableViewCell" bundle:nil] forCellReuseIdentifier:@"OtherWorkTableViewCell"];
    [self.tableView3 registerNib:[UINib nibWithNibName:@"OtherWorkTableViewCell" bundle:nil] forCellReuseIdentifier:@"OtherWorkTableViewCell"];
    
    [self.tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).dividedBy(375.0/75);
    }];
    [self.tableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(140.0/375);
    }];
    [self.tableView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(160.0/375);
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadData
{
    [RequestManager getOtherWorkDataSuccessHandler:^(NSArray *array) {
        self.dataArray = [MTLJSONAdapter modelsOfClass:[OtherWorkModel class] fromJSONArray:array error:nil];
        [self.tableView1 reloadData];
        if (self.dataArray.count) {
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView1 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            _selModel1 = self.dataArray.firstObject;
            [self.tableView2 reloadData];
            [self.tableView2 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            if (_selModel1.listChildDict.count) {
                _selModel2 = _selModel1.listChildDict.firstObject;
                [self.tableView3 reloadData];
                if (_selModel2.listChild.count) {
                    _selModel3 = _selModel2.listChild.firstObject;
                    [self.tableView3 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
        }
    } errorHandler:^(NSError *error) {
        
    }];
}




#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView1) {
        return self.dataArray.count;
    }
    else if (tableView == self.tableView2)
    {
        return _selModel1.listChildDict.count;
    }
    else if (tableView == self.tableView3)
    {
        return _selModel2.listChild.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView1) {
        OtherWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherWorkTableViewCell"];
        cell.otherModel = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (tableView == self.tableView2) {
        OtherWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherWorkTableViewCell"];
        cell.otherModel = [_selModel1.listChildDict objectAtIndex:indexPath.row];
        return cell;
    }
    else if (tableView == self.tableView3) {
        OtherWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherWorkTableViewCell"];
        cell.otherModel = [_selModel2.listChild objectAtIndex:indexPath.row];
        return cell;
    }
    else
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView1 == tableView) {
        _selModel1 = [self.dataArray objectAtIndex:indexPath.row];
        if (_selModel1.listChildDict.count) {
            [self.tableView2 reloadData];
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView2 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            _selModel2 = _selModel1.listChildDict.firstObject;
            [self.tableView3 reloadData];
            if (_selModel2.listChild.count) {
                _selModel3 = _selModel2.listChild.firstObject;
                
                [self.tableView3 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            else
            {
                _selModel3 = nil;
                [self.tableView3 reloadData];
            }
        }
        else
        {
            _selModel2 = nil;
            _selModel3 = nil;
            [self.tableView2 reloadData];
            [self.tableView3 reloadData];
        }
    }
    else if (self.tableView2 == tableView) {
        _selModel2 = [_selModel1.listChildDict objectAtIndex:indexPath.row];
        if (_selModel2.listChild.count) {
            [self.tableView3 reloadData];
            _selModel3 = _selModel2.listChild.firstObject;
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView3 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else
        {
            _selModel3 = nil;
            [self.tableView3 reloadData];
        }
        
    }
    else if (self.tableView3 == tableView)
    {
        _selModel3 = [_selModel2.listChild objectAtIndex:indexPath.row];
    }
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goToPublic:(id)sender {
    if([AppUserDefaults share].isLogin)
    {
        if (_selModel1) {
            [self performSegueWithIdentifier:@"OtherPushPublish" sender:self];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"未获取到数据，请返回重试"];
        }
    }
    else
    {
        [self goToLogin];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OtherPushPublish"]) {
        PublishErrandTableViewController *vc = segue.destinationViewController;
        vc.selOtherModel1 = _selModel1;
        vc.selOtherModel2 = _selModel2;
        vc.selOtherModel3 = _selModel3;
    }
}
-(void)goToLogin
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
