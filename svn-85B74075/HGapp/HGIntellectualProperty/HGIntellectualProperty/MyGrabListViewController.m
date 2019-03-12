//
//  MyGrabListViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MyGrabListViewController.h"
#import "MyGrapTableViewCell.h"
#import "SelectedErrandTypeViewController.h"
#import "HandleTableViewController.h"
#import "ProgressListViewController.h"
#import "FilterViewController.h"

#import "DoingErrandTableView.h"
#import "FinishErrandTableView.h"
#import "PopBankInfoView.h"

#define NavHeight (kDevice_Is_iPhoneX?88:64)

@interface MyGrabListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UIView *headerView;


@property (nonatomic,strong) UIView *filterBgView;
@property (nonatomic,strong) UIWindow *filterWindow;
@property (nonatomic,strong) FilterViewController *filterVC;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong)DoingErrandTableView *doingErrandTableView;
@property (nonatomic,strong)FinishErrandTableView *finishErrandTableView;
@property (nonatomic,strong)UIButton *cashBtn;

@end



@implementation MyGrabListViewController
{
    int _page;
    BOOL _isLast;
    UILabel *_cityLab;
    UILabel *_typeLab;
    NSString *_cityCode;
    NSString *_typeCode;
    NSInteger _indexPathRow;
    ///1进行中  2已完成 
    NSString *_sortType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" font:13 target:self action:@selector(filter:)];

    self.scrollView.contentSize = CGSizeMake(ScreenWidth*2, 0);
    self.scrollView.backgroundColor = [UIColor greenColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.doingErrandTableView];
    [self.scrollView addSubview:self.finishErrandTableView];

    [self.scrollView addSubview:self.cashBtn];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---tableView

-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
        _headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        view1.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:view1];
        
        _cityLab = [[UILabel alloc]initWithFrame:CGRectMake(11, 10, ScreenWidth-100, 25)];
        _cityLab.text  = @"差事所在地：全国";
        _cityLab.textColor = UIColorFromRGB(0x666666);
        _cityLab.font = [UIFont systemFontOfSize:14];
        [view1 addSubview:_cityLab];
        
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-30, 10, 20, 25)];
        image1.contentMode = UIViewContentModeCenter;
        image1.image = [UIImage imageNamed:@"more"];
        [view1 addSubview:image1];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1)];
        [view1 addGestureRecognizer:tap1];
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 55, ScreenWidth, 45)];
        view2.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:view2];
        _typeLab = [[UILabel alloc]initWithFrame:CGRectMake(11, 10, ScreenWidth-100, 25)];
        _typeLab.text  = @"差事类型：无限制";
        _typeLab.textColor = UIColorFromRGB(0x666666);
        _typeLab.font = [UIFont systemFontOfSize:14];
        [view2 addSubview:_typeLab];
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-30, 10, 20, 25)];
        image2.contentMode = UIViewContentModeCenter;
        image2.image = [UIImage imageNamed:@"more"];
        [view2 addSubview:image2];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)];
        [view2 addGestureRecognizer:tap2];
    }
    return _headerView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPathRow = indexPath.row;
    [self performSegueWithIdentifier:@"MyGrabPushGrabDetial" sender:self];
}

-(void)addProgressTableViewCell:(MyGrapTableViewCell *)cell
{
    NSLog(@"办理");
    if ([cell.model.errandStatus isEqualToString:@"CSZT01-03"]) {
        [SVProgressHUD showInfoWithStatus:@"未支付差事，不可办理"];
    }
    else
    {
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HandleTableViewController *vc = [mainStory instantiateViewControllerWithIdentifier:@"HandleTableViewController"];
        vc.model = cell.model;
        vc.fromList = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)lookProgressTableViewCell:(MyGrapTableViewCell *)cell
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProgressListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProgressListViewController"];
    vc.model = cell.model;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark ---- push
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MyGrabPushGrabDetial"]) {
        RobbedDetialTableViewController *vc = segue.destinationViewController;
        vc.fromList = self;
        vc.type = GrabDetialFunctionTypeHandle;
        vc.model = [self.dataArray objectAtIndex:_indexPathRow];
    }
    
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tap1
{
    SelectedCityViewController *vc = [[SelectedCityViewController alloc]init];
    vc.block = ^(AreaModel *cityModel) {
        NSLog(@"%@",cityModel);
        _cityLab.text = [NSString stringWithFormat:@"差事所在地：%@",cityModel.addrName];
        _cityCode = cityModel.addrCode;
       
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tap2
{
    SelectedErrandTypeViewController *vc = [[SelectedErrandTypeViewController alloc]init];
    vc.block = ^(ErrandClassModel *model) {
        _typeLab.text = [NSString stringWithFormat:@"差事类型：%@",model.dictionaryName];
        _typeCode = model.dictionaryCode;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)filter:(id)sender {
    [MyApp.window addSubview:self.filterBgView];
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 1;
        self.filterWindow.frame = CGRectMake(100, 0, ScreenWidth-100, ScreenHeight);
    }];
}


-(UIView *)filterBgView
{
    if (!_filterBgView) {
        _filterBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _filterBgView.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        _filterBgView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(filterBgViewTab)];
        [_filterBgView addGestureRecognizer:tap];
        
    }
    return _filterBgView;
}
-(UIWindow *)filterWindow
{
    if (!_filterWindow) {
        _filterWindow = [[UIWindow alloc]initWithFrame:CGRectMake(100+ScreenWidth, 0, ScreenWidth-100, ScreenHeight)];
        
        _filterWindow.windowLevel = UIWindowLevelNormal;
        _filterWindow.hidden = NO;
        [_filterWindow makeKeyAndVisible];
        _filterWindow.backgroundColor = [UIColor whiteColor];
        
        _filterWindow.rootViewController = self.filterVC;
    }
    return _filterWindow;
}
-(FilterViewController *)filterVC
{
    if (!_filterVC) {
        _filterVC = [[FilterViewController alloc]initWithNibName:@"FilterViewController" bundle:nil];
        _filterVC.view.frame = CGRectMake(0, 0, ScreenWidth-100, ScreenHeight);
        __weak typeof(self) weakSelf = self;
        
        _filterVC.selectItemBlock = ^(NSString *addrStr, NSString *typeStr) {
            NSLog(@"11111--%@\n22222--%@",typeStr,addrStr);
            if (addrStr.length) {
                _cityCode = addrStr;
            }
            else
            {
                _cityCode = @"";
            }
            if (typeStr.length) {
                _typeCode = [typeStr substringFromIndex:1];
            }
            else
            {
                _typeCode = @"";
            }
            [weakSelf finishLoadData];
        };
    }
    return _filterVC;
}

-(void)finishLoadData
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth+100, 0, ScreenWidth-100, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        self.filterWindow = nil;
        [self.tableView.mj_header beginRefreshing];
        
    }];
}

-(void)filterBgViewTab
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth+100, 0, ScreenWidth-100, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        self.filterWindow = nil;
    }];
}

- (IBAction)typeClick:(UIButton *)sender {
    sender.selected = YES;
    if (sender == self.btn1) {
        self.btn2.selected = NO;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else
    {
        self.btn1.selected = NO;
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
    }
}

-(FinishErrandTableView *)finishErrandTableView
{
    if (!_finishErrandTableView) {
        CGFloat mmm =ScreenHeight- NavHeight -44 -44;
        _finishErrandTableView = [[FinishErrandTableView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, mmm) style:UITableViewStylePlain];
    }
    return _finishErrandTableView;
}
-(DoingErrandTableView *)doingErrandTableView
{
    NSLog(@"%d----%f",NavHeight,ScreenHeight);
    if (!_doingErrandTableView) {
        CGFloat hhh =ScreenHeight  -NavHeight -44;
        _doingErrandTableView = [[DoingErrandTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, hhh) style:UITableViewStylePlain];
    }
    return _doingErrandTableView;
}
-(UIButton *)cashBtn
{  
    if (!_cashBtn) {
        _cashBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight- NavHeight-88, ScreenWidth, 44)];
        [_cashBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_cashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cashBtn.backgroundColor = MainColor;
        [_cashBtn addTarget:self action:@selector(cash) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cashBtn;
}
-(void)cash{
    PopBankInfoView *view = [[PopBankInfoView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [view show];
}



@end
