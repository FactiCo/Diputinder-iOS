//
//  DocumentViewController.h
//  Diputinder
//
//  Created by Carlos Castellanos on 19/08/15.
//  Copyright (c) 2015 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *titulo;

@end
