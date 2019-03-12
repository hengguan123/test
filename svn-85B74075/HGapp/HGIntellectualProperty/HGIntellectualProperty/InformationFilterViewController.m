//
//  InformationFilterViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/17.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "InformationFilterViewController.h"
#import "OrgInfoTypeTableViewCell.h"
#import "OrganizationTypeTableViewCell.h"
@interface InformationFilterViewController ()<UITableViewDelegate,UITableViewDataSource,OrganizationTypeTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;

@property (weak, nonatomic) IBOutlet UITableView *tableViewTwo;

@property (weak, nonatomic) IBOutlet UIView *navBgView;

@property (nonatomic,strong)NSArray *dataArray1;
@property (nonatomic,strong)NSArray *dataArray2;

@property (nonatomic,strong)NSDictionary *stutasDataDict;
@property (nonatomic,strong)NSDictionary *attentionDict;

@property (weak, nonatomic) IBOutlet UILabel *selview1;
@property (weak, nonatomic) IBOutlet UILabel *selview2;
@property (weak, nonatomic) IBOutlet UILabel *selview3;


@end

@implementation InformationFilterViewController
{
    OrgAreaModel *_selProvincialAreaModel;
    OrgAreaModel *_selCityAreaModel;
    OrgAreaModel *_selCountyAreaModel;
    OrganizationModel *_selOrgModel;
    
    /// 0一级省   1二级市  3三级区县
    NSInteger _level;
    NSInteger _otherLevel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"OrgInfoTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrgInfoTypeTableViewCell"];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"OrgInfoTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrgInfoTypeTableViewCell"];
    [self.tableViewTwo registerNib:[UINib nibWithNibName:@"OrgInfoTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrgInfoTypeTableViewCell"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"OrganizationTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrganizationTypeTableViewCell"];
    [self loaddata];
    [self loadAttentionData];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(noti:) name:HomeFilterReloaddateNoti object:nil];
    
    [self.navBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kDevice_Is_iPhoneX) {
            make.height.mas_equalTo(88);
        }
        else
        {
            make.height.mas_equalTo(64);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)noti:(NSNotification *)noti
{
    [self loaddata];
    [self loadAttentionData];
}


-(void)loaddata
{
    [RequestManager getOrganizationAndRegionWithDepartCode:@"0" successHandler:^(NSArray *array) {
        self.dataArray2 = array;
    } errorHandler:^(NSError *error) {
        
    }];
    [RequestManager getRegionAndOrganizationWithAddrCode:@"0" successHandler:^(NSArray *array) {
        self.dataArray1 = array;
        [self.tableView1 reloadData];
    } errorHandler:^(NSError *error) {
        
    }];
    [RequestManager getNewStatuDataSuccessHandler:^(NSDictionary *dict) {
        self.stutasDataDict = dict;
        [self.tableView2 reloadData];
    } errorHandler:^(NSError *error) {
        
    }];
    
}
- (void)loadAttentionData
{
    if ([AppUserDefaults share].isLogin) {
        [RequestManager getLayeredAttentionListSuccessHandler:^(NSDictionary *dict) {
            self.attentionDict = dict;
            [self.tableView2 reloadData];
        } errorHandler:^(NSError *error) {
            
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segControl.selectedSegmentIndex == 0) {
        if (tableView == self.tableView1) {
            return self.dataArray1.count;
        }
        else if (tableView == self.tableViewTwo)
        {
            NSInteger num = _selProvincialAreaModel.listAddr.count;
            if (num == 0) {
                self.selview2.hidden = YES;
            }
            else
            {
                self.selview2.hidden = NO;
            }
            return num;
        }
        else
        {
            NSInteger num =0;
            if (_selCityAreaModel) {
                num = _selCityAreaModel.listDept.count;
            }
            else
            {
                num = _selProvincialAreaModel.listDept.count;
            }
            if (num == 0) {
                self.selview3.hidden = YES;
            }
            else
            {
                self.selview3.hidden = NO;
            }
            return num;
        }
    }
    else
    {
        if (tableView == self.tableView1) {
            return self.dataArray2.count;
        }
        else if(tableView == self.tableViewTwo)
        {
            NSInteger num = _selOrgModel.listAddr.count;
            if (num == 0) {
                self.selview2.hidden = YES;
            }
            else
            {
                self.selview2.hidden = NO;
            }
            return num;
        }
        else
        {
            NSInteger num = _selProvincialAreaModel.listAddr.count;
            if (num == 0) {
                self.selview3.hidden = YES;
            }
            else
            {
                self.selview3.hidden = NO;
            }
            return num;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segControl.selectedSegmentIndex == 0)//选地区
    {
        if (tableView == self.tableView1) {
            OrgInfoTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrgInfoTypeTableViewCell"];
            OrgAreaModel *model = [self.dataArray1 objectAtIndex:indexPath.row];
            cell.areamodel = model;
            if ([_selProvincialAreaModel.addrName isEqualToString:model.addrName] ) {
                cell.isSel = YES;
            }
            else
            {
                cell.isSel = NO;
            }
            cell.isNew = NO;
            return cell;
        }
        else if (tableView == self.tableViewTwo)
        {
            OrgInfoTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrgInfoTypeTableViewCell"];
            OrgAreaModel *model = [_selProvincialAreaModel.listAddr objectAtIndex:indexPath.row];
            cell.areamodel = model;
            if ([_selCityAreaModel.addrName isEqualToString:model.addrName] ) {
                cell.isSel = YES;
            }
            else
            {
                cell.isSel = NO;
            }
            cell.isNew = NO;
            return cell;
        }
        else
        {
            OrganizationTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrganizationTypeTableViewCell"];
            OrganizationModel *model;
            cell.delegate = self;
            NSString *key;
            if (_selCountyAreaModel) {
                model= [_selCountyAreaModel.listDept objectAtIndex:indexPath.row];
                key = _selCountyAreaModel.addrName;
            }
            else
            {
                if (_selCityAreaModel) {
                    model= [_selCityAreaModel.listDept objectAtIndex:indexPath.row];
                    key = _selCityAreaModel.addrName;
                }
                else
                {
                    model= [_selProvincialAreaModel.listDept objectAtIndex:indexPath.row];
                    key = _selProvincialAreaModel.addrName;
                }
            }
            cell.orgmodel = model;
            NSArray *array = [self.stutasDataDict objectForKey:key];
            cell.isNew = NO;
            for (NSDictionary *dict in array) {
                if ([[dict objectForKey:@"sorce"]isEqualToString:model.departName]) {
                    if ([AppUserDefaults share].login) {
                        if ([[dict objectForKey:@"isSee"]intValue]==0) {
                            cell.isNew = YES;
                        }
                    }
                    else
                    {
                        cell.isNew = YES;
                    }
                }
            }
            if ([_selOrgModel.departName isEqualToString:model.departName]) {
                cell.isSel = YES;
            }
            else
            {
                cell.isSel = NO;
            }
            
            NSArray *attentionArray = [self.attentionDict objectForKey:key];
            cell.isAttention = NO;
            cell.attentionId = @0;
            for (NSDictionary *dict in attentionArray) {
                if ([[dict objectForKey:@"departCode"]isEqualToString:model.departCode]) {
                    cell.isAttention = YES;
                    cell.attentionId = [dict objectForKey:@"id"];
                }
            }
            
            return cell;
        }
    }
    else  //选机构
    {
        if (tableView == self.tableView1) {
            OrgInfoTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrgInfoTypeTableViewCell"];
            OrganizationModel *model = [self.dataArray2 objectAtIndex:indexPath.row];
            if ([_selOrgModel.dictionaryName isEqualToString:model.dictionaryName]) {
                cell.isSel = YES;
            }
            else
            {
                cell.isSel = NO;
            }
            cell.orgmodel = model;
            cell.isNew = NO;
            return cell;
        }
        else if (tableView == self.tableViewTwo)
        {
            OrgInfoTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrgInfoTypeTableViewCell"];
            OrgAreaModel *model = [_selOrgModel.listAddr objectAtIndex:indexPath.row];
            cell.areamodel = model;
            if ([_selProvincialAreaModel.addrName isEqualToString:model.addrName] ) {
                cell.isSel = YES;
            }
            else
            {
                cell.isSel = NO;
            }
            cell.isNew = NO;
            return cell;
        }
        else
        {
            OrgInfoTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrgInfoTypeTableViewCell"];
            OrgAreaModel *model = [_selProvincialAreaModel.listAddr objectAtIndex:indexPath.row];
            cell.areamodel = model;
            if ([_selCityAreaModel.addrName isEqualToString:model.addrName] ) {
                cell.isSel = YES;
            }
            else
            {
                cell.isSel = NO;
            }
            cell.isNew = NO;
            return cell;
        }
    }
}

//  CHN110000北京   CHN120000天津   CHN310000上海   CHN500000重庆

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segControl.selectedSegmentIndex == 0) {///选地区
        if (tableView == self.tableView1) {
            _selProvincialAreaModel = [self.dataArray1 objectAtIndex:indexPath.row];
            //三清
            _selCityAreaModel = nil;
            _selCountyAreaModel = nil;
            _selOrgModel = nil;
            
            //二刷新
            [tableView reloadData];
            [self.tableViewTwo reloadData];
            [self.tableView2 reloadData];
        }
        else if (tableView == self.tableViewTwo){
            _selCityAreaModel = [_selProvincialAreaModel.listAddr objectAtIndex:indexPath.row];
            //二清
            _selCountyAreaModel = nil;
            _selOrgModel = nil;
            
            if (_selCityAreaModel.listAddr.count) {
                _level = 2;
            }
            else
            {
                
            }
            //刷新
            [tableView reloadData];
            [self.tableView2 reloadData];
        }
        else  //页面右
        {
            OrganizationModel *model;
            if (_selCountyAreaModel) {
                model= [_selCountyAreaModel.listDept objectAtIndex:indexPath.row];
            }
            else
            {
                if (_selCityAreaModel) {
                    model= [_selCityAreaModel.listDept objectAtIndex:indexPath.row];
                }
                else
                {
                    model= [_selProvincialAreaModel.listDept objectAtIndex:indexPath.row];;
                }
            }
            _selOrgModel = model;
           
            [tableView reloadData];
        }
        
    }
    else   //选机构
    {
        if (self.tableView1 == tableView) {
            _selOrgModel = [self.dataArray2 objectAtIndex:indexPath.row];
            _level = 0;//地址置为省级
           
            //清空选中地区
            _selProvincialAreaModel = nil;
            _selCityAreaModel = nil;
            _selCountyAreaModel = nil;
            [self.tableView1 reloadData];
            [self.tableViewTwo reloadData];
            [self.tableView2 reloadData];
        }
        else if (tableView==self.tableViewTwo)
        {
            _selProvincialAreaModel = [_selOrgModel.listAddr objectAtIndex:indexPath.row];
            _selCityAreaModel = nil;
            _selCountyAreaModel = nil;
            
            
            [tableView reloadData];
            [self.tableView2 reloadData];
        }
        else  //地址
        {
            _selCityAreaModel = [_selProvincialAreaModel.listAddr objectAtIndex:indexPath.row];
            [tableView reloadData];
        }
    }
    [self refreshSelView];
}

-(void)refreshSelView
{
    if (self.segControl.selectedSegmentIndex == 0) {
        self.selview1.text = _selProvincialAreaModel?_selProvincialAreaModel.addrName:@"未选择";
        self.selview2.text = _selCityAreaModel?_selCityAreaModel.addrName:@"未选择";
        self.selview3.text = _selOrgModel?_selOrgModel.departName:@"未选择";
    }
    else
    {
        self.selview1.text = _selOrgModel?_selOrgModel.dictionaryName:@"未选择";
        self.selview2.text = _selProvincialAreaModel?_selProvincialAreaModel.addrName:@"未选择";
        self.selview3.text = _selCityAreaModel?_selCityAreaModel.addrName:@"未选择";
    }
}

- (IBAction)valueChange:(UISegmentedControl *)sender {
    
    _selProvincialAreaModel = nil;
    _selCityAreaModel = nil;
    _selCountyAreaModel = nil;
    _selOrgModel = nil;
    [self refreshSelView];
    [self.tableView1 reloadData];
    [self.tableViewTwo reloadData];
    [self.tableView2 reloadData];
}

- (IBAction)tap:(id)sender {
    if (self.hiddenBlcok) {
        self.hiddenBlcok();
    }
}

- (IBAction)sure:(id)sender {
    NSString *area;
    if (_selCountyAreaModel) {
        area = _selCountyAreaModel.addrName;
    }
    else
    {
        if (_selCityAreaModel) {
            area = _selCityAreaModel.addrName;
        }
        else
        {
            if (_selProvincialAreaModel) {
                area = _selProvincialAreaModel.addrName;
            }
            else
            {
                area = @"";
            }
        }
    }
    if (self.segControl.selectedSegmentIndex==0) {
        if ([AppUserDefaults share].isLogin) {
            if (![area isEqualToString:@""]&&_selOrgModel) {
                NSArray *array = [self.stutasDataDict objectForKey:area];
                for (NSDictionary *dict in array) {
                    if ([[dict objectForKey:@"sorce"]isEqualToString:_selOrgModel.departName]) {
                        if ([[dict objectForKey:@"isSee"]intValue]==0) {
                            [RequestManager removeLittleRedDotWith:area source:_selOrgModel.departName successHandler:^(BOOL success) {
                                
                            } errorHandler:^(NSError *error) {
                                
                            }];
                        }
                    }
                }
            }
        }
        if (self.selFinishBlcok) {
            self.selFinishBlcok(_selOrgModel?_selOrgModel.departName:@"", area, @"");
        }
    }
    else
    {
        if (self.selFinishBlcok) {
            self.selFinishBlcok(@"", area, _selOrgModel?_selOrgModel.dictionaryCode:@"");
        }
    }
}
#pragma mark  代理
///////代理方法
-(void)organizationTypeTableViewCell:(OrganizationTypeTableViewCell *)cell beFollowedWithBtnSelected:(BOOL)selected
{
    if ([AppUserDefaults share].isLogin) {
        if (!selected) {
            [RequestManager addAttentionWithAddrCode:cell.orgmodel.addrCode addrName:cell.orgmodel.addrName departName:cell.orgmodel.departName departCode:cell.orgmodel.departCode SuccessHandler:^(NSNumber *modelId) {
                [self loadAttentionData];
            } errorHandler:^(NSError *error) {
                
            }];
        }
        else
        {
            [RequestManager deleteAttentionWithId:cell.attentionId SuccessHandler:^(BOOL success) {
                [self loadAttentionData];
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
    else
    {
        [self goToLogin];
    }
}

-(void)goToLogin
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}



@end
