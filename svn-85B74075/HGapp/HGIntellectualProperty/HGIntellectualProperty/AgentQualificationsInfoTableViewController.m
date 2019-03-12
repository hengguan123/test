//
//  AgentQualificationsInfoTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AgentQualificationsInfoTableViewController.h"

@interface AgentQualificationsInfoTableViewController ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/// 真是名称
@property (weak, nonatomic) IBOutlet UITextField *trueNameTextField;
/// 资格证号
@property (weak, nonatomic) IBOutlet UITextField *QualificationNumberTextField;
/// 资格证图
@property (weak, nonatomic) IBOutlet UIImageView *qualificationImageView;

/// 执业证号
@property (weak, nonatomic) IBOutlet UITextField *certificateNumberTextField;
/// 所在机构
@property (weak, nonatomic) IBOutlet UITextField *organizationNameTextField;
/// 组织机构代码
@property (weak, nonatomic) IBOutlet UITextField *organizationCodeTextField;
/// 年检
@property (weak, nonatomic) IBOutlet UIButton *noSubmitBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
/// 城市
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *QQTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIImageView *IDCardPositiveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *IDCardNegativeImageView;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *openBankTextField;
@property (weak, nonatomic) IBOutlet UITextField *openBankLocationTextField;
@property (weak, nonatomic) IBOutlet UITextView *serviceDeclarationTextView;
@property (weak, nonatomic) IBOutlet UITextView *serviceBriefTextView;
@property (weak, nonatomic) IBOutlet UITextView *otherTextView;

@property (nonatomic,strong)AgentInfoModel *userModel;

@end

@implementation AgentQualificationsInfoTableViewController
{
    NSInteger _uploadImageType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" font:13 target:self action:@selector(save:)];
    [self loadData];
    
}
- (void)loadData
{
    
    [RequestManager getAgentInfoSuccessHandler:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        self.userModel = [MTLJSONAdapter modelOfClass:[AgentInfoModel class] fromJSONDictionary:[dict objectForKey:@"faci"] error:nil];
        NSDictionary *addrDict = [dict objectForKey:@"addr"];
        NSString *str = [addrDict objectForKey:@"cityName"];
        if (str) {
            self.cityLab.text = str;
            self.cityLab.textColor = [UIColor darkGrayColor];
        }
        [self.tableView.mj_header endRefreshing];
    } errorHandler:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUserModel:(AgentInfoModel *)userModel
{
    _userModel = userModel;
    self.trueNameTextField.text = userModel.realName;
    self.QualificationNumberTextField.text = userModel.qualCertNo;
    self.certificateNumberTextField.text = userModel.practCertNo;
    [self.qualificationImageView sd_setImageWithURL:[NSURL URLWithString:ImageURL(userModel.credUrl)] placeholderImage:[UIImage imageNamed:@"addimage"]];
    self.organizationNameTextField.text = userModel.companyName;
    self.organizationCodeTextField.text = userModel.organNo;
    if ([userModel.annualStatus isEqualToString:@"0"]) {
        self.noSubmitBtn.selected = YES;
        self.submitBtn.selected = NO;
    }
    else if ([userModel.annualStatus isEqualToString:@"1"])
    {
        self.noSubmitBtn.selected = NO;
        self.submitBtn.selected = YES;
    }
    self.phoneTextField.text = userModel.mobilePhone;
    self.QQTextField.text = userModel.qq;
    self.emailTextField.text = userModel.email;
    
    [self.IDCardPositiveImageView sd_setImageWithURL:[NSURL URLWithString:ImageURL(userModel.fileUrl1)] placeholderImage:[UIImage imageNamed:@"addimage"]];
    [self.IDCardNegativeImageView sd_setImageWithURL:[NSURL URLWithString:ImageURL(userModel.fileUrl2)] placeholderImage:[UIImage imageNamed:@"addimage"]];
    self.bankCardNumberTextField.text = userModel.bankCardNo;
    self.openBankTextField.text = userModel.bankOpen;
    self.openBankLocationTextField.text = userModel.bankLocale;
    self.serviceDeclarationTextView.text = userModel.serveManifesto;
    self.serviceBriefTextView.text = userModel.serveBrief;
    self.otherTextView.text = userModel.ortherInfo;
}

#pragma mark 输入框

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    _uploadImageType = sender.view.tag;
    [self selImage];
}


- (IBAction)selbtnClcik:(UIButton *)sender {
    sender.selected = YES;
    if (sender == self.submitBtn) {
        self.noSubmitBtn.selected = NO;
        self.userModel.annualStatus = @"1";
    }
    else if (sender == self.noSubmitBtn)
    {
        self.submitBtn.selected = NO;
        self.userModel.annualStatus = @"0";
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"前%@",textField.text);
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"后%@",textField.text);
    if (textField == self.trueNameTextField) {
        self.userModel.realName = textField.text;
    }
    else if (textField == self.QualificationNumberTextField)
    {
        self.userModel.qualCertNo = textField.text;
    }
    else if (textField == self.certificateNumberTextField)
    {
        self.userModel.practCertNo = textField.text;
    }
    else if (textField == self.organizationNameTextField)
    {
        self.userModel.companyName = textField.text;
    }
    else if (textField == self.organizationCodeTextField)
    {
        self.userModel.organNo = textField.text;
    }
    else if (textField == self.phoneTextField)
    {
        self.userModel.mobilePhone = textField.text;
    }
    else if (textField == self.QQTextField)
    {
        self.userModel.qq = textField.text;
    }
    else if (textField == self.emailTextField)
    {
        self.userModel.email = textField.text;
    }
    else if (textField == self.bankCardNumberTextField)
    {
        self.userModel.bankCardNo = textField.text;
    }
    else if (textField == self.openBankTextField)
    {
        self.userModel.bankOpen = textField.text;
    }
    else if (textField == self.openBankLocationTextField)
    {
        self.userModel.bankLocale = textField.text;
    }
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.serviceDeclarationTextView) {
        self.userModel.serveManifesto = textView.text;
    }
    else if (textView == self.serviceBriefTextView)
    {
        self.userModel.serveBrief = textView.text;
    }
    else if (textView == self.otherTextView)
    {
        self.userModel.ortherInfo = textView.text;
    }
}


#pragma mark - uploadImage

-(void)selImage
{
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertvc addAction:camera];
    [alertvc addAction:photo];
    [alertvc addAction:cancel];
    [self presentViewController:alertvc animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data=UIImagePNGRepresentation(portraitImg);
        if (_uploadImageType==1) {
            [RequestManager uploadImageWithImageData:data successHandler:^(NSString *imageUrl) {
                weakSelf.userModel.credUrl = imageUrl;
                weakSelf.qualificationImageView.image = portraitImg;
            } errorHandler:^(NSError *error) {
                
            }];
        }
        else if (_uploadImageType == 2)
        {
            [RequestManager uploadImageWithImageData:data successHandler:^(NSString *imageUrl) {
                weakSelf.userModel.fileUrl1 = imageUrl;
                weakSelf.IDCardPositiveImageView.image = portraitImg;
            } errorHandler:^(NSError *error) {
            
            }];
        }
        else if (_uploadImageType == 3)
        {
            [RequestManager uploadImageWithImageData:data successHandler:^(NSString *imageUrl) {
                weakSelf.userModel.fileUrl2 = imageUrl;
                weakSelf.IDCardNegativeImageView.image = portraitImg;
            } errorHandler:^(NSError *error) {
                
            }];
        }
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 18;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==7) {
        SelectedCityViewController *vc = [[SelectedCityViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.block = ^(AreaModel *cityModel) {
            NSLog(@"%@",cityModel);
            self.cityLab.text = cityModel.addrName;
            self.userModel.dwellAddr = cityModel.addrCode;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (IBAction)save:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if ([self.userModel.realName isEqualToString:@""]||self.userModel.realName==nil) {
        [SVProgressHUD showInfoWithStatus:@"名称不能为空"];
    }
    else if (![GGTool isMobileNumber:self.userModel.mobilePhone])
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正确手机号"];
    }
    else
    {
        [RequestManager changeAgentInfoWithModel:self.userModel successHandler:^(BOOL success) {
            [self.navigationController popViewControllerAnimated:YES];
        } errorHandler:^(NSError *error) {
            
        }];
//        [RequestManager changePhone:self.phoneTextField.text detailsId:MyApp.userInfo.detailsId successHandler:^(BOOL success) {
//            
//        } errorHandler:^(NSError *error) {
//            
//        }];
    }
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
