//
//  SearchToSellViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SearchToSellViewController.h"
#import "BatchSelPatentTableViewCell.h"
#import "AssociateView.h"
#import "FilterCountryViewController.h"
#define CurrentFilterWidth ScreenWidth*3/4

@interface SearchToSellViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AssociateViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)AssociateView *associateView;
@property (nonatomic,strong) UIView *filterBgView;
@property (nonatomic,strong) UIWindow *filterWindow;
@property (nonatomic,strong) FilterCountryViewController *filterVC;
@property (weak, nonatomic) IBOutlet UIButton *selAllBtn;

@end

@implementation SearchToSellViewController
{
    int _page;
    BOOL _isLast;
    NSString *_provinceName;
    NSString *_countryCode;
//    NSURLSessionDataTask *_task;
    NSString *_pkindStr;
    NSString *_searchStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    leftView.image = [UIImage imageNamed:@"searchLogo"];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.titleBgView.frame= CGRectMake(0, 0, ScreenWidth-100, 33);
    leftView.contentMode = UIViewContentModeCenter;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = leftView;
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    [clearBtn setImage:[UIImage imageNamed:@"clearTextField"] forState:UIControlStateNormal];
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    [clearBtn addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];
    self.searchTextField.rightView = clearBtn;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" font:13 target:self action:@selector(search:)];
    _provinceName = @"";
    _pkindStr = @"";
    _countryCode = @"CHN";
    _searchStr = @"";
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataRefresh:NO];
    }];

//    [self.searchTextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}

-(void)loadDataRefresh:(BOOL)refresh
{
    if ([_searchStr isEqualToString:@""]||!_searchStr) {
        [SVProgressHUD showInfoWithStatus:@"搜索内容不能为空"];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (refresh) {
        _page = 1;
        [LoadingManager show];
        [RequestManager searchPatentWithContent:_searchStr pageNo:_page anAdd:_provinceName country:_countryCode pkind:_pkindStr successHandler:^(BOOL isLast, NSArray *array,NSNumber *totalNum) {
            self.tableView.tableHeaderView = [[ResultNumView alloc]initWithNum:totalNum];
            [self.dataArray removeAllObjects];
            [LoadingManager dismiss];
            _isLast = isLast;
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            if (self.dataArray.count==0) {
                [SVProgressHUD showInfoWithStatus:@"未查询到专利数据，请更换关键字后重试!"];
            }
            [self checkAll];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        if (_isLast) {
            [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            _page++;
            [RequestManager searchPatentWithContent:_searchStr pageNo:_page anAdd:_provinceName country:_countryCode pkind:_pkindStr successHandler:^(BOOL isLast, NSArray *array,NSNumber *totalNum) {
                [SVProgressHUD dismiss];
                _isLast = isLast;
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                [self checkAll];
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)back:(id)sender {
    
    [self.searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib:[UINib nibWithNibName:@"BatchSelPatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"BatchSelPatentTableViewCell"];
    BatchSelPatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BatchSelPatentTableViewCell"];
    cell.searchStr = self.searchTextField.text;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.selStatus) {
        model.selStatus = NO;
    }
    else
    {
        int i = 0;
        for (PatentModel *patentModel in self.dataArray) {
            if (patentModel.selStatus) {
                i ++ ;
            }
        }
        if (i+_totalNum>=100) {
            [SVProgressHUD showInfoWithStatus:@"最多添加100项专利"];
        }
        else
        {
            model.selStatus = YES;
        }
    }
    [self.tableView reloadData];
    [self checkAll];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length>0) {
        [textField resignFirstResponder];
        _searchStr = textField.text;
        [self loadDataRefresh:YES];
        [self.associateView removeFromSuperview];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"搜索内容不能为空"];
    }
    
    return YES;
}


-(AssociateView *)associateView
{
    if (!_associateView) {
        _associateView = [[AssociateView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) type:2 presentView:self.view];
        _associateView.delegate = self;
    }
    return _associateView;
}

- (IBAction)valueChange:(id)sender {
    NSLog(@"%@",self.searchTextField.text);
    if (self.searchTextField.text.length>=4) {
        [self.associateView searchStrChange:self.searchTextField.text];
    }
    else
    {
        [self.associateView removeFromSuperview];
    }
}
-(void)clearTextField
{
    self.searchTextField.text = @"";
    [self.associateView removeFromSuperview];
}

-(void)associateView:(AssociateView *)view didSelectedKeyStr:(NSString *)keyStr
{
    _searchStr = keyStr;
    self.searchTextField.text = keyStr;
    [self.searchTextField resignFirstResponder];
    [self loadDataRefresh:YES];
}
-(void)associateView:(AssociateView *)view didSelectedCompanyName:(NSString *)companyName
{
    _searchStr = companyName;
    self.searchTextField.text = companyName;
    [self.searchTextField resignFirstResponder];
    [self loadDataRefresh:YES];
}
-(void)duringScrolling
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}
- (IBAction)search:(id)sender {
    
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
        _filterVC.type = 2;//专利
        _filterVC.view.frame = CGRectMake(0, 0, CurrentFilterWidth, ScreenHeight);
        __weak typeof(self) weakSelf = self;
        
        _filterVC.sureSelBlock = ^(BOOL ischina, NSString *addrcodes, NSString *typecodes) {
            if (ischina) {
                _countryCode = @"CHN";
                _provinceName = addrcodes;
                if ([addrcodes isEqualToString:@"全国"]) {
                    _provinceName = @"";
                }
            }
            else{
                _provinceName = @"";
                _countryCode = addrcodes;
            }
            _pkindStr = typecodes;
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

- (IBAction)selAll:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        if (self.dataArray.count+_totalNum>=100) {
            [SVProgressHUD showInfoWithStatus:@"最多添加100项专利"];
            for (int i=0; i<100-_totalNum; i++) {
                PatentModel *model = [self.dataArray objectAtIndex:i];
                model.selStatus = YES;
            }
        }
        else
        {
            for (PatentModel *model in self.dataArray) {
                model.selStatus = sender.isSelected;
            }
        }
    }
    else
    {
        for (PatentModel *model in self.dataArray) {
            model.selStatus = sender.isSelected;
        }
    }
    [self.tableView reloadData];
}

-(void)checkAll
{
    for (PatentModel *model in self.dataArray) {
        if (!model.selStatus) {
            self.selAllBtn.selected = NO;
            return;
        }
    }
    self.selAllBtn.selected = YES;
}

-(NSArray *)resultSelArray
{
    NSMutableArray *array = [NSMutableArray new];
    for (PatentModel *model in self.dataArray) {
        if (model.selStatus) {
            [array addObject:model];
        }
    }
    return array;
}

- (IBAction)sure:(id)sender {
    NSArray *array = [self resultSelArray];
    if (array.count) {
        if (array.count>100) {
            
        }
        else
        {
            if (self.selArrayBlock) {
                self.selArrayBlock([self resultSelArray]);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"当前选择为空"];
    }
}



@end
