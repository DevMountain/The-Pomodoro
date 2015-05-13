//
//  AppearanceController.m
//  The-Pomodoro-iOS8
//
//  Created by Taylor Mott on 19.2.2015.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "AppearanceController.h"
#import "TimerViewController.h"

@implementation AppearanceController

//Change the barTintColor
//Use setTitleTextAttributes to change the text attributes.
//Change the tab bar color
+ (void)initializeAppearanceDefaults
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light" size:20]
                                                           }];
    [[UITabBar appearance] setTintColor:[UIColor purpleColor]];
    
    
    
    //Extra Appearance Modifications not in directions
    [[UIButton appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[UIView appearanceWhenContainedIn:[TimerViewController class], nil] setBackgroundColor:[UIColor purpleColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
