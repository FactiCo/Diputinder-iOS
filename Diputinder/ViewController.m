//
//  ViewController.m
//  Diputinder
//
//  Created by Carlos Castellanos on 28/04/15.
//  Copyright (c) 2015 Carlos Castellanos. All rights reserved.
//

#import "ViewController.h"
#import "DraggableViewBackground.h"

#import <AFHTTPRequestOperationManager.h>

#import "AppDelegate.h"
#import "DetailViewController.h"
@interface ViewController ()

@end

@implementation ViewController
{


    UILabel *name;
    UIScrollView *vista;
    
    UIActivityIndicatorView *loading;
    AppDelegate *delegate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
       [[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
    DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    [self.view addSubview:draggableBackground];
    // Do any additional setup after loading the view, typically from a nib.
    
   // [super layoutSubviews];
    [self.navigationController.navigationBar setTranslucent:NO];
     [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:48/255.0 green:204/255.0 blue:113/255.0 alpha:1]];
  //  self.navigationItem.title=@"liguepolítico";
    
    UIImage *image2 = [UIImage imageNamed:@"ligue.png"];
    //[self.navigationController.navigationBar setBackgroundImage:image2 forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,25,20)] ;
    
    //set your image logo replace to the main-logo
    [image setImage:[UIImage imageNamed:@"ligue.png"]];

   // [self.navigationController.navigationBar.topItem setTitleView:image];
    
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ligue.png"]];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeInfoLight];
    button.backgroundColor=[UIColor clearColor];
    button.imageView.backgroundColor=[UIColor clearColor];
    button.tintColor=[UIColor whiteColor];
    //[button setImage:[UIImage imageNamed:@"button_menu_navigationbar.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentMenuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [button setFrame:CGRectMake(0, 0, 37,34)];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = barButton;
    
    //verde 48,204, 113
    //modaro 116, 94,197
    //226,226,226

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
