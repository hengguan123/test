//
//  AssignAgentTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AssignAgentTableViewController.h"

@interface AssignAgentTableViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *domainLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (weak, nonatomic) IBOutlet UILabel *subTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *promptLab;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;


@end

@implementation AssignAgentTableViewController
{
    NSString *_cityCode;
    NSString *_typeCode;
    NSString *_subTypeCode;
    NSString *_domainCode;
    NSString *_price;
    NSString *_faciId;
    NSString *_faciName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    _typeCode = [self.dict objectForKey:@"typeCode"];
    _subTypeCode = [self.dict objectForKey:@"childCode"];
    _domainCode = [self.dict objectForKey:@"filedCode"];
    _price = [self.dict objectForKey:@"price"];
    _faciId = [self.dict objectForKey:@"faciId"];
    _faciName = [self.dict objectForKey:@"faciName"];
    
    NSString *subtypeName =  [self.dict objectForKey:@"childName"];
    
    
    self.titleTextField.text = [NSString stringWithFormat:@"%@%@",[self.dict objectForKey:@"typeName"],subtypeName.length?subtypeName:@"全流程"];
    self.domainLab.text = [self.dict objectForKey:@"filedName"];
    self.typeLab.text =[self.dict objectForKey:@"typeName"];
    self.subTypeLab.text = subtypeName.length?subtypeName:@"全流程";
    self.priceLab.text = _price;
    if ([AppUserDefaults.share.phone isEqualToString:@""]||AppUserDefaults.share.phone==nil) {
        
    }
    else
    {
        self.phoneTextField.text = AppUserDefaults.share.phone;
    }
    if (MyApp.locationCity) {
        self.cityLab.text = MyApp.locationCity;
        [RequestManager getCityCodeByCityName:MyApp.locationCity successHandler:^(AreaModel *model) {
            _cityCode = model.addrCode;
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        [[GGTool share]getLocationSuccessHandler:^(NSString *province,NSString *city, CLLocation *location) {
            self.cityLab.text = city;
            [RequestManager getCityCodeByCityName:city successHandler:^(AreaModel *model) {
                _cityCode = model.addrCode;
            } errorHandler:^(NSError *error) {
                
            }];
        } errorHandler:^(NSError *error) {
            
        }];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        SelectedCityViewController *vc = [[SelectedCityViewController alloc]init];
        vc.block = ^(AreaModel *cityModel) {
            NSLog(@"%@",cityModel);
            self.cityLab.text = cityModel.addrName;
            _cityCode = cityModel.addrCode;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.promptLab.hidden=NO;
    }
    else
    {
        self.promptLab.hidden=YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submit:(id)sender {
    if ([self.titleTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"标题不能为空"];
    }
    else if ([self.nameTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"称呼不能为空"];
    }
    else if ([self.phoneTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"联系电话不能为空"];
    }
    else if (_cityCode == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"获取当前城市编码失败，请手动选择"];
    }
    else
    {
        [LoadingManager show];
        [RequestManager assignAgentWithFaciId:_faciId faciName:_faciName usrName:self.nameTextField.text dwellAddr:_cityCode classifyDomain:_domainCode errandType:_typeCode busiType:_subTypeCode price:_price title:self.titleTextField.text remark:self.remarkTextView.text phone:self.phoneTextField.text successHandler:^(BOOL success){
            if (success) {
                [LoadingManager dismiss];
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                [self performSegueWithIdentifier:@"AssignPushNoPay" sender:self];
            }
        } errorHandler:^(NSError *error) {
            
        }];
    }
}

@end
