//
//  AssociateView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/24.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AssociateView.h"

@interface AssociateView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataArray;

@end


@implementation AssociateView
{
    UIView *_presentView;
    UITableView *_tableView;
    NSInteger _type;
    NSString *_str;
    NSURLSessionDataTask *_task;
    BOOL _isCompanyName;
}
-(instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type presentView:(UIView *)view
{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        _presentView = view;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-30) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self addSubview:_tableView];
        
        UIButton *cloce = [[UIButton alloc]initWithFrame:CGRectMake(0, frame.size.height-30, ScreenWidth, 30)];
        cloce.backgroundColor = [UIColor whiteColor];
        [cloce setTitle:@"关闭" forState:UIControlStateNormal];
        cloce.titleLabel.font = [UIFont systemFontOfSize:14];
        [cloce setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [cloce addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cloce];
    }
    return self;
}
-(void)close
{
    [self removeFromSuperview];
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssociateViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AssociateView"];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.preservesSuperviewLayoutMargins = NO;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    if (_type == 2) {
        if (_isCompanyName) {
            NSString *name = [self.dataArray objectAtIndex:indexPath.row];
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:name];
            [attrStr
             addAttribute:NSForegroundColorAttributeName value:MainColor range:[name rangeOfString:_str]];
            cell.textLabel.attributedText = attrStr;

        }
        else
        {
            PatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:model.TITLE];
            [attrStr
             addAttribute:NSForegroundColorAttributeName value:MainColor range:[model.TITLE rangeOfString:_str]];
            cell.textLabel.attributedText = attrStr;
        }
        
    }
    else if (_type == 1)
    {
        SearchAllModel *model = [self.dataArray objectAtIndex:indexPath.row];
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:model.companyName];
        [attrStr
         addAttribute:NSForegroundColorAttributeName value:MainColor range:[model.companyName rangeOfString:_str]];
        cell.textLabel.attributedText = attrStr;
    }
    else if (_type == 4)
    {
        CopyrightModel *model = [self.dataArray objectAtIndex:indexPath.row];
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:model.copyrightName];
        [attrStr
         addAttribute:NSForegroundColorAttributeName value:MainColor range:[model.copyrightName rangeOfString:_str]];
        cell.textLabel.attributedText = attrStr;
    }
    else if (_type == 6)
    {
        if (self.isHotSearch) {
            HotSearchModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.textLabel.text = model.keyword;
        }
        else
        {
            PatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:model.TITLE];
            [attrStr
             addAttribute:NSForegroundColorAttributeName value:MainColor range:[model.TITLE rangeOfString:_str]];
            cell.textLabel.attributedText = attrStr;
        }
    }
    return cell;
}

-(void)searchStrChange:(NSString *)str
{
    [_task cancel];
    _str = str;
    if (_type==2 ) {
        _task=[RequestManager searchPatentWithTITLE:str pageNo:1 anAdd:@"" country:@"CHN" pkind:@"" PBD:@"" IPC1:@"" ISVALID:@"" successHandler:^(BOOL isLast, NSArray *array,NSNumber *total) {
            _isCompanyName = NO;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [_tableView reloadData];
            if (self.dataArray.count) {
                [_presentView addSubview:self];
            }
            else
            {
                [[RequestManager new] searchCompanyWithCompany:str successHandler:^(NSArray *array) {
                    _isCompanyName = YES;
                    [self.dataArray removeAllObjects];
                    [self.dataArray addObjectsFromArray:array];
                    [_tableView reloadData];
                    if (self.dataArray.count) {
                        [_presentView addSubview:self];
                    }
                } errorHandler:^(NSError *error) {
                    
                }];
            }
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else if (_type==1)
    {
        _task = [RequestManager searchAllWithKeyword:str anAdd:@"" country:@"CHN" successHandler:^(NSArray *array) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [_tableView reloadData];
            if (self.dataArray.count) {
                [_presentView addSubview:self];
            }
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else if (_type ==6)
    {
        if (self.isHotSearch) {
            
        }
        else
        {
            _task=[RequestManager searchPatentWithTITLE:str pageNo:1 anAdd:@"" country:@"CHN" pkind:@"" PBD:@"" IPC1:@"" ISVALID:@"" successHandler:^(BOOL isLast, NSArray *array,NSNumber *total) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:array];
                [_tableView reloadData];
                if (self.dataArray.count) {
                    [_presentView addSubview:self];
                }
                else
                {
                    [self removeFromSuperview];
                }
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type ==2) {
        if (_isCompanyName) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(associateView:didSelectedCompanyName:)]) {
                [self.delegate associateView:self didSelectedCompanyName:[self.dataArray objectAtIndex:indexPath.row]];
                [self removeFromSuperview];
            }
        }
        else
        {
            PatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [self selKeyStr:model.TITLE];
        }
    }
    else if (_type ==1)
    {
        SearchAllModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [self selKeyStr: model.companyName];
    }
    else if (_type ==4)
    {
        CopyrightModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [self selKeyStr:model.copyrightName ];
    }
    else if (_type ==6)
    {
        if (self.isHotSearch) {
            HotSearchModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [self selKeyStr:model.keyword];
        }
        else
        {
            PatentModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [self selKeyStr:model.TITLE];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(duringScrolling)]) {
        [self.delegate duringScrolling];
    }
}

-(void)selKeyStr:(NSString *)keyStr
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(associateView:didSelectedKeyStr:)]) {
        [self.delegate associateView:self didSelectedKeyStr:keyStr];
    }
    [self removeFromSuperview];

}

-(void)setHotArray:(NSArray *)hotArray
{
    _hotArray = hotArray ;
    
}
-(void)setHotSearch:(BOOL)hotSearch
{
    _hotSearch = hotSearch;
    if (hotSearch) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:self.hotArray];
        [_tableView reloadData];
        if (self.dataArray.count) {
            [_presentView addSubview:self];
        }
    }
    else
    {
//        [self removeFromSuperview];
    }
}

@end
