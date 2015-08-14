//
//  AppDelegate.m
//  Diputinder
//
//  Created by Carlos Castellanos on 28/04/15.
//  Copyright (c) 2015 Carlos Castellanos. All rights reserved.
//

#import "AppDelegate.h"
#import <AFHTTPRequestOperationManager.h>
#import "ViewController.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _imgCache=[[NSMutableDictionary alloc]init];
    // Permisos para localizar al usuario
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    [locationManager startUpdatingLocation];
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
#endif
    
   // [self getAddress];
  //  [self reverseGeokcode:locationManager.location];
    ViewController *vc=[[ViewController alloc]init];
   _navBar=[[UINavigationController alloc]initWithRootViewController:vc];
    
    self.window.rootViewController=_navBar;
    
    return YES;
}
-(void)getAddress{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //NSString *url =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?sensor=true&latlng=%f,%f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude];
       NSString *url =[NSString stringWithFormat:@"http://liguepolitico.herokuapp.com/geocoder.json?latitude=%f&longitude=%f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude];
    
    
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@",[[responseObject objectForKey:@"country"]objectForKey:@"id"]);
        NSLog(@"%@",[[responseObject objectForKey:@"state"]objectForKey:@"id"]);
       
        _country=  [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"country"]objectForKey:@"id"]];
        _state= [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"state"]objectForKey:@"id"]];
        _city= [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"cityx"]objectForKey:@"id"]];;
       
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error);
        
        
    }];

}
/*- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            NSString *address = [NSString stringWithFormat:@"%d", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
            NSLog(@"%@",address);
        }
    }];
}*/
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
