//
//  DocumentViewController.m
//  Diputinder
//
//  Created by Carlos Castellanos on 19/08/15.
//  Copyright (c) 2015 Carlos Castellanos. All rights reserved.
//

#import "DocumentViewController.h"

@implementation DocumentViewController{
UIView *loading;
UIActivityIndicatorView *spinner;
}
- (void)viewDidLoad {

    
    
    loading=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2 -50, 50, 50)];
    loading.backgroundColor=[UIColor blackColor];
    // loading.alpha=0.8;
    loading.layer.cornerRadius = 5;
    loading.layer.masksToBounds = YES;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(loading.frame.size.width/2.0, loading.frame.size.height/2.0)];
    [spinner startAnimating];
    [loading addSubview:spinner];
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _webView.delegate=self;
    [self.view addSubview:_webView];
    
    
   
    NSURL *targetURL = [NSURL URLWithString:_path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_webView loadRequest:request];
    //[self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]]];
    
    
    //[_webView loadRequest:requestObj];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) webViewDidStartLoad:(UIWebView *)webView {
    
    [self.view addSubview:loading];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    [loading removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


-(void)viewDidAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.backItem.title=@"";
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIFont fontWithName:@"GothamRounded-Bold" size:19],NSFontAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes =textAttributes;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.topViewController.navigationItem.title=@"Documento";
    
}
@end
