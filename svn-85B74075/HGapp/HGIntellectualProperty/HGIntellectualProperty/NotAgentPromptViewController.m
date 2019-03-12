//
//  NotAgentPromptViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/9.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "NotAgentPromptViewController.h"

@interface NotAgentPromptViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLab1;
@property (weak, nonatomic) IBOutlet UILabel *infoLab2;

@end

@implementation NotAgentPromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    NSArray *infoArray = [self.infoStr componentsSeparatedByString:@","];
    self.infoLab1.text = infoArray.firstObject;
    self.infoLab2.text = infoArray.lastObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view removeFromSuperview];
}
- (IBAction)sure:(id)sender {
    if (self.block) {
        self.block();
        [self.view removeFromSuperview];
    }
}

@end
