//
//  CommentScoreView.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentScoreView : UIView
{
    BOOL _big;
    float _score;
}
-(void)setScore:(double)score;
-(void)setStarTypeIsBig:(BOOL)type;
@end
