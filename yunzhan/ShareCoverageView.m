//
//  ShareCoverageView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/9/17.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

#import "ShareCoverageView.h"
#import "WXApi.h"
#if ENTERPISE
#import "yunzhan_copy-Swift.h"
#define PORT "www.zhangzhantong.com"
#else
#define PORT "www.zhangzhantong.com"
#import "yunzhan-Swift.h"
#endif

@implementation ShareCoverageView
@synthesize token,wallID;

-(id)initWithDelegate:(id<ShareCoverageProtocol>)delegate
{
    self = [super init];
    _delegate = delegate;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView)];
    [self addGestureRecognizer:tap];
    return self;
}

-(void)tapBackView{

   [self shareViewDisappera];

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
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[footView(125)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(footView)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:footView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:210]];
    
    
    UILabel* titleL = [[UILabel alloc]init];
    titleL.text = @"分享至";
    titleL.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:titleL];
    
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:titleL attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[titleL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleL)]];
    
    
    UIView* separateView = [[UIView alloc]init];
    separateView.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:separateView];
//    separateView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    separateView.backgroundColor = [UIColor whiteColor];
    
     [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[separateView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleL]-5-[separateView(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleL,separateView)]];

    
    UIButton* friendBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendBt setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 30, 0)];
    [friendBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, -55, 0)];
    friendBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [friendBt setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [friendBt setTitle:@"微信好友" forState:UIControlStateNormal];
    [friendBt setImage:[UIImage imageNamed:@"sharewx_friend"] forState:UIControlStateNormal];
    [friendBt addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    friendBt.tag = 1;
    friendBt.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:friendBt];
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:friendBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-50]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[friendBt(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(friendBt)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateView]-5-[friendBt(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView,friendBt)]];
    

    
    
    UIButton* groupBt = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [groupBt setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 30, 0)];
    [groupBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, -55, 0)];
    
    [groupBt setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    groupBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [groupBt setTitle:@"微信朋友圈" forState:UIControlStateNormal];
    [groupBt setImage:[UIImage imageNamed:@"sharewx_group"] forState:UIControlStateNormal];
    [groupBt addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    groupBt.tag = 2;
    groupBt.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:groupBt];
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:groupBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:50]];
    
     [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[groupBt(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(groupBt)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateView]-5-[groupBt(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView,groupBt)]];
    
    
    
//    UIView* separateBottom = [[UIView alloc]init];
//    separateBottom.translatesAutoresizingMaskIntoConstraints = NO;
//    separateBottom.backgroundColor = [UIColor clearColor];
//    [footView addSubview:separateBottom];
////    separateBottom.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
//    
//    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[separateBottom]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateBottom)]];
//    
//    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateBottom(0.5)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateBottom)]];
//
    
    
    
    
//    UIButton* cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBt.layer.masksToBounds = YES;
//    cancelBt.layer.cornerRadius = 4;
//    cancelBt.layer.borderColor = [UIColor colorWithRed:223.0/255.0 green:32.0/255.0 blue:82.0/255.0 alpha:1.0].CGColor;
//    cancelBt.layer.borderWidth = 0.5;
//    [cancelBt addTarget:self action:@selector(shareViewDisappera) forControlEvents:UIControlEventTouchUpInside];
//    cancelBt.translatesAutoresizingMaskIntoConstraints = NO;
//    [footView addSubview:cancelBt];
//     [cancelBt setTitle:@"取消" forState:UIControlStateNormal];
//    
//    
//    [cancelBt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [cancelBt setTitleColor:[UIColor colorWithRed:223.0/255.0 green:32.0/255.0 blue:82.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//   
//    [cancelBt setBackgroundImage:[UIImage imageNamed:@"login_hight"] forState:UIControlStateHighlighted];
//    
//    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[cancelBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelBt)]];
//    
//    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelBt(35)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelBt)]];
    
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
    WXWebpageObject *ext = [WXWebpageObject object];
    
    NSString* url = [NSString stringWithFormat:@"http://www.zhangzhantong.com/share?name=jsbicycle&token=%@&eid=1&info_wall_id=%@",self.token,self.wallID];
    NSLog(url);
    ext.webpageUrl = url;
    
    WXMediaMessage *message = [WXMediaMessage message];
//    message.message = "message"
    message.title = @"中国电动车展";
    message.description = @"《第34界中国江苏国际自行车新能源电动车及零部件交易会》火热报名中~";
    [message setThumbImage:[UIImage imageNamed:@"aboutImage"]];
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.text = @"http://www.zhangzhantong.com/jsbicycle";
    req.message = message;
    req.bText = NO;
    if (flag) {
        req.scene = WXSceneSession;
    }
    else
    {
        req.scene = WXSceneTimeline;
        
    }
    BOOL success = [WXApi sendReq:req];
    
    if ([_delegate respondsToSelector:@selector(shareActionFinish:)]&&success==YES)
    {
        [_delegate shareActionFinish:success];
    }
}



@end
