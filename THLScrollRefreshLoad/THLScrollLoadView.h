//
//  THLScrollLoadView.h
//  PushVC
//
//  Created by 陶海龙 on 15/12/4.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ScrollLoadBegin)(void);
typedef enum ScrollLoadStatus{
    ScrollLoadStatusNormal,
   ScrollLoadStatusLoading
}ScrollLoadStatus;
@interface THLScrollLoadView : UIView
-(void)setBeginLoadBlock:(ScrollLoadBegin)block;
+(id)scrollLoadingView;
-(void)addToScrollView:(UIScrollView*)scrollView;
-(void)endScrollLoadingStatus;


-(void)removeScrollLoading;
-(void)recoverLoadingStatue;
@end
