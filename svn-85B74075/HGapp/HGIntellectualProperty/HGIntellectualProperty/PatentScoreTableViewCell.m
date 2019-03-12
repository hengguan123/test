//
//  PatentScoreTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentScoreTableViewCell.h"
#import "ScoreContentTableViewCell.h"
#import "RingProgressView.h"
@interface PatentScoreTableViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *conBgView;
@property (weak, nonatomic) IBOutlet UILabel *scoreTypeLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSArray *colorArray;

@property (strong, nonatomic)RingProgressView *ringView;

@property (nonatomic,strong)NSArray *aniColorArray;

@end

@implementation PatentScoreTableViewCell

- (void)setModel:(PatentScoreModel *)model
{
    _model = model;
    self.titleLab.text = model.title;
    if ([model.title isEqualToString:@"专利稳定性"]) {
        self.scoreTypeLab.text = @"稳定性评分";
    }
    else if ([model.title isEqualToString:@"专利保护范围"])
    {
        self.scoreTypeLab.text = @"范围评分";
    }
    else if ([model.title isEqualToString:@"专利技术质量"])
    {
        self.scoreTypeLab.text = @"质量评分";
    }
    else if ([model.title isEqualToString:@"专利技术应用性"])
    {
        self.scoreTypeLab.text = @"应用评分";
    }
    else{
        self.scoreTypeLab.text = @"评分";
    }
    self.scoreLab.text = [NSString stringWithFormat:@"%.2f",[model.score floatValue]];
    
    UIColor *color = [self.colorArray objectAtIndex:([model.num integerValue]-1)%4];
    
    if (color) {
        self.scoreLab.textColor = color;
        self.scoreTypeLab.textColor = color;
    }
    [self.scoreLab addSubview:self.ringView];
    self.ringView.foregroundColor = color;
    self.ringView.ringColor = [self.aniColorArray objectAtIndex:([model.num integerValue]-1)%4];
    self.ringView.model = model;
    [self.ringView setProgress:[model.score doubleValue]/100];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.texts.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ScoreContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"ScoreContentTableViewCell"];
    ScoreContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreContentTableViewCell"];
    cell.contentStr = [self.model.texts objectAtIndex:indexPath.row];
    return cell;
}

-(NSArray *)colorArray
{
    if (!_colorArray) {
        _colorArray = @[[UIColor colorWithHue:0.12 saturation:0.82 brightness:0.99 alpha:1.00],[UIColor colorWithHue:0.42 saturation:0.85 brightness:0.67 alpha:1.00],[UIColor colorWithHue:0.69 saturation:0.55 brightness:0.62 alpha:1.00],[UIColor colorWithHue:0.32 saturation:0.60 brightness:0.76 alpha:1.00]];
    }
    return _colorArray;
}

-(NSArray *)aniColorArray
{
    if (!_aniColorArray) {
        _aniColorArray = @[[UIColor colorWithHue:0.11 saturation:0.74 brightness:0.85 alpha:1.00],[UIColor colorWithHue:0.46 saturation:0.35 brightness:0.80 alpha:1.00],[UIColor colorWithHue:0.72 saturation:0.12 brightness:0.76 alpha:1.00],[UIColor colorWithHue:0.31 saturation:0.17 brightness:0.88 alpha:1.00]];
    }
    return _aniColorArray;
}

-(RingProgressView *)ringView
{
    if (!_ringView) {
        _ringView = [[RingProgressView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        _ringView.backgroundColor = UIColorFromRGBA(0x0000ff, 0);
    }
    return _ringView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
