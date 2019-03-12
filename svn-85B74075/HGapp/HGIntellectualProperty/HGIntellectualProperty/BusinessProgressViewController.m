//
//  BusinessProgressViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/5/9.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "BusinessProgressViewController.h"
#import "BusinessProgressTableViewCell.h"

@interface BusinessProgressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArray;


@end

@implementation BusinessProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"业务进度";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessProgressTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessProgressTableViewCell"];
    
    self.nameLab.text = self.model.goodsName;
    self.priceLab.text = [NSString stringWithFormat:@"%@",self.model.goodsPrice];
    self.timeLab.text = self.model.createTime;
    self.typeImageView.image = [UIImage imageNamed:self.model.type];
    [RequestManager getOrderProcessWith:self.model.orderInfoId successHandler:^(NSArray *array) {
        self.dataArray = array;
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        
    }];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessProgressTableViewCell"];
    if (indexPath.row == 0 &&self.dataArray.count == 1) {
        cell.type = BusinessProgressTypeFirstAndCurrent;
    }
    else if(indexPath.row == self.dataArray.count-1){
        cell.type = BusinessProgressTypeFirst;
    }
    else if (indexPath.row == 0 &&self.dataArray.count != 1)
    {
        cell.type = BusinessProgressTypeCurrent;
    }
    else{
        cell.type = BusinessProgressTypeDefault;
    }
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
