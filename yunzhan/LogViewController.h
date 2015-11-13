//
//  LogViewController.h
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^logCallBack)(BOOL success) ;
@interface LogViewController : UIViewController
{
     UIButton * _voiceVerifyBt;
}
-(void)setLogResturnBk:(logCallBack)bk;
@end
