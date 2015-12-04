//
//  THLScrollLoadView.m
//  PushVC
//
//  Created by 陶海龙 on 15/12/4.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

#import "THLScrollLoadView.h"
#define SDLoadingViewObservingkeyPath @"contentOffset"
#define LoadHeight 45
@implementation THLScrollLoadView
{
    
    UILabel* _statusLabel;
    UIActivityIndicatorView* _activityView;
    __weak UIScrollView* _scrollView;
    ScrollLoadStatus _scrollStatus;
    ScrollLoadBegin _beginLoadedBlock;
    UIEdgeInsets _originalInset;
    CGFloat _originalScrollViewContentHeight;
    BOOL _isSetOriginalContentInset;
    BOOL _isStoped;
}


+(id)scrollLoadingView
{
    return [[self alloc]init];
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollStatus = ScrollLoadStatusNormal;
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
        _statusLabel.text = @"加载更多...";
        _statusLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:108.0/255.0 blue:113.0/255.0 alpha:1.0];
        _statusLabel.font = [UIFont systemFontOfSize:15.0];
        _statusLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_statusLabel];
        
        
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];
        [_activityView startAnimating];
    }
    return self;
}

-(void)setBeginLoadBlock:(ScrollLoadBegin)block
{
    if (block) {
        _beginLoadedBlock = block;
    }
}


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.superview removeObserver:self forKeyPath:SDLoadingViewObservingkeyPath];
    }
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.bounds = CGRectMake(0, 0, _scrollView.frame.size.width, LoadHeight);
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_scrollView.contentSize.height<=_scrollView.frame.size.height) {
        self.hidden = YES;
        return;
    }

    
    self.center = CGPointMake(self.frame.size.width/2, _scrollView.contentSize.height+self.frame.size.height/2);
    _statusLabel.center = CGPointMake(self.frame.size.width/2+25, self.frame.size.height/2);
    _activityView.center = CGPointMake(self.frame.size.width/2-30, self.frame.size.height/2);
    _originalScrollViewContentHeight = _scrollView.contentSize.height;
    
}

-(void)addToScrollView:(UIScrollView*)scrollView
{
    _scrollView = scrollView;
    [_scrollView addSubview:self];
    [_scrollView addObserver:self forKeyPath:SDLoadingViewObservingkeyPath options:NSKeyValueObservingOptionNew context:nil];
    //    [_scrollView addObserver:self forKeyPath:SDRefreshViewObservingDrag options:NSKeyValueObservingOptionNew context:nil];
}

-(void)endScrollLoadingStatus
{
    _scrollView.contentInset = _originalInset;
    _scrollStatus = ScrollLoadStatusNormal;
    self.hidden = YES;
}


-(void)removeScrollLoading
{
    self.hidden = YES;
    _isStoped = YES;
}


-(void)recoverLoadingStatue
{
    self.hidden = NO;
    _isStoped = NO;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:SDLoadingViewObservingkeyPath]||_scrollStatus == ScrollLoadStatusLoading||_isStoped == YES) {
        return;
    }
    

    CGFloat offset_y = [change[@"new"] CGPointValue].y;
    if ((offset_y <= 0) || (_scrollView.bounds.size.height - _scrollView.contentSize.height >= 0)) return;//当不满一屏幕时
    
    
//    更新 self loadview 位置
    if (_scrollView.contentSize.height != _originalScrollViewContentHeight) {
        [self setNeedsLayout];
    }

    
    CGRect bounds = _scrollView.bounds;
    CGSize size = _scrollView.contentSize;
    UIEdgeInsets inset = _scrollView.contentInset;
    float y =  bounds.size.height - inset.bottom;
    float h = size.height;
    
//    NSLog(@"h-offset is %lf",h-offset_y-y);
    if(h - offset_y -y < self.frame.size.height)
    {
//        首次设置scrollcontentInset
        if (_isSetOriginalContentInset == NO) {
            _originalInset = _scrollView.contentInset;
            _isSetOriginalContentInset = YES;
        }
        
        self.hidden = NO;
        
        _scrollStatus = ScrollLoadStatusLoading;
        _scrollView.contentInset = UIEdgeInsetsMake(_originalInset.top, _originalInset.left, _originalInset.bottom+self.frame.size.height, _originalInset.right);
        
        if (_beginLoadedBlock) {
            _beginLoadedBlock();
        }
    }

    
//    CGFloat criticalY = -self.sd_height - self.scrollView.contentInset.top;

}

@end
