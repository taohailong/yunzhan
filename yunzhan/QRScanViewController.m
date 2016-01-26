
//
//  RootViewController.m
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "QRScanViewController.h"

@interface QRScanViewController ()<UIAlertViewDelegate>

@end

@implementation QRScanViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
//    [self creatSubView];
}


-(void)creatSubView{

    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.font = [UIFont systemFontOfSize:13];
    labIntroudction.translatesAutoresizingMaskIntoConstraints = NO;
    labIntroudction.numberOfLines=0;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码放入框内，即可自动扫描";
    [self.view addSubview:labIntroudction];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[labIntroudction]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(labIntroudction)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[labIntroudction]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(labIntroudction)]];
    
    
    
    //    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 300, 300)];
    //    imageView.image = [UIImage imageNamed:@"pick_bg"];
    //    [self.view addSubview:imageView];
    
    
//    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
//    [scanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:scanButton];
//    
//    scanButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[scanButton]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scanButton)]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scanButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[scanButton(45)]-30-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scanButton)]];
//    
//    scanButton.layer.masksToBounds = YES;
//    scanButton.layer.borderColor = [UIColor blackColor].CGColor;
//    scanButton.layer.borderWidth = 1;
//    scanButton.layer.cornerRadius = 6;
//
}


- (void)generateScanLine{

        upOrdown = NO;
        num =0;
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 2)];
        _line.image = [UIImage imageNamed:@"line.png"];
        [self.view addSubview:_line];
    
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }

}

-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupCamera];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [timer invalidate];
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//     _output.rectOfInterest=CGRectMake(0.5,0,0.5, 1);
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
//    [_session setSessionPreset: AVCaptureSessionPreset640x480];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
//        NSLog(@"相机权限受限");
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查是否开启系统相机权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 10;
        [alert show];
        return;
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    
    
    
    NSArray* types = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeQRCode];

    _output.metadataObjectTypes = types;
//    AVMetadataObjectTypeQRCode  二维码
//    AVCaptureDeviceFormat
//    AVCaptureSessionPreset
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    CGFloat devWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat devHeight = [UIScreen mainScreen].bounds.size.height;
//    _preview.frame =CGRectMake(0,64,devWidth,devHeight-64);
    _preview.frame =CGRectMake((devWidth-280)/2,(devHeight-280)/2,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.font = [UIFont systemFontOfSize:13];
    labIntroudction.numberOfLines=0;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码放入框内，即可自动扫描";
    [self.view addSubview:labIntroudction];
    [labIntroudction sizeToFit];
    labIntroudction.center = CGPointMake(devWidth/2, (devHeight-280)/2 - 25);
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
        {
            stringValue = metadataObject.stringValue;
        }
        else
        {
           
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(scanActionCompleteWithResult:)]) {
        [self.delegate scanActionCompleteWithResult:stringValue];
    }
    
   [_session stopRunning];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10) {
        
        if (alertView.cancelButtonIndex == buttonIndex) {
            return;
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL
                                                        URLWithString:UIApplicationOpenSettingsURLString]];
}

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) drawPlaceholderInRect:(CGRect)rect {
//    [[UIColor blueColor] setFill];
//    [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
//}

@end
