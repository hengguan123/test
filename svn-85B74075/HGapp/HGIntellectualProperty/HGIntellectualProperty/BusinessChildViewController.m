//
//  BusinessChildViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "BusinessChildViewController.h"
#import "SetPriceTableViewCell.h"
#import "SubTypeStarTableViewCell.h"

#import "BusinessTypeCollectionViewCell.h"
@interface BusinessChildViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,BusinessTypeCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectiongView;

@end

@implementation BusinessChildViewController
{
    NSInteger _currentIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self reloadBtnUI];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.collectiongView registerNib:[UINib nibWithNibName:@"BusinessTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BusinessTypeCollectionViewCell"];
}

- (void)reloadBtnUI
{
    
}

-(void)btnClick:(UIButton *)btn
{
    _currentIndex = btn.tag-100;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.type isEqualToString:@"1"]) {
        return 2;
    }
    else
    {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (self.typeArray.count>_currentIndex) {
            BusinessModel *model = [self.typeArray objectAtIndex:_currentIndex];
            if (self.isEditing) {
                return [self addModelToArrayWithModdel:model].count;
            }
            else
            {
                return [self filterArray:[self addModelToArrayWithModdel:model]].count;
            }
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if (self.isEditing) {
             return self.domainArray.count;
        }
        else
        {
            return [self filterArray:self.domainArray].count;
        }
    }
}

-(NSArray *)filterArray:(NSArray *)array
{
    NSMutableArray *mutArray = [NSMutableArray new];
    for (BusinessModel *model in array) {
        if ([model.auditStatus boolValue]) {
            [mutArray addObject:model];
        }
    }
    return mutArray;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [self.tableView registerNib:[UINib nibWithNibName:@"SubTypeStarTableViewCell" bundle:nil] forCellReuseIdentifier:@"SubTypeStarTableViewCell"];
        SubTypeStarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubTypeStarTableViewCell"];
        cell.index = indexPath.row;
        BusinessModel *model = [self.typeArray objectAtIndex:_currentIndex];
        cell.model = [[self addModelToArrayWithModdel:model] objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"SetPriceTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetPriceTableViewCell"];
        SetPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetPriceTableViewCell"];
        cell.busiModel = [self.domainArray objectAtIndex:indexPath.row];
        return cell;
    }
}

-(NSArray *)addModelToArrayWithModdel:(BusinessModel *)model
{
    NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:model.listChild];
    [muArray insertObject:model atIndex:0];
    return muArray;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
    {
        return 34;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        view.backgroundColor = UIColorFromRGB(0xf2f2f2);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 24)];
        lab.text = @"擅长领域";
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = UIColorFromRGB(0x666666);
        [view addSubview:lab];
        return view;
    }
    else
        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            [SVProgressHUD showInfoWithStatus:@"默认选中，不可取消"];
        }
        else
        {
            BusinessModel *model = [self.typeArray objectAtIndex:_currentIndex];
            BusinessModel *subModel = [[self addModelToArrayWithModdel:model] objectAtIndex:indexPath.row];
            if ([subModel.delFlag boolValue]) {
                subModel.delFlag = @"0";
            }
            else
            {
                subModel.delFlag = @"1";
            }
        }
        
    }
    else
    {
        BusinessModel *model = [self.domainArray objectAtIndex:indexPath.row];
        if ([model.delFlag boolValue]) {
            model.delFlag = @"0";
        }
        else
            model.delFlag = @"1";
    }
    [self.tableView reloadData];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"脱宅");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark collectionView
#pragma mark -collection相关
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.typeArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BusinessTypeCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row==_currentIndex) {
//        cell.backgroundColor = UIColorFromRGB(0xFFAE94);
        cell.canEdit = YES;
    }
    else
    {
//        cell.backgroundColor = [UIColor whiteColor];
        cell.canEdit = NO;
    }
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.model = [self.typeArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndex = indexPath.row;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.tableView reloadData];
    [self.collectiongView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(ScreenWidth/self.typeArray.count, self.btnBgView.bounds.size.height);
}

-(void)selBtnClickWithBusinessTypeCollectionViewCell:(BusinessTypeCollectionViewCell *)cell
{
    _currentIndex = cell.index;
    [self.collectiongView reloadData];
    [self.tableView reloadData];
}

//-(void)cancelSelBtnWithBusinessTypeCollectionViewCell:(BusinessTypeCollectionViewCell *)cell
//{
//    BusinessModel *model = [self.typeArray objectAtIndex:_currentIndex];
//    for (BusinessModel *subModel in model.listChild) {
//        subModel.delFlag = @"1";
//    }
//    [self.tableView reloadData];
//}


@end
