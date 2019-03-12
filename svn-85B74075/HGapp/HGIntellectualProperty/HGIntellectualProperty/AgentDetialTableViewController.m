//
//  AgentDetialTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AgentDetialTableViewController.h"
#import "CommentListViewController.h"
#import "CommentTableViewCell.h"
#import "AssignAgentTableViewController.h"


@interface AgentDetialTableViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (weak, nonatomic) IBOutlet UIView *lineBgView;

@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;


@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *introductionLab;
@property (weak, nonatomic) IBOutlet UIView *domainBgView;
@property (weak, nonatomic) IBOutlet UIView *typeBgView;
@property (weak, nonatomic) IBOutlet UIView *subTypeBgView;

@property(nonatomic,strong)NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UILabel *commentTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceDesLab;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;

@property(nonatomic,strong)AgentModel *model;


@end

@implementation AgentDetialTableViewController
{
    AgentDomainModel *_seleDomainModel;
    AgentTypeModel *_seleTypeModel;
    AgentSutTypeModel *_seleSubTypeModel;
    CGFloat _totalPrice;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.headerBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBarBg"]];
    self.lineBgView.layer.borderWidth =1;
    self.lineBgView.layer.borderColor = UIColorFromRGBA(0xffffff, 0.5).CGColor;
    self.lineBgView.backgroundColor =[UIColor clearColor];
    if (self.usrId) {
        [RequestManager getAgentDetailsWithUsrId:self.usrId successHandler:^(NSDictionary *dict) {
            _model = [AgentModel new];
            _model.usrId = self.usrId;
            _model.portraitUrl = [dict objectForKey:@"portraitUrl"];
            _model.facilitatorId = [dict objectForKey:@"facilitatorId"];
            _model.facilitatorName = [dict objectForKey:@"facilitatorName"];
            _model.serveBrief = [dict objectForKey:@"serveBrief"];
            _model.provinceName = [dict objectForKey:@"provinceName"];
            _model.cityName = [dict objectForKey:@"cityName"];
            _model.queryListClassify = [MTLJSONAdapter modelsOfClass:[AgentDomainModel class] fromJSONArray:[dict objectForKey:@"classify"] error:nil];
            _model.queryListRange = [MTLJSONAdapter modelsOfClass:[AgentTypeModel class] fromJSONArray:[dict objectForKey:@"service"] error:nil];
            if ([self.model.portraitUrl isEqualToString:@""]||self.model.portraitUrl==nil) {
            }
            else
            {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:ImageURL(self.model.portraitUrl)]];
            }
            self.nickNameLab.text = self.model.facilitatorName;
            
            if ([self.model.provinceName isEqualToString:self.model.cityName]) {
                self.addressLab.text = self.model.provinceName;
            }
            else
            {
                self.addressLab.text =[NSString stringWithFormat:@"%@%@",self.model.provinceName,self.model.cityName];
            }
            if ([self.model.serveBrief isEqualToString:@""]||self.model.serveBrief == nil) {
                self.introductionLab.text = @"无简介";
            }
            else{
                self.introductionLab.text = self.model.serveBrief;
            }
            [self setDomainBgViewWithArray:self.model.queryListClassify];
            [self setTypeBgViewWithArray:self.model.queryListRange];
            [self.tableView reloadData];
            
            [self loadComment];

        } errorHandler:^(NSError *error) {
            
        }];
    }
}

-(void)loadComment
{
    [RequestManager getCommentListForTwoFaciId:self.model.usrId successHandler:^(NSNumber *total, NSArray *array) {
        self.dataArray = array;
        self.commentTitleLab.text = [NSString stringWithFormat:@"客户评价(%@)",total];
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDomainBgViewWithArray:(NSArray *)fieldArray
{
    CGRect frame = CGRectMake(0, 9, 0, 0);
    for (int i=0; i<fieldArray.count; i++) {
        AgentDomainModel *model = [fieldArray objectAtIndex:i];
        UIButton *btn = [[UIButton alloc]init];
        CGSize titleSize = [model.classifyName boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        CGFloat btnWidth = MAX(titleSize.width + 20, 80) ;
        if (frame.origin.x+frame.size.width + 20 +btnWidth +20>ScreenWidth) {
            frame = CGRectMake(0, frame.origin.y+42, 0, 0);
        }
        btn.frame = CGRectMake(frame.origin.x+20+frame.size.width, frame.origin.y, btnWidth, 30);
        [btn setBackgroundImage:[UIImage imageNamed:@"类型未选中"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"类型选中"] forState:UIControlStateSelected];
        [btn setTitle:model.classifyName forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xfe6246) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(domainTypeClcik:) forControlEvents:UIControlEventTouchUpInside];
        frame = btn.frame;
        btn.tag = 100+i;
        
        if (i==0)
        {
            btn.selected = YES;
            _seleDomainModel = model;
        }
        [self.domainBgView addSubview:btn];
    }
    self.domainBgView.frame = CGRectMake(0, 27, ScreenWidth, frame.origin.y + 30 +9);
    [self.tableView reloadData];
}
- (void)domainTypeClcik:(UIButton *)sender
{
    for (UIView *view in self.domainBgView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn == sender) {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    NSInteger tag = sender.tag - 100;
    _seleDomainModel = [self.model.queryListClassify objectAtIndex:tag];
    [self checkPrice];
}
-(void)setTypeBgViewWithArray:(NSArray *)errandClassArray
{
    CGFloat btnWidth = (ScreenWidth - 20*4)/3;
    NSInteger x = MIN(errandClassArray.count, 3);
    for (int i=0; i<x; i++) {
        AgentTypeModel *model = [errandClassArray objectAtIndex:i];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20+i*(btnWidth+20), 10, btnWidth, 30)];
        [btn setBackgroundImage:[UIImage imageNamed:@"类型未选中"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"类型选中"] forState:UIControlStateSelected];
        [btn setTitle:model.serviceTypeName forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xfe6246) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag =200+i;
        if (i==0)
            {
                btn.selected = YES;
                _seleTypeModel = model;
                [self setSubTypeBgVIewWithArray:model.typeInfo];
                if (_seleTypeModel.starService.length) {
                    NSInteger num = [[_seleTypeModel.starService substringFromIndex:_seleTypeModel.starService.length-2]integerValue];
                    [self setStarWithNum:num];
                }
                else
                {
                    [self setStarWithNum:0];
                    
                }
            }
        [self.typeBgView addSubview:btn];
        
    }
}
- (void)typeBtnClick:(UIButton *)sender {
    for (UIView *view in self.typeBgView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn == sender) {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    NSInteger tag = sender.tag - 200;
    _seleTypeModel = [self.model.queryListRange objectAtIndex:tag];
    [self checkPrice];
    if (_seleTypeModel.starService.length) {
        NSInteger num = [[_seleTypeModel.starService substringFromIndex:_seleTypeModel.starService.length-2]integerValue];
        [self setStarWithNum:num];
    }
    else
    {
        [self setStarWithNum:0];

    }
    [self setSubTypeBgVIewWithArray:_seleTypeModel.typeInfo];
}
- (void)setSubTypeBgVIewWithArray:(NSArray *)detailClassArray
{
    _seleSubTypeModel = nil;
    for (UIView *view in self.subTypeBgView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat btnWidth = (ScreenWidth - 26*4)/3;
    NSInteger x = MIN(detailClassArray.count, 6);
    for (int i=0; i<x; i++) {
        AgentSutTypeModel *model = [detailClassArray objectAtIndex:i];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(26+i%3*(btnWidth+26), 9+42*(i/3), btnWidth, 30)];
        [btn setBackgroundImage:[UIImage imageNamed:@"类型未选中"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"类型选中"] forState:UIControlStateSelected];
        [btn setTitle:model.detailTypeName forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xfe6246) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(subTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 300+i;
        
        if (i==0)
        {
            btn.selected = YES;
            _seleSubTypeModel = model;
            [self checkPrice];
        }
        
        [self.subTypeBgView addSubview:btn];
        
    }
}
- (void)subTypeBtnClick:(UIButton *)sender {
    for (UIView *view in self.subTypeBgView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn == sender) {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    NSInteger tag = sender.tag - 300;
    _seleSubTypeModel = [_seleTypeModel.typeInfo objectAtIndex:tag];
    [self checkPrice];
}


-(void)checkPrice
{
    if (_seleDomainModel&&_seleTypeModel&&_seleSubTypeModel) {
        CGFloat discount;
        if (self.isReduce) {
            discount = 0.15;
        }
        else
        {
            discount = 1.0;
        }
        _totalPrice = [_seleDomainModel.price integerValue]+[_seleSubTypeModel.price integerValue]+[_seleTypeModel.cost integerValue]*discount+[_seleTypeModel.starPrice integerValue];
        
        self.priceLab.text = [NSString stringWithFormat:@"￥%@元",@(_totalPrice)];
        if (self.isReduce) {
            CGFloat discountPrice = [_seleTypeModel.cost integerValue]*(1-discount);
            self.priceDesLab.text = [NSString stringWithFormat:@"%@+%@*15%%+%@+%@ = %@  (减缓%@)",_seleDomainModel.price,_seleTypeModel.cost,_seleTypeModel.starPrice,_seleSubTypeModel.price,@(_totalPrice),@(discountPrice)];
        }
        else
        {
            self.priceDesLab.text = [NSString stringWithFormat:@"%@+%@+%@+%@ = %@",_seleDomainModel.price,@([_seleTypeModel.cost integerValue]*discount),_seleTypeModel.starPrice,_seleSubTypeModel.price,@(_totalPrice)];
        }
        self.buyNowBtn.enabled = YES;
        self.buyNowBtn.backgroundColor = MainColor;
    }
    else
    {
        self.priceLab.text = @"￥0元";
        self.buyNowBtn.enabled = NO;
        self.buyNowBtn.backgroundColor = UIColorFromRGB(0x999999);
    }
}



-(void)setStarWithNum:(NSInteger)num
{
    switch (num) {
        case 0:
        {
            self.star1.image = [UIImage imageNamed:@"agentstar_nor"];
            self.star2.image = [UIImage imageNamed:@"agentstar_nor"];
            self.star3.image = [UIImage imageNamed:@"agentstar_nor"];
            self.star4.image = [UIImage imageNamed:@"agentstar_nor"];
            self.star5.image = [UIImage imageNamed:@"agentstar_nor"];
        }
            break;
        case 1:
        {
            self.star1.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star2.image = [UIImage imageNamed:@"agentstar_nor"];
            self.star3.image = [UIImage imageNamed:@"agentstar_nor"];
            self.star4.image = [UIImage imageNamed:@"agentstar_nor"];
            self.star5.image = [UIImage imageNamed:@"agentstar_nor"];
        }
            break;
        case 2:
        {
            self.star1.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star2.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star3.image = [UIImage imageNamed:@"agentstar_nor"];
            self.star4.image = [UIImage imageNamed:@"agentstar_nor"];
            self.star5.image = [UIImage imageNamed:@"agentstar_nor"];
        }
            break;
        case 3:
        {
            self.star1.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star2.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star3.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star4.image = [UIImage imageNamed:@"agentstar_nor"];
            self.star5.image = [UIImage imageNamed:@"agentstar_nor"];
        }
            break;
        case 4:
        {
            self.star1.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star2.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star3.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star4.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star5.image = [UIImage imageNamed:@"agentstar_nor"];
        }
            break;
        case 5:
        {
            self.star1.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star2.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star3.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star4.image = [UIImage imageNamed:@"agentstar_sel"];
            self.star5.image = [UIImage imageNamed:@"agentstar_sel"];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 7;
    }
    else
    {
        NSInteger x = MIN(2, self.dataArray.count);
        return x;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
    else
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCell"];
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            
            NSString *briefStr ;
            if ([self.model.serveBrief isEqualToString:@""]||self.model.serveBrief==nil) {
                briefStr = @"无";
            }
            else
            {
                briefStr = self.model.serveBrief;
            }
            CGSize titleSize = [briefStr  boundingRectWithSize:CGSizeMake(ScreenWidth-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            return titleSize.height +30+30;
        }
        else if (indexPath.row == 1)
        {
            CGFloat height = self.domainBgView.bounds.size.height+27;
            return height;
            
        }
        else if (indexPath.row == 2)
        {
            return 77;
        }
        else if (indexPath.row == 3)
        {
            return 117;
        }
        else if (indexPath.row == 4)
        {
            return 75;
        }
        else if (indexPath.row == 5)
        {
            return 105;
        }
        else if (indexPath.row == 6)
        {
            return 45;
        }
        return 0;
    }
    else
    {
        return 120;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AgentDetialPushCommentList"]) {
        CommentListViewController *vc = segue.destinationViewController;
        vc.model = self.model;
    }
    else if ([segue.identifier isEqualToString:@"AgentDetailPushAssign"]) {
        AssignAgentTableViewController *vc = segue.destinationViewController;
//        vc.domainModel = _seleDomainModel;
//        vc.typeModel = _seleTypeModel;
//        vc.subTypeModel = _seleSubTypeModel;
//        vc.price = _totalPrice;
//        vc.faciId = self.model.facilitatorId;
//        vc.name = self.model.facilitatorName;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)telephone:(id)sender {
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入当前使用手机号" preferredStyle:UIAlertControllerStyleAlert];
    //定义第一个输入框；
    [alertvc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入您手机号";
        textField.textAlignment = 1;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        if ([AppUserDefaults.share.phone isEqualToString:@""]||AppUserDefaults.share.phone==nil) {
            
        }
        else
        {
            textField.text = AppUserDefaults.share.phone;
        }
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *phoneTextField = alertvc.textFields.firstObject;
        if ([GGTool isMobileNumber:phoneTextField.text]) {
            [SVProgressHUD show];
            [RequestManager callDoublePhoneWithPhone:phoneTextField.text call:self.model.mobilePhone successHandler:^(BOOL success) {
                [SVProgressHUD showSuccessWithStatus:@"呼叫申请成功，请等待呼叫"];
            } errorHandler:^(NSError *error) {
                
            }];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"请输入正确手机号"];
        }
        
        
    } ];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertvc addAction:sure];
    [alertvc addAction:cancel];
    [self presentViewController:alertvc animated:YES completion:^{
        
    }];
}





@end
