//
//  BusinessDetailsViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "BusinessDetailsViewController.h"
#import "BusinessChildViewController.h"
@interface BusinessDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@property (nonatomic,strong)NSArray *domainArray;
@property (nonatomic,strong)NSArray *allKindsArray;

@end

@implementation BusinessDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交审核" font:13 target:self action:@selector(save:)];
    self.scrollerView.scrollEnabled = NO;
    self.scrollerView.contentSize = CGSizeMake(ScreenWidth*3, 0);
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}

- (void)loadData
{
    [LoadingManager show];
    [RequestManager getAgentInfoSuccessHandler:^(NSDictionary *dict) {
        
        AppUserDefaults.share.facilitatorId = [[dict objectForKey:@"faci"]objectForKey:@"facilitatorId"];
        self.domainArray = [MTLJSONAdapter modelsOfClass:[BusinessModel class] fromJSONArray:[dict objectForKey:@"classify"] error:nil];
        self.allKindsArray = [MTLJSONAdapter modelsOfClass:[BusinessModel class] fromJSONArray:[dict objectForKey:@"scope"] error:nil];
        [LoadingManager dismiss];
    } errorHandler:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAllKindsArray:(NSArray *)allKindsArray
{
    _allKindsArray = allKindsArray;
    for (int i=0; i<MIN(3, allKindsArray.count); i++) {
        BusinessModel *model = [allKindsArray objectAtIndex:i];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, 44)];
        [btn setTitle:model.dictionaryName forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:MainColor forState:UIControlStateSelected];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnBgView addSubview:btn];
        
        if (i==0) {
            btn.selected=YES;
        }
        
        BusinessChildViewController *vc = [[BusinessChildViewController alloc]initWithNibName:@"BusinessChildViewController" bundle:nil];
        if ([model.dictionaryName isEqualToString:@"专利"]) {
            vc.type = @"1";
            vc.domainArray = self.domainArray;
        }
        else
        {
            vc.type = @"2";
        }
        vc.editing = YES;
        vc.typeArray = model.listChildDict;
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(ScreenWidth*i, 0, ScreenWidth, self.scrollerView.bounds.size.height);
        [self.scrollerView addSubview:vc.view];
        
        
    }
}

-(void)btnClick:(UIButton *)btn
{
    for (UIView *view in self.btnBgView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *uibtn = (UIButton *)view;
            btn.selected = YES;
            if (btn != uibtn) {
                uibtn.selected = NO;
            }
        }
    }
    self.scrollerView.contentOffset = CGPointMake(ScreenWidth*(btn.tag-100), 0);
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]initWithDictionary:@{@"facilitatorId":[AppUserDefaults share].facilitatorId,@"usrId":[AppUserDefaults share].usrId}];
    NSMutableArray *domainMuArr = [NSMutableArray new];
    for (BusinessModel *model in self.domainArray) {
        NSDictionary *dict1 = @{
                                @"classifyCode":model.dictionaryCode,
                                @"delFlag":model.delFlag,
                                @"price":model.price,
                                @"remark":model.remark?:@""};
        [domainMuArr addObject:dict1];
    }
    [dict setObject:domainMuArr forKey:@"classifyDataList"];
    
    NSMutableArray *typeMuArr = [NSMutableArray new];
    
    for (BusinessModel *model in self.allKindsArray) {
        for (BusinessModel *typeModel in model.listChildDict) {
            for (BusinessModel *subTypeModel in typeModel.listChild) {
                NSDictionary *dict1 = @{
                                        @"delFlag":subTypeModel.delFlag,
                                        @"serviceType":subTypeModel.dictionaryCode,
                                        @"price":subTypeModel.price,
                                        @"remark":subTypeModel.remark?:@""};
                [typeMuArr addObject:dict1];
            }
            NSDictionary *dict2 = @{
                                    @"delFlag":typeModel.delFlag,
                                    @"price":typeModel.price,
                                    @"remark":typeModel.remark?:@"",
                                    @"serviceType":typeModel.dictionaryCode,
                                    };
            [typeMuArr addObject:dict2];
        }
    }
    
    [dict setObject:typeMuArr forKey:@"rangeDataList"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    [RequestManager submitFaciInfoToReViewWithParameter:jsonString successHandler:^(BOOL success) {
        
    } errorHandler:^(NSError *error) {
        
    }];
}

@end
