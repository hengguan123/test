//
//  CityTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CityTableViewCell.h"
#import "CityCollectionViewCell.h"

@interface CityTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (nonatomic,strong)UIView *resultView;

@end

@implementation CityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CityCollectionViewCell"];
    
     
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCityArray:(NSArray *)cityArray
{
    _cityArray = cityArray;
    [self.collectionView reloadData];
    [self updateConstraintsIfNeeded];
    
    
    self.collectionViewHeight.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    NSLog(@"======%f=====",self.collectionView.contentSize.height);
}
#pragma mark -collection相关
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cityArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityCollectionViewCell" forIndexPath:indexPath];
    AreaModel *model = [self.cityArray objectAtIndex:indexPath.row];
    cell.cityModel = model;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AreaModel *model = [self.cityArray objectAtIndex:indexPath.row];
    model.selected = !model.isSelected;
    [self.collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityTableViewCell:didSelectedItemWithCityModel:)]) {
        [self.delegate cityTableViewCell:self didSelectedItemWithCityModel:model];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AreaModel *model = [self.cityArray objectAtIndex:indexPath.row];
    CGSize titleSize = [model.addrName  boundingRectWithSize:CGSizeMake(MAXFLOAT, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    return  CGSizeMake(titleSize.width+20, 24);
   
}




@end
