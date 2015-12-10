//
//  RepeatScrollView.h
//  YBExample
//
//  Created by 陶海龙 on 15/12/7.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@class RepeatScrollView;
@protocol RepeatScrollProtocol <NSObject>

-(NSString*)getImageUrl;

@end

typedef void (^RepeatScrollBlock)(NSInteger index,id<RepeatScrollProtocol> object);
@interface RepeatScrollView : UIView
-(void)setAutoRepeat;
-(void)setDataSource:(NSArray*)dataArr;
-(void)setTapCallBack:(RepeatScrollBlock)block;
@end
