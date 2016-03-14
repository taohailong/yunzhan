//
//  LogViewController.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "LogViewController.h"
#import "THActivityView.h"
#import <AFNetworking.h>
#import "LogInCell.h"

#if EXTERENTERPISE
#import "yunzhan_external-Swift.h"
//#define PORT "123.56.102.224"
#elif INTERENTERPISE
#import "yunzhan_internal-Swift.h"
//#define PORT "123.56.102.224:8099"
#else
#import "yunzhan-Swift.h"
//#define PORT "www.zhangzhantong.com"
//#define PORT "123.56.102.224:8099"
#endif



@interface LogViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
 
    UITableView* _table;
    __weak UITextField* _phoneField;
    __weak UITextField* _pwField;
     UIButton* _logBt;
    UIButton* _verifyBt;
    NSTimer* _timer;
    logCallBack _completeBk;
    int _countDown;
    UILabel* _voiceLabel;
//    UITextField* _respondField;
}
@property(nonatomic,strong)NSString* phoneStr;
@property(nonatomic,strong)NSString* pwStr;
@end

@implementation LogViewController
@synthesize phoneStr,pwStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    


    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.delegate = self;
    _table.dataSource = self;
     _table.separatorColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0 ];
    [_table registerClass:[LogInCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_table];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_table]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    
    
    
    _verifyBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyBt setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verifyBt addTarget:self action:@selector(accessVerifyNu:) forControlEvents:UIControlEventTouchUpInside];
    _verifyBt.frame = CGRectMake(0, 0, 90, 30);
    _verifyBt.titleLabel.font =[UIFont systemFontOfSize:15];
    _verifyBt.layer.masksToBounds = YES;
    _verifyBt.layer.cornerRadius = 3;
    _verifyBt.layer.borderWidth = 1;
    
    UIColor* c = [Profile NavBarColorGenuine];
    _verifyBt.layer.borderColor = c.CGColor;
    
    [_verifyBt setBackgroundImage:[c convertToImage] forState:UIControlStateHighlighted];
    [_verifyBt setTitleColor:c forState:UIControlStateNormal];
    [_verifyBt setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0 ] forState:UIControlStateDisabled];
    [_verifyBt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    UIView* tableFoot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_table.frame), 100)];
//    tableFoot.backgroundColor = [UIColor redColor];
    _table.tableFooterView = tableFoot;
    
    
    _logBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _logBt.translatesAutoresizingMaskIntoConstraints = NO;
    [tableFoot addSubview:_logBt];
    _logBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [_logBt setTitle:@"立即登录" forState:UIControlStateNormal];
    [_logBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [_logBt setBackgroundImage:[[Profile GlobalButtonHightColor] convertToImage] forState:UIControlStateHighlighted];
    [_logBt setBackgroundImage:[[Profile GlobalButtonDisableColor] convertToImage] forState:UIControlStateNormal];
    _logBt.layer.masksToBounds = YES;
    _logBt.layer.cornerRadius = 3;
    _logBt.layer.borderWidth = 1;
    _logBt.layer.borderColor = [UIColor clearColor].CGColor;

    [_logBt addTarget:self action:@selector(logAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableFoot addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_logBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_logBt)]];
    
    [tableFoot addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_logBt(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_logBt)]];
    
    
    
    
    
    _voiceVerifyBt = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSMutableAttributedString* voiceStr = [[NSMutableAttributedString alloc]initWithString:@"收不到短信？使用语音验证码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [voiceStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]} range:NSMakeRange(0, 8)];
    [voiceStr addAttributes:@{NSForegroundColorAttributeName:[Profile NavBarColorGenuine]} range:NSMakeRange(8, 5)];
    
    [_voiceVerifyBt setAttributedTitle:voiceStr forState:UIControlStateNormal];
    _voiceVerifyBt.translatesAutoresizingMaskIntoConstraints = NO;
    [tableFoot addSubview:_voiceVerifyBt];
    
    [_voiceVerifyBt addTarget:self action:@selector(voiceVerifyPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableFoot addConstraint:[NSLayoutConstraint constraintWithItem:_voiceVerifyBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tableFoot attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [tableFoot addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_logBt]-15-[_voiceVerifyBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_logBt,_voiceVerifyBt)]];
    
    
    _voiceLabel = [[UILabel alloc]init];
    _voiceLabel.font = [UIFont systemFontOfSize:15];
//    _voiceLabel.textColor = DEFAULTBLACK;
    _voiceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [tableFoot addSubview:_voiceLabel];
    
    [tableFoot addConstraint:[NSLayoutConstraint constraintWithItem:_voiceLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tableFoot attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:5]];
    
    [tableFoot addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_voiceVerifyBt]-5-[_voiceLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_voiceVerifyBt,_voiceLabel)]];
    

    [self registeNotificationCenter];
    // Do any additional setup after loading the view.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    __weak LogViewController* wself = self;
    LogInCell* cell = (LogInCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0) {
        
        UITextField* phoneField = [cell getTextFieldView];
        _phoneField = phoneField;
        _phoneField.placeholder = @"请输入手机号";
        phoneField.keyboardType = UIKeyboardTypeNumberPad;
        phoneField.leftViewMode =UITextFieldViewModeAlways;
        UIImageView* phoneLeftV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 20)];
        phoneLeftV.contentMode = UIViewContentModeScaleAspectFit;
        phoneLeftV.image = [UIImage imageNamed:@"login_photo"];
        phoneField.leftView = phoneLeftV;

//        [cell setFieldBlock:^(NSString *text) {
//            wself.phoneStr = text;
//        }];
    }
    else
    {
        UITextField* pwField = [cell getTextFieldView];
        _pwField = pwField;
        _pwField.placeholder = @"请输入验证码";
        pwField.keyboardType = UIKeyboardTypeNumberPad;
        pwField.translatesAutoresizingMaskIntoConstraints = NO;
        pwField.leftViewMode =UITextFieldViewModeAlways;
        UIImageView* pwLeftV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 20)];
        pwLeftV.image = [UIImage imageNamed:@"login_pw"];
        pwLeftV.contentMode = UIViewContentModeScaleAspectFit;
        pwField.leftView = pwLeftV;

//        [cell setFieldBlock:^(NSString *text) {
//            wself.pwStr = text;
//        }];
        cell.accessoryView = _verifyBt;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    return cell;
}


-(void)accessVerifyNu:(id)sender
{
    if ([NSString verifyIsMobilePhoneNu: _phoneField.text] == NO) {
        
        THActivityView* showStr = [[THActivityView alloc]initWithString:@"号码格式不正确"];
        [showStr show];
        return;
    }
    [_pwField becomeFirstResponder];
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    __weak LogViewController* wself = self;
    
//    NSString* str = [NSString stringWithFormat:@"http://%s/api/app/user/verifysms?eid=1&phone=%@",PORT,_phoneField.text];
    NSString* str = [NSString stringWithFormat:@"http://%@/api/app/user/verifysms?chn=ios&eid=%@&phone=%@",[Profile domain],[Profile exhibitor],_phoneField.text];

//    NSString* str = [Profile globalHttpHead:@"api/app/user/verifysms" parameter:[NSString stringWithFormat:@"phone=%@",_phoneField.text]];
    NSURLRequest* url = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    AFHTTPRequestOperation * req = [[AFHTTPRequestOperation alloc]initWithRequest:url];
    [req setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [loadView removeFromSuperview];
         NSDictionary* dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        
        if ([dataDic[@"code"] intValue]== 0) {
            [wself startCountdown];
        }
        else
        {
            THActivityView* alert = [[THActivityView alloc]initWithString:dataDic[@"msg"]];
            [alert show];
            return ;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loadView removeFromSuperview];
        THActivityView* alert = [[THActivityView alloc]initWithString:@"网络连接失败"];
        [alert show];
    }];

    [req start];
}

-(void)startCountdown
{
    _countDown = 60;
    [_verifyBt setTitle:[NSString stringWithFormat:@"%ds后(重发)",_countDown] forState:UIControlStateDisabled];
    _verifyBt.enabled = NO;
    _verifyBt.layer.borderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0 ].CGColor;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRunLoop) userInfo:nil repeats:YES];

}

-(void)timeRunLoop
{
    _countDown--;
    [_verifyBt setTitle:[NSString stringWithFormat:@"%ds后(重发)",_countDown] forState:UIControlStateDisabled];

    
    if (_countDown==0) {
        _verifyBt.layer.borderColor = [Profile NavBarColorGenuine].CGColor;
        _verifyBt.enabled = YES;
        [_timer invalidate];
    }
}


-(void)timerInvalid
{
    _verifyBt.enabled = YES;
    [_timer invalidate];
}



-(void)setLogResturnBk:(logCallBack)bk
{
    _completeBk = bk;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)logAction:(id)sender
{
    if (_pwField.text.length==0||_phoneField.text.length==0) {
        THActivityView* alter = [[THActivityView alloc]initWithString:@"账号或密码无效"];
        [alter show];
        return;
    }
    
    [_phoneField resignFirstResponder];
    [_pwField resignFirstResponder];
    
    THActivityView* loading = [[THActivityView alloc]initActivityView];
    loading.center = self.view.center;
    [self.view addSubview:loading];
    
    __weak LogViewController* wSelf = self;
    
    
    NSString* str = [NSString stringWithFormat:@"http://%@/api/app/user/login?chn=ios&eid=%@&phone=%@&code=%@",[Profile domain],[Profile exhibitor],_phoneField.text,_pwField.text];

//    NSString* str = [Profile globalHttpHead:@"api/app/user/login" parameter:[NSString stringWithFormat:@"phone=%@&code=%@",_phoneField.text,_pwField.text]];
    NSURLRequest* url = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    AFHTTPRequestOperation * req = [[AFHTTPRequestOperation alloc]initWithRequest:url];
    [req setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [loading removeFromSuperview];
        
        NSDictionary* dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        
         if ([dataDic[@"code"] intValue]== 0) {
        
             dataDic = dataDic[@"data"];
             UserData* user = [UserData shared];
             user.title = dataDic[@"title"];
             user.name = dataDic[@"name"];
             user.phone = dataDic[@"mobile"];
             user.token = dataDic[@"user_token"];
             user.messID = dataDic[@"hxin_id"];
             user.password_huanxin = @"123456";
             NSNumber* userID = dataDic[@"id"];
             user.userID = [userID stringValue];
             user.qq = dataDic[@"qq"];
             user.company = dataDic[@"company"];
             [user sendDeviceToken];
             [user logInHuanxin];
             [[NSNotificationCenter defaultCenter] postNotificationName:[Profile userStatusChanged] object:nil];
             [wSelf logViewDismiss];
         }
         else
         {
                [wSelf timerInvalid];
                THActivityView* alter = [[THActivityView alloc]initWithString:dataDic[@"msg"]];
                [alter show];
                [loading removeFromSuperview];
         }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loading removeFromSuperview];
    }];
    
    [req start];

    
//    UserManager* user = [UserManager shareUserManager];
//    [user logInWithPhone:self.phoneStr Pass:self.pwStr logBack:^(BOOL success, id respond) {
//    
//        if (success) {
//    
//            [wSelf logViewDismiss];
//        }
//        else
//        {
//            [wSelf timerInvalid];
//            THActivityView* alter = [[THActivityView alloc]initWithString:respond];
//            [alter show];
//            [loading removeFromSuperview];
//        }
//    }];
   
}


-(void)voiceVerifyPhoneAction:(id)sender
{
    if ([NSString verifyIsMobilePhoneNu: _phoneField.text] == NO) {
        
        THActivityView* showStr = [[THActivityView alloc]initWithString:@"号码格式不正确"];
        [showStr show];
        return;
    }
    
    [_pwField resignFirstResponder];
    [_phoneField resignFirstResponder];
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    __weak LogViewController* wself = self;
    
 
    NSString* str = [NSString stringWithFormat:@"http://%@/api/app/user/verifyvoice?chn=ios&eid=%@&phone=%@",[Profile domain],[Profile exhibitor],_phoneField.text];

//    NSString* str = [Profile globalHttpHead:@"api/app/user/verifyvoice" parameter:[NSString stringWithFormat:@"phone=%@",_phoneField.text]];
    NSURLRequest* url = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    AFHTTPRequestOperation * req = [[AFHTTPRequestOperation alloc]initWithRequest:url];
    [req setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [loadView removeFromSuperview];
        
        NSDictionary* dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        
        if ([dataDic[@"code"] intValue]==0) {
            [wself voiceVerifyComplete];
        }
        else
        {
            THActivityView* showStr = [[THActivityView alloc]initWithString:dataDic[@"msg"]];
            [showStr show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loadView removeFromSuperview];
    }];
    
    [req start];
}

-(void)voiceVerifyComplete
{
   _voiceLabel.text = @"电话拨打中...请留意一下电话";
}





-(void)logViewDismiss
{
    [self timerInvalid];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
      [self dismissViewControllerAnimated:YES completion:^{}];
    }
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.002* NSEC_PER_SEC);
    
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        if (_completeBk) {
            _completeBk(YES);
        }
        _completeBk = nil;
  
    });
}



#pragma mark- textField


-(void)registeNotificationCenter
{
    /*注册成功后  重新链接服务器*/
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    
//    [def addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    /* 注册键盘的显示/隐藏事件 */
    [def addObserver:self selector:@selector(keyboardShown:)
                name:UIKeyboardWillShowNotification
											   object:nil];
    
    
    [def addObserver:self selector:@selector(keyboardHidden:)name:UIKeyboardWillHideNotification
											   object:nil];
    
}

- (void)keyboardShown:(NSNotification *)aNotification
{
    [_logBt setBackgroundImage:[[Profile GlobalButtonHightColor] convertToImage] forState:UIControlStateHighlighted];
    [_logBt setBackgroundImage:[[Profile NavBarColorGenuine] convertToImage] forState:UIControlStateNormal];
    
    NSDictionary *info = [aNotification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [aValue CGRectValue].size;
    [self accessViewAnimate:-keyboardSize.height];
}

- (void)keyboardHidden:(NSNotification *)aNotification
{
    [_logBt setBackgroundImage:[[Profile GlobalButtonDisableColor] convertToImage] forState:UIControlStateNormal];
    [self accessViewAnimate:0.0];
}

-(void)accessViewAnimate:(float)height
{
    
//    _table.contentInset = UIEdgeInsetsMake(0, 0, -height, 0);
    [UIView animateWithDuration:.2 delay:0 options:0 animations:^{
        
        for (NSLayoutConstraint * constranint in self.view.constraints)
        {
            if (constranint.firstItem==_table&&constranint.firstAttribute==NSLayoutAttributeBottom) {
                constranint.constant = height;
            }
        }
    } completion:^(BOOL finished) {
        
    }];
}


//-(BOOL)verifyNumber:(NSString*)str
//{
//    NSString * MOBILE =  @"[0-9]+.?[0-9]*";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    
//    return  [regextestmobile evaluateWithObject:str];
//}

//-(void)textFieldChanged:(NSNotification*)noti
//{
//    _respondField = (UITextField*)noti.object;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
