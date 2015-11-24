//
//  ShareCoverageView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/9/17.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

#import "ShareCoverageView.h"
#import "WXApi.h"
@implementation ShareCoverageView
//-(id)initInSuperView:(UIView *)superView
//{
//    self = [super initWithFrame:superView.bounds];
//
//    
//    return self;
//}


-(id)initWithDelegate:(id<ShareCoverageProtocol>)delegate
{
    self = [super init];
    _delegate = delegate;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    return self;
}

-(void)showInView:(UIView*)superView
{
    self.frame = superView.bounds;
    [superView addSubview:self];
    _footView = [self getFootView];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self footViewAnimationWithVertical:0];
    }) ;
    
}


-(void)didMoveToSuperview
{}


-(UIView*)getFootView
{
    UIView* footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    footView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:footView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[footView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(footView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[footView(210)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(footView)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:footView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:210]];
    
    
    UILabel* titleL = [[UILabel alloc]init];
    titleL.text = @"分享至";
    titleL.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:titleL];
    
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:titleL attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[titleL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleL)]];
    
    
    UIView* separateView = [[UIView alloc]init];
    separateView.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:separateView];
    separateView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    
     [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[separateView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleL]-20-[separateView(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleL,separateView)]];

    
    UIButton* friendBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendBt setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 30, 0)];
    [friendBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, -55, 0)];
    friendBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [friendBt setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [friendBt setTitle:@"微信好友" forState:UIControlStateNormal];
    [friendBt setImage:[UIImage imageNamed:@"sharewx_friend"] forState:UIControlStateNormal];
    [friendBt addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    friendBt.tag = 1;
    friendBt.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:friendBt];
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:friendBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-50]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[friendBt(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(friendBt)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateView]-20-[friendBt(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView,friendBt)]];
    

    
    
    UIButton* groupBt = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [groupBt setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 30, 0)];
    [groupBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, -55, 0)];
    
    [groupBt setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    groupBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [groupBt setTitle:@"微信朋友圈" forState:UIControlStateNormal];
    [groupBt setImage:[UIImage imageNamed:@"sharewx_group"] forState:UIControlStateNormal];
    [groupBt addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    groupBt.tag = 2;
    groupBt.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:groupBt];
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:groupBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:50]];
    
     [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[groupBt(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(groupBt)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateView]-20-[groupBt(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView,groupBt)]];
    
    
    UIView* separateBottom = [[UIView alloc]init];
    separateBottom.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:separateBottom];
    separateBottom.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[separateBottom]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateBottom)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateBottom(0.5)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateBottom)]];

    
    UIButton* cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBt.layer.masksToBounds = YES;
    cancelBt.layer.cornerRadius = 4;
    cancelBt.layer.borderColor = [UIColor colorWithRed:223.0/255.0 green:32.0/255.0 blue:82.0/255.0 alpha:1.0].CGColor;
    cancelBt.layer.borderWidth = 0.5;
    [cancelBt addTarget:self action:@selector(shareViewDisappera) forControlEvents:UIControlEventTouchUpInside];
    cancelBt.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:cancelBt];
    [cancelBt setTitleColor:[UIColor colorWithRed:223.0/255.0 green:32.0/255.0 blue:82.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBt setTitle:@"取消" forState:UIControlStateNormal];

    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[cancelBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelBt)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelBt]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelBt)]];
    
    return footView;
}


-(void)shareAction:(UIButton*)button
{
    if (button.tag == 1) {
        [self wxShareToFriend:YES];
    }
    else
    {
        [self wxShareToFriend:NO];
    }
    [self shareViewDisappera];
}


-(void)shareViewDisappera
{
    [self removeFromSuperview];
}


-(void)footViewAnimationWithVertical:(float)y
{
    [UIView animateWithDuration:0.2 animations:^{
        
        for (NSLayoutConstraint * constranint in self.constraints)
        {
            if (constranint.firstItem==_footView&&constranint.firstAttribute==NSLayoutAttributeBottom) {
                constranint.constant = y;
            }
        }
         [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}


-(void)wxShareToFriend:(BOOL)flag
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
    req.bText = YES;
    if (flag) {
        req.scene = WXSceneSession;
    }
    else
    {
        req.scene = WXSceneTimeline;
        
    }
    [WXApi sendReq:req];
}



@end
