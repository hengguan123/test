//
//  FilterCountryViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/19.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "FilterCountryViewController.h"
#import "NormalCodeModel.h"


@interface FilterCountryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *provinceArray;
@property (nonatomic,strong)NSArray *countryArray;
@property (nonatomic,strong)NSArray *tradeMarkArray;
@property (nonatomic,strong)UIView *secHeaderView;


@property (nonatomic,strong)NSMutableArray *selPatentTypeArray;
@property (nonatomic,strong)NSMutableArray *selAreaArray;
@property (nonatomic,strong)NSMutableArray *selTrademarkTypeArray;


@end

@implementation FilterCountryViewController
{
    NSArray *_typeArray;
    BOOL _isChina;
    UIButton *_chinaBtn,*_worldBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isChina = YES;
    _typeArray = [MTLJSONAdapter modelsOfClass:[NormalCodeModel class] fromJSONArray:@[@{@"name":@"发明专利",@"code":@"A B C"},@{@"name":@"实用新型",@"code":@"U Y"},@{@"name":@"外观专利",@"code":@"D S"}] error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark tableView

-(NSArray *)countryArray
{
    if (!_countryArray) {
        NSString *strPath = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:strPath];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        _countryArray = [MTLJSONAdapter modelsOfClass:[AreaModel class] fromJSONArray:array error:nil];
    }
    return _countryArray;
}
-(NSArray *)tradeMarkArray
{
    if (!_tradeMarkArray) {
        
        _tradeMarkArray = [[AppUserDefaults share].trademarkType allKeys];
    }
    return _tradeMarkArray;
}
-(NSArray *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [AppUserDefaults share].provinceArray;
    }
    return _provinceArray;
}
-(NSMutableArray *)selPatentTypeArray
{
    if (!_selPatentTypeArray) {
        _selPatentTypeArray = [NSMutableArray new];
    }
    return _selPatentTypeArray;
}
-(NSMutableArray *)selAreaArray
{
    if (!_selAreaArray) {
        _selAreaArray = [NSMutableArray new];
    }
    return _selAreaArray;
}
-(NSMutableArray *)selTrademarkTypeArray
{
    if (!_selTrademarkTypeArray) {
        _selTrademarkTypeArray = [NSMutableArray new];
    }
    return _selTrademarkTypeArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.type == HotSearchViewTypePatent||self.type == HotSearchViewTypePatentScore) {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else if(section ==1)
    {
        if (self.type == HotSearchViewTypeTrademark) {
            return 0;
        }
        else
        {
            if (_isChina) {
                return self.provinceArray.count;
            }
            else
            {
                return self.countryArray.count;
            }
        }
    }
    else
    {
        if (self.type == HotSearchViewTypeTrademark) {
            return self.tradeMarkArray.count;
        }
        else
        {
            return 0;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat gapWidth = (self.view.bounds.size.width -70*3)/4;
        for (int i = 0; i<_typeArray.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(gapWidth+(70+gapWidth)*i, 10, 70, 24)];
            NormalCodeModel *model = [_typeArray objectAtIndex:i];
            btn.tag = i;
            [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:model.name forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//            btn.layer.borderWidth = 0.5;
            btn.layer.cornerRadius = 5;
//            btn.layer.borderColor = MainColor.CGColor;
            
            [cell.contentView addSubview:btn];
        }
        return cell;
    }
    
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"provinceCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"provinceCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.section ==1)
        {
            AreaModel *model;
            if (_isChina) {
                model = [self.provinceArray objectAtIndex:indexPath.row];
                if ([self.selAreaArray containsObject:model.addrName]) {
                    cell.textLabel.textColor = MainColor;
                }
                else
                {
                    cell.textLabel.textColor = UIColorFromRGB(0x666666);
                }
            }
            else
            {
                model = [self.countryArray objectAtIndex:indexPath.row];
                if ([self.selAreaArray containsObject:model.addrCode]) {
                    cell.textLabel.textColor = MainColor;
                }
                else
                {
                    cell.textLabel.textColor = UIColorFromRGB(0x666666);
                }
            }
            
            cell.textLabel.text = model.addrName;
        }
        else
        {
            if (indexPath.row==0) {
                NSString *type = [[AppUserDefaults share].trademarkType objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
                cell.textLabel.text = type;
                
            }
            else
            {
                NSString *type = [NSString stringWithFormat:@"第%ld类 %@",indexPath.row,[[AppUserDefaults share].trademarkType objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] ];
                cell.textLabel.text = type;
            }
            if ([self.selTrademarkTypeArray containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
                cell.textLabel.textColor = MainColor;
            }
            else
            {
                cell.textLabel.textColor = UIColorFromRGB(0x666666);
            }
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.type == HotSearchViewTypePatent||self.type == HotSearchViewTypePatentScore) {
        if (section == 0) {
            return 44;
        }
        else if (section ==1)
        {
            return 44;
        }
        else
        {
            return 0;
        }
    }
    else if(self.type == HotSearchViewTypeAll)
    {
        if (section == 0) {
            return 0;
        }
        else if (section ==1)
        {
            return 44;
        }
        else
        {
            return 0;
        }
    }
    else if(self.type == HotSearchViewTypeTrademark)
    {
        if (section == 0) {
            return 0;
        }
        else if (section ==1)
        {
            return 0;
        }
        else
        {
            return 44;
        }
    }
    else
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44.0;
    }
    else
    {
        return 34.0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        view.backgroundColor = UIColorFromRGB(0xf2f2f2);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 24)];
        lab.text = @"专利类型:";
        lab.textColor = UIColorFromRGB(0x333333);
        lab.font = [UIFont systemFontOfSize:14];
        [view addSubview:lab];
        return view;
    }
    else if(section ==1)
    {
        return self.secHeaderView;
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        view.backgroundColor = UIColorFromRGB(0xf2f2f2);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 24)];
        lab.text = @"商标类型:";
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = UIColorFromRGB(0x333333);
        [view addSubview:lab];
        return view;
    }
}

-(UIView *)secHeaderView
{
    if (!_secHeaderView) {
        _secHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _secHeaderView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _secHeaderView.layer.masksToBounds = YES;
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 24)];
        lab.text = @"所属区域:";
        lab.textColor = UIColorFromRGB(0x333333);
        lab.font = [UIFont systemFontOfSize:14];
//        lab.backgroundColor = [UIColor whiteColor];
        [_secHeaderView addSubview:lab];
        
        _chinaBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 10, 60, 24)];
        _chinaBtn.backgroundColor = MainColor;
        [_chinaBtn setTitle:@"中国" forState:UIControlStateNormal];
        _chinaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _chinaBtn.selected = YES;
        _chinaBtn.layer.cornerRadius = 5;
        [_chinaBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_chinaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_chinaBtn addTarget:self action:@selector(selChina:) forControlEvents:UIControlEventTouchUpInside];
        [_secHeaderView addSubview:_chinaBtn];
        
        _worldBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, 10, 60, 24)];
        _worldBtn.backgroundColor = [UIColor whiteColor];
        [_worldBtn setTitle:@"国际" forState:UIControlStateNormal];
        _worldBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _worldBtn.layer.cornerRadius = 5;
        [_worldBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_worldBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_worldBtn addTarget:self action:@selector(selChina:) forControlEvents:UIControlEventTouchUpInside];
        [_secHeaderView addSubview:_worldBtn];
    }
    return _secHeaderView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    else if(indexPath.section == 1)
    {
        AreaModel *model;
        if (_isChina) {
            model = [self.provinceArray objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                [self.selAreaArray removeAllObjects];
                [self.selAreaArray addObject:model.addrName];
            }
            else
            {
                AreaModel *armodel = [self.provinceArray firstObject];
                if ([self.selAreaArray containsObject:armodel.addrName]) {
                    [self.selAreaArray removeObject:armodel.addrName];
                }
                if ([self.selAreaArray containsObject:model.addrName]) {
                    [self.selAreaArray removeObject:model.addrName];
                }
                else
                {
                    [self.selAreaArray addObject:model.addrName];
                }
            }
        }
        else
        {
            model = [self.countryArray objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                [self.selAreaArray removeAllObjects];
                [self.selAreaArray addObject:model.addrCode];
            }
            else
            {
                AreaModel *armodel = [self.countryArray firstObject];
                if ([self.selAreaArray containsObject:armodel.addrCode]) {
                    [self.selAreaArray removeObject:armodel.addrCode];
                }
                if ([self.selAreaArray containsObject:model.addrCode]) {
                    [self.selAreaArray removeObject:model.addrCode];
                }
                else
                {
                    [self.selAreaArray addObject:model.addrCode];
                }
            }
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

    }
    else if(indexPath.section == 2)
    {
        NSString *type = [NSString stringWithFormat:@"%ld",indexPath.row];
//        if (indexPath.row == 0) {
//            [self.selTrademarkTypeArray removeAllObjects];
//            [self.selTrademarkTypeArray addObject:type];
//        }
//        else
//        {
//            if ([self.selTrademarkTypeArray containsObject:@"0"]) {
//                [self.selTrademarkTypeArray removeObject:@"0"];
//            }
//            else
//            {
//                if ([self.selTrademarkTypeArray containsObject:type]) {
//                    [self.selTrademarkTypeArray removeObject:type];
//                }
//                else
//                {
//                    [self.selTrademarkTypeArray addObject:type];
//                }
//            }
//        }
        [self.selTrademarkTypeArray removeAllObjects];
        [self.selTrademarkTypeArray addObject:type];
        [self.tableView reloadData];
    }
}

-(void)typeBtnClick:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    NormalCodeModel *model = [_typeArray objectAtIndex:btn.tag];
    if (btn.selected) {
        btn.backgroundColor = MainColor;
        if (![self.selPatentTypeArray containsObject:model.code])
        {
            [self.selPatentTypeArray addObject:model.code];
        }
    }
    else
    {
        btn.backgroundColor = [UIColor whiteColor];
        if ([self.selPatentTypeArray containsObject:model.code]) {
            [self.selPatentTypeArray removeObject:model.code];
        }
    }
}

-(void)selChina:(UIButton *)sender
{
    if (sender == _chinaBtn) {
        _chinaBtn.selected = YES;
        _chinaBtn.backgroundColor = MainColor;
        _worldBtn.selected = NO;
        _worldBtn.backgroundColor = [UIColor whiteColor];
        _isChina = YES;
    }
    else
    {
        _worldBtn.selected = YES;
        _worldBtn.backgroundColor = MainColor;
        _chinaBtn.selected = NO;
        _chinaBtn.backgroundColor = [UIColor whiteColor];
        _isChina = NO;
    }
    [self.selAreaArray removeAllObjects];
    [self.tableView reloadData];
}

- (IBAction)sure:(id)sender {
    
    if (self.type == HotSearchViewTypePatent||self.type == HotSearchViewTypePatentScore) {
        NSString *addrcodes = @"";
        if (self.selAreaArray.count) {
            addrcodes = [self.selAreaArray componentsJoinedByString:@" "];
        }
        
        NSString *typecodes = @"";
        if (self.selPatentTypeArray.count) {
            typecodes = [self.selPatentTypeArray componentsJoinedByString:@" "];
        }
        if (self.sureSelBlock) {
            self.sureSelBlock(_isChina, addrcodes, typecodes);
        }
    }
    else if (self.type == HotSearchViewTypeTrademark)
    {
        NSString *trademarkType = @"";
        if (self.selTrademarkTypeArray.count) {
            trademarkType = [self.selTrademarkTypeArray componentsJoinedByString:@","];
        }
        if (self.selTrademarkTypeBlock) {
            self.selTrademarkTypeBlock(trademarkType);
        }
    }
    else if (self.type == HotSearchViewTypeAll)
    {
        NSString *addrcodes = @"";
        if (self.selAreaArray.count) {
            addrcodes = [self.selAreaArray componentsJoinedByString:@" "];
        }
        NSString *typecodes = @"";
        if (self.selPatentTypeArray.count) {
            typecodes = [self.selPatentTypeArray componentsJoinedByString:@" "];
        }
        if (self.sureSelBlock) {
            self.sureSelBlock(_isChina, addrcodes, typecodes);
        }
    }
}




@end
