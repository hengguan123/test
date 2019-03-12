//
//  MyPatentViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MyPatentViewController.h"
#import "MyPatentTableViewCell.h"
#import "MyCompanyTableViewCell.h"
#import "AddApplicantTableViewCell.h"
#import "SearchCompanyViewController.h"
#import "RequestURL.h"


#import "MyPatentModel.h"
#import "MyCompanyModel.h"


@interface MyPatentViewController ()<UITableViewDelegate,UITableViewDataSource,MyCompanyTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *myCompanyArray;
@property (nonatomic,strong) NSArray *patentArray;


@property(nonatomic,strong)NSDictionary *dataDict;


@end

@implementation MyPatentViewController
{
    BOOL _isSearchCompany;
    MyCompanyModel *_company;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self loadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}

-(void)loadData
{
    [RequestManager lookforMyPatentSuccessHandler:^(NSDictionary *dict) {
        self.dataDict = dict;
        [self.tableView.mj_header endRefreshing];
    } errorHandler:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    self.myCompanyArray = [MTLJSONAdapter modelsOfClass:[MyCompanyModel class] fromJSONArray:[dataDict objectForKey:@"listKeyword"] error:nil];
    self.patentArray = [MTLJSONAdapter modelsOfClass:[MyPatentModel class] fromJSONArray:[dataDict objectForKey:@"listPatentInfo"] error:nil];
    [self.tableView reloadData];
}




- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.myCompanyArray.count;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return self.patentArray.count;
    }
    else
        return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    }
    else if (indexPath.section == 1)
    {
        return 65;
    }
    else if (indexPath.section == 2)
    {
        return 120;
    }
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.tableView registerNib:[UINib nibWithNibName:@"MyCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCompanyTableViewCell"];
        MyCompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCompanyTableViewCell"];
        cell.delegate = self;
        cell.model = [self.myCompanyArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"AddApplicantTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddApplicantTableViewCell"];
        AddApplicantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddApplicantTableViewCell"];
        return cell;
    }
    else
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"MyPatentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyPatentTableViewCell"];
        MyPatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPatentTableViewCell"];
        cell.model = [self.patentArray objectAtIndex:indexPath.row];
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
    }
    else if(indexPath.section == 1)
    {
        _company = nil;
        [self performSegueWithIdentifier:@"MyPatentPushAdd" sender:self];
    }
    else if (indexPath.section ==2)
    {
        MyPatentModel *model = [self.patentArray objectAtIndex:indexPath.row];
        
        [CutoverManager openPatendDetailWithFromController:self techId:model.patentId physicDb:model.dbName PKINDS:model.pkinds monitorId:nil title:nil subTitle:nil share:NO];
    }
}


-(void)editWithMyCompanyTableViewCell:(MyCompanyTableViewCell *)cell
{
    _company = cell.model;
    [self performSegueWithIdentifier:@"MyPatentPushAdd" sender:self];
    
}
-(void)deleteWithMyCompanyTableViewCell:(MyCompanyTableViewCell *)cell
{
    [LoadingManager show];
    [RequestManager editCompantWithKeywordId:cell.model.keywordId selKeyword:@"" successHandler:^(NSDictionary *dict) {
        [LoadingManager dismiss];
        self.dataDict = dict;
    } errorHandler:^(NSError *error) {
        
    }];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MyPatentPushAdd"]) {
        SearchCompanyViewController *vc = segue.destinationViewController;
        __weak typeof(self) weakSelf = self;
        vc.addBlock = ^(NSDictionary *dict) {
            weakSelf.dataDict = dict;
        };
        vc.company =_company;
    }
}
@end
