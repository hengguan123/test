//
//  AreaChildTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AreaChildTableViewCell.h"
#import "AreaCityCollectionViewCell.h"
@interface AreaChildTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *updownBtn;
@property (weak, nonatomic) IBOutlet UILabel *provinceLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation AreaChildTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AreaCityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AreaCityCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setProvinceModel:(AreaModel *)provinceModel
{
    _provinceModel = provinceModel;
    self.provinceLab.text = provinceModel.addrName;
    [self.collectionView reloadData];
}
#pragma mark -collection相关
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.provinceModel.subAddsArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AreaCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AreaCityCollectionViewCell" forIndexPath:indexPath];
    AreaModel *model = [self.provinceModel.subAddsArray objectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AreaModel *model = [self.provinceModel.subAddsArray objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(areaChildTableViewCell:didSelAreaItemWithModel:)]) {
        [self.delegate areaChildTableViewCell:self didSelAreaItemWithModel:model];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((self.bounds.size.width-40)/3, 46);
}


@end
