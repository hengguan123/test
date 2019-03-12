//
//  CompanyCopyrightViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CompanyCopyrightViewController.h"
#import "Copyright1ViewController.h"
#import "Copyright2ViewController.h"


@interface CompanyCopyrightViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBgView;

@property (nonatomic,strong)Copyright1ViewController *vc1;
@property (nonatomic,strong)Copyright2ViewController *vc2;
@property (nonatomic,assign)NSInteger resultCount;
@property (nonatomic,assign)NSInteger resulttype;



@end

@implementation CompanyCopyrightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.companyName;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    [self.scrollBgView addSubview:self.vc1.view];
    [self.scrollBgView addSubview:self.vc2.view];
    [self.vc1 searchWithSearchStr:self.companyName type:3];
    [self.vc2 searchWithSearchStr:self.companyName type:3];

}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(Copyright1ViewController *)vc1
{
    if (!_vc1) {
        _vc1 = [[Copyright1ViewController alloc]initWithNibName:@"Copyright1ViewController" bundle:nil];
        [self addChildViewController:_vc1];
        _vc1.view.frame = self.scrollBgView.bounds;
        __weak typeof(self) weakSelf = self;
        _vc1.numBlock = ^(NSNumber *num) {
            [weakSelf.btn1 setTitle:[NSString stringWithFormat:@"软件著作权(%@)",num] forState:UIControlStateNormal];
            [weakSelf getResultConut:num withType:1];
        };
    }
    return _vc1;
}
-(Copyright2ViewController *)vc2
{
    if (!_vc2) {
        _vc2 = [[Copyright2ViewController alloc]initWithNibName:@"Copyright2ViewController" bundle:nil];
        [self addChildViewController:_vc2];
        _vc2.view.frame = CGRectMake(ScreenWidth, 0, self.scrollBgView.bounds.size.width, self.scrollBgView.bounds.size.height);
        __weak typeof(self) weakSelf = self;
        _vc2.numBlock = ^(NSNumber *num) {
            [weakSelf.btn2 setTitle:[NSString stringWithFormat:@"作品著作权(%@)",num] forState:UIControlStateNormal];
            [weakSelf getResultConut:num withType:2];
        };
    }
    return _vc2;
}
-(void)getResultConut:(NSNumber *)num withType:(NSInteger )type
{
    if (self.resulttype == 1) {
        if (type == 1) {
            
        }
        else
        {
            if (self.resultCount>0) {
                
            }
            else
            {
                [self btnClick:self.btn2];
            }
        }
    }
    else if (self.resulttype == 2)
    {
        if (type==1) {
            if ([num integerValue]>0) {
                [self btnClick:self.btn1];
            }
        }
    }
    self.resultCount = [num integerValue];
    self.resulttype = type;
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender == self.btn1) {
        self.btn1.selected = YES;
        self.btn2.selected = NO;
        [self.scrollBgView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        [self.scrollBgView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.center = CGPointMake(sender.center.x, self.lineView.center.y);
    }];
}

@end
