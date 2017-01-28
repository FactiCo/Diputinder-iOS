//
//  AppDelegate.h
//  Diputinder
//
//  Created by Carlos Castellanos on 28/04/15.
//  Copyright (c) 2015 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{

    CLLocationManager *locationManager;
}
@property (strong, nonatomic) NSMutableDictionary *imgCache;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navBar;


@end

