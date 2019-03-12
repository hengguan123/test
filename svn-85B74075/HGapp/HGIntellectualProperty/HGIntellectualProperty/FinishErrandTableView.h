//
//  FinishErrandTableView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/8/24.
//  Copyright © 2018年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishErrandTableView : UITableView

-(void)loadDataRefresh:(BOOL)refresh;

@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *typeCode;

@end
