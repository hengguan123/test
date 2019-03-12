//
//  MyBusinessTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/4/26.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "MyBusinessTableViewCell.h"
#import "ChildBusinessCollectionViewCell.h"

@interface MyBusinessTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic,strong)NSArray *dataArray;

@end
@implementation MyBusinessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChildBusinessCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChildBusinessCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    self.orderNo.text = orderModel.orderNo;
    self.orderStatus.text = orderModel.orderStatus;
    self.creatTimeLab.text = orderModel.createTime;
    self.priceLab.text = [NSString stringWithFormat:@"订单金额:%@",orderModel.orderPrice];
    self.dataArray = orderModel.listOrderInfo;
    [self.collectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChildBusinessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChildBusinessCollectionViewCell" forIndexPath:indexPath];
    cell.model = [self.orderModel.listOrderInfo objectAtIndex:indexPath.row];
    return cell;
}

@end
