//
//  AppDelegate.m
//  The-Pomodoro-iOS8
//
//  Created by Taylor Mott on 18.2.2015.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "AppDelegate.h"
#import "RoundsViewController.h"
#import "TimerViewController.h"
#import "AppearanceController.h"
#import "Timer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [AppearanceController initializeAppearanceDefaults];

    
    //Create a Timer View Controller
    //Add tabBarItem.title and tabBarItem.image
    TimerViewController *timerVC = [TimerViewController new];
    timerVC.tabBarItem.title = @"Timer";
    timerVC.tabBarItem.image = [UIImage imageNamed:@"timer.png"];
    
    //Create a new RoundsViewController and initWithRootViewController
    RoundsViewController *roundsVC = [RoundsViewController new];
    UINavigationController *roundsNavController = [[UINavigationController alloc] initWithRootViewController:roundsVC];
    roundsNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Rounds" image:[UIImage imageNamed:@"rounds.png"] tag:1];
    
    //Create a TabBarController and add the viewController to the viewControllers array
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = @[timerVC, roundsNavController];
    
    //set the rootViewController as the tabBarController
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[Timer sharedInstance] prepareForBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[Timer sharedInstance] loadFromBackground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil]];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Round Finished!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Start Next Round" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[Timer sharedInstance] startTimer];
    }]];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
