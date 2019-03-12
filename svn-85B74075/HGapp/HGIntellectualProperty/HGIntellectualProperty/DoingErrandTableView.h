//
//  DoingErrandTableView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/8/24.
//  Copyright © 2018年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoingErrandTableView : UITableView

-(void)loadDataRefresh:(BOOL)refresh;

@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *typeCode;


@end
