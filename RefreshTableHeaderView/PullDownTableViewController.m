//
//  ViewController.m
//  PushVC
//
//  Created by 陶海龙 on 15/12/1.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

#import "PullDownTableViewController.h"

@interface PullDownTableViewController()
{
//    UITableView* table;
    EGORefreshTableHeaderView* headView;
}
@end

@implementation PullDownTableViewController
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self creatTableView];
//    [self addHeadView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)creatTableView
{
//    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(void)addHeadViewWithTableEdge:(UIEdgeInsets)edge withFrame:(CGRect)rect withBlock:(DidTriggerRefresh)block
{
    refreshBlock = block;
//    CGRect refreshRect = CGRectMake(0.0f,
//                                    0.0f-self.tableView.bounds.size.height,
//                                    self.tableView.bounds.size.width,
//                                    self.tableView.bounds.size.height);
    
//    CGRect refreshRect = CGRectMake(0.0f,0.0f-[UIScreen mainScreen].bounds.size.height+113,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-113);
//
    headView = [[EGORefreshTableHeaderView alloc] initWithFrame:rect];
//    headView = [[EGORefreshTableHeaderView alloc]init];
//    headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    headView.scrollEdge = edge;
//    NSLog(NSStringFromUIEdgeInsets(self.tableView.contentInset));
    [self.tableView addSubview:headView];
//    [self.tableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headView)]];
//    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:headView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
//    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:headView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    /* 刷新一次数据 */
    [headView refreshLastUpdatedDate];
    
//    [self headViewBeginLoading];
}


-(void)headViewBeginLoading
{
    [headView refreshBegin:self.tableView];

}

-(void)headViewEndLoading
{
    [headView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}



- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
//    NSLog(@"%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
    /* 实现更新代码 */
    if (refreshBlock != nil) {
        refreshBlock();
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [headView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [headView egoRefreshScrollViewDidScroll:scrollView];
}


//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 20;
//}
//
//
//-(UITableViewCell*)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell* cell = [tableViews dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    cell.textLabel.text = @"123456";
//    return cell;
//}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
