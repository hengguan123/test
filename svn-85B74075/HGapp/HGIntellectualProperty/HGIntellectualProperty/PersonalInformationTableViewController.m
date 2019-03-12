//
//  PersonalInformationTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PersonalInformationTableViewController.h"
#import "BundPhoneViewController.h"
#import "GetCodeViewController.h"

@interface PersonalInformationTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIImageView *userIamgeView;

@end

@implementation PersonalInformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.tableView.tableFooterView = [UIView new];
    NSString *url = [self.userInfo.portraitUrl hasPrefix:@"http"]?self.userInfo.portraitUrl:ImageURL(self.userInfo.portraitUrl);
    [self.userIamgeView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.userNameLab.text = [AppUserDefaults share].userName;
    NSString *phone = [AppUserDefaults share].phone;
    if (phone==nil || [phone isEqualToString:@""]) {
        self.phoneLab.text = @"未绑定";
    }
    else
    {
        self.phoneLab.text = [AppUserDefaults share].phone;
    }
    self.idLab.text = [NSString stringWithFormat:@"%@",[AppUserDefaults share].usrId];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([MyApp.userInfo.usrType isEqualToString:@"1"]) {
        return 2;
    }
    else
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 4;
    }
    else
    {
        return 2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = YES;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = YES;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertvc addAction:camera];
        [alertvc addAction:photo];
        [alertvc addAction:cancel];
        [self presentViewController:alertvc animated:YES completion:nil];
    }
    else if (indexPath.section==0&&indexPath.row==1)
    {
        [SVProgressHUD showInfoWithStatus:@"用户ID是用户唯一标识不可修改"];
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        if ([AppUserDefaults share].phone==nil || [[AppUserDefaults share].phone isEqualToString:@""]) {
            BundPhoneViewController *vc = [[BundPhoneViewController alloc]initWithNibName:@"BundPhoneViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改手机号需先解除绑定当前手机号，是否解绑" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.tableView reloadData];
            }];
            [alertvc addAction:cancel];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"解除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                GetCodeViewController *vc = [[GetCodeViewController alloc]initWithNibName:@"GetCodeViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [alertvc addAction:sure];
            [self presentViewController:alertvc animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data=UIImagePNGRepresentation(portraitImg);
        [RequestManager uploadImageWithImageData:data successHandler:^(NSString *imageUrl) {
            MyApp.userInfo.portraitUrl = imageUrl;
            [RequestManager changeUserInfoWithPortraitUrl:imageUrl successHandler:^(BOOL success) {
                weakSelf.userIamgeView.image = portraitImg;
            } errorHandler:^(NSError *error) {
                
            }];
            if ([MyApp.userInfo.usrType isEqualToString:@""]&&MyApp.userInfo.facilitatorId) {
                
                [RequestManager changeAgentInfoWithHeaderImage:imageUrl SuccessHandler:^(BOOL success) {
                    
                } errorHandler:^(NSError *error) {
                    
                }];

            }
        } errorHandler:^(NSError *error) {
            
        }];
    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
