//
//  SearchCompanyViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SearchCompanyViewController.h"
#import "MyCompanyTableViewCell.h"


@interface SearchCompanyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *searchCompanyArray;

@end

@implementation SearchCompanyViewController
{
    RequestManager *_reqMan;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.company) {
        self.companyTextField.text = self.company.selKeyword;
        self.navigationItem.title = @"编辑";
    }
    else
    {
        self.navigationItem.title = @"修改";
    }
    _reqMan = [RequestManager new];
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchCompanyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SecarchCompanyTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecarchCompanyTableViewCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
    }
    cell.textLabel.text = [self.searchCompanyArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [LoadingManager show];
    if (self.company) {
        [RequestManager editCompantWithKeywordId:self.company.keywordId selKeyword:[self.searchCompanyArray objectAtIndex:indexPath.row] successHandler:^(NSDictionary *dict) {
            if (self.addBlock) {
                [LoadingManager dismiss];
                self.addBlock(dict);
                [self.navigationController popViewControllerAnimated:YES];
            }
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        [RequestManager addCompanyWithName:[self.searchCompanyArray objectAtIndex:indexPath.row] successHandler:^(NSDictionary *dict) {
            if (self.addBlock) {
                [LoadingManager dismiss];
                self.addBlock(dict);
                [self.navigationController popViewControllerAnimated:YES];
            }
        } errorHandler:^(NSError *error) {
            
        }];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)valueChange:(id)sender {
    NSLog(@"搜索:%@",self.companyTextField.text);
    if(self.companyTextField.text==nil||[self.companyTextField.text isEqualToString:@""]){
        return;
    }
    self.searchCompanyArray = nil;
    [self.tableView reloadData];
    [_reqMan searchCompanyWithCompany:self.companyTextField.text successHandler:^(NSArray *array) {
        self.searchCompanyArray = array;
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        
    }];
}


@end
