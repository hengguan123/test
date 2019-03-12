//
//  PatentTransactionPatentViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentTransactionPatentViewController.h"
#import "SearchToSellViewController.h"
#import "SellTableView.h"
#import "PatentCollectionViewCell.h"
#import "AssociateView.h"
#import "FilterManager.h"
#import "BuyFilterViewController.h"
#import "BuyInfoPopUpView.h"
#import "BuyInfoTableViewCell.h"

@interface PatentTransactionPatentViewController ()<UITableViewDelegate,UITableViewDataSource,SellTableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBgView;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;

@property (nonatomic,strong)SellTableView *sellBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic)IBOutlet UIView *titleBgView;

@property (nonatomic,strong)BuyInfoPopUpView *popupView;

@end

@implementation PatentTransactionPatentViewController
{
    int _page;
    BOOL _isLast;
    NSString *_searchStr;
    UILabel *_resultNumLab;
    NSString *_provinceName;
    NSString *_countryCode;
    NSString *_pkindStr;
    NSString *_timeStr;
    NSString *_ipcStr;
    NSString *_valid;
    NSInteger _currentSelNum;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    leftView.image = [UIImage imageNamed:@"searchLogo"];
    leftView.contentMode = UIViewContentModeCenter;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = leftView;
    self.titleBgView.frame= CGRectMake(0, 0, ScreenWidth-50, 33);
    self.tableView.backgroundColor =UIColorFromRGB(0xf2f2f2);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadSearchListRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadSearchListRefresh:NO];
    }];
    
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.minimumInteritemSpacing = 10;
//    layout.minimumLineSpacing = 10;
//    layout.itemSize = CGSizeMake((ScreenWidth-10)/2.0,200 );
//    layout.headerReferenceSize=CGSizeMake(ScreenWidth, 34);
//    [self.collectionView setCollectionViewLayout:layout];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"PatentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PatentCollectionViewCell"];
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"resultHeader"];
//
    _searchStr = @"";
    [self loadSearchListRefresh:YES];
    self.scrollBgView.contentSize = CGSizeMake(ScreenWidth*2, 0);
    [self.scrollBgView addSubview:self.sellBgView];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}

- (void)loadSearchListRefresh:(BOOL)refresh
{
//    if (self.sellBtn.isSelected) {
//        self.sellBtn.selected = NO;
//        self.sellBtn.backgroundColor = [UIColor whiteColor];
//        self.buyBtn.backgroundColor = MainColor;
//        self.buyBtn.selected = YES;
//        [self.scrollBgView setContentOffset:CGPointMake(0, 0)];
//    }
    if (refresh) {
        _page = 1;
        [RequestManager getBuyingInformationWithPage:_page businessName:_searchStr busiQuality:@"8" isMain:NO successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
            [self.dataArray removeAllObjects];
            _isLast = isLast;
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            self.totalLab.text = [NSString stringWithFormat:@"共搜索到%ld条项目",[total integerValue]];
            [self.tableView.mj_header endRefreshing];
        } errorHandler:^(NSError *error) {
            
        }];
    }else
    {
        if (_isLast) {
            [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            _page ++;
            [RequestManager getBuyingInformationWithPage:_page businessName:_searchStr busiQuality:@"8" isMain:NO successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_footer endRefreshing];
            }];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sell:(UIButton *)sender {
    self.buyBtn.selected = NO;
    self.buyBtn.backgroundColor = [UIColor whiteColor];
    sender.backgroundColor = MainColor;
    sender.selected = YES;
    [self.scrollBgView setContentOffset:CGPointMake(ScreenWidth, 0)];
}

- (IBAction)buy:(UIButton *)sender {
    self.sellBtn.selected = NO;
    self.sellBtn.backgroundColor = [UIColor whiteColor];
    sender.backgroundColor = MainColor;
    sender.selected = YES;
    [self.scrollBgView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark returnButton

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _searchStr = textField.text;
    [self.tableView.mj_header beginRefreshing];
    self.sellBgView.searchStr = textField.text;
    [self.sellBgView.mj_header beginRefreshing];
    
    return YES;
}
#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib:[UINib nibWithNibName:@"BuyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"BuyInfoTableViewCell"];
    BuyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyInfoTableViewCell"];
    
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchTextField resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyInformationModel *model = [self.dataArray objectAtIndex:indexPath.row];
    HTMLViewController *vc = [[HTMLViewController alloc]init];
    vc.titleStr = @"求购信息";
    vc.htmlUrl = [NSString stringWithFormat:@"%@/business/patentBuy?id=%@&usrPhone=%@&busiQuality=8&usrId=%@",HTTPURL,model.modelId,[[AppUserDefaults share].phone isKindOfClass:[NSNull class]]?[AppUserDefaults share].phone:@"",[AppUserDefaults share].usrId?:@""];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark collectionView

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return  self.dataArray.count;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    PatentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PatentCollectionViewCell" forIndexPath:indexPath];
////    cell.contentView.backgroundColor = MainColor;
//    cell.model = [self.dataArray objectAtIndex:indexPath.row];
//    cell.delegate = self;
//    return cell;
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake((ScreenWidth-10)/2,(ScreenWidth-10)/2+90);
//}
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([AppUserDefaults share].isLogin) {
//        PatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
//        NSMutableString *url = [[NSMutableString alloc]initWithFormat:@"%@%@%@",HTTPURL,@"/patent/info?usrId=",[AppUserDefaults share].usrId];
//        [url appendFormat:@"&techId=%@&physicDb=%@&PKINDS=%@&app=1&buy=1",model.ID,model.PHYSIC_DB,model.PKIND_S];
//        if ([AppUserDefaults share].phone) {
//            [url appendFormat:@"&usrPhone=%@",[AppUserDefaults share].phone ];
//        }
//        WebViewController *webview = [[WebViewController alloc]init];
//        webview.urlStr = url;
//        webview.titleStr = @"专利详情";
//        webview.physicDb = model.PHYSIC_DB;
//        webview.hidesBottomBarWhenPushed = YES;
//        [self showViewController:webview sender:self];
//    }
//    else
//    {
//        [self goToLogin];
//    }
//}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    //如果是头部视图 (因为这里的kind 有头部和尾部所以需要判断  默认是头部,严谨判断比较好)
//    /*
//     JHHeaderReusableView 头部的类
//     kHeaderID  重用标识
//     */
//    if (kind == UICollectionElementKindSectionHeader) {
//        UICollectionReusableView *headerRV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"resultHeader" forIndexPath:indexPath];
//        headerRV.backgroundColor = [UIColor whiteColor];
//
//        if (!_resultNumLab) {
//            _resultNumLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 33)];
//            _resultNumLab.textColor = UIColorFromRGB(0x666666);
//            _resultNumLab.font = [UIFont systemFontOfSize:12];
//            _resultNumLab.text = @"搜索到0个匹配对象";
//            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 33, ScreenWidth, 0.5)];
//            line.backgroundColor = UIColorFromRGB(0xf2f2f2);
//            [headerRV addSubview:line];
//        }
//
//        [headerRV addSubview:_resultNumLab];
//
//        return headerRV;
//
//    }else //有兴趣的也可以添加尾部视图
//    {
//        return nil;
//    }
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TransactionPushSeacrSell"]) {
        SearchToSellViewController *vc = [segue destinationViewController];
        __weak typeof(self) weakSelf = self;
        vc.totalNum = _currentSelNum;
        vc.selArrayBlock = ^(NSArray *modelArray) {
            [weakSelf.sellBgView addPatentModelArray:modelArray];
        };
        
    }
}

-(SellTableView *)sellBgView
{
    if (!_sellBgView) {
        _sellBgView = [[SellTableView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-64-49)];
        _sellBgView.sellDelegate = self;
    }
    return _sellBgView;
}
-(void)goToAddPatentWithCurrentNum:(NSInteger)currentNum
{
    if ([AppUserDefaults share].isLogin) {
        _currentSelNum = currentNum;
        [self performSegueWithIdentifier:@"TransactionPushSeacrSell" sender:self];
    }
    else
    {
        [self goToLogin];
    }
}
-(void)goToSellViewControllerWithModel:(BuyInformationModel *)model
{
#warning 这里要改这里要改
    HTMLViewController *vc = [[HTMLViewController alloc]init];
    vc.titleStr = @"转让信息";
    vc.htmlUrl = [NSString stringWithFormat:@"%@/business/patentBuy?id=%@&usrPhone=%@&busiQuality=9&usrId=%@",HTTPURL,model.modelId,[AppUserDefaults share].phone?[AppUserDefaults share].phone:@"",[AppUserDefaults share].usrId?:@""];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToLogin
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}





@end
