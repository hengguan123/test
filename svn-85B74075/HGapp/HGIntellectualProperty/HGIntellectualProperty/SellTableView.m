//
//  SellTableView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SellTableView.h"
#import "SellPatentTableViewCell.h"
#import "BuyInfoTableViewCell.h"

@interface SellTableView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SellPatentTableViewCellDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *footerView;

@property(nonatomic,strong)NSMutableArray *sellDataArray;


@end

@implementation SellTableView
{
    UITextField *_nameTextFeild;
    UITextField *_phoneTextFeild;
    int _page;
    BOOL _isLast;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"SellPatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"SellPatentTableViewCell"];
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        [self loadSellData:YES];
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadSellData:YES];
        }];
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadSellData:NO];
        }];
    }
    return self;
}
-(void)loadSellData:(BOOL)refresh
{
    if (refresh) {
        _page = 1;
        [RequestManager getBuyingInformationWithPage:_page businessName:self.searchStr?:@"" busiQuality:@"9" isMain:NO successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
            _isLast = isLast;
            [self.sellDataArray removeAllObjects];
            [self.sellDataArray addObjectsFromArray:array];
            [self reloadData];
            [self.mj_header endRefreshing];
        } errorHandler:^(NSError *error) {
            [self.mj_header endRefreshing];
        }];
    }
    else
    {
        if (_isLast) {
            [self.mj_footer endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"没有更多了"];
        }
        else
        {
            _page++;
            [RequestManager getBuyingInformationWithPage:_page businessName:self.searchStr?:@"" busiQuality:@"9" isMain:NO successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
                _isLast = isLast;
                [self.sellDataArray addObjectsFromArray:array];
                [self reloadData];
                [self.mj_footer endRefreshing];
            } errorHandler:^(NSError *error) {
                [self.mj_footer endRefreshing];
            }];
        }
    }
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(NSMutableArray*)sellDataArray
{
    if (!_sellDataArray) {
        _sellDataArray = [NSMutableArray new];
    }
    return _sellDataArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.dataArray.count;
    }
    else if(section ==1)
    {
        return 1;
    }
    else if(section == 2)
    {
        return self.dataArray.count?3:0;
    }
    else if (section == 3)
    {
        return self.sellDataArray.count;
    }
    else
    {
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SellPatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellPatentTableViewCell"];
        cell.delegate = self;
        cell.sellPatentModel = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.section == 3)
    {
        [self registerNib:[UINib nibWithNibName:@"BuyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"BuyInfoTableViewCell"];
        BuyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyInfoTableViewCell"];
        
        cell.model = [self.sellDataArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellPatentActionCell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SellPatentActionCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section==1) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-120)/2, 7, 120, 30)];
            [btn setTitle:@"添加预售专利" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5.0;
            btn.layer.borderWidth = 0.5;
            [btn addTarget:self action:@selector(addPatentToSell) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderColor = MainColor.CGColor;
            [cell.contentView addSubview:btn];
        }
        else if (indexPath.section == 2)
        {
            if (indexPath.row==0) {
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, 50, 20)];
                lab.text = @"姓名";
                lab.textColor = UIColorFromRGB(0x666666);
                lab.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:lab];
                if (!_nameTextFeild) {
                    _nameTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, ScreenWidth-80, 24)];
                    _nameTextFeild.borderStyle = UITextBorderStyleNone;
                    _nameTextFeild.placeholder = @"请输入姓名";
                    _nameTextFeild.font = [UIFont systemFontOfSize:14];
                    _nameTextFeild.textColor = UIColorFromRGB(0x666666);
                    _nameTextFeild.delegate = self;
                    _nameTextFeild.returnKeyType = UIReturnKeyDone;
                }
                [cell.contentView addSubview:_nameTextFeild];
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, ScreenWidth, 0.5)];
                line.backgroundColor = UIColorFromRGB(0xf2f2f2);
                [cell addSubview:line];
                
            }
            else if (indexPath.row==1)
            {
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, 50, 20)];
                lab.text = @"电话";
                lab.textColor = UIColorFromRGB(0x666666);
                lab.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:lab];
                if (!_phoneTextFeild) {
                    _phoneTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, ScreenWidth-80, 24)];
                    _phoneTextFeild.borderStyle = UITextBorderStyleNone;
                    _phoneTextFeild.placeholder = @"请输入联系方式";
                    _phoneTextFeild.font = [UIFont systemFontOfSize:14];
                    _phoneTextFeild.textColor = UIColorFromRGB(0x666666);
                    _phoneTextFeild.delegate = self;
                    _phoneTextFeild.returnKeyType = UIReturnKeyDone;
                }
                if ([AppUserDefaults share].phone) {
                    _phoneTextFeild.text = [AppUserDefaults share].phone;
                }
                [cell.contentView addSubview:_phoneTextFeild];
            }
            else
            {
                [cell.contentView addSubview:self.footerView];
            }
        }
        return cell;
    }
}
-(void)addPatentToSell
{
    if (self.dataArray.count>=100) {
        [SVProgressHUD showInfoWithStatus:@"最多可添加100项专利"];
    }
    else
    {
        if (self.sellDelegate && [self.sellDelegate respondsToSelector:@selector(goToAddPatentWithCurrentNum:)]) {
            [self.sellDelegate goToAddPatentWithCurrentNum:self.dataArray.count];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        BuyInformationModel *model = [self.sellDataArray objectAtIndex:indexPath.row];
        if (self.sellDelegate && [self.sellDelegate respondsToSelector:@selector(goToSellViewControllerWithModel:)]) {
            [self.sellDelegate goToSellViewControllerWithModel:model];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 175;
    }
    else if(indexPath.section == 1)
    {
        return 44;
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row == 2) {
            return 90;
        }
        else
        return 44;
    }
    else
        return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)addPatentModelArray:(NSArray *)modelarray
{
    for (PatentModel *model in modelarray) {
        if (self.dataArray.count>=100) {
            [SVProgressHUD showInfoWithStatus:@""];
        }
        for (PatentModel *datamodel in self.dataArray) {
            if ([model.PN isEqualToString:datamodel.PN]) {
                [SVProgressHUD showInfoWithStatus:@"已存在"];
                return;
            }
        }
        [self.dataArray addObject:model];
        [self reloadData];
    }
}

-(void)deletePatentModelWithCell:(SellPatentTableViewCell *)cell
{
    if ([self.dataArray containsObject:cell.sellPatentModel])
    {
        [self.dataArray removeObject:cell.sellPatentModel];
        [self reloadData];
    }
}

-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
        _footerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-200)/2, 20, 200, 40)];
        btn.layer.cornerRadius = 5;
        btn.backgroundColor = MainColor;
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        
    }
    return _footerView;
}

-(void)submit
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if ([_phoneTextFeild.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写联系方式"];
    }
    else
    {
        NSMutableArray *array = [NSMutableArray new];
        for (PatentModel *model in self.dataArray) {
            if (model.price == nil||[model.price isEqualToString:@""]) {
                [SVProgressHUD showInfoWithStatus:@"报价不能为空"];
                return;
            }
            else if (![GGTool isContainNumStr:model.price])
            {
                [SVProgressHUD showInfoWithStatus:@"报价不符合规则"];
                return;
            }
           
            NSString *businessDesc=[NSString stringWithFormat:@"标题:%@<br/>专利号:%@<br/>法律状态:%@<br/>申请人:%@<br/>报价:%@",model.TITLE,model.APN,model.VALID,model.AN,model.price];
            NSDictionary *dict = @{@"usrId":[AppUserDefaults share].usrId,@"usrPhone":_phoneTextFeild.text,@"busiQuality":@"9",@"typeCode":@"YWLX01-04",@"businessDesc":businessDesc,@"price":model.price,@"usrName":_nameTextFeild.text,@"businessName":[NSString stringWithFormat:@"出售%@",model.TITLE]};
            [array addObject:dict];
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        [RequestManager sellPatentsWithListBusi:jsonString successHandler:^(BOOL success) {
            [self.dataArray removeAllObjects];
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self reloadData];
        } errorHandler:^(NSError *error) {
            
        }];
    }

}


@end
