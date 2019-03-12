//
//  CopyrightDetailsViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/24.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CopyrightDetailsViewController.h"
#import "SearchResultViewController.h"


@interface CopyrightDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *owerLab;
@property (weak, nonatomic) IBOutlet UILabel *regIdLab;
@property (weak, nonatomic) IBOutlet UILabel *info1Lab;
@property (weak, nonatomic) IBOutlet UILabel *info2Lab;
@property (weak, nonatomic) IBOutlet UILabel *info3Lab;
@property (weak, nonatomic) IBOutlet UILabel *detailTypeLab;

@end

@implementation CopyrightDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"版权详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    if (self.softModel) {
        self.typeLab.text = @"软件著作权";
        self.nameLab.text = self.softModel.name;
        self.owerLab.text = self.softModel.owner;
        self.regIdLab.text = self.softModel.number;
        self.info1Lab.text = self.softModel.recordDate;
        self.detailTypeLab.text = @"状态";
        self.info2Lab.text = self.softModel.postDate;
    }
    if (self.worksModel) {
        self.typeLab.text = @"作品著作权";
        self.nameLab.text = self.worksModel.name;
        self.owerLab.text = self.worksModel.owner;
        self.regIdLab.text = self.worksModel.number;
        self.info1Lab.text = self.worksModel.date;
        self.detailTypeLab.text = @"类型";
        self.info2Lab.text = self.worksModel.category;
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
//    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SearchResultViewController *vc = [main instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
//    vc.searchStr = self.model.owner;
//    vc.type = HotSearchViewTypeAll;
//    [self.navigationController pushViewController:vc animated:YES];
}


@end
