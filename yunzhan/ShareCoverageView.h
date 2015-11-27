//
//  ShareCoverageView.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/9/17.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WXApi.h"

typedef enum ShareWxType_{
    WXFriend,
    WXTimeLine
}ShareWxType;

@class ShareCoverageView;
@protocol ShareCoverageProtocol <NSObject>
@optional
-(void)shareCoverageSelectWxTpye:(ShareWxType)type;
-(void)shareActionFinish:(BOOL)success;
@end
@interface ShareCoverageView : UIView
{
    __weak id<ShareCoverageProtocol>_delegate;
    UIView* _footView;
}
-(id)initWithDelegate:(id<ShareCoverageProtocol>)delegate;
-(void)showInView:(UIView*)superView;
@end
