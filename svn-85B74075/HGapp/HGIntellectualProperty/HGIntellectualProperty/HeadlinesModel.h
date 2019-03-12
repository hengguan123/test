//
//  HeadlinesModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeadlinesModel :NSObject

//@property(nonatomic,copy)NSString *Name;
@property(nonatomic,strong)NSNumber *articleId;
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSString *pubDate;
@property(nonatomic,copy)NSString *pubOrg;
@property(nonatomic,copy)NSString *source;
@property(nonatomic,copy)NSString *sourceUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *isWebsite;
@property(nonatomic,copy)NSString *downloadUrl;

@end
