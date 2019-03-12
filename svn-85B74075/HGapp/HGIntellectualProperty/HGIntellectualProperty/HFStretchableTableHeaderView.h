//
//  StretchableTableHeaderView.h
//  StretchableTableHeaderView
//

#import <Foundation/Foundation.h>

@interface HFStretchableTableHeaderView : NSObject

@property (nonatomic,retain) UITableView* tableView;
@property (nonatomic,retain) UIView* view;
@property (nonatomic,retain) UIView* subView;


- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view subView:(UIView *)subView;
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
- (void)resizeView;

@end
