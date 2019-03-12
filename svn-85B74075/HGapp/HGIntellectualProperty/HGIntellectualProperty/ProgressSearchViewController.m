//
//  ProgressSearchViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/31.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ProgressSearchViewController.h"
#import "PatentProgressListTableViewCell.h"
#import "UIImage+GIF.h"
#import "FLAnimatedImage.h"
#import "ScanViewController.h"
#import "PatentTableViewCell.h"

@interface ProgressSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AssociateViewDelegate>
@property (strong, nonatomic) UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIView *labBgView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)NSMutableArray *patentArray;

@property (weak, nonatomic) IBOutlet UIImageView *rightView;
@property (nonatomic ,strong) AssociateView *associateView;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@end

@implementation ProgressSearchViewController
{
    NSTimer *_timer;
    int _page;
    BOOL _isLast;
    NSString *_uuid;
    /// _type  0-内部进度    1-专利进度
    NSInteger _type;
    /// _searchType    0-专利名  1-公司
    NSInteger _searchType;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.labBgView addSubview:self.infoLab];
//    self.labBgView.backgroundColor = [UIColor redColor];
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    leftView.image = [UIImage imageNamed:@"searchLogo"];
    leftView.contentMode = UIViewContentModeCenter;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = leftView;
    
    NSArray *gifArray = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"60-60-1"],
                         [UIImage imageNamed:@"60-60-2"],
                         [UIImage imageNamed:@"60-60-3"],
                         [UIImage imageNamed:@"60-60-4"],
                         [UIImage imageNamed:@"60-60-5"],
                         nil];
    self.rightView.animationImages = gifArray; //动画图片数组
    self.rightView.animationDuration = 0.6; //执行一次完整动画所需的时长
    self.rightView.animationRepeatCount = 0;  //动画重复次数
    [self.rightView startAnimating];
   
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).with.offset(0);
        make.left.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(0); make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(0);
        } else {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        }
    }];
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PatentProgressListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatentProgressListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatentTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.srearchStr) {
            if (_type) {
                [self searchPatentRefresh:YES];
            }
            else
            {
                [self loadProgress:YES];
            }
        }
        else
        {
            [self.tableView.mj_header endRefreshing];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.srearchStr) {
            if (_type) {
                [self searchPatentRefresh:NO];
            }
            else
            {
                [self loadProgress:NO];
            }
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    if (self.srearchStr) {
        [self loadProgress:YES];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [UIView setAnimationsEnabled:YES];
    self.infoLab.frame = CGRectMake(ScreenWidth-86, 8, 290, 20);
    [self changeFrame];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}
-(void)loadProgress:(BOOL)refresh
{
    self.infoView.hidden = YES;
    _type = 0;
    if (refresh) {
        _page = 1;
        [RequestManager getCompanyProgressEnableListWithUUID:self.srearchStr page:_page successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
            _isLast = isLast;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
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
            _page ++;
            [RequestManager getCompanyProgressEnableListWithUUID:self.srearchStr page:_page successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
                _isLast = isLast;
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_footer endRefreshing];
            }];
        }
    }
    
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(NSMutableArray *)patentArray
{
    if (!_patentArray) {
        _patentArray = [NSMutableArray new];
    }
    return _patentArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeFrame{
    
    [UIView beginAnimations:@"FrameAni"context:nil];
    [UIView setAnimationDuration:10.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(startAni:)];
    [UIView setAnimationDidStopSelector:@selector(stopAni:)];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.infoLab.frame = CGRectMake(-290, 8, 290, 20);
    [UIView commitAnimations];
}
-(void)startAni:(NSString*)aniID{
    NSLog(@"%@start",aniID);
}
-(void)stopAni:(NSString*)aniID{
    NSLog(@"%@stop",aniID);
}

#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type==0) {
        return self.dataArray.count;
    }
    else
    {
        return self.patentArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 0) {
        PatentProgressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatentProgressListTableViewCell"];
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        PatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatentTableViewCell"];
        cell.searchStr = self.srearchStr;
        
        cell.model = [self.patentArray objectAtIndex:indexPath.row];
        return cell;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ProgressPushScan"]) {
        ScanViewController *vc = [segue destinationViewController];
        vc.fromProgressList = YES;
        __weak typeof(self) weakSelf = self;
        vc.resultBlock = ^(NSString *uuid) {
            weakSelf.srearchStr = uuid;
            [weakSelf loadProgress:YES];
        };
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 0) {
        CompanyEnableProgressPatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
        WebViewController *vc = [[WebViewController alloc]init];
        vc.titleStr = @"专利进度";
        vc.urlStr = [NSString stringWithFormat:@"%@%@?compUuid=%@&caseUuid=%@&applyNo=%@",HTTPURL,@"/hot/flowinfo",model.compUuid,model.caseUuid,model.applyNo];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        PatentModel *model = [self.patentArray objectAtIndex:indexPath.row];
        NSMutableString *str = [[NSMutableString alloc]initWithString:model.APN];
        if ([str containsString:@"."]) {
            [str deleteCharactersInRange:[str rangeOfString:@"."]];
        }
        if ([str containsString:@"CN"]) {
            [str deleteCharactersInRange:[str rangeOfString:@"CN"]];
        }
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
        HTMLViewController *web = [[HTMLViewController alloc]init];
        
        web.htmlUrl = [NSString stringWithFormat:@"http://cpquery.sipo.gov.cn/txnQueryPublicationData.do?select-key:shenqingh=%@&select-key:zhuanlilx=2&select-key:backPage=http://cpquery.sipo.gov.cn/txnQueryOrdinaryPatents.do?select-key:shenqingh=200720159082X&token=04C22AA7119748429292B508FFCFD79D&inner-flag:open-type=window&inner-flag:flowno=1535523704758",str];
        web.rightItem = NO;
        web.titleStr = @"专利查询";
        [self.searchTextField resignFirstResponder];
        [self.navigationController pushViewController:web animated:YES];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        
    }
}

-(UILabel *)infoLab
{
    if (!_infoLab) {
        _infoLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-86, 8, 290, 20)];
        _infoLab.text = @"扫描二维码查询恒冠知识产权代理的专利的内部进度";
        _infoLab.font = [UIFont systemFontOfSize:12];
        _infoLab.textColor = MainColor;
//        _infoLab.backgroundColor = [UIColor yellowColor];
    }
    return _infoLab;
}


#pragma mark 联想
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
-(AssociateView *)associateView
{
    if (!_associateView) {
        _associateView = [[AssociateView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) type:HotSearchViewTypePatent presentView:self.view];
        _associateView.delegate = self;
    }
    return _associateView;
}

-(void)duringScrolling
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}
-(void)associateView:(AssociateView *)view didSelectedKeyStr:(NSString *)keyStr
{
    self.searchTextField.text = keyStr;
    self.srearchStr = keyStr;
    _searchType = 0;
    [self.searchTextField resignFirstResponder];
    [self searchPatentRefresh:YES];
}

-(void)associateView:(AssociateView *)view didSelectedCompanyName:(NSString *)companyName
{
    self.searchTextField.text = companyName;
    self.srearchStr = companyName;
    _searchType = 1;
    [self searchPatentRefresh:YES];
    [self.searchTextField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.srearchStr = textField.text;
    _searchType = 1;
    [self.associateView removeFromSuperview];
    [self searchPatentRefresh:YES];
    [textField resignFirstResponder];
    return YES;
}
-(void)searchPatentRefresh:(BOOL)refresh
{
    self.infoView.hidden = YES;
    _type = 1;
    if (refresh) {
        _page = 1;
        [LoadingManager show];
        if (_searchType == 0) {
            [RequestManager searchPatentWithTITLE:self.srearchStr pageNo:_page anAdd:@"" country:@"CHN" pkind:@"" PBD:@"" IPC1:@"" ISVALID:@"" successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
                [self.patentArray removeAllObjects];
                _isLast = isLast;
                [LoadingManager dismiss];
                [self.patentArray addObjectsFromArray:array];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
            }];
        }
        else
        {
            [RequestManager searchPatentWithContent:self.srearchStr pageNo:_page anAdd:@"" country:@"CHN" pkind:@"" successHandler:^(BOOL isLast, NSArray *array, NSNumber *totalNum) {
                [self.patentArray removeAllObjects];
                _isLast = isLast;
                [LoadingManager dismiss];
                [self.patentArray addObjectsFromArray:array];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            } errorHandler:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
            }];
        }
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
            if (_searchType == 0) {
                [RequestManager searchPatentWithTITLE:self.srearchStr pageNo:_page anAdd:@"" country:@"CHN" pkind:@"" PBD:@"" IPC1:@"" ISVALID:@"" successHandler:^(BOOL isLast, NSArray *array, NSNumber *total) {
                    _isLast = isLast;
                    [self.patentArray addObjectsFromArray:array];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                } errorHandler:^(NSError *error) {
                    [self.tableView.mj_footer endRefreshing];
                }];
            }
            else
            {
                [RequestManager searchPatentWithContent:self.srearchStr pageNo:_page anAdd:@"" country:@"CHN" pkind:@"" successHandler:^(BOOL isLast, NSArray *array, NSNumber *totalNum) {
                    _isLast = isLast;
                    [self.patentArray addObjectsFromArray:array];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                } errorHandler:^(NSError *error) {
                    [self.tableView.mj_footer endRefreshing];
                }];
            }

        }
    }
}








@end
