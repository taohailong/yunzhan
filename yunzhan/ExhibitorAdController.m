//
//  ExhibitorAdController.m
//  yunzhan
//
//  Created by 陶海龙 on 16/1/15.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

#import "ExhibitorAdController.h"
#import "THActivityView.h"
#if EXTERENTERPISE
#import "yunzhan_external-Swift.h"
#elif INTERENTERPISE
#import "yunzhan_internal-Swift.h"

#else
#import "yunzhan-Swift.h"
#endif


@implementation ExhibitorAdController
{
    THActivityView* loadView;
    UIWebView* web;
}

-(void)viewDidLoad
{
    web = [[UIWebView alloc]init];
    web.delegate = self;
    web.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:web];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[web]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(web)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[web]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(web)]];
    [self loadLocalHtml];
    
    loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
}

-(void)getNetData{
   
    NetWorkData* net = [[NetWorkData alloc]init];
//    [net ex]
  
  
}


-(void)loadLocalHtml{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL * url = [NSURL fileURLWithPath:path];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loadView removeFromSuperview];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadView removeFromSuperview];
}


-(void)writeBodyToWeb:(NSString*)html
{
    [web stringByEvaluatingJavaScriptFromString:html];
}


@end
