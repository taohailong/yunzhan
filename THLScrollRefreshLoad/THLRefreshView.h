//
//  THLRefreshView.h
//  PushVC
//
//  Created by 陶海龙 on 15/12/3.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  TRefreshViewStatusWillRefresh,
  TRefreshViewStatusRefreshing,
  TRefreshViewStatusNormal
}TRefreshViewStatus;
typedef void(^BeginRefresh)(void);

@interface THLRefreshView : UIView

+(THLRefreshView*)refreshView;
-(void)addToScrollView:(UIScrollView*)scrollView;
-(void)setBeginRefreshBlock:(BeginRefresh)block;

-(void)endRefreshing;
@property(nonatomic,strong)UIImageView* stateIndicatorView;
@property(nonatomic,strong)UIActivityIndicatorView* activityView;
@property(nonatomic,strong)UILabel* textIndicator;
//@property(nonatomic,assign)TRefreshViewStatus refreshStatus;
@property (nonatomic, assign) UIEdgeInsets originalEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets scrollViewEdgeInsets;
@property (nonatomic, assign) BOOL isManuallyRefreshing;
@end
