//
//  LogInCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/9.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "LogInCell.h"

@implementation LogInCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self creatSubView];
    return self;
}

-(void)creatSubView
{
    _contentField = [[UITextField alloc]init];
    _contentField.font = [UIFont systemFontOfSize:14.0];
    //    _contentField.backgroundColor = [UIColor redColor];
    _contentField.translatesAutoresizingMaskIntoConstraints = NO;
    _contentField.delegate =self;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:_contentField];
    
    _contentField.borderStyle = UITextBorderStyleNone;
    _contentField.returnKeyType = UIReturnKeyDone;
    
    [self.contentView addSubview:_contentField];
    [self setLayout];
}
-(void)setLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_contentField]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentField)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentField(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentField)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

-(UITextField*)getTextFieldView
{
    return _contentField;
}
//-(void)textChanged:(NSNotification*)notic
//{
//    if (notic.object!=_contentField) {
//        return;
//    }
//    if (_fieldBk) {
//        
//        _fieldBk(_contentField.text);
//    }
//    
//    NSLog(@"field is %@ ",_contentField.text);
//}

@end
