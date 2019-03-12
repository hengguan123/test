//
//  PublishErrandTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PublishErrandTableViewController.h"
#import "SelectedCityViewController.h"
#import "DomainViewController.h"
#import "ErrandsListTableViewController.h"

@interface PublishErrandTableViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *domainLab;
@property (weak, nonatomic) IBOutlet UILabel *promptLab;
@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UILabel *proWorkDesLab;


@end

@implementation PublishErrandTableViewController
{
    NSString *_city;
    NSString *_cityCode;
    ErrandClassModel *_fieldSelectedModel;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.model) {
        self.navigationItem.title = @"修改差事";
        _fieldSelectedModel = [ErrandClassModel new];
        _fieldSelectedModel.dictionaryCode = self.model.classifyDomain;
        _cityCode = self.model.dwellAddr;
        if ([_cityCode isEqualToString:InternationalCode]) {
            _sel1 = 2;
        }
        else
        {
            _sel1 = 1;
            _cityLab.text = self.model.dwellAddrName;
        }
        if ([self.model.errandType isEqualToString:TrademarkCode]) {
            _sel2 = 2;
        }
        else if ([self.model.errandType isEqualToString:CopyrightCode])
        {
            _sel2 = 3;
        }
        else
        {
            _sel2 = 1;
            self.domainLab.text = self.model.domainName;
        }
        self.titleTextField.text = self.model.errandTitle;
        self.userNameTextField.text = self.model.usrName;
        
        self.priceTextField.text = [NSString stringWithFormat:@"%@",self.model.price];
        if (self.model.remark && ![self.model.remark isEqualToString:@""]) {
            self.remarksTextView.text = self.model.remark;
            self.promptLab.hidden = YES;
        }
        self.publishBtn.hidden = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"delete_icon_big"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteErrand:)];
        self.phoneTextField.text = self.model.phone;
        if ([self.model.busiTypeName containsString:self.model.errandTypeName]) {
            self.proWorkDesLab.text = self.model.busiTypeName;
        }
        else
        {
            self.proWorkDesLab.text = [self.model.errandTypeName stringByAppendingString:self.model.busiTypeName];
        }
        [self.tableView reloadData];
    }
    else
    {
        self.changeBtn.hidden = YES;
        if ([AppUserDefaults.share.phone isEqualToString:@""]||AppUserDefaults.share.phone==nil) {
            
        }
        else
        {
            self.phoneTextField.text = AppUserDefaults.share.phone;
        }
        if ([self.selOtherModel1.dictionaryCode isEqualToString:InternationalCode]) {
//            self.cityLab.text = @"国际";
            _cityCode = InternationalCode;
        }
        else
        {
            self.cityLab.text = @"内陆";
            _cityCode = @"CHN";
        }
        if ([self.selOtherModel1.dictionaryCode isEqualToString:PatentCode]) {
            self.proWorkDesLab.text = [self.selOtherModel2.dictionaryName stringByAppendingString:self.selOtherModel3.dictionaryName];
        }
        else
        {
            if (self.selOtherModel3) {
                self.proWorkDesLab.text = self.selOtherModel3.dictionaryName;
            }
            else
            {
                self.proWorkDesLab.text = self.selOtherModel2.dictionaryName;
            }
        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0||indexPath.row ==1||indexPath.row ==2||indexPath.row == 6) {
        return 54;
    }
    else if (indexPath.row==3)
    {
        if (![self.selOtherModel1.dictionaryCode isEqualToString:InternationalCode]) {
            return 54;
        }
        else
        {
            return 0;
        }
    }
    else if (indexPath.row==4)
    {
        if ([self.selOtherModel1.dictionaryCode isEqualToString:InternationalCode]) {
            return 54;
        }
        else
        {
            return 0;
        }
    }
    else if (indexPath.row == 5)
    {
        if ([self.selOtherModel1.dictionaryCode isEqualToString:PatentCode]) {
            return 54;
        }
        else
        {
            return 0;
        }
    }
    else if (indexPath.row == 7)
    {
        return 44;
    }
    else{
        return 130;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        SelectedCityViewController *vc = [[SelectedCityViewController alloc]init];
        vc.currentCity = _city;
        vc.block = ^(AreaModel *cityModel) {
            _city = cityModel.addrName;
            _cityCode = cityModel.addrCode;
            _cityLab.text = _city;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 5)
    {
        DomainViewController *vc = [[DomainViewController alloc]init];
        vc.block = ^(ErrandClassModel *model) {
            _fieldSelectedModel = model;
            self.domainLab.text = model.dictionaryName;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.userNameTextField resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.remarksTextView resignFirstResponder];
}

#pragma mark --- btn


#pragma mark ----textView
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length==0) {
        self.promptLab.hidden = NO;
    }
    else
    {
        self.promptLab.hidden = YES;
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark ----xib 事件

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)publish:(UIButton *)sender {
    if ([self.titleTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"标题不能为空"];
        return;
    }
    if ([self.userNameTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"称呼不能为空"];
        return;
    }
    if ([self.phoneTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"联系电话不能为空"];
        return;
    }
    if ([self.selOtherModel1.dictionaryCode isEqualToString:PatentCode])
    {
        if (_fieldSelectedModel==nil)
        {
            [SVProgressHUD showInfoWithStatus:@"请选择领域"];
            return;
        }
    }
    if ([self.priceTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"您还没有出价哦"];
        return;
    }
    if ([self.priceTextField.text integerValue]<400)
    {
        [SVProgressHUD showInfoWithStatus:@"出价不能过低哦"];
        return;
    }
    if (_cityCode == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"获取当前城市编码失败，请手动选择"];
        return;
    }
    [LoadingManager show];
    NSString *type,*subType;
    if (self.selOtherModel3) {
        type = self.selOtherModel3.superDictionaryCode;
        subType = self.selOtherModel3.dictionaryCode;
    }
    else
    {
        type = self.selOtherModel2.superDictionaryCode;
        subType = self.selOtherModel2.dictionaryCode;
    }
    sender.enabled = NO;
    [RequestManager publicErrandWithUsrId:[AppUserDefaults share].usrId usrName:self.userNameTextField.text dwellAddr:_cityCode classifyDomain:_fieldSelectedModel?_fieldSelectedModel.dictionaryCode:@"" errandType:type busiType:subType price:@([self.priceTextField.text integerValue]) title:self.titleTextField.text phone:self.phoneTextField.text remark:self.remarksTextView.text successHandler:^(BOOL success) {
        [LoadingManager dismiss];
        sender.enabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } errorHandler:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"发布失败"];
        sender.enabled = YES;
    }];
}
- (IBAction)changeErrand:(id)sender {
    if ([self.titleTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"标题不能为空"];
    }
    else if ([self.userNameTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"称呼不能为空"];
    }
    else if ([self.priceTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"您还没有出价哦"];
    }
    else if ([self.priceTextField.text integerValue]<400)
    {
        [SVProgressHUD showInfoWithStatus:@"出价不能过低哦"];
    }
    else if ([self.priceTextField.text integerValue]>99999)
    {
        [SVProgressHUD showInfoWithStatus:@"出价上限99999"];
    }
    else if (_cityCode == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"获取当前城市编码失败，请手动选择"];
    }
    else
    {
        [LoadingManager show];
        
        [RequestManager changeErrandWithErrandId:self.model.errandId usrName:self.userNameTextField.text dwellAddr:_cityCode classifyDomain:_fieldSelectedModel?_fieldSelectedModel.dictionaryCode:@"" errandType:self.model.errandType busiType:self.model.busiType price:@([self.priceTextField.text integerValue]) title:self.titleTextField.text phone:self.phoneTextField.text remark:self.remarksTextView.text successHandler:^(BOOL success) {
            [LoadingManager dismiss];
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            if (self.fromList) {
                [self.navigationController popToViewController:self.fromList animated:YES];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } errorHandler:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];

        }];
        
    }
}

-(void)deleteErrand:(UIButton *)btn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"您确认撤销发布并删除此差事吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除然后刷新");
        [RequestManager deleteErrandWithErrandId:self.model.errandId successHandler:^(BOOL success) {
            [SVProgressHUD showSuccessWithStatus:@"删除差事成功"];
            if (self.fromList) {
                [self.navigationController popToViewController:self.fromList animated:YES];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } errorHandler:^(NSError *error) {
            
        }];
        
        
    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
