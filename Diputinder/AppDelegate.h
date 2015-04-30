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
@property (strong, nonatomic) NSString *localidad;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navBar;


@end

