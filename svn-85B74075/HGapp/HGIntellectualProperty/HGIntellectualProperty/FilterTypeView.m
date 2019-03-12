//
//  FilterTypeView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "FilterTypeView.h"
#import "CityCollectionViewCell.h"
#import "TypeReusableView.h"
#import "FilterTypeModel.h"
@interface FilterTypeView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation FilterTypeView

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"FilterTypeView" owner:nil options:nil]objectAtIndex:0];
//    self.frame = CGRectMake(0, 0, ScreenWidth-100, 150);
    [self.collectionView registerNib:[UINib nibWithNibName:@"TypeReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TypeReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CityCollectionViewCell"];
    
    [self.collectionView reloadData];
    
    return self;
}

-(NSArray *)dataArray
{
    if (!_dataArray) {
        NSString *strPath = [[NSBundle mainBundle] pathForResource:@"ErrandFilterJson" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:strPath];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        _dataArray = [NSArray yy_modelArrayWithClass:[FilterTypeModel class] json:array];
    }
    return _dataArray;
}
-(NSArray *)areaArray
{
    if (!_areaArray) {
        FilterTypeModel *model1 = [FilterTypeModel new];
        model1.name = @"国内";
        model1.code = @"CHN";
        model1.isSel = NO;
        FilterTypeModel *model2 = [FilterTypeModel new];
        model2.name = @"国际";
        model2.code = @"FOREIGN";
        model2.isSel = NO;
        _areaArray = @[model1,model2];
    }
    return _areaArray;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }
    else if (section == 1)
    {
        if ([self.selModel1.level integerValue]==2) {
            return self.selModel1.childArray.count;
        }
        else
        {
            return 0;
        }
    }
    else if (section == 2)
    {
        if ([self.selModel1.level integerValue]==3) {
            return self.selModel1.childArray.count;
        }
        else if ([self.selModel2.level integerValue]==3)
        {
            return self.selModel2.childArray.count;
        }
        else
        {
            return 0;
        }
    }
    else if (section == 3)
    {
        return self.areaArray.count;
    }
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.selModel1.isSel = NO;
        self.selModel2.isSel = NO;
        self.selModel3.isSel = NO;
        self.selModel2 = nil;
        self.selModel3 = nil;
//        if (self.selModel1 == [self.dataArray objectAtIndex:indexPath.row]) {
//            self.selModel1 = nil;
//        }
//        else
//        {
            self.selModel1 = [self.dataArray objectAtIndex:indexPath.row];
            self.selModel1.isSel = YES;
//        }
    }
    else if (indexPath.section == 1)
    {
        self.selModel2.isSel = NO;
        self.selModel3.isSel = NO;
        self.selModel3 = nil;
//        if (self.selModel2 == [self.selModel1.childArray objectAtIndex:indexPath.row]) {
//            self.selModel2 = nil;
//        }
//        else
//        {
            self.selModel2 = [self.selModel1.childArray objectAtIndex:indexPath.row];
            self.selModel2.isSel = YES;
//        }
        
    }
    else if (indexPath.section == 2)
    {
        self.selModel3.isSel = NO;
        if (self.selModel2) {
            self.selModel3 = [self.selModel2.childArray objectAtIndex:indexPath.row];
            self.selModel3.isSel = YES;
        }
        else
        {
            self.selModel3 = [self.selModel1.childArray objectAtIndex:indexPath.row];
            self.selModel3.isSel = YES;
        }
    }
    else if (indexPath.section==3)
    {
        FilterTypeModel *model = [self.areaArray objectAtIndex:indexPath.row];
        model.isSel = !model.isSel;
    }
    [collectionView reloadData];
    [collectionView layoutIfNeeded];
    NSLog(@"%f",collectionView.contentSize.height);
    self.frame = CGRectMake(0, 0, collectionView.frame.size.width, collectionView.contentSize.height+10);
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadFrame)]) {
        [self.delegate reloadFrame];
    }
}


//协议方法里面创建头视图

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSArray *titleArr = @[@"业务类型",@"专利类型",@"详细业务",@"所在地"];
    TypeReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TypeReusableView" forIndexPath:indexPath];
    header.title = [titleArr objectAtIndex:indexPath.section];
    return header;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.filterModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 1)
    {
        cell.filterModel = [self.selModel1.childArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2)
    {
        if (self.selModel2) {
            cell.filterModel = [self.selModel2.childArray objectAtIndex:indexPath.row];
        }
        else
        {
            cell.filterModel = [self.selModel1.childArray objectAtIndex:indexPath.row];
        }
    }
    else if (indexPath.section == 3)
    {
        cell.filterModel = [self.areaArray objectAtIndex:indexPath.row];
    }
    
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.frame.size.width-40)/3 , 25);
}
//设置宽高

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section

{
    if (section == 0) {
        return CGSizeMake(self.frame.size.width,30);
    }
    else if (section == 1)
    {
        if ([self.selModel1.level integerValue]==2) {
            return CGSizeMake(self.frame.size.width,30);
        }
        else
        {
            return CGSizeMake(0,0);
        }
    }
    else if (section == 2)
    {
        if ([self.selModel1.level integerValue]==3) {
            return CGSizeMake(self.frame.size.width,30);
        }
        else if ([self.selModel2.level integerValue]==3)
        {
            return CGSizeMake(self.frame.size.width,30);
        }
        else
        {
            return CGSizeMake(0,0);
        }
    }
    else if (section == 3)
    {
        return CGSizeMake(self.frame.size.width,30);
    }
    return CGSizeMake(self.frame.size.width,30);
}

-(void)reset
{
    self.dataArray = nil;
    self.areaArray = nil;
    self.selModel1 = nil;
    self.selModel2 = nil;
    self.selModel3 = nil;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];

    self.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, self.collectionView.contentSize.height+10);
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadFrame)]) {
        [self.delegate reloadFrame];
    }
}

@end
