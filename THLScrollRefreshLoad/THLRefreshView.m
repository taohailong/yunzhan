//
//  THLRefreshView.m
//  PushVC
//
//  Created by 陶海龙 on 15/12/3.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

#import "THLRefreshView.h"
#define SDRefreshViewObservingkeyPath @"contentOffset"

@implementation THLRefreshView
{
   __weak UIScrollView* _scrollView;
   BOOL _hasSetOriginalInsets;
   TRefreshViewStatus _refreshStatus;
   BeginRefresh _refreshBlock;
   BOOL _hasLayoutedForManuallyRefreshing;
   BOOL _hasSetFrame;
}
@synthesize textIndicator,activityView,stateIndicatorView;
//@synthesize refreshStatus;
@synthesize originalEdgeInsets;
@synthesize scrollViewEdgeInsets;
@synthesize isManuallyRefreshing;

+ (THLRefreshView*)refreshView{
    return  [[self alloc] init];
}

-(id)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if(self){
      
        self.textIndicator = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 20)];
        textIndicator.textAlignment = NSTextAlignmentCenter;
        textIndicator.backgroundColor = [UIColor clearColor];
        textIndicator.font = [UIFont systemFontOfSize:14];
        textIndicator.textColor = [UIColor lightGrayColor];
        [self addSubview:textIndicator];
        self.textIndicator.text = @"下拉刷新";
        
        
        self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activityView];
        [self.activityView startAnimating];
        
        
        
        self.stateIndicatorView = [[UIImageView alloc]init];
        stateIndicatorView.image = [UIImage imageNamed:@"THLRefeshView_arrow"];
        [self addSubview:stateIndicatorView];
        stateIndicatorView.bounds = CGRectMake(0, 0, 15, 40);

    }
    return self;
}

-(void)setBeginRefreshBlock:(BeginRefresh)block
{
    _refreshBlock = block;
}


-(void)addToScrollView:(UIScrollView*)scrollView
{
    _scrollView = scrollView;
    [_scrollView addSubview:self];
    [_scrollView addObserver:self forKeyPath:SDRefreshViewObservingkeyPath options:NSKeyValueObservingOptionNew context:nil];
//    [_scrollView addObserver:self forKeyPath:SDRefreshViewObservingDrag options:NSKeyValueObservingOptionNew context:nil];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_hasSetFrame == NO) {
        
        _hasSetFrame = YES;
        self.bounds = CGRectMake(0, 0, _scrollView.bounds.size.width, 65);
//        NSLog(@"frame is %@",NSStringFromCGRect(_scrollView.frame));
        self.scrollViewEdgeInsets = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
    }
    
    
    CGFloat height_half = self.frame.size.height/2;
    self.center = CGPointMake(self.frame.size.width/2, -height_half);
    self.activityView.center = CGPointMake(self.center.x-40, height_half);
    self.stateIndicatorView.center = CGPointMake(self.center.x-40, height_half);
    self.textIndicator.center = CGPointMake(self.center.x+20, height_half);
    
//    NSLog(@"scroll layoutsubView frame %@",NSStringFromCGRect(_scrollView.frame));
//     NSLog(@"layout subView offset %@ contented%@",NSStringFromCGPoint(_scrollView.contentOffset),NSStringFromUIEdgeInsets(_scrollView.contentInset));
    if(self.isManuallyRefreshing&&_scrollView.contentInset.top>=0&& !_hasLayoutedForManuallyRefreshing)
    {
        _hasLayoutedForManuallyRefreshing = YES;
        [self.activityView startAnimating];
        CGPoint temp = _scrollView.contentOffset;
        temp.y -= self.frame.size.height * 2;
        _scrollView.contentOffset = temp; // 触发准备刷新
        temp.y += self.frame.size.height;
        _scrollView.contentOffset = temp; // 触发刷新
    }
    else
    {
//       self.activityView.hidden = !self.isManuallyRefreshing;
    }
    
}

//-(void)didMoveToSuperview
//{
//    [super didMoveToSuperview];
////    self.bounds = CGRectMake(0, 0, _scrollView.bounds.size.width, 65);
////    NSLog(@"frame is %@",NSStringFromCGRect(_scrollView.frame));
//    self.scrollViewEdgeInsets = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
////    NSLog(NSStringFromUIEdgeInsets(_scrollView.contentInset));
//}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.superview removeObserver:self forKeyPath:SDRefreshViewObservingkeyPath];
    }
}


// 获得在scrollView的contentInset原来基础上增加一定值之后的新contentInset
- (UIEdgeInsets)syntheticalEdgeInsetsWithEdgeInsets:(UIEdgeInsets)edgeInsets
{
    return UIEdgeInsetsMake(self.originalEdgeInsets.top + edgeInsets.top, self.originalEdgeInsets.left + edgeInsets.left, self.originalEdgeInsets.bottom + edgeInsets.bottom, self.originalEdgeInsets.right + edgeInsets.right);
}


-(void)setRefreshStatus:(TRefreshViewStatus)status
{
    _refreshStatus = status;
    switch (status) {
            
        case TRefreshViewStatusNormal:
            
        {
            [UIView animateWithDuration:0.4 animations:^{
                self.stateIndicatorView.transform = CGAffineTransformMakeRotation(0);
            }];
            
            self.stateIndicatorView.hidden = NO;
            self.textIndicator.text = @"下拉刷新数据";
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
        }
            break;
        case TRefreshViewStatusRefreshing:
        {
            if (!_hasSetOriginalInsets) {
                self.originalEdgeInsets = _scrollView.contentInset;
                _hasSetOriginalInsets = YES;
//                NSLog(NSStringFromUIEdgeInsets(_scrollView.contentInset));
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                _scrollView.contentInset = [self syntheticalEdgeInsetsWithEdgeInsets:self.scrollViewEdgeInsets];
            }];

//            _scrollView.contentInset = [self syntheticalEdgeInsetsWithEdgeInsets:self.scrollViewEdgeInsets];
            self.textIndicator.text = @"正在刷新...";
            [self.activityView startAnimating];
            self.activityView.hidden = NO;
            self.stateIndicatorView.hidden = YES;
           
            if (_refreshBlock) {
                _refreshBlock();
            }
        }
            break;
            
         case TRefreshViewStatusWillRefresh:
        {
            [UIView animateWithDuration:0.4 animations:^{
                self.stateIndicatorView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            
            self.textIndicator.text = @"释放更新数据";
            self.activityView.hidden = YES;
           [self.activityView stopAnimating];
        }
            break;
            
        default:
            break;
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
//    if ([keyPath isEqualToString:SDRefreshViewObservingDrag]) {
//        NSLog(@"content off %f  isdrag %d",_scrollView.contentOffset.y,_scrollView.dragging);
//        return;
//    }
    
    if (![keyPath isEqualToString:SDRefreshViewObservingkeyPath]||_refreshStatus == TRefreshViewStatusRefreshing) {
        return;
    }

    CGFloat y =  [change[@"new"] CGPointValue].y;
    if (y>0 || _scrollView.bounds.size.height == 0) {
        return;
    }
    
    CGFloat criticalY = -_scrollView.contentInset.top - self.frame.size.height;
//    NSLog(@"content off %f  criticalY%f dragging%d",y,criticalY,_scrollView.dragging);
    
//这里加10 因为 scrollview dragging 松开时 offset不能准确得到， 会有大概10point的延迟，拉伸越大，反弹时速度越快，捕获offset时 误差越大
    if(y<=criticalY+10&&(_refreshStatus == TRefreshViewStatusWillRefresh)&&!_scrollView.dragging)
    {
        [self setRefreshStatus:TRefreshViewStatusRefreshing];
        return;
    }
    
    if(y<criticalY&&_refreshStatus == TRefreshViewStatusNormal){
    
//        self.refreshStatus = TRefreshViewStatusWillRefresh;
        [self setRefreshStatus:TRefreshViewStatusWillRefresh];
        return;
    }
    
    if (y>criticalY&&(_refreshStatus != TRefreshViewStatusNormal )) {
        [self setRefreshStatus:TRefreshViewStatusNormal];
    }
}


-(void)endRefreshing{

    [UIView animateWithDuration:0.4 animations:^{
        _scrollView.contentInset = self.originalEdgeInsets;
        
    } completion:^(BOOL finished) {

        [self setRefreshStatus:TRefreshViewStatusNormal];
        if (self.isManuallyRefreshing) {
//            _scrollView.contentOffset = CGPointMake(0, 0);
            self.isManuallyRefreshing = NO;
        }
    }];

}

@end
