//
//  LogInCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/9.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TextFieldBk)(NSString*text);
@interface LogInCell : UITableViewCell<UITextFieldDelegate>
{
    UIButton* _bt;
    UITextField* _contentField;
}
-(void)setFieldBlock:(TextFieldBk)bk;
-(UITextField*)getTextFieldView;
@end
