//
//  HandleTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HandleTableViewController.h"
#import "TimePickerView.h"
#import "ProgressListViewController.h"


@interface HandleTableViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *grabTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *classLab;
@property (weak, nonatomic) IBOutlet UILabel *subClassLab;
@property (weak, nonatomic) IBOutlet UILabel *domainLab;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;

@property (weak, nonatomic) IBOutlet UILabel *statusLab;


@property (weak, nonatomic) IBOutlet UILabel *finishTimeLab;

@property (weak, nonatomic) IBOutlet UITextView *handleRemarksTextView;
@property (weak, nonatomic) IBOutlet UILabel *promptLab;

@property (nonatomic,strong)TimePickerView *timePickerBgView;

@end

@implementation HandleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.model)
    {
        self.titleLab.text = self.model.errandTitle;
        self.priceLab.text = [NSString stringWithFormat:@"%@",self.model.price ];
        self.userName.text = self.model.usrName;
        self.cityLab.text = self.model.dwellAddrName;
        self.timeLab.text = self.model.createTime;
        self.grabTimeLab.text = self.model.robTime;
        self.classLab.text = self.model.errandTypeName;
        self.subClassLab.text = self.model.busiTypeName;
        self.domainLab.text = self.model.domainName;
        self.statusLab.text = self.model.errandStatusName;
        if (self.model.remark) {
            self.remarkTextView.text = self.model.remark;
        }
    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
    [LoadingManager dismiss];
    [self.tableView setContentOffset:offset animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ask:(id)sender {
    NSLog(@"咨询平台");
    
    [self consultationPlatform];
    
}

-(void)consultationPlatform
{
    WebViewController *vc= [[WebViewController alloc]init];
    vc.titleStr = @"咨询平台";
    vc.urlStr = CustomerServiceUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)functionClick:(id)sender {
    
}
- (IBAction)addProgress:(id)sender {
    if ([self.model.isReply isEqualToString:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"进度编辑已完成，不可添加"];
    }
    else
    {
        if ([self.finishTimeLab.text isEqualToString:@""]) {
            [SVProgressHUD showInfoWithStatus:@"请先填写预计完成日期"];
            
        }
        else
        {
            [LoadingManager show];
            [RequestManager addProgressWithErrandId:self.model.errandId endTime:self.finishTimeLab.text remark:self.handleRemarksTextView.text errandStatus:@"CSZT01-05" successHandler:^(BOOL success) {
                [LoadingManager dismiss];
                [SVProgressHUD showSuccessWithStatus:@"进度添加成功!"];
                self.finishTimeLab.text = @"";
                self.handleRemarksTextView.text = @"";
                self.promptLab.hidden = NO;
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
}
- (IBAction)addAndFinish:(id)sender {
    
    if ([self.model.isReply isEqualToString:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"进度编辑已完成，不可添加"];
    }
    else
    {
        [LoadingManager dismiss];
        NSString *str ;
        if ([self.remarkTextView.text isEqualToString:@""]) {
            str = @"已办理完毕";
        }
        else
        {
            str = self.remarkTextView.text;
        }
        [RequestManager addProgressWithErrandId:self.model.errandId endTime:@"" remark:self.handleRemarksTextView.text errandStatus:@"CSZT01-02" successHandler:^(BOOL success) {
            [RequestManager finishWithErrandId:self.model.errandId robId:self.model.robId errandTitle:self.model.errandTitle usrId:self.model.usrId faciName:[AppUserDefaults share].userName price:self.model.price successHandler:^(BOOL success) {
                [SVProgressHUD showSuccessWithStatus:@"进度编辑完成"];
                [LoadingManager dismiss];
                if (self.fromList) {
                    [self.navigationController popToViewController:self.fromList animated:YES];
                }
            } errorHandler:^(NSError *error) {
                
            }];
        } errorHandler:^(NSError *error) {
            
        }];
    }
}

#pragma mark ---Time selector

-(UIView *)timePickerBgView
{
    if (!_timePickerBgView) {
        _timePickerBgView = [[TimePickerView alloc]initWithFrame:CGRectMake(0, self.tableView.contentSize.height, ScreenWidth, 250)];
        _timePickerBgView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _timePickerBgView.selectedTimeBlock = ^(NSString *timeStr) {
            weakSelf.finishTimeLab.text = timeStr;
        };
    }
    return _timePickerBgView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 11) {
        if (self.handleRemarksTextView.isFirstResponder) {
            [self.handleRemarksTextView resignFirstResponder];
        }
        [self.view addSubview:self.timePickerBgView];
        [self.timePickerBgView show];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.handleRemarksTextView resignFirstResponder];
    if (self.timePickerBgView.isShow) {
        [self.timePickerBgView hidden];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        self.promptLab.hidden = YES;
    }
    else
    {
        self.promptLab.hidden = NO;
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"HandlePushProgressList"]) {
        ProgressListViewController *vc = segue.destinationViewController;
        vc.model = self.model;
    }
}


@end
