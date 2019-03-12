//
//  LookOverProgressViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "LookOverProgressViewController.h"

@interface LookOverProgressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

@end

@implementation LookOverProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"办理进度";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)consultationPlatform:(id)sender {
}

@end
