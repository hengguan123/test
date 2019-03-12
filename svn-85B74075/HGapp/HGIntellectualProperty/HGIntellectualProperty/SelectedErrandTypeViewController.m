//
//  SelectedErrandTypeViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SelectedErrandTypeViewController.h"

@interface SelectedErrandTypeViewController ()

@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation SelectedErrandTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"差事类型";
    [self loaddata];
}

-(void)loaddata
{
    [RequestManager getErrandClassSuccessHandler:^(NSArray *array) {
        self.dataArray = array;
    } errorHandler:^(NSError *error) {
        
    }];
}
-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    CGFloat btnWidth = (ScreenWidth - 26*4)/3;
    NSInteger x = MIN(dataArray.count, 3);
    for (int i=0; i<x; i++) {
        ErrandClassModel *model = [dataArray objectAtIndex:i];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(26+i*(btnWidth+26), 35, btnWidth, 30)];
        
        btn.layer.cornerRadius = 5;
        
        [btn setTitle:model.dictionaryName forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        btn.backgroundColor = UIColorFromRGB(0xfe6246);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag =200+i;
        [self.view addSubview:btn];
        
    }
}

- (void)typeBtnClick:(UIButton *)sender {
    NSInteger tag = sender.tag - 200;
    ErrandClassModel *model = [self.dataArray objectAtIndex:tag];
    if (self.block) {
        self.block(model);
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
