//
//  PatentProgressViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/31.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentProgressViewController.h"
#import "PatentProgressTableViewCell.h"


@interface PatentProgressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PatentProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"专利进度";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self.tableView registerNib:[UINib nibWithNibName:@"PatentProgressTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatentProgressTableViewCell"];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatentProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatentProgressTableViewCell"];
    cell.index = indexPath.row;
    return cell;
}

@end
