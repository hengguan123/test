//
//  FilterViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterHeaderView.h"
#import "CityTableViewCell.h"
#import "CitySectionHeaderView.h"

@interface FilterViewController ()<UITableViewDelegate,UITableViewDataSource,CitySectionHeaderViewDelegate,CityTableViewCellDelegate,FilterHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIView *headerView;


@property (nonatomic,strong)NSArray *provinceArray;

@property (nonatomic,strong)NSMutableString *typeStr;
@property (nonatomic,strong)NSMutableString *addressStr;
@property (nonatomic,strong)NSMutableArray *addrArray;

@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;



@end

@implementation FilterViewController
{
    NSArray *_domainArray,*_typeArray,*_subTypeArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //rowHeight属性设置为UITableViewAutomaticDimension
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.provinceArray = [AppUserDefaults share].provinceArray;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableView

-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-100, 120)];
        _headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        NSArray *array = @[@"专利",@"商标",@"版权"];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FilterWidth, 40)];
        view1.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [_headerView addSubview:view1];
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 22)];
        lab1.textColor = UIColorFromRGB(0x666666);
        lab1.font = [UIFont systemFontOfSize:12];
        lab1.text = @"业务类型：";
        [view1 addSubview:lab1];
        
        CGFloat width = (ScreenWidth -140)/3;
        
        for (int i=0; i<array.count; i++) {
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+(width+10)*i, 48, width, 24)];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 5;
            btn.tag = 100+i;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor =UIColorFromRGBA(0x666666, 0.3).CGColor;
            [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:btn];
        }
        
        UIView *typeBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth-100, 60)];
        typeBgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        typeBgView.tag = 1001;
        [_headerView addSubview:typeBgView];
        
        UILabel *typelab = [[UILabel alloc]initWithFrame:CGRectMake(10,0, 150, 20)];
        typelab.textColor = UIColorFromRGB(0x666666);
        typelab.font = [UIFont systemFontOfSize:12];
        typelab.text = @"专利类型：";
        [typeBgView addSubview:typelab];
        
        NSArray *typeArray = @[@"发明专利",@"实用新型",@"外观专利"];
        for (int i=0; i<array.count; i++) {
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+(width+10)*i, 28, width, 24)];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 5;
            btn.tag = 10+i;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor =UIColorFromRGBA(0x666666, 0.3).CGColor;
            [btn setTitle:[typeArray objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [btn addTarget:self action:@selector(typeClcik:) forControlEvents:UIControlEventTouchUpInside];
            [typeBgView addSubview:btn];
        }
        typeBgView.hidden = YES;
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 79, FilterWidth, 40)];
        view2.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [_headerView addSubview:view2];
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
        lab2.textColor = UIColorFromRGB(0x666666);
        //        lab2.backgroundColor = [UIColor redColor];
        lab2.font = [UIFont systemFontOfSize:12];
        lab2.text = @"选择区域:";
        view2.tag = 1000;
        [view2 addSubview:lab2];
        NSArray *areaArray = @[@"国内",@"国际"];
        for (int i=0; i<2; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(70+(width+10)*i, 8, width, 24)];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 5;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor =UIColorFromRGBA(0x666666, 0.3).CGColor;
            btn.tag = 10+i;
            [btn setTitle:[areaArray objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [btn addTarget:self action:@selector(areaClcik:) forControlEvents:UIControlEventTouchUpInside];
            [view2 addSubview:btn];
        }
        
    }
    return _headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.provinceArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AreaModel *model = [self.provinceArray objectAtIndex:section];
    if (model.isOpen) {
        return 1;
    }
    else
    {
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==2) {
//        return 100;
//    }
//    else{
//        return 0;
//    }
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:nil] forCellReuseIdentifier:@"CityTableViewCell"];
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell"];
    cell.frame = tableView.bounds;
    [cell layoutIfNeeded];
    cell.delegate = self;
    AreaModel *model = [self.provinceArray objectAtIndex:indexPath.section];
    cell.cityArray = model.subAddsArray;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CitySectionHeaderView *view = [[CitySectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-100, 34)];
    AreaModel *model  = [self.provinceArray objectAtIndex:section];
    view.open = model.isOpen;
    view.delegate = self;
    view.sention = section;
    view.provinceName = model.addrName;
    return view;
}

-(void)cityTableViewCell:(CityTableViewCell *)cityTableViewCell didSelectedItemWithCityModel:(AreaModel *)cityModel
{
    if (cityModel.isSelected) {
        if (![self.addrArray containsObject:cityModel.addrCode]) {
            [self.addrArray addObject:cityModel.addrCode];
        }
    }
    else
    {
        if ([self.addrArray containsObject:cityModel.addrCode]) {
            [self.addrArray removeObject:cityModel.addrCode];
        }
    }
}


-(void)openOrCloseCitySectionHeaderView:(CitySectionHeaderView *)citySectionHeaderView
{
    NSInteger section = citySectionHeaderView.sention;
    AreaModel *model = [self.provinceArray objectAtIndex:section];
    model.open = !citySectionHeaderView.isOpen;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark delegate-----filterHeader
/*
 YWLX02-04-01 发明专利
 YWLX02-04-02 实用新型
 YWLX02-04-03 外观专利
 YWLX02-05  版权
 YWLX02-06  商标
 */
-(NSMutableString *)typeStr
{
    if (!_typeStr) {
        _typeStr = [NSMutableString new];
    }
    return _typeStr;
}
-(NSMutableString *)addressStr
{
    if (!_addressStr) {
        _addressStr = [NSMutableString new];
    }
    return _addressStr;
}

-(NSMutableArray *)addrArray
{
    if (!_addrArray) {
        _addrArray = [NSMutableArray new];
    }
    return _addrArray;
}

- (void)btnClcik:(UIButton *)sender
{
    UIView *typeBgView = [self.headerView viewWithTag:1001];
    if (sender.tag==100) {
        if (typeBgView.hidden) {
            self.headerView.frame = CGRectMake(0, 0, ScreenWidth-100, 180);
            typeBgView.hidden = NO;
        }
        else
        {
            self.headerView.frame = CGRectMake(0, 0, ScreenWidth-100, 120);
            typeBgView.hidden = YES;
        }
    }
    else
    {
        sender.selected = !sender.isSelected;
        if (sender.selected) {
            sender.backgroundColor = MainColor;
        }
        else
        {
            sender.backgroundColor = [UIColor whiteColor];
        }
        if (sender.tag ==101) {
            [self setCodeWith:@"YWLX02-06"];
        }
        else
        {
            [self setCodeWith:@"YWLX02-05"];
        }
    }
    
    UIView *view = [self.headerView viewWithTag:1000];
    view.frame = CGRectMake(0, self.headerView.bounds.size.height-41, ScreenWidth-100, 40)
    ;
    [self.tableView reloadData];
}

-(void)setCodeWith:(NSString *)code
{
    NSString *str  = [NSString stringWithFormat:@",%@",code];
    if ([self.typeStr containsString:str]) {
        [self.typeStr deleteCharactersInRange:[self.typeStr rangeOfString:str]];
    }
    else
    {
        [self.typeStr appendString:str];
    }
    
    NSLog(@"%@",self.typeStr);
}

-(void)typeClcik:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        sender.backgroundColor = MainColor;
    }
    else
    {
        sender.backgroundColor = [UIColor whiteColor];
    }
    if (sender.tag == 10) {
        [self setCodeWith:@"YWLX02-04-01"];
    }
    else if (sender.tag == 11)
    {
        [self setCodeWith:@"YWLX02-04-02"];
    }
    else if (sender.tag ==12)
    {
        [self setCodeWith:@"YWLX02-04-03"];
    }
    UIView *typeBgView = [self.headerView viewWithTag:1001];
    UIButton *paBtn = [self.headerView viewWithTag:100];
    for (UIView *view in typeBgView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.isSelected) {
                paBtn.selected = YES;
                paBtn.backgroundColor = MainColor;
                return;
            }
        }
        paBtn.selected = NO;
        paBtn.backgroundColor = [UIColor whiteColor];
        
    }
    
}
-(void)areaClcik:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        sender.backgroundColor = MainColor;
    }
    else
    {
        sender.backgroundColor = [UIColor whiteColor];
    }
    if (sender.tag == 10) {
        if (sender.selected) {
            if (![self.addrArray containsObject:@"CHN"])
            {
                [self.addrArray addObject:@"CHN"];
            }
        }
        else
        {
            if ([self.addrArray containsObject:@"CHN"])
            {
                [self.addrArray removeObject:@"CHN"];
            }
        }
    }
    else
    {
        if (sender.selected) {
            if (![self.addrArray containsObject:@"FOREIGN"])
            {
                [self.addrArray addObject:@"FOREIGN"];
            }
        }
        else
        {
            if ([self.addrArray containsObject:@"FOREIGN"])
            {
                [self.addrArray removeObject:@"FOREIGN"];
            }
        }
    }
}

- (IBAction)reSet:(id)sender {
    
    [self.typeStr deleteCharactersInRange:NSMakeRange(0, self.typeStr.length)];
    [self.addrArray removeAllObjects];
    for (AreaModel *model in self.provinceArray) {
        model.selected = NO;
        for (AreaModel *childModel in model.subAddsArray) {
            childModel.selected = NO;
        }
    }
    for (UIView *view in self.headerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton *)view).selected = NO;
            view.backgroundColor = [UIColor whiteColor];
        }
    }
    UIView *typeBgView = [self.headerView viewWithTag:1001];
    for (UIView *view in typeBgView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton *)view).selected = NO;
            view.backgroundColor = [UIColor whiteColor];
        }
    }
    UIView *areaView = [self.headerView viewWithTag:1000];
    for (UIView *view in areaView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton *)view).selected = NO;
            view.backgroundColor = [UIColor whiteColor];
        }
    }
    [self.tableView reloadData];
}
- (IBAction)finish:(id)sender {
    
    [self runBlock];
    
    if (self.finishBlcok) {
        self.finishBlcok();
    }
}

- (void)runBlock
{
    NSString *addStr = @"";
    if (self.addrArray.count) {
        addStr = [self.addrArray componentsJoinedByString:@","];
    }
    if ([self.addrArray containsObject:@"CHN"]&&[self.addrArray containsObject:@"FOREIGN"]) {
        addStr = @"";
    }
    if (self.selectItemBlock) {
        self.selectItemBlock(addStr, self.typeStr);
    }
}

@end

