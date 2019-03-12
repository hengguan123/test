	//
//  HomeTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HFStretchableTableHeaderView.h"
#import "ADScrollView.h"
#import "HeadlinesTableViewCell.h"
#import "SearchAllViewController.h"
#import "InformationFilterViewController.h"
#import "VersionManager.h"
#import "RankingViewController.h"
#import "InformationScrollingView.h"
#import "ErrandTableViewCell.h"
#import "EventEntranceView.h"
#import "InviteViewController.h"
#import "MyBusinessViewController.h"
#import "PayAnnualFeeViewController.h"


@interface HomeTableViewController ()<UITextFieldDelegate,ADScrollViewDelegate,InformationScrollingViewDelegate,ErrandTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
//@property (weak, nonatomic) IBOutlet UIView *adBgView;

@property (weak, nonatomic) IBOutlet UITableViewCell *scrollCell;

@property (nonatomic,strong) ADScrollView *bannerView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *otherDataArray;
@property (nonatomic,strong) NSMutableArray *errandArray;


@property (nonatomic,strong)FilterManager *filterManager;
@property (nonatomic,strong)InformationScrollingView *infoScrollView;

@property (nonatomic,strong)UIView *footerView;


@end

@implementation HomeTableViewController
{
    HFStretchableTableHeaderView *_stretchableTableHeaderView;
    HotSearchViewType _type;
    BOOL _isLast;
    int _page;
    int _otherPage;
    NSString *_addr;
    NSString *_pubOrg;
    NSString *_timeSort;
    UIButton *_timerUpBtn;
    NSString *_orgType;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBarBg"]]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkrecover) name:@"networkrecover" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getLocationProvince) name:LocationNoti object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successLogin) name:LoginNodti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successLogout) name:LogoutNoti object:nil];
    
    if (@available(iOS 11.0, *))
    {
       self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        self.additionalSafeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        
    } else {
        // Fallback on earlier versions
    }
    
    
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    
    [self loadBuyInfomation];
    
    _pubOrg = @"";
    _orgType = @"";
    _timeSort = @"1";
    _otherPage = 0;
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 170/375.0*ScreenWidth);
    [self.headerView insertSubview:self.bannerView atIndex:0];
   
    self.bannerView.imageArray = [AppUserDefaults share].bannerArr;
    _stretchableTableHeaderView = [HFStretchableTableHeaderView new];
    [_stretchableTableHeaderView stretchHeaderForTableView:self.tableView withView:self.headerView subView:self.bannerView];
    CGRect frame = self.searchTextField.frame;
    self.searchTextField.frame = CGRectMake(16, frame.origin.y, ScreenWidth-32, 36);
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    image.contentMode = UIViewContentModeCenter;
    image.frame = CGRectMake(0, 0, 36, 36);
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView =image;
    
    UIButton *scan = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    [scan setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [scan addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    self.searchTextField.rightView = scan;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getHeaderlinesRefresh:NO];
    }];
    [self loadBanner];
    if ([AppUserDefaults share].selArea) {
        _addr = [AppUserDefaults share].selArea;
    }
    else
    {
        if (MyApp.homeCity) {
            _addr = MyApp.homeCity;
        }
        else
        {
            _addr = @"中央部委";
        }
    }
    [self getHeaderlinesRefresh:YES];
    
    
    AppUserDefaults.share.isShowVersion = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://admin.techhg.com/version" parameters:@{@"useType":@"1"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([[responseObject objectForKey:@"success"]boolValue])
        {
            NSArray *array = [MTLJSONAdapter modelsOfClass:[VersionModel class] fromJSONArray:[responseObject objectForKey:@"body"] error:nil];
            VersionModel *model = array.firstObject;
            if (model&&[model.coerceStatus isEqualToString:@"0"]) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                // app名称
                //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                // app版本
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSString *nowVersion = model.versionNo;
                BOOL result = [app_Version compare:nowVersion]==NSOrderedAscending;
                if (result) {
                    [VersionManager showVersionWithModel:model];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
}

/// 登录--登出
-(void)successLogin
{
    [self getHeaderlinesRefresh:YES];
    [self.tableView reloadData];
    if ([AppUserDefaults share].ykId) {
        [RequestManager associatedYKandUserWithUsrId:[AppUserDefaults share].usrId ykId:[AppUserDefaults share].ykId successHandler:^(BOOL success) {
            NSSet *set = [[NSSet alloc]initWithObjects:[NSString stringWithFormat:@"yk%@",[AppUserDefaults share].ykId], nil];
            [JPUSHService deleteTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                if (iResCode==0) {
                    
                }
                else
                {
                    [JPUSHService deleteTags:set completion:nil seq:2];
                }
            } seq:1];
            
            [AppUserDefaults share].ykId = nil;
        } errorHandler:^(NSError *error) {
            
        }];
    }
}
-(void)successLogout
{
    [self getHeaderlinesRefresh:YES];
    [self.tableView reloadData];
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.techhg.HGIntellectualProperty"account:@"useruuid"];
    if (retrieveuuid) {
        [RequestManager registeredTouristsWithUUid:retrieveuuid successHandler:^(NSNumber *ykid) {
            NSSet *set = [[NSSet alloc]initWithObjects:[NSString stringWithFormat:@"yk%@",ykid], nil];
            [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                if (iResCode==0) {
                    
                }
                else
                {
                    [JPUSHService setTags:set completion:nil seq:2];
                }
            } seq:1];
        } errorHandler:^(NSError *error) {
            
        }];
    }
}

///
-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:@"NoDataView" owner:nil options:nil] lastObject];
    }
    _footerView.frame = CGRectMake(0, 0, ScreenWidth, 215);
    return _footerView;
}




///
-(void)scan
{
    [self performSegueWithIdentifier:@"HomePushScan" sender:self];
}
-(void)networkrecover
{
    [self loadBanner];
    [self getHeaderlinesRefresh:YES];
}
-(void)getLocationProvince
{
    if (![AppUserDefaults share].selArea) {
        _addr = MyApp.homeCity?:@"中央部委";
        [self getHeaderlinesRefresh:YES];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    [[EventEntranceView share] show];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(eventEntranceTapNotiAct) name:EventEntranceTapNoti object:nil];
    self.tableView.tableFooterView = nil;
    [self getHeaderlinesRefresh:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    [[EventEntranceView share] dismiss];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EventEntranceTapNoti object:nil];
}
- (void)loadBanner
{
    [RequestManager getRotationImageSuccessHandler:^(NSArray *array) {
        self.bannerView.imageArray = array;
        [AppUserDefaults share].bannerArr = array;
    } errorHandler:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

-(ADScrollView *)bannerView
{
    if (!_bannerView) {
        _bannerView=[[ADScrollView alloc]initWithFrame:self.headerView.bounds];
        _bannerView.delegate=self;
    }
    return _bannerView;
}

-(void)adScrollView:(ADScrollView *)adScrollView didSelectedBannerWith:(BannerModel *)bannerModel
{
    NSLog(@"");
    if ([bannerModel.skipLink hasPrefix:@"http://"]) {
        WebViewController *webview = [[WebViewController alloc]init];
        webview.urlStr = bannerModel.skipLink;
        webview.titleStr = bannerModel.title;
        webview.hidesBottomBarWhenPushed = YES;
        [self showViewController:webview sender:self];
    }
}


#define mark ---通知方法
-(void)eventEntranceTapNotiAct
{
    NSLog(@"点击了活动入口");
    InviteViewController *vc = [[InviteViewController alloc]initWithNibName:@"InviteViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(NSMutableArray *)otherDataArray
{
    if (!_otherDataArray) {
        _otherDataArray = [NSMutableArray new];
    }
    return _otherDataArray;
}
-(NSMutableArray *)errandArray
{
    if (!_errandArray) {
        _errandArray = [NSMutableArray new];
    }
    return _errandArray;
}
-(void)getHeaderlinesRefresh:(BOOL)refresh
{
    if ([AppUserDefaults share].isSpecialUser) {
        NSLog(@"代理人");
        if (refresh) {
            _page = 1;
            [RequestManager getFilterErrandListWithDwellAddrs:@"" searchStr:@"" price:@"" classifyDomains:@"" errandTypes:@"" busiTypes:@"" page:_page successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
                _isLast = isLast;
                [self.errandArray removeAllObjects];
                [self.errandArray addObjectsFromArray:array];
                [self.tableView reloadData];
                if (array.count== 0) {
                    self.tableView.tableFooterView = self.footerView;
                }
            } errorHandler:^(NSError *error) {
                
            }];
        }
        else
        {
            if (_isLast) {
                [self.tableView.mj_footer endRefreshing];
                [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            }
            else
            {
                _page ++;
                [RequestManager getFilterErrandListWithDwellAddrs:@"" searchStr:@"" price:@"" classifyDomains:@"" errandTypes:@"" busiTypes:@"" page:_page successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
                    _isLast = isLast;
                    [self.errandArray addObjectsFromArray:array];
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                } errorHandler:^(NSError *error) {
                    [self.tableView.mj_footer endRefreshing];
                }];
            }
        }
    }
    else
    {
        if (refresh) {
            _page = 1;
            
            [RequestManager searchPolicyInformationWithNotEqual:NO addr:_addr source:_pubOrg title:@"" info:@"" orderBy:@"" sourceType:_orgType page:_page successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
                _isLast = isLast;
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                if ([total integerValue]==0) {
                    [self getOtherHeaderlinesFirst:YES];
                }
            } errorHandler:^(NSError *error) {
                
            }];
        }
        else
        {
            if (_isLast) {
                [self getOtherHeaderlinesFirst:NO];
            }
            else
            {
                _page++;
                [RequestManager searchPolicyInformationWithNotEqual:NO addr:_addr source:_pubOrg title:@"" info:@"" orderBy:@"" sourceType:_orgType page:_page successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
                    _isLast = isLast;
                    [self.tableView.mj_footer endRefreshing];
                    [self.dataArray addObjectsFromArray:array];
                    [self.tableView reloadData];
                    
                } errorHandler:^(NSError *error) {
                    [self.tableView.mj_footer endRefreshing];
                    
                }];
            }
        }
    }
}

-(void)getOtherHeaderlinesFirst:(BOOL)isFirst
{
    if (isFirst) {
        _otherPage = 1;
        [RequestManager searchPolicyInformationWithNotEqual:YES addr:_addr source:_pubOrg title:@"" info:@"" orderBy:@"" sourceType:_orgType page:_otherPage successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
            [self.otherDataArray removeAllObjects];
            [self.otherDataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        _otherPage ++ ;
        [RequestManager searchPolicyInformationWithNotEqual:YES addr:_addr source:_pubOrg title:@"" info:@"" orderBy:@"" sourceType:_orgType page:_otherPage successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
            [self.otherDataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } errorHandler:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    else if(section == 1){
        if ([AppUserDefaults share].isSpecialUser) {
            return self.errandArray.count;
        }
        else
        {
            return self.dataArray.count;
        }
    }
    else
    {
        if ([AppUserDefaults share].isLogin) {
            if ([MyApp.userInfo.usrType isEqualToString:@"1"]) {
                return 0;
            }
        }
        return self.otherDataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        if ([AppUserDefaults share].isSpecialUser) {
            [self.tableView registerNib:[UINib nibWithNibName:@"ErrandTableViewCell" bundle:nil] forCellReuseIdentifier:@"ErrandTableViewCell"];
            ErrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ErrandTableViewCell"];
            cell.delegate = self;
            cell.model = [self.errandArray objectAtIndex:indexPath.row];
            return cell;
        }
        else
        {
            [self.tableView registerNib:[UINib nibWithNibName:@"HeadlinesTableViewCell" bundle:nil] forCellReuseIdentifier:@"HeadlinesTableViewCell"];
            HeadlinesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadlinesTableViewCell"];
            cell.model = [self.dataArray objectAtIndex:indexPath.row];
            return cell;
        }
    }
    else
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"HeadlinesTableViewCell" bundle:nil] forCellReuseIdentifier:@"HeadlinesTableViewCell"];
        HeadlinesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadlinesTableViewCell"];
        cell.model = [self.otherDataArray objectAtIndex:indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&&indexPath.row == 0) {
        InviteViewController *vc = [[InviteViewController alloc]initWithNibName:@"InviteViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1) {
        if ([AppUserDefaults share].isSpecialUser) {
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ErrandsDetialTableViewController *vc = [main instantiateViewControllerWithIdentifier:@"ErrandsDetialTableViewController"];
            vc.model = [self.errandArray objectAtIndex:indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            vc.fromList = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HeadlinesModel *model = [self.dataArray objectAtIndex:indexPath.row];
            HTMLViewController *view = [[HTMLViewController alloc]init];
            view.htmlUrl = [HTTPURL stringByAppendingFormat:@"/granoti/info?id=%@&addr=%@&source=%@",model.articleId,model.addr,model.source];
            view.titleStr = model.title;
            view.canShare = YES;
            view.addr = model.addr;
            view.source = model.source;
            view.pubtime = model.pubDate;
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        }
        
    }
   else if (indexPath.section == 2) {
       HeadlinesModel *model = [self.otherDataArray objectAtIndex:indexPath.row];
       HTMLViewController *view = [[HTMLViewController alloc]init];
       view.htmlUrl = [HTTPURL stringByAppendingFormat:@"/granoti/info?id=%@&addr=%@&source=%@",model.articleId,model.addr,model.source];
       view.titleStr = model.title;
       view.canShare = YES;
       view.addr = model.addr;
       view.source = model.source;
       view.pubtime = model.pubDate;
       view.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:view animated:YES];
    }
}

//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1||indexPath.section == 2){//（动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else if(section == 1)
    {
        return 40;
    }
    else if(section == 2&&self.otherDataArray.count)
    {
        if ([AppUserDefaults share].isSpecialUser) {
            return 0;
        }
        return 40;
    }
    else
        return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            return 300.0;
        }
        else if (indexPath.row==0)
        {
//            return ScreenWidth/375*45;
            return 0;
        }
        else{
            return 50.0;
        }
    }
    else
    {
        return 100;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        view.backgroundColor = UIColorFromRGB(0xf2f2f2);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapReload)];
        [view addGestureRecognizer:tap];
        if ([AppUserDefaults share].isSpecialUser) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 12, 15)];
            imageView.image = [UIImage imageNamed:@"hot"];
            [view addSubview:imageView];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(24, 12, 150, 15)];
            lab.text = @"差事列表";
            lab.textColor = UIColorFromRGB(0x333333);
            lab.font = [UIFont systemFontOfSize:12];
            [view addSubview:lab];
            return view;
        }
        else
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 12, 15)];
            imageView.image = [UIImage imageNamed:@"hot"];
            [view addSubview:imageView];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(24, 12, 150, 15)];
            lab.text = @"政策信息";
            lab.textColor = UIColorFromRGB(0x333333);
            lab.font = [UIFont systemFontOfSize:12];
            [view addSubview:lab];
            
            NSString *btnTitle =[_addr isEqualToString:@""]?@"不限":_addr;
            
            CGSize size = [btnTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-size.width-70, 0, size.width+20, 40)];
            //        btn.backgroundColor = [UIColor redColor];
            [btn setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
            
            [btn setTitle:btnTitle forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            //        btn.backgroundColor = [UIColor greenColor];
            [btn addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:btn];
            
            UIButton *changeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, 0, 40, 40)];
            [changeBtn setTitle:@"[更改]" forState:UIControlStateNormal];
            [changeBtn setTitleColor:MainColor forState:UIControlStateNormal];
            changeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [changeBtn addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:changeBtn];
            
            UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-168, 0, 44, 40)];
            [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
            searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [searchBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [searchBtn addTarget:self action:@selector(searchItem) forControlEvents:UIControlEventTouchUpInside];
            [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
            [view addSubview:searchBtn];
            
            //        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-168, 10, 45, 20)];
            ////        time.backgroundColor = [UIColor redColor];
            //        time.text= @"时间筛选";
            //        time.textColor = UIColorFromRGB(0x666666);
            //        time.font = [UIFont systemFontOfSize:10];
            //        [view addSubview:time];
            //
            //        if (!_timerUpBtn) {
            //            _timerUpBtn= [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(time.frame), 0, 20, 40)];
            //            [_timerUpBtn setImage:[UIImage imageNamed:@"timeUp"] forState:UIControlStateNormal];
            //            //        timerUpBtn.backgroundColor = [UIColor redColor];
            //            [_timerUpBtn setImage:[UIImage imageNamed:@"timeDown"] forState:UIControlStateSelected];
            //            [_timerUpBtn addTarget:self action:@selector(timeSort:) forControlEvents:UIControlEventTouchUpInside];
            //        }
            //        [view addSubview:_timerUpBtn];
            return view;
        }
    }
    if (section==2&&self.otherDataArray.count&&![AppUserDefaults share].isSpecialUser) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        view.backgroundColor = UIColorFromRGB(0xf2f2f2);
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, ScreenWidth-30, 30)];
        lab.text = @"———— 以下为其他地区部门信息 ————";
        lab.textColor = MainColor;
        lab.font = [UIFont systemFontOfSize:12];
        lab.textAlignment = 1;
        [view addSubview:lab];
        
        return view;
    }
    return nil;
}
/// 去搜索信息条目

-(void)tapReload
{
    [self getHeaderlinesRefresh:YES];
}


- (void )searchItem
{
    [self performSegueWithIdentifier:@"HomePushInformation" sender:self];
}

- (void)timeSort:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        _timeSort = @"0";
    }
    else
    {
        _timeSort = @"1";
    }
    [self getHeaderlinesRefresh:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"yyyyyyyyy---%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y>0) {
        if (scrollView.contentOffset.y>5) {
        }
        else
        {
            
        }
    }
    else
    {
        [_stretchableTableHeaderView scrollViewDidScroll:scrollView];
    }
}

- (void)viewDidLayoutSubviews
{
    [_stretchableTableHeaderView resizeView];
}


-(void)filter
{
    [[NSNotificationCenter defaultCenter]postNotificationName:HomeFilterReloaddateNoti object:nil];
     [self.filterManager show];
}

-(FilterManager *)filterManager
{
    if (!_filterManager) {
        InformationFilterViewController *vc = [[InformationFilterViewController alloc]initWithNibName:@"InformationFilterViewController" bundle:nil];
        vc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        __weak typeof(self) weakSelf = self;
        vc.hiddenBlcok = ^{
            [weakSelf.filterManager hidden];
        };
        
        vc.selFinishBlcok = ^(NSString *orgStr, NSString *areaStr,NSString *orgTypeStr) {
            NSLog(@"地址:%@\n组织:%@",areaStr,orgStr);
            _addr = areaStr;
            _pubOrg = orgStr;
            _orgType = orgTypeStr;
            if (areaStr.length) {
                [AppUserDefaults share].selArea = areaStr;
            }
            [weakSelf.filterManager sureCompletion:^(BOOL finished) {
                [weakSelf getHeaderlinesRefresh:YES];
            }];
        };
        
        
        _filterManager = [[FilterManager alloc]initWithFilterVc:vc];
        
    }
    return _filterManager;
}



#pragma mark textFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _type = HotSearchViewTypePatent;
    [self performSegueWithIdentifier:@"HomePushSearchAll" sender:self];
    
//    PayAnnualFeeViewController *vc = [[PayAnnualFeeViewController alloc]initWithNibName:@"PayAnnualFeeViewController" bundle:nil];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
//    MyBusinessViewController *vc = [[MyBusinessViewController alloc]initWithNibName:@"MyBusinessViewController" bundle:nil];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

#pragma mark  tap

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    NSLog(@"tap%ld",sender.view.tag);
    switch (sender.view.tag) {
        case 100://排行榜
        {
            RankingViewController *vc = [[RankingViewController alloc]init];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
                    }
            break;
        case 101:
        {
            _type = HotSearchViewTypeTrademark;
            [self performSegueWithIdentifier:@"HomePushSearchAll" sender:self];
        }   break;
        case 102:
        {
//            [SVProgressHUD showInfoWithStatus:@"敬请期待"];
//            [self performSegueWithIdentifier:@"HomePushSearchCopyright" sender:self];
            [self performSegueWithIdentifier:@"HomePushInformation" sender:self];

        }   break;
        case 103:
        {
//            [self performSegueWithIdentifier:@"HomePushScan" sender:self];
            [self performSegueWithIdentifier:@"HomePushProgressList" sender:self];
        }   break;
        case 104:
        {
            _type = HotSearchViewTypeProperty;
            [self performSegueWithIdentifier:@"HomePushSearchAll" sender:self];
        }
            break;
        case 105://专利分析
        {
            _type = HotSearchViewTypePatentScore;
            [self performSegueWithIdentifier:@"HomePushSearchAll" sender:self];
        }
            break;
        case 106:
        {
            _type = HotSearchViewTypePatent;
            [self performSegueWithIdentifier:@"HomePushSearchAll" sender:self];
        }
            break;
        case 107:
        {
            [self performSegueWithIdentifier:@"HomePushTransaction" sender:self];
        }
            break;
        case 108://专利申请
        {
            HTMLViewController *vc = [[HTMLViewController alloc]init];
            if ([AppUserDefaults share].login) {
                (void)(vc.htmlUrl = [HTTPURL stringByAppendingFormat:@"/patent/regpatent?usrId=%@&userPhone=%@",[AppUserDefaults share].usrId,[AppUserDefaults share].phone?:@""]);
            }
            else
            {
                vc.htmlUrl = [HTTPURL stringByAppendingFormat:@"/patent/regpatent"];
            }
            vc.titleStr = @"专利申请";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 109://商标注册
        {
            HTMLViewController *vc = [[HTMLViewController alloc]init];
            if ([AppUserDefaults share].login) {
                vc.htmlUrl = [HTTPURL stringByAppendingFormat:@"/trademark/regtrade?usrId=%@&userPhone=%@",[AppUserDefaults share].usrId,[AppUserDefaults share].phone?:@""];
            }
            else
            {
                vc.htmlUrl = [HTTPURL stringByAppendingFormat:@"/trademark/regtrade"];
            }
            vc.titleStr = @"商标注册";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 110://版权申请
        {
            HTMLViewController *vc = [[HTMLViewController alloc]init];
            if ([AppUserDefaults share].login) {
                vc.htmlUrl = [HTTPURL stringByAppendingFormat:@"/copy/regcopy?usrId=%@&userPhone=%@",[AppUserDefaults share].usrId,[AppUserDefaults share].phone?:@""];
            }
            else
            {
                vc.htmlUrl = [HTTPURL stringByAppendingFormat:@"/copy/regcopy"];
            }
            vc.titleStr = @"版权登记";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 111://其他业务
        {
            [self performSegueWithIdentifier:@"HomePushOtherProfessionalWork" sender:self];
        }
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"HomePushSearchAll"]) {
        SearchAllViewController *vc = segue.destinationViewController;
        vc.type = _type;
    }
}

-(void)goToLogin
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark 求购滚动信息
///获取求购信息
-(void)loadBuyInfomation
{
    [RequestManager getBuyingInformationWithPage:1 businessName:@"" busiQuality:@"8" isMain:NO successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
        if (array.count>=2) {
            self.infoScrollView.dataArray = array;
        }
    } errorHandler:^(NSError *error) {
        
    }];
}
-(InformationScrollingView *)infoScrollView
{
    if (!_infoScrollView) {
        _infoScrollView = [[InformationScrollingView alloc]initWithFrame:CGRectMake(0, 0.5, self.scrollCell.bounds.size.width, self.scrollCell.bounds.size.height)];
        [self.scrollCell.contentView addSubview:_infoScrollView];
        _infoScrollView.delegate = self;
    }
    return _infoScrollView;
}
-(void)taptap
{
    [self performSegueWithIdentifier:@"HomePushTransaction" sender:self];
}

#pragma mark  抢单代理
-(void)grabOrderWithErrandTableViewCell:(ErrandTableViewCell *)errandTableViewCell sender:(UIButton *)sender
{
    [LoadingManager show];
    sender.enabled = NO;
    [RequestManager grabErrandWithErrandId:errandTableViewCell.model.errandId faciName:[AppUserDefaults share].userName errandTitle:errandTableViewCell.model.errandTitle usrId:errandTableViewCell.model.usrId price:errandTableViewCell.model.price successHandler:^(BOOL success) {
        [LoadingManager dismiss];
        if (success) {
            [NetPromptBox showWithInfo:@"抢单成功" stayTime:2];
            [self getHeaderlinesRefresh:YES];
        }
        
        sender.enabled = YES;
    } errorHandler:^(NSError *error) {
        sender.enabled = YES;
    }];
}



@end
