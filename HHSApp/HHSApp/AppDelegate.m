//
//  AppDelegate.m
//  HHSApp
//
//  Created by Connor Koehler on 2/7/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import "AppDelegate.h"
//#import "GAI.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    tabBarItem1.title = @"Home";
    tabBarItem2.title = @"Staff";
    tabBarItem3.title = @"Broadside";
    tabBarItem4.title = @"More";
    
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"home_white_60x60.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home_60x60.png"]];
    [tabBarItem1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [tabBarItem1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[self colorWithHexString:@"000000"],UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"staff_white_60x60.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"staff_60x60.png"]];
    [tabBarItem2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [tabBarItem2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[self colorWithHexString:@"000000"],UITextAttributeTextColor, nil] forState:UIControlStateNormal];

    
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"broadside_white_60x60.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"broadside_60x60.png"]];
    [tabBarItem3 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [tabBarItem3 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[self colorWithHexString:@"000000"],UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"more_white_60x60.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"more_60x60.png"]];
    [tabBarItem4 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [tabBarItem4 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[self colorWithHexString:@"000000"],UITextAttributeTextColor, nil] forState:UIControlStateNormal];

    
    /*NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *handbookPath = [documentsDirectory stringByAppendingPathComponent:@"handbook.pdf"];
    
    if ([fileManager fileExistsAtPath:handbookPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"handbook" ofType:@"pdf"];
        [fileManager copyItemAtPath:resourcePath toPath:handbookPath error:&error];
    }
    
    NSString *programOfStudiesPath = [documentsDirectory stringByAppendingPathComponent:@"programofstudies.pdf"];
    
    if ([fileManager fileExistsAtPath:programOfStudiesPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"programofstudies" ofType:@"pdf"];
        [fileManager copyItemAtPath:resourcePath toPath:programOfStudiesPath error:&error];
    }
    */ // code to store pdfs locally in documents folder
    
    return YES;
    //okay. I returned. Nothing else will happen
    /*


    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-39417034-1"];
    */
}



-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
