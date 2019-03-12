//
//  InfoScrollTableView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/24.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "InfoScrollTableView.h"
#import "ScrollInfoTableViewCell.h"
@interface InfoScrollTableView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation InfoScrollTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = NO;
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self registerNib:[UINib nibWithNibName:@"ScrollInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ScrollInfoTableViewCell"];
    ScrollInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScrollInfoTableViewCell"];
    
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height/2;
}

@end
