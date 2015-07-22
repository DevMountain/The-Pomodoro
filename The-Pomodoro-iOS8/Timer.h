//
//  Timer.h
//  The-Pomodoro-iOS8
//
//  Created by Taylor Mott on 18.2.2015.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *SecondTickNotification = @"secondTickNotification";
static NSString *TimerCompleteNotification = @"timerCompleteNotification";
static NSString *NewRoundNotification = @"newRoundNotification";

@interface Timer : NSObject

@property (assign, nonatomic) NSInteger seconds;

+ (Timer *)sharedInstance;

- (void)startTimer;
- (void)cancelTimer;
- (NSString *)stringOfTimeRemaining;

@end
