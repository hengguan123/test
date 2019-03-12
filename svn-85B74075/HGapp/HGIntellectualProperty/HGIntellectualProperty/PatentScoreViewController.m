//
//  PatentScoreViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/14.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentScoreViewController.h"
#import "PatentScoreModel.h"
#import "PatentScoreTableViewCell.h"
#import "RingProgressView.h"


@interface PatentScoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSDictionary *dict;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)NSArray *dataArray;


@property (weak, nonatomic) IBOutlet UILabel *totalScoreLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *applyPerson;
@property (weak, nonatomic) IBOutlet UILabel *patentID;

@property (weak, nonatomic) IBOutlet UILabel *dclnLab;
@property (weak, nonatomic) IBOutlet UILabel *deciLab;

@property (weak, nonatomic) IBOutlet UILabel *iclnLab;
@property (weak, nonatomic) IBOutlet UILabel *incoLab;
@property (weak, nonatomic) IBOutlet UILabel *invaLab;
@property (weak, nonatomic) IBOutlet UILabel *oppoLab;
@property (weak, nonatomic) IBOutlet UILabel *reexLab;
@property (weak, nonatomic) IBOutlet UILabel *tclnLab;
@property (weak, nonatomic) IBOutlet UILabel *verdLab;


@property (strong, nonatomic) RingProgressView *ringView;


@end

@implementation PatentScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" font:13 target:self action:@selector(share:)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PatentScoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatentScoreTableViewCell"];
    self.titleLab.text = self.model.TITLE;
    CGSize titleSize = [self.model.TITLE  boundingRectWithSize:CGSizeMake(ScreenWidth-85, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    self.titleLab.frame = CGRectMake(70, 14, ScreenWidth-85, titleSize.height);
    self.applyPerson.text = self.model.AN;
    self.patentID.text = self.model.APN;
    
    [self.totalScoreLab addSubview:self.ringView];
    
    [self loadData];
    
}

-(RingProgressView *)ringView
{
    if (!_ringView) {
        _ringView = [[RingProgressView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        _ringView.foregroundColor = [UIColor colorWithHue:0.02 saturation:0.69 brightness:0.98 alpha:1.00];
        _ringView.ringColor = [UIColor colorWithHue:0.02 saturation:0.41 brightness:0.94 alpha:1.00];
        _ringView.backgroundColor = UIColorFromRGBA(0x0000ff, 0);
        
    }
    return _ringView;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData
{
    [LoadingManager show];
    [RequestManager getPatentScoreWithPN:self.model.PN successHandler:^(NSDictionary *dict) {
        self.dict = dict;
        [LoadingManager dismiss];
    } errorHandler:^(NSError *error) {
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}
-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    NSDictionary *numDict = [dict objectForKey:@"indexInfo"];
    if (numDict) {
        self.dclnLab.text = [NSString stringWithFormat:@"%@",[numDict objectForKey:@"dcln"]];
        self.deciLab.text = [NSString stringWithFormat:@"%@",[numDict objectForKey:@"deci"]];
        self.iclnLab.text = [NSString stringWithFormat:@"%@",[numDict objectForKey:@"icln"]];
        self.incoLab.text = [NSString stringWithFormat:@"%@",[numDict objectForKey:@"inco"]];
        self.invaLab.text = [NSString stringWithFormat:@"%@",[numDict objectForKey:@"inva"]];
        self.oppoLab.text = [NSString stringWithFormat:@"%@",[numDict objectForKey:@"oppo"]];
        self.reexLab.text = [NSString stringWithFormat:@"%@",[numDict objectForKey:@"reex"]];
        self.tclnLab.text = [NSString stringWithFormat:@"%@",[numDict objectForKey:@"tcln"]];
        self.verdLab.text = [NSString stringWithFormat:@"%@",[numDict objectForKey:@"verd"]];
    }
    self.totalScoreLab.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"score"] doubleValue]];
    
    [self.ringView setProgress:[[dict objectForKey:@"score"] doubleValue]/100];
    
    self.dataArray = [MTLJSONAdapter modelsOfClass:[PatentScoreModel class] fromJSONArray:[dict objectForKey:@"dataList"] error:nil];
    [self.tableView reloadData];
    
}


-(UIImage *)getTableViewimage{
    UIImage* viewImage = nil; UITableView *scrollView = self.tableView;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0); { CGPoint savedContentOffset = scrollView.contentOffset; CGRect savedFrame = scrollView.frame; scrollView.contentOffset = CGPointZero; scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height); [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()]; viewImage = UIGraphicsGetImageFromCurrentImageContext(); scrollView.contentOffset = savedContentOffset; scrollView.frame = savedFrame; } UIGraphicsEndImageContext(); return viewImage;
}



- (IBAction)share:(id)sender {
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
    }];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"我的专利评分高达%.2f分",[[self.dict objectForKey:@"score"] doubleValue]] descr:self.model.TITLE thumImage:[UIImage imageNamed:@"share评分"]];
//    设置网页地址·
    NSString *url = [NSString stringWithFormat:@"%@/patent/gradeCore?AN=%@&APN=%@&patentName=%@&PN=%@",HTTPURL,self.model.AN,self.model.APN,self.model.TITLE,self.model.PN];
    shareObject.webpageUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    
    
//    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = [UIImage imageNamed:@"logoImage"];
//    [shareObject setShareImage:[self getTableViewimage]];
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

#pragma mark tableView

-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 250)];
        _headerView.backgroundColor = MainColor;
    }
    return _headerView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataArray.count) {
        return 1;
    }
    else
        return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatentScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatentScoreTableViewCell"];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatentScoreModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.texts.count>4) {
        return 180+(model.texts.count-4)*30;
    }
    else
    {
        return 180;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{ 
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    lab.textAlignment = 1;
    lab.text = @"评估维度详情";
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = MainColor;
    lab.backgroundColor = [UIColor whiteColor];
    return lab;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
