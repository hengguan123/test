//
//  StretchableTableHeaderView.m
//  StretchableTableHeaderView
//

#import "HFStretchableTableHeaderView.h"

@interface HFStretchableTableHeaderView()
{
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}
@end


@implementation HFStretchableTableHeaderView

@synthesize tableView = _tableView;
@synthesize view = _view;
@synthesize subView = _subView;


- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view subView:(UIView *)subView
{
    _tableView = tableView;
    _view = view;
    _subView = subView;
    
    initialFrame       = _view.frame;
    defaultViewHeight  = initialFrame.size.height;
    
    UIView* emptyTableHeaderView = [[UIView alloc] initWithFrame:initialFrame];
    emptyTableHeaderView.backgroundColor = [UIColor redColor];
    _tableView.tableHeaderView = emptyTableHeaderView;
    
    [emptyTableHeaderView addSubview:_view];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
//    CGRect f     = _view.frame;
//    f.size.width = _tableView.frame.size.width;
//    _view.frame = f;
    if(scrollView.contentOffset.y <= 0) {
        CGFloat offsetY = scrollView.contentOffset.y * -1;
        initialFrame.origin.y = - offsetY * 1;
        initialFrame.origin.x = - offsetY / 2;
        initialFrame.size.width  = _tableView.frame.size.width + offsetY;
        initialFrame.size.height = defaultViewHeight + offsetY;
        _view.frame = initialFrame;
        _subView.frame = CGRectMake(0, 0, initialFrame.size.width, initialFrame.size.height);
    }
}

- (void)resizeView
{
//    initialFrame.size.width = _tableView.frame.size.width;
//    _view.frame = initialFrame;
}


@end
