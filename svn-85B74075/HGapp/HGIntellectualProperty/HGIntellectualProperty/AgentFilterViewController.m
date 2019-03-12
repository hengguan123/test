//
//  AgentFilterViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/4.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AgentFilterViewController.h"
#import "SelectedTimeView.h"
#import "AreaChildTableViewCell.h"

@interface AgentFilterViewController ()<UITableViewDelegate,UITableViewDataSource,AreaChildTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *provinceArray;
@property (nonatomic,strong)NSArray *countryArray;
@property (nonatomic,strong)NSArray *tradeMarkArray;
@property (nonatomic,strong)UIView *secHeaderView;


@property (nonatomic,strong)NSMutableArray *selPatentTypeArray;
@property (nonatomic,strong)NSMutableArray *selAreaArray;
@property (nonatomic,strong)NSMutableArray *selIPCArray;
@property (nonatomic,strong)SelectedTimeView *selTimeView;

@property (nonatomic,strong)UIView *starView;


@end

@implementation AgentFilterViewController
{
    NSArray *_typeArray;
    NSArray *_IPCArray;
    AreaModel *_selCityModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [RequestManager getFieldListSuccessHandler:^(NSArray *array) {
        _IPCArray = array;
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        
    }];
    [RequestManager getErrandClassSuccessHandler:^(NSArray *array) {
        _typeArray = array;
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        
    }];
    
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
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return MIN(3, _typeArray.count);
    }
    else if (section==1)
    {
        return 1;
    }
    else if (section==2)
    {
        return _IPCArray.count;
    }
    else if (section==3)
    {
        return self.provinceArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        ErrandClassModel *model = [_typeArray objectAtIndex:indexPath.row];
        if ([self.selTypeCode isEqualToString:model.dictionaryCode] ) {
            cell.textLabel.textColor = MainColor;
        }
        else
        {
            cell.textLabel.textColor = UIColorFromRGB(0x666666);
        }
        cell.textLabel.text = model.dictionaryName;
        return cell;
    }
    else if(indexPath.section == 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.starView];
        
        return cell;
    }
    else if(indexPath.section == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"provinceCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"provinceCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        ErrandClassModel *model = [_IPCArray objectAtIndex:indexPath.row];
        //            if ([self.selIPCArray containsObject:model.dictionaryCode]) {
        //                cell.textLabel.textColor = MainColor;
        //            }
        //            else
        //            {
        //                cell.textLabel.textColor = UIColorFromRGB(0x666666);
        //            }
        if ([model.dictionaryCode isEqualToString:self.selDomainCode]) {
            cell.textLabel.textColor = MainColor;
        }
        else
        {
            cell.textLabel.textColor = UIColorFromRGB(0x666666);
        }
        cell.textLabel.text = model.dictionaryName;

        return cell;
    }
    else if(indexPath.section ==3)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"AreaChildTableViewCell" bundle:nil] forCellReuseIdentifier:@"AreaChildTableViewCell"];
        AreaChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaChildTableViewCell"];
        AreaModel *model = [self.provinceArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.provinceModel = model;
        
        return cell;
    }
    else
        return nil;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 4) {
        NSArray *array = @[@"专利类型",@"服务星级",@"所属领域",@"区域"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        view.backgroundColor = UIColorFromRGB(0xf2f2f2);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 24)];
        lab.text = [array objectAtIndex:section];
        lab.textColor = UIColorFromRGB(0x333333);
        lab.font = [UIFont systemFontOfSize:14];
        [view addSubview:lab];
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 34.0;
    }
    else if (indexPath.section==1)
    {
        return 44;
    }
    else if (indexPath.section ==2)
    {
        return 34.0;
    }
    else if (indexPath.section ==3)
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
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ErrandClassModel *model = [_typeArray objectAtIndex:indexPath.row];
        self.selTypeCode = model.dictionaryCode;
        [tableView reloadData];
    }
    
    else if (indexPath.section == 2)
    {
        ErrandClassModel *model = [_IPCArray objectAtIndex:indexPath.row];
//        if ([self.selIPCArray containsObject:model.dictionaryCode]) {
//            [self.selIPCArray removeObject:model.dictionaryCode];
//        }
//        else
//        {
//            [self.selIPCArray addObject:model.dictionaryCode];
//            
//        }
        self.selDomainCode = model.dictionaryCode;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        
        
    }
    else if(indexPath.section == 3)
    {
        AreaModel *model;
        model = [self.provinceArray objectAtIndex:indexPath.row];
//        if (indexPath.row == 0) {
//            [self.selAreaArray removeAllObjects];
//            [self.selAreaArray addObject:model.addrName];
//        }
//        else
//        {
//            AreaModel *armodel = [self.provinceArray firstObject];
//            if ([self.selAreaArray containsObject:armodel.addrName]) {
//                [self.selAreaArray removeObject:armodel.addrName];
//            }
//            if ([self.selAreaArray containsObject:model.addrName]) {
//                [self.selAreaArray removeObject:model.addrName];
//            }
//            else
//            {
//                [self.selAreaArray addObject:model.addrName];
//            }
//        }
        model.open = !model.isOpen;
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
    ErrandClassModel *model = [_typeArray objectAtIndex:btn.tag];
    if ([self.selPatentTypeArray containsObject:model.dictionaryCode]) {
        [self.selPatentTypeArray removeObject:model.dictionaryCode];
    }
    else
    {
        [self.selPatentTypeArray addObject:model.dictionaryCode];
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

-(UIView *)starView
{
    if (!_starView) {
        _starView = [[UIView alloc]initWithFrame:CGRectMake(30, 10, 200, 24)];
        for (int i=0; i<5; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40*i, 0, 40, 24)];
            imageView.image = [UIImage imageNamed:@"agentstar_nor"];
            imageView.tag = i;
            imageView.contentMode =UIViewContentModeCenter;
            [_starView addSubview:imageView];
        }
//        _starView.layer.borderWidth = 1;
//        _starView.layer.borderColor = MainColor.CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starTap:)];
        _starView.userInteractionEnabled = YES;
        [_starView addGestureRecognizer:tap];
    }
    return _starView;
}
-(void)starTap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:tap.view];
    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
    NSInteger x = point.x/40;
    for (UIView *view in self.starView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            if (imageView.tag<=x) {
                imageView.image = [UIImage imageNamed:@"agentstar_sel"];
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"agentstar_nor"];
            }
        }
    }
    self.star = x+1;
}

#pragma mark AreaChildTableViewCellDelegate
-(void)areaChildTableViewCell:(AreaChildTableViewCell *)cell didSelAreaItemWithModel:(AreaModel *)model
{
    _selCityModel.selected = NO;
    _selCityModel = model;
    model.selected = YES;
    [self.tableView reloadData];
}



- (IBAction)sure:(id)sender {
    if (self.sureSelBlock) {
        self.sureSelBlock(_selCityModel.addrCode, self.selTypeCode, self.star, self.selDomainCode);
    }
}

- (IBAction)dismissTap:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


@end
