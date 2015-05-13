//
//  Timer.h
//  The-Pomodoro-iOS8
//
//  Created by Taylor Mott on 18.2.2015.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *SecondTickNotification = @"secondTickNotification";
static NSString *RoundCompleteNotification = @"roundCompleteNotification";
static NSString *NewRoundNotification = @"newRoundNotification";
static NSString *expirationDate = @"expiryDate";

@interface Timer : NSObject

@property (assign, nonatomic) NSInteger minutes;
@property (assign, nonatomic) NSInteger seconds;

+ (Timer *)sharedInstance;

- (void)startTimer;
- (void)cancelTimer;
- (void)prepareForBackground;
- (void)loadFromBackground;

@end
