
//  SelectedCityViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SelectedCityViewController.h"
#import "CityTableViewCell.h"
#import "CitySectionHeaderView.h"


@interface SelectedCityViewController ()<UITableViewDelegate,UITableViewDataSource,CitySectionHeaderViewDelegate,CityTableViewCellDelegate>

@property (nonatomic,strong)UIView *currentCityBgView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *provinceArray;
@property (nonatomic,strong)UIView *chinaBgView;

@end

@implementation SelectedCityViewController
{
    NSString *_city;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择城市";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [self.view addSubview:self.currentCityBgView];
//    [self.view addSubview:self.chinaBgView];
    [self.view addSubview:self.tableView];
    [self loadProvince];
}

-(void)loadProvince
{
    self.provinceArray = [AppUserDefaults share].provinceArray;
    [self.tableView reloadData];

//    {
//        [SVProgressHUD show];
//        [RequestManager getAreaWithSuperAddrCode:@"CHN" successHandler:^(NSArray *array) {
//            [self loadCityWithProvinceArray:array];
//        } errorHandler:^(NSError *error) {
//            
//        }];
//    }
}

- (void)loadCityWithProvinceArray:(NSArray *)array
{
    //    /创建信号量/
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //    /创建全局并行/
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *mutArray = [NSMutableArray new];
    __block int m = 0 ,n = 0;
    for (NSDictionary *dict in array) {
        NSLog(@"nnnn---->%d",n);n++;
        dispatch_group_async(group, queue, ^{
           
            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
            [mutArray addObject:mutDict];
            [RequestManager getAreaWithSuperAddrCode:[dict objectForKey:@"addrCode"] successHandler:^(NSArray *array) {
                [mutDict setObject:array forKey:@"subAddsArray"];
                
                dispatch_semaphore_signal(semaphore);
                NSLog(@"%d",m);m++;

            } errorHandler:^(NSError *error) {
                dispatch_semaphore_signal(semaphore);
            }];
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        //        /四个请求对应四次信号等待/
        for (int i=0;i<array.count;i++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        [SVProgressHUD dismiss];
        NSLog(@"111");
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingString:@"/Area.plist"];
        
        [mutArray writeToFile:fileName atomically:YES];
        
    });
}

-(UIView *)currentCityBgView
{
    if (!_currentCityBgView) {
        _currentCityBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,40)];
        _currentCityBgView.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 40)];
        
        if (MyApp.locationCity) {
            lab.text = [NSString stringWithFormat:@"当前位置：%@",MyApp.locationCity];
        }
        else
        {
            [[GGTool share]getLocationSuccessHandler:^(NSString *province,NSString *city, CLLocation *location) {
                lab.text = [NSString stringWithFormat:@"当前位置：%@",MyApp.locationCity];
            } errorHandler:^(NSError *error) {
                
            }];
        }
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [_currentCityBgView addSubview:lab];
        
    }
    return _currentCityBgView;
}
//-(UIView *)chinaBgView
//{
//    if (!_chinaBgView) {
//        _chinaBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 41, ScreenWidth, 40)];
//        _chinaBgView.backgroundColor = [UIColor whiteColor];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chinaTap)];
//        [_chinaBgView addGestureRecognizer:tap];
//        UILabel *china = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-100, 40)];
//        china.text = @"全国";
//        china.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
//        china.font = [UIFont systemFontOfSize:14];
//        [_chinaBgView addSubview:china];
//        
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20, 0, 15, 40)];
//        image.image = [UIImage imageNamed:@"more"];
//        image.contentMode = UIViewContentModeCenter;
//        [_chinaBgView addSubview:image];
//        
//    }
//    return _chinaBgView;
//}
//-(void)chinaTap
//{
//    AreaModel *model = [AreaModel new];
//    model.addrName = @"全国";
//    model.addrCode = @"";
//    if (self.block) {
//        self.block(model);
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
#pragma mark ---tableView

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight - 50-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //rowHeight属性设置为UITableViewAutomaticDimension
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.provinceArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AreaModel *model = [self.provinceArray objectAtIndex:section];
    if (model.isOpen) {
        return 1;
    }
    else
    {
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==2) {
//        return 100;
//    }
//    else{
//        return 0;
//    }
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:nil] forCellReuseIdentifier:@"CityTableViewCell"];
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell"];
    cell.frame = tableView.bounds;
    [cell layoutIfNeeded];
    cell.delegate = self;
    AreaModel *model = [self.provinceArray objectAtIndex:indexPath.section];
    cell.cityArray = model.subAddsArray;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CitySectionHeaderView *view = [[CitySectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    AreaModel *model  = [self.provinceArray objectAtIndex:section];
    view.open = model.isOpen;
    view.delegate = self;
    view.sention = section;
    view.provinceName = model.addrName;
    return view;
}

-(void)cityTableViewCell:(CityTableViewCell *)cityTableViewCell didSelectedItemWithCityModel:(AreaModel *)cityModel
{
    if (self.block) {
        self.block(cityModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)openOrCloseCitySectionHeaderView:(CitySectionHeaderView *)citySectionHeaderView
{
    NSInteger section = citySectionHeaderView.sention;
        AreaModel *model = [self.provinceArray objectAtIndex:section];
        model.open = !citySectionHeaderView.isOpen;
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        
}


@end
