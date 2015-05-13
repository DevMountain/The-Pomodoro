//
//  Timer.m
//  The-Pomodoro-iOS8
//
//  Created by Taylor Mott on 18.2.2015.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "Timer.h"
@import UIKit;

@interface Timer()

@property (assign, nonatomic) BOOL isOn;
@property (strong, nonatomic) NSDate *expirationDate;

@end

@implementation Timer


//Create timer shared instance
+ (Timer *)sharedInstance {
    static Timer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [Timer new];
        
        /* code for testing Timer
        sharedInstance.minutes = 5;
        sharedInstance.seconds = 10;
         */
    });
    
    return sharedInstance;
}

//set isON to No or False and call roundCompleteNotification
- (void)endTimer
{
    self.isOn = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:RoundCompleteNotification object:nil];
}

//If seconds in larger than 0 subtract one & call secondTickNotification
//If seconds is equal to 0 and minutes is larger than 0 subtract 1 from minutes
//Otherwise end the timer
- (void)decreaseSecond
{
    if (self.seconds > 0)
    {
        self.seconds--;
        [[NSNotificationCenter defaultCenter] postNotificationName:SecondTickNotification object:nil];
    }
    else if (self.seconds == 0 && self.minutes > 0)
    {
        self.minutes--;
        self.seconds = 59;
        [[NSNotificationCenter defaultCenter] postNotificationName:SecondTickNotification object:nil];
    }
    else
    {
        [self endTimer];
    }
}

//Set inOn to NO or False
//Cancel all requests for the target
- (void)cancelTimer
{
    self.isOn = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

//set isON to YES and call checkActive
//Set timer length to the amount of time in the round.
//set the expiration date property to that time
//Create a LocalNotification and set the fireDate,timeZone, soundName, alertBody
//schedule the local notification.
- (void)startTimer
{
    self.isOn = YES;
    
    NSTimeInterval timerLength = self.minutes * 60 + self.seconds;
    self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:timerLength];
    
    UILocalNotification *timerExpiredNotification = [UILocalNotification new];
    
    timerExpiredNotification.fireDate = self.expirationDate;
    timerExpiredNotification.timeZone = [NSTimeZone defaultTimeZone];
    timerExpiredNotification.soundName = UILocalNotificationDefaultSoundName;
    timerExpiredNotification.alertBody = @"Round Complete. Continue with next round?";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:timerExpiredNotification];
    
    [self checkActive];
}

//checks isOn if yes it calls decreaseSecond and performs checkActive after a second delay
- (void)checkActive
{
    if (self.isOn)
    {
        [self decreaseSecond];
        [self performSelector:@selector(checkActive) withObject:nil afterDelay:1.0];
    }
}

//Add the expiration date to the background
- (void)prepareForBackground
{
    [[NSUserDefaults standardUserDefaults] setObject:self.expirationDate forKey:expirationDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//load the expiration date from the background
- (void)loadFromBackground
{
    self.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:expirationDate];
    NSTimeInterval seconds = [self.expirationDate timeIntervalSinceNow];
    self.minutes = seconds / 60;
    self.seconds = seconds - (self.minutes * 60);
}

@end
