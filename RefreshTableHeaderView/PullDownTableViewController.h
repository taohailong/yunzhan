//
//  ViewController.h
//  PushVC
//
//  Created by 陶海龙 on 15/12/1.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
typedef void (^DidTriggerRefresh)(void);
@interface PullDownTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    DidTriggerRefresh refreshBlock;
}
@property(nonatomic,strong)UITableView* tableView;
-(void)addHeadViewWithTableEdge:(UIEdgeInsets)edge withFrame:(CGRect)rect withBlock:(DidTriggerRefresh)block;
-(void)headViewBeginLoading;
-(void)headViewEndLoading;
@end

