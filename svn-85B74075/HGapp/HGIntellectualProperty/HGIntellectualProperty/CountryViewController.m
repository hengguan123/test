//
//  CountryViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/20.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CountryViewController.h"

@interface CountryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableArray *selArray;

@end

@implementation CountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)dataArray
{
    if (!_dataArray) {
        NSString *strPath = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:strPath];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        _dataArray = [MTLJSONAdapter modelsOfClass:[AreaModel class] fromJSONArray:array error:nil];
    }
    return _dataArray;
}
-(NSMutableArray *)selArray
{
    if (!_selArray) {
        _selArray = [NSMutableArray new];
    }
    return _selArray;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"countryCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    AreaModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([self.selArray containsObject:model.addrCode]) {
        cell.textLabel.textColor = MainColor;
    }
    else
    {
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
    }
    cell.textLabel.text = model.addrName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        [self.selArray removeAllObjects];
        [self.selArray addObject:model.addrCode];
    }
    else
    {
        AreaModel *all = [self.dataArray firstObject];
        if ([self.selArray containsObject:all.addrCode]) {
            [self.selArray removeObject:all.addrCode];
        }
        if ([self.selArray containsObject:model.addrCode]) {
            [self.selArray removeObject:model.addrCode];
        }
        else
        {
            if (self.selArray.count>=10) {
                [SVProgressHUD showInfoWithStatus:@"所选不能超10个"];
            }
            else{
                [self.selArray addObject:model.addrCode];
            }
        }
    }
    
    [tableView reloadData];
}

-(void)block
{
    NSString *countrys = [self.selArray componentsJoinedByString:@" "];
    NSLog(@"%@",countrys);
    if (self.selCountryBlock) {
        self.selCountryBlock(countrys);
    }
}

- (IBAction)hidden:(id)sender {
    if (self.finishBlock) {
        self.finishBlock();
    }
}

- (IBAction)sure:(id)sender {
    [self block];
}

@end
