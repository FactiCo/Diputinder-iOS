//
//  ViewController.h
//  Diputinder
//
//  Created by Carlos Castellanos on 28/04/15.
//  Copyright (c) 2015 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController <UIAlertViewDelegate,CLLocationManagerDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    
    CLLocationManager *locationManager;
}

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

//@property (retain,nonatomic)NSArray* exampleCardLabels; //%%% the labels the cards
@property (retain,nonatomic)NSMutableArray* allCards; //%%% the labels the cards


@end

