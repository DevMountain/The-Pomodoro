//
//  RoundsController.h
//  The-Pomodoro-iOS8
//
//  Created by Taylor Mott on 18.2.2015.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoundsController : NSObject

@property (assign, nonatomic) NSInteger currentRound;
@property (strong, nonatomic, readonly) NSArray *roundTimes;

+ (RoundsController *)sharedInstance;
- (void)roundSelected;

@end
