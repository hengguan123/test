//
//  MessageDetailViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"消息详情";
    if (self.model) {
        self.titleLab.text = self.model.msgTitle;
        
        CGSize titleSize = [self.model.msgContent  boundingRectWithSize:CGSizeMake(ScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        self.contentLab.text = self.model.msgContent;
        self.contentLab.frame = CGRectMake(15, 60, ScreenWidth-30, titleSize.height);
        
        if ([self.model.readStatus isEqualToString:@"0"]) {
            [RequestManager changeMessageReadStatusWithMsgId:self.model.msgId successHandler:^(BOOL success) {
                
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
