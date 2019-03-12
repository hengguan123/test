//
//  ClassificationQueryViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/20.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ClassificationQueryViewController.h"

#import "PatentTableViewCell.h"
#import "TrademarkTableViewCell.h"
#import "FilterCountryViewController.h"
#import "BundPhoneViewController.h"

#define CurrentFilterWidth ScreenWidth*3/4

@interface ClassificationQueryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *filterBgViewPatent;

@property (nonatomic,strong) UIView *filterBgView;
@property (nonatomic,strong) UIWindow *filterWindow;
@property (nonatomic,strong) FilterCountryViewController *filterVC;


@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ClassificationQueryViewController
{
    BOOL _isLast;
    int _page;
    NSMutableString *_typeStr;
    NSString *_trademarkType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == 1) {
        self.navigationItem.title = @"专利";
    }
    else if (self.type == 2) {
        self.navigationItem.title = @"商标";
    }
    else if (self.type == 3) {
        self.navigationItem.title = @"版权";
    }
    _trademarkType = @"0";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    if (self.type == 1||self.type == 2) {
        _typeStr = [NSMutableString stringWithFormat:@""];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(filter)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
    [self loadDataRefresh:YES];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataRefresh:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDataRefresh:(BOOL)refresh
{
    if (refresh) {
        [self.dataArray removeAllObjects];
        _isLast = NO;
        _page = 1;
        [self.tableView reloadData];
    }
    else
    {
        _page++;
    }
    if (_isLast) {
        [SVProgressHUD showInfoWithStatus:@"没有更多了"];
        _page--;
        [self.tableView.mj_footer endRefreshing];
    }
    else
    {
        if (self.type == 1) {
            NSString *str=@"";
            if ([_typeStr hasPrefix:@" "]) {
                 str= [_typeStr substringFromIndex:1];
                NSLog(@"%@",str);
            }
            
            [RequestManager getCompanyPatentListWithCompany:self.companyName page:_page country:self.country pkind:str successHandler:^(BOOL isLast, NSArray *array,NSNumber *total) {
                _isLast =isLast ;
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            } errorHandler:^(NSError *error) {
                
            }];
        }
        else if (self.type == 2)
        {
            
            [RequestManager searchTrademarkWithContent:self.companyName pageNo:_page intCls:_trademarkType successHandler:^(NSString *totalNum, NSArray *array) {
                [self.dataArray addObjectsFromArray:array];
                if (self.dataArray.count >= [totalNum integerValue]) {
                    _isLast = YES;
                }
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }];
            
            [RequestManager getCompanyTrademarkListWithCompany:self.companyName page:_page successHandler:^(BOOL isLast, NSArray *array,NSNumber *total) {
                
            } errorHandler:^(NSError *error) {
                
            }];
        }
        else if (self.type == 3)
        {
            
        }
    }
}

#pragma mark - Table view data source

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        [self.tableView registerNib:[UINib nibWithNibName:@"PatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatentTableViewCell"];
        PatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatentTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (self.type == 2)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"TrademarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"TrademarkTableViewCell"];
        
        TrademarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrademarkTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
        
    }
    else if (self.type == 3)
    {
        
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type==1) {
        PatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [CutoverManager openPatendDetailWithFromController:self techId:model.ID physicDb:model.PHYSIC_DB PKINDS:model.PKIND_S monitorId:nil title:model.TITLE subTitle:model.AN share:YES];
    }
    else if (self.type ==2)
    {
        TrademarkModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if ([AppUserDefaults share].isLogin) {
            if ([AppUserDefaults share].phone == nil ||[[AppUserDefaults share].phone isEqualToString:@""]) {
                BundPhoneViewController *vc = [[BundPhoneViewController alloc]initWithNibName:@"BundPhoneViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [CutoverManager openTrademarkDetailWithFromController:self regNo:model.regNo intCls:model.intCls name:model.tmName owner:model.applicantCn usrPhone:[AppUserDefaults share].phone];
            }
        }
        else
        {
            [self goToLogin];
        }
    }
    else if (self.type == 3)
    {
        
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 3) {
        return 190;
    }
    else
    {
        return 140;
    }
}




-(void)goToLogin
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)filter
{
    if (self.type == 1) {
        [self filterpatent];
    }
    else if (self.type == 2)
    {
        [self filterTrademark];
    }
}
- (IBAction)selType:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    CGRect frame = self.filterBgView.frame;
    frame.origin.y =-44;
    
    if (sender.tag == 101) {
        if (![_typeStr containsString:@" A B C"]) {
            [_typeStr appendString:@" A B C"];
        }
        else
        {
            NSRange range = [_typeStr rangeOfString:@" A B C"];
            [_typeStr deleteCharactersInRange:range];
        }
    }
    else if (sender.tag == 102)
    {
        if (![_typeStr containsString:@" U Y"]) {
            [_typeStr appendString:@" U Y"];
        }
        else
        {
            NSRange range = [_typeStr rangeOfString:@" U Y"];
            [_typeStr deleteCharactersInRange:range];
        }
    }
    else if (sender.tag == 103)
    {
        if (![_typeStr containsString:@" D S"]) {
            [_typeStr appendString:@" D S"];
        }
        else
        {
            NSRange range = [_typeStr rangeOfString:@" D S"];
            [_typeStr deleteCharactersInRange:range];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.filterBgView.frame = frame;
    }];
    
    [self loadDataRefresh:YES];
}

- (void)filterpatent
{
    CGRect frame = self.filterBgViewPatent.frame;
    if (frame.origin.y==0) {
        frame.origin.y=-44;
    }
    else{
        frame.origin.y =0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.filterBgViewPatent.frame = frame;
    }];
}
- (void)filterTrademark
{
    [MyApp.window addSubview:self.filterBgView];
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 1;
        self.filterWindow.frame = CGRectMake(ScreenWidth-CurrentFilterWidth, 0, CurrentFilterWidth, ScreenHeight);
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
        _filterWindow = [[UIWindow alloc]initWithFrame:CGRectMake(100+ScreenWidth, 0, CurrentFilterWidth, ScreenHeight)];
        
        _filterWindow.windowLevel = UIWindowLevelNormal;
        _filterWindow.hidden = NO;
        [_filterWindow makeKeyAndVisible];
        _filterWindow.backgroundColor = [UIColor whiteColor];
        
        _filterWindow.rootViewController = self.filterVC;
    }
    return _filterWindow;
}
-(FilterCountryViewController *)filterVC
{
    if (!_filterVC) {
        _filterVC = [[FilterCountryViewController alloc]initWithNibName:@"FilterCountryViewController" bundle:nil];
        _filterVC.type = self.type+1;
        _filterVC.view.frame = CGRectMake(0, 0, CurrentFilterWidth, ScreenHeight);
        __weak typeof(self) weakSelf = self;
        _filterVC.selTrademarkTypeBlock = ^(NSString *typeStr) {
            _trademarkType = typeStr;
            [weakSelf hiddenFilter];
        };
    }
    return _filterVC;
}

-(void)hiddenFilter
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth+100, 0, CurrentFilterWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        self.filterWindow = nil;
        [self loadDataRefresh:YES];
    }];
    
}

-(void)filterBgViewTab
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth+100, 0, CurrentFilterWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        self.filterWindow = nil;
    }];
}


@end
