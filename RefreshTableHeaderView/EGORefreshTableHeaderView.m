//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
//#define PUSHLENTH -75.0

@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView
//@synthesize scrollEdge;
//@synthesize delegate=_delegate;

-(void)setScrollEdge:(UIEdgeInsets)scrollEdge
{
    _scrollEdge = scrollEdge;
//    OFFY = OFFY+scrollEdge.top;
//    PUSHLENTH = PUSHLENTH-scrollEdge.top;
}

-(UIEdgeInsets)scrollEdge
{
    return _scrollEdge;
}

-(void)setRefreshStyle:(RefreshStyle)style
{
    switch (style) {
        case RefreshInset64:
           
            PUSHLENTH =-139.0;
            break;
        case RefreshInsetNormal:
           
            PUSHLENTH =-65.0;
            break;
        default:
            break;
    }
}




-(void)setDelegate:(id<EGORefreshTableHeaderDelegate>)delegate
{
    
    _delegate = delegate;
}

-(id<EGORefreshTableHeaderDelegate>)delegate
{
    return _delegate;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
		
//        OFFY = 0.0;
        PUSHLENTH =-65.0;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
//        self.backgroundColor = [UIColor yellowColor];
//		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
//		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		label.font = [UIFont systemFontOfSize:12.0f];
//		label.textColor = TEXT_COLOR;
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//		label.backgroundColor = [UIColor clearColor];
//		label.textAlignment = NSTextAlignmentCenter;
//		[self addSubview:label];
//		_lastUpdatedLabel=label;
		
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-5, frame.size.height - 43.0f, 70, 20.0f)];
//		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
//		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(frame.size.width/2-30, frame.size.height - 55.0f, 15.0f, 40);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"refreshArrow"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(frame.size.width/2-30, frame.size.height - 43.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}





#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate
{
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
//		_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"Last Updated", nil),[formatter stringFromDate:date]];
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新时间:%@",[formatter stringFromDate:date]];
        
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		
	} else {
		
		NSDate *date = [NSDate date];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新时间:%@",[formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	}

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
//			_statusLabel.text = NSLocalizedString(@"Release to refresh...",nil);
            _statusLabel.text = @"释放加载...";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//            arrowImageV.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
//                arrowImageV.layer.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
//			_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", nil);
            _statusLabel.text = @"下拉刷新...";
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
//            arrowImageV.hidden = NO;
//            arrowImageV.layer.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
            
//			_statusLabel.text = NSLocalizedString(@"Loading...", @"加载...");
            _statusLabel.text = @"加载...";
			[_activityView startAnimating];
            
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
//    NSLog(@"y %f %f",scrollView.contentOffset.y,65+self.scrollEdge.top);
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
//		offset = MIN(offset, 60);
        if (offset < 65+self.scrollEdge.top)
        {
//            [UIView animateWithDuration:20 animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(self.scrollEdge.top+65, scrollView.contentInset.left, self.scrollEdge.bottom, scrollView.contentInset.right);
                [scrollView setContentOffset:CGPointMake(0.0f, PUSHLENTH-self.scrollEdge.top)];
//            }];
        }
        
//		scrollView.contentInset = UIEdgeInsetsMake(offset+OFFY, 0.0f, 48.0f, 0.0f);
//        scrollView.contentInset = UIEdgeInsetsMake(self.scrollEdge.top+offset, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
		
	} else if (scrollView.isDragging)
    {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > PUSHLENTH - self.scrollEdge.top&& scrollView.contentOffset.y < -self.scrollEdge.top && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < PUSHLENTH-self.scrollEdge.top && !_loading) {
            
			[self setState:EGOOPullRefreshPulling];
		}
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
    
	if (scrollView.contentOffset.y <= PUSHLENTH-self.scrollEdge.top && !_loading)
    {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)])
        {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
//        CGFloat lenth = PUSHLENTH - scrollView.contentOffset.y;
//        float time = lenth / 500.0;
//        time = 80;
//        NSLog(@"time %f",time);
        
//		[UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [self setState:EGOOPullRefreshLoading];
//        [scrollView setContentOffset:CGPointMake(0.0f, -129)];
//        [scrollView setContentOffset:CGPointMake(0.0f, PUSHLENTH-self.scrollEdge.top)];
//
////        scrollView.contentInset = UIEdgeInsetsMake(self.scrollEdge.top - PUSHLENTH, scrollView.contentInset.left, self.scrollEdge.bottom, scrollView.contentInset.right);
//        [UIView setAnimationDuration:time];
//        [UIView commitAnimations];
		
	}
	
}


-(void)refreshBegin:(UIScrollView*)scrollView
{
    
    if(scrollView == nil)
    {
        return;
    }
    if(_state == EGOOPullRefreshNormal){
       
        [self setState:EGOOPullRefreshLoading];//放在动画前面
        [UIView animateWithDuration:20 animations:^{
            
            scrollView.contentInset = UIEdgeInsetsMake(-PUSHLENTH, self.scrollEdge.left, self.scrollEdge.bottom, self.scrollEdge.right);
//            [scrollView setContentOffset:CGPointMake(-0.0f, PUSHLENTH)];
        } completion:^(BOOL finished) {
            
        }];
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)])
        {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }

    }

}

-(void)egoRefreshScrollViewDataSourceDidBeginLoading:(UIScrollView *)scrollView
{
    [self setState:EGOOPullRefreshLoading];//放在动画前面
    [UIView animateWithDuration:.2 animations:^{
        
        scrollView.contentInset = UIEdgeInsetsMake(-PUSHLENTH, self.scrollEdge.left, self.scrollEdge.bottom, self.scrollEdge.right);
//        [scrollView setContentOffset:CGPointMake(0.0f, PUSHLENTH)];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
//    return;
//	NSLog(@"content is %@",NSStringFromUIEdgeInsets(scrollView.contentInset));
    [self setState:EGOOPullRefreshNormal];//放在动画前面
//    scrollView.contentInset = self.scrollEdge;

    [UIView animateWithDuration:.35 animations:^{
        
        scrollView.contentInset = self.scrollEdge;
//         scrollView.contentInset = UIEdgeInsetsMake(self.scrollEdge., scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
    } completion:^(BOOL finished) {
//       NSLog(@"content is %@ original %@",NSStringFromUIEdgeInsets(scrollView.contentInset),NSStringFromUIEdgeInsets(self.scrollEdge));
    }];
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:.3];
//    scrollView.contentInset = self.scrollEdge;
//	[UIView commitAnimations];
   
	

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}


@end
