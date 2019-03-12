//
//  ErrandFilterViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/25.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ErrandFilterViewController.h"
#import "FilterTypeModel.h"
#import "FilterTypeView.h"
#import "AreaChildTableViewCell.h"

@interface ErrandFilterViewController ()<UITableViewDelegate,UITableViewDataSource,FilterTypeViewDelegate,AreaChildTableViewCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) FilterTypeView *headerView;

@property (nonatomic,strong)NSArray *provinceArray;
@property (nonatomic,strong)NSArray *typeArray;

@property (nonatomic,strong)NSMutableArray *selAreaArray;


@end

@implementation ErrandFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-44);

        } else {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-44);
        }
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    UIView *view = [[UIView alloc]init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(44);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(0);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        }
        ;
    }];
    UIButton *resetBtn = [[UIButton alloc]init];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    resetBtn.backgroundColor = [UIColor whiteColor];
    [resetBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(reSet) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:resetBtn];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(0);
        make.right.equalTo(view.mas_centerX).offset(0);
        make.bottom.equalTo(view).offset(0);
        make.top.equalTo(view).offset(0);
    }];
    UIButton *sureBtn = [[UIButton alloc]init];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sureBtn.backgroundColor = MainColor;
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_centerX).offset(0);
        make.right.equalTo(view).offset(0);
        make.bottom.equalTo(view).offset(0);
        make.top.equalTo(view).offset(0);
    }];
}

-(UITableView *)tableView
{
    if (!_tableView ) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}


-(FilterTypeView *)headerView
{
    if (!_headerView) {
        _headerView = [[FilterTypeView alloc]init];
        _headerView.frame = CGRectMake(0, 0, ScreenWidth-100, 120);
        _headerView.delegate = self;
    }
    return _headerView;
}
-(void)reloadFrame
{
    [self.tableView reloadData];
}


#pragma mark  tableVview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.provinceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib:[UINib nibWithNibName:@"AreaChildTableViewCell" bundle:nil] forCellReuseIdentifier:@"AreaChildTableViewCell"];
    AreaChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaChildTableViewCell"];
    AreaModel *model = [self.provinceArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.provinceModel = model;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaModel *model = [_provinceArray objectAtIndex:indexPath.row];
    NSInteger remainder = model.subAddsArray.count%3;
    NSInteger result;
    if (remainder) {
        result = model.subAddsArray.count/3+1;
    }
    else
    {
        result = model.subAddsArray.count/3;
    }
    if (model.open) {
        return 34+result*56;
    }
    else
    {
        return 34;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaModel *model;
    model = [self.provinceArray objectAtIndex:indexPath.row];
    model.open = !model.isOpen;
    [self.tableView reloadData];
}


-(NSArray *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [AppUserDefaults share].provinceArray;
    }
    return _provinceArray;
}

#pragma mark AreaChildTableViewCellDelegate
-(NSMutableArray *)selAreaArray
{
    if (!_selAreaArray) {
        _selAreaArray = [NSMutableArray new];
    }
    return _selAreaArray;
}
-(void)areaChildTableViewCell:(AreaChildTableViewCell *)cell didSelAreaItemWithModel:(AreaModel *)model
{
    model.selected = !model.selected;
    if (model.selected) {
        if (![self.selAreaArray containsObject:model.addrCode]) {
            [self.selAreaArray addObject:model.addrCode];
        }
    }
    else
    {
        if ([self.selAreaArray containsObject:model.addrCode]) {
            [self.selAreaArray removeObject:model.addrCode];
        }
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)viewLayoutMarginsDidChange
{
    [super viewLayoutMarginsDidChange];
    self.tableView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-64);
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth-100, 120);

    NSLog(@"gaibianle");
}

-(void)reSet
{
    [self.headerView reset];
    [self.selAreaArray removeAllObjects];
    for (AreaModel *model in self.provinceArray) {
        for (AreaModel *subModel in model.subAddsArray) {
            subModel.selected = NO;
        }
    }
    [self.tableView reloadData];
}
-(void)sure
{
    NSString *addStr = @"";
    if (self.selAreaArray.count) {
        addStr = [self.selAreaArray componentsJoinedByString:@","];
    }
    for (FilterTypeModel *model in self.headerView.areaArray) {
        if (model.isSel) {
            addStr = [addStr stringByAppendingFormat:@",%@",model.code];
        }
    }
    if ([addStr containsString:@"CHN,FOREIGN"]) {
        addStr = @"";
    }
    
    
    NSString *typeLike = @"";
    NSString *subTypeStr = @"";
    if (self.headerView.selModel3) {
        subTypeStr = self.headerView.selModel3.code;
    }
    else
    {
        if (self.headerView.selModel2) {
            typeLike = self.headerView.selModel2.code;
        }
        else
        {
            if(self.headerView.selModel1)
            {
                typeLike = self.headerView.selModel1.code;
            }
        }
    }
    if ([addStr hasPrefix:@","]) {
        addStr = [addStr substringFromIndex:1];
    }
    if (self.selectItemsBlock) {
        self.selectItemsBlock(addStr, typeLike, subTypeStr);
    }
}

@end
