//
//  PublishErrandTableViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OtherWorkModel;
@interface PublishErrandTableViewController : UITableViewController

@property(nonatomic,strong)ErrandModel *model;
@property(nonatomic,strong)UIViewController *fromList;

@property(nonatomic,assign)NSInteger sel1;
@property(nonatomic,assign)NSInteger sel2;

@property(nonatomic,copy)NSString *typeCode;
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *subTypeName;
@property(nonatomic,copy)NSString *subTypeCode;

@property(nonatomic,strong)OtherWorkModel *selOtherModel1;
@property(nonatomic,strong)OtherWorkModel *selOtherModel2;
@property(nonatomic,strong)OtherWorkModel *selOtherModel3;

@end
