//
//  BuyFilterViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "BuyFilterViewController.h"
#import "NormalCodeModel.h"
#import "SelectedTimeView.h"
#import "IPCModel.h"
#define DefaultTimeStr @"点击设定"
@interface BuyFilterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *provinceArray;
@property (nonatomic,strong)NSArray *countryArray;
@property (nonatomic,strong)NSArray *tradeMarkArray;
@property (nonatomic,strong)UIView *secHeaderView;


@property (nonatomic,strong)NSMutableArray *selPatentTypeArray;
@property (nonatomic,strong)NSMutableArray *selAreaArray;
@property (nonatomic,strong)NSMutableArray *selIPCArray;
@property (nonatomic,strong)SelectedTimeView *selTimeView;

@property (nonatomic,strong)UIButton *invalidBtn;
@property (nonatomic,strong)UIButton *validBtn;


@end

@implementation BuyFilterViewController
{
    NSArray *_typeArray;
    BOOL _isChina;
    UIButton *_chinaBtn,*_worldBtn;
    UILabel *_timeLab1,*_timeLab2;
    int _selTimeType;
    NSArray *_IPCArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isChina = YES;
    _typeArray = [MTLJSONAdapter modelsOfClass:[NormalCodeModel class] fromJSONArray:@[@{@"name":@"发明专利",@"code":@"A B C"},@{@"name":@"实用新型",@"code":@"U Y"},@{@"name":@"外观专利",@"code":@"D S"}] error:nil];
    
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"IPCList" ofType:@"geojson"];
    NSData *data = [NSData dataWithContentsOfFile:strPath];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _IPCArray = [MTLJSONAdapter modelsOfClass:[IPCModel class] fromJSONArray:array error:nil];
    
}
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
-(NSMutableArray *)selIPCArray
{
    if (!_selIPCArray) {
        _selIPCArray = [NSMutableArray new];
    }
    return _selIPCArray;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if (section==1)
    {
        return 1;
    }
    else if (section==2)
    {
        return 1;
    }
    else if (section==3)
    {
        return _IPCArray.count;
    }
    else if (section==4)
    {
        if (_isChina) {
            return self.provinceArray.count;
        }
        else
        {
            return self.countryArray.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat gapWidth = (ScreenWidth/5*4 -70*3)/4;
        for (int i = 0; i<_typeArray.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(gapWidth+(70+gapWidth)*i, 10, 70, 24)];
            NormalCodeModel *model = [_typeArray objectAtIndex:i];
            btn.tag = i;
            [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:model.name forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.layer.borderWidth = 0.5;
            btn.layer.cornerRadius = 5;
            btn.layer.borderColor = MainColor.CGColor;
            
            [cell.contentView addSubview:btn];
        }
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat width = (ScreenWidth/5*4-30)/2;
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(width, 10, 30, 24)];
        lab.textAlignment =1;
        lab.text = @"To";
//        lab.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:lab];
        
        if (!_timeLab1) {
            _timeLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, width, 24)];
//            _timeLab1.backgroundColor = [UIColor purpleColor];
            _timeLab1.textAlignment=1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeLabTap:)];
            [_timeLab1 addGestureRecognizer:tap];
            _timeLab1.textColor = UIColorFromRGB(0x666666);
            _timeLab1.font = [UIFont systemFontOfSize:12];
            _timeLab1.text = DefaultTimeStr;
            _timeLab1.userInteractionEnabled=YES;
            
        }
        [cell.contentView addSubview:_timeLab1];
        if (!_timeLab2) {
            _timeLab2 = [[UILabel alloc]initWithFrame:CGRectMake(width+30, 10, width, 24)];
            _timeLab2.textColor = UIColorFromRGB(0x666666);
//            _timeLab2.backgroundColor = [UIColor purpleColor];
            _timeLab2.textAlignment=1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeLabTap:)];
            [_timeLab2 addGestureRecognizer:tap];
            _timeLab2.font = [UIFont systemFontOfSize:12];
            _timeLab2.text = DefaultTimeStr;
            _timeLab2.userInteractionEnabled=YES;
            
        }
        [cell.contentView addSubview:_timeLab2];
        return cell;
    }
    else if (indexPath.section == 2)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat gapWidth = (ScreenWidth/5*4 -70*3)/4;
        if (!_validBtn) {
            _validBtn = [[UIButton alloc]initWithFrame:CGRectMake(gapWidth, 10, 70, 24)];
            [_validBtn addTarget:self action:@selector(validBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_validBtn setTitle:@"有效专利" forState:UIControlStateNormal];
            _validBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_validBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [_validBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            _validBtn.layer.borderWidth = 0.5;
            _validBtn.layer.cornerRadius = 5;
            _validBtn.layer.borderColor = MainColor.CGColor;

        }
        [cell.contentView addSubview:_validBtn];
        if (!_invalidBtn) {
            _invalidBtn = [[UIButton alloc]initWithFrame:CGRectMake(gapWidth*2+70, 10, 70, 24)];
            [_invalidBtn addTarget:self action:@selector(validBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_invalidBtn setTitle:@"无效专利" forState:UIControlStateNormal];
            _invalidBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_invalidBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [_invalidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            _invalidBtn.layer.borderWidth = 0.5;
            _invalidBtn.layer.cornerRadius = 5;
            _invalidBtn.layer.borderColor = MainColor.CGColor;
            
        }
        [cell.contentView addSubview:_invalidBtn];
        
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
        
        if(indexPath.section ==4)
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
        else if (indexPath.section==3)
        {
            IPCModel *model = [_IPCArray objectAtIndex:indexPath.row];
            if ([self.selIPCArray containsObject:model.svTypeCode]) {
                cell.textLabel.textColor = MainColor;
            }
            else
            {
                cell.textLabel.textColor = UIColorFromRGB(0x666666);
            }
            cell.textLabel.text = model.svTypeName;
        }
        return cell;
    };
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 4) {
        NSArray *array = @[@"专利类型",@"公开时间",@"有效性",@"IPC分类"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        view.backgroundColor = UIColorFromRGB(0xf2f2f2);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 24)];
        lab.text = [array objectAtIndex:section];
        lab.textColor = UIColorFromRGB(0x333333);
        lab.font = [UIFont systemFontOfSize:14];
        [view addSubview:lab];
        return view;
    }
    else
    {
        return self.secHeaderView;
    }
    
}


-(UIView *)secHeaderView
{
    if (!_secHeaderView)
    {
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44.0;
    }
    else if (indexPath.section==1)
    {
        return 44;
    }
    else if (indexPath.section==2)
    {
        return 44;
    }

//    else if (indexPath.section == 2)
//    {
//        return 34;
//    }
//    else if (indexPath.section == 4)
//    {
//        return 44;
//    }
    return 34;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    else if (indexPath.section == 3)
    {
        IPCModel *model = [_IPCArray objectAtIndex:indexPath.row];
        if ([self.selIPCArray containsObject:model.svTypeCode]) {
            [self.selIPCArray removeObject:model.svTypeCode];
        }
        else
        {
            [self.selIPCArray addObject:model.svTypeCode];

        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        

    }
    else if(indexPath.section == 4)
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
                if ([self.selAreaArray containsObject:model.addrName]) {
                    [self.selAreaArray removeObject:model.addrName];
                }
                else
                {
                    [self.selAreaArray addObject:model.addrName];
                }
            }
        }
        
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
    }
}

-(void)typeBtnClick:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        btn.backgroundColor = MainColor;
    }
    else
    {
        btn.backgroundColor = [UIColor whiteColor];
    }
    NormalCodeModel *model = [_typeArray objectAtIndex:btn.tag];
    if ([self.selPatentTypeArray containsObject:model.code]) {
        [self.selPatentTypeArray removeObject:model.code];
    }
    else
    {
        [self.selPatentTypeArray addObject:model.code];
    }
    
}

-(void)validBtnClick:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        btn.backgroundColor = MainColor;
    }
    else
    {
        btn.backgroundColor = [UIColor whiteColor];
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



#pragma mark seltime
-(SelectedTimeView *)selTimeView
{
    if (!_selTimeView) {
        _selTimeView = [[SelectedTimeView alloc]initWithParentView:self.view];
        __weak UILabel *timelab1 = _timeLab1;
        __weak UILabel *timelab2 = _timeLab2;
        _selTimeView.selectedTimeBlock = ^(NSString *time) {
            if (_selTimeType==1) {
                timelab1.text = time;
            }
            else if (_selTimeType==2)
            {
                timelab2.text = time;
            }
        };
    }
    return _selTimeView;
}








/// 隐藏

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if (self.hiddenBlcok) {
//        self.hiddenBlcok();
//    }
//}
- (IBAction)tap:(id)sender {
    if (self.hiddenBlcok) {
        self.hiddenBlcok();
    }
}

-(void)timeLabTap:(UITapGestureRecognizer *)tap
{
    if (tap.view == _timeLab1) {
        _selTimeType = 1;
    }
    else if(tap.view ==_timeLab2)
    {
        _selTimeType = 2;
    }
    [self.selTimeView show];

}

- (IBAction)sure:(id)sender {
    NSString *timeStr;
    NSInteger result = [_timeLab1.text compare:_timeLab2.text options:NSNumericSearch] ;
    NSString *valid;
    if (self.validBtn.isSelected == self.invalidBtn.isSelected) {
        valid = @"";
    }
    else
    {
        if (self.validBtn.selected) {
            valid = @"1";
        }
        else
        {
            valid = @"2";
        }
    }
    if ([_timeLab1.text isEqualToString:_timeLab2.text]&&[_timeLab2.text isEqualToString:DefaultTimeStr]) {
        timeStr = @"";
    }
    else if([_timeLab1.text isEqualToString:DefaultTimeStr])
    {
        [SVProgressHUD showInfoWithStatus:@"未设定公开时间上限"];
        return;
    }
    else if ([_timeLab2.text isEqualToString:DefaultTimeStr])
    {
        [SVProgressHUD showInfoWithStatus:@"未设定公开时间下限"];
        return;
    }
    else if (result == NSOrderedDescending)
    {
        [SVProgressHUD showInfoWithStatus:@"请设定正确的时间范围"];
        return;
    }
    else
    {
        timeStr=[NSString stringWithFormat:@"%@ TO %@",_timeLab1.text,_timeLab2.text];
    }
    NSString *addrcodes = [self.selAreaArray componentsJoinedByString:@" "];
    NSString *typecodes = [self.selPatentTypeArray componentsJoinedByString:@" "];
    NSString *ipccodes = [self.selIPCArray componentsJoinedByString:@" "];
    
    
    if (self.sureSelBlock) {
        self.sureSelBlock(_isChina, addrcodes, typecodes, timeStr,ipccodes,valid);
    }
}



@end
