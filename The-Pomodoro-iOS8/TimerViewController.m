//
//  TimerViewController.m
//  The-Pomodoro-iOS8
//
//  Created by Taylor Mott on 18.2.2015.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "TimerViewController.h"
#import "Timer.h"

@interface TimerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;

@end

@implementation TimerViewController


//register for notification
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [self registerForNotifications];
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Unregister for notifications
- (void)dealloc
{
    [self unregisterForNotifications];
}

//disable the timerButton
//Start the timer
- (IBAction)timerButtonPressed {
    self.timerButton.enabled = NO;
    [[Timer sharedInstance] startTimer];
}

//Call update timer and enable the button
- (void)newRound
{
    [self updateTimerLabel];
    self.timerButton.enabled = YES;
}

//Set the minutes and the seconds to the Timer seconds and minutes property
- (void)updateTimerLabel
{
    //set the TimerLabel using the stringOfTimeRemaining method
    self.timerLabel.text = [[Timer sharedInstance] stringOfTimeRemaining];
}

//Register for the notfications
- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTimerLabel) name:SecondTickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRound) name:NewRoundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRound) name:NewRoundNotification object:nil];
}

//Unregister for the notfications
- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
