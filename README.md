# The-Pomodoro-iOS8
============

An iOS pomodoro timer app (including history ♦︎). A pomodoro app has 'Rounds' of time for focusing and taking breaks. Take a look at some sample Pomodoro apps in the app store, or run the solution code to see what you are building.

For more information and examples of Pomodoro:

* [LifeHacker on Pomodoro](http://lifehacker.com/productivity-101-a-primer-to-the-pomodoro-technique-1598992730)
* [Wired In](https://itunes.apple.com/US/app/id953366135)

Remember, the solution code is here as a resource. Do not copy and paste. Understand, walk through it *line by line*, and write it yourself.

## Day 1 - UITabBarController and NSNotifications

If you don't finish all the steps today, that is alright. Tomorrow's project will allow ample time to finish both days.

###Step 1: Initialize and Add the UITabBarController as the RootViewController

- Add view controllers (```TimerViewController```, ```RoundsViewController```) to project (include a XIB for the ```TimerViewController```)

- In the app delegate, initialize the ```TimerViewController``` and ```RoundsViewController```

- Place the instance of ```RoundsViewController``` in a NavigationController

- Set each viewcontroller's ```tabBarItem.title``` and ```tabBarItem.image``` (find two fitting icons on icons8.com, import them into the Images.xcassets file)

- Initialize a UITabBarController

- Set the ```viewControllers``` property on the UITabBarController to an array containing your navigation controller with a ```TimerViewController``` instance and your ```RoundsViewController``` instance

- Set the tab bar controller as ```rootViewController``` of ```window```.

###OVERVIEW OF TIMER APP

The classes within our app are going to talk to each other with NSNotifications. 

| Notification Name               | When Posted                               | Who Posts        | Who Observes                              |
|---------------------------------|-------------------------------------------|------------------|-------------------------------------------|
| ```SecondTickNotification```    | every second tick while timer is active   | Timer            | TimerViewController                       |
| ```TimerCompleteNotification``` | on completion of round (aka timer expiry) | Timer            | TimerViewController, RoundsViewController |
| ```NewRoundNotification```      | when a new round is "selected"            | RoundsController | TimerViewController                       |

###Step 2: Add the interface to the TimerViewController

The Timer View Controller displays a countdown of the current round and has a Start button to start the timer.

- Add a label and button to the timer screen using a XIB
- Add IBOutlets for the ```timerButton``` and ```timerLabel```
- Add an IBAction for the ```timerButton``` that will trigger the timer (leave method empty for now)

###Step 3: Create a RoundsController

- Create a ```sharedInstance``` class method on ```RoundsController``` that returns a singleton ```RoundsController``` instance
- Add a public, readonly property of type NSArray called ```roundTimes```
	- In the implementaion file, override the roundTimes getter method and return this array ```@[@1500, @300, @1500, @300, @1500, @300, @1500, @900]```. This array represents the number of seconds in each round (25 minutes, 5 minutes, 25, 5, 25, 5, 25, 15 minutes).
- Add a public property of type NSInteger called ```currentRound```

###Step 4: Create a timer class

Use a separate [Timer](https://github.com/DevMountain/The-Pomodoro/blob/solution-day1/The-Pomodoro-iOS8/Timer.m) class to manage the timer. This timer class holds the minutes and seconds and has a method to begin counting down. 
Pay attention to what the class does for you, walk through each method, understand what it is doing.

- Create a ```Timer``` Class as a Shared Instance
- Add public properties of type NSInteger for ```seconds```
- Create public static NSStrings with names from above table (```SecondTickNotification```, ```TimerCompleteNotification```, ```NewRoundNotification```)
- Add a private BOOL property called ```isOn``` to allow you to check if the timer is active
- Add a public void method called ```startTimer```
  - ```startTimer``` should turn ```isOn``` to YES
  - ```startTimer``` should call ```checkActive``` (which you will write below)
- Add a private void method called ```endTimer```
  - ```endTimer``` should turn ```isOn``` to NO and send a ```TimerCompleteNotification``` that the timer has finished
- Add a private void method called ```decreaseSecond```
  - ```decreaseSecond``` should decrease one second from the remaining time and send a ```SecondTickNotification``` notification that one second passed
  	- if the timer has elpased, then call ```endTimer```
- Add a private void method called ```checkActive```
  - ```checkActive``` should check if the timer is on (```self.isOn```), and if so, call the ```decreaseSecond``` method, then it should call itself in one second
  - before the if statement, make sure you cancel previous perform requests
- Add a public void method called ```cancelTimer```
  - ```cancelTimer``` should turn ```isOn``` to NO
  - ```cancelTimer``` should cancel previous perform requests
- Add an instance helper method that will return an NSString of the time remaining. This should return a string like one you'd read on a timer,  "05:09", for 309 seconds 

###Step 5: Update TimerViewController User Interface and Implementation File

- Add a method to your ```TimerViewController``` to update the ````timerLabel``` from the ```sharedInstance``` of ```Timer``` using the helper method above.
- Subscribe your ```TimerViewController``` to run the update label method on the ```SecondTickNotification```.
  - ```registerForNotifications``` should be placed in a custom **DESIGNATED** init method.
- Unsubscribe your ```TimerViewController``` from notifications when instances are deallocated.
- In your timer button pressed method (written above but left empty), call ```startTimer``` on ```sharedInstace``` of ```Timer```.
  - note: We need to disable the button while the timer is going.
- At this point we can test that our timer works and the update label method works:
  - in the ```dispatch_once``` method, set ```sharedInstance.seconds``` to whatever value you want to test (might be smart to make sure the minute decreases appropriately)
  - build and run the app
  - your timer label won't update until you tap start timer button
  - your timer should be counting down correctly
  - remove the lines of code where you set ```sharedInstance.seconds```

###Step 6: Add a tableview and datasource methods to the rounds view controller

- Create a ```tableView``` property on the ```RoundsViewController``` and instantiate it with style UITableViewStyleGrouped
- set ```self``` as datasource and delegate of ```tableView```
- Add the ```tableView``` to the ```RoundsViewController```'s ```view```
- Add required datasource methods to display cells that the user can use to select which round they want to start
  - The cell should display the number of MINUTES in the round (which can be retieved from the ```RoundsController```)
- In the ```RoundsController``` add a public, void method, ```roundSelected```
  - that will update the ```seconds``` property on the ```[Timer sharedInstance]``` from the ```currentRound``` property
  - that will send a ```NewRoundNotification``` notification
- In the ```RoundsViewController```, add didSelectRowAtIndexPath
  - set the ```currentRound``` property of ```[RoundsViewController sharedInstance] to the indexPath.row
  - and call ```roundSelected```
  - and call ```cancelTimer```

###Step 7: Add observer notifications
- Add ```RoundsViewController``` as observer of ```TimerCompleteNotification```
  - ```-(void)roundComplete```
    - if the current round is not the last round 
      - increment the ```currentRounds``` property
      - select the correct row on the tableview
      - call ```roundSelected```
    - else
      - set ```currentRounds``` property to 0
      - select the correct row on the tableview
      - call ```roundSelected```
- Add ```TimerViewController``` as observer of ```NewRoundNotification```
  - ```-(void)newRound```
    - update ```timerLabel```
    - enable ```timerButton```
- Add ```TimerViewController``` as observer of ```TimerCompleteNotification```
  - ```-(void)newRound```
- Don't forget to register in the init and unregister in the dealloc
