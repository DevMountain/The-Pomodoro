# The-Pomodoro-iOS8
============

An iOS pomodoro timer app (including history ♦︎). A pomodoro app has 'Rounds' of time for focusing and taking breaks. Take a look at some sample Pomodoro apps in the app store, or run the solution code to see what you are building.

For more information and examples of Pomodoro:

* [Wired In](https://itunes.apple.com/US/app/id953366135)
* [LifeHacker on Pomodoro](http://lifehacker.com/productivity-101-a-primer-to-the-pomodoro-technique-1598992730)

Remember, the solution code is here as a resource. Do not copy and paste. Understand, walk through it *line by line*, and write it yourself.

## Day 1 - UITabBarController and NSNotifications

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
| ```RoundCompleteNotification``` | on completion of round (aka timer expiry) | Timer            | TimerViewController, RoundsViewController |
| ```NewRoundNotification```      | when a new round is "selected"            | RoundsController | TimerViewController                       |

###Step 2: Add the interface to the TimerViewController

The Timer View Controller displays a countdown of the current round and has a Start button to start the timer.

- Add a label and button to the timer screen using a XIB
- Add IBOutlets for the ```timerButton``` and ```timerLabel```
- Add an IBAction for the ```timerButton``` that will trigger the timer (leave method empty for now)

###Step 3: Create a RoundsController

- Create a ```sharedInstance``` class method on ```RoundsController``` that returns a singleton ```RoundsController``` instance
- Add a public, readonly property of type NSArray called ```roundTimes```
	- In the implementaion file, override the roundTimes getter method and return this array ```@[@25, @5, @25, @5, @25, @5, @25, @15]```
- Add a public property of type NSInteger called ```currentRound```

###Step 4: Create a timer class

Use a separate [Timer](https://github.com/DevMountain/The-Pomodoro/blob/solution-day1/The-Pomodoro-iOS8/Timer.m) class to manage the timer. This timer class holds the minutes and seconds and has a method to begin counting down. 
Pay attention to what the class does for you, walk through each method, understand what it is doing.

- Create a ```POTimer``` Class as a Shared Instance
- Add public properties of type NSInteger for ```minutes``` and ```seconds```
- Create public static NSStrings with names from above table (```SecondTickNotification```, ```RoundCompleteNotification```, ```NewRoundNotification```)
- Add a private BOOL property called ```isOn``` to allow you to check if the timer is active
- Add a public void method called ```startTimer```
  - ```startTimer``` should turn ```isOn``` to YES
  - ```startTimer``` should call ```checkActive``` (which you will write below)
- Add a private void method called ```endTimer```
  - ```endTimer``` should turn ```isOn``` to NO and send a ```RoundCompleteNotification``` that the timer has finished
- Add a private void method called ```decreaseSecond```
  - ```decreaseSecond``` should decrease one second from the remaining time and send a ```SecondTickNotification``` notification that one second passed
  	- don't forget to change minutes, if necessary
  	- if the timer has elpased, then call ```endTimer```
- Add a private void method called ```checkActive```
  - ```checkActive``` should check if the timer is on (```self.isOn```), and if so, call the ```decreaseSecond``` method, then it should call itself in one second
  - before the if statement, make sure you cancel previous perform requests
- Add a public void method called ```cancelTimer```
  - ```cancelTimer``` should turn ```isOn``` to NO
  - ```cancelTimer``` should cancel previous perform requests

###Step 5: Update TimerViewController User Interface and Implementation File

- Add a method to your ```TimerViewController``` to update the ````timerLabel``` from the ```sharedInstance``` of ```Timer```.
- Subscribe your ```TimerViewController``` to run the update label method on the ```SecondTickNotification```.
  - ```registerForNotifications``` should be placed in a custom init method.
- Unsubscribe your ```TimerViewController``` from notifications when instances are deallocated.
- In your timer button pressed method (written above but left empty), call ```startTimer``` on ```sharedInstace``` of ```Timer```.
  - note: We need to disable the button while the timer is going.
- At this point we can test that our timer works and the update label method works:
  - in the ```dispatch_once``` method, set ```sharedInstance.minutes``` and ```sharedInstance.seconds``` to whatever values you want to test (might be smart to make sure the minute decreases appropriately)
  - build and run the app
  - your timer label won't update until you tap start timer button
  - your timer should be counting down correctly
  - remove the lines of code where you set ```minutes``` and ```seconds```

###Step 6: Add a tableview and datasource methods to the rounds view controller

- Create a ```tableView``` property on the ```RoundsViewController``` and instantiate it with style UITableViewStyleGrouped
- set ```self``` as datasource and delegate of ```tableView```
- Add the ```tableView``` to the ```RoundsViewController```'s ```view```
- Add required datasource methods to display cells that the user can use to select which round they want to start
  - The cell should display the number of minutes in the round (which can be retieved from the ```RoundsController```)
- In the ```RoundsController``` add a public, void method, ```roundSelected```
  - that will update the minutes and seconds on the ```[Timer sharedInstance]``` from the ```currentRound``` property
  - that will send a ```NewRoundNotification``` notification
- In the ```RoundsViewController```, add didSelectRowAtIndexPath
  - set the ```currentRound``` property of ```[RoundsViewController sharedInstance] to the indexPath.row
  - and call ```roundSelected```
  - and call ```cancelTimer```

###Step 7: Add observer notifications

- Add ```RoundsViewController``` as observer of ```RoundCompleteNotification```
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
- Add ```TimerViewController``` as observer of ```RoundCompleteNotification```
  - ```-(void)newRound```
- Don't forget to register in the init and unregister in the dealloc

##Day 2 - UIAppearance

### Step 8: Stylize the App

- Create an ```AppearanceController``` object (make sure to import UIKit, if you need to)
  - Add a class method called ```initializeAppearanceDefaults```
    - Update navigationBar color
    - Update navigationBar title font and text color
    - Update the tint color on the tab bar
- Import the ```AppearanceController``` and call the method in the ```AppDelegate```
- Add images to the tableViewCells
  - Add a public method that returns an NSArray of imageNames for each round called ```imageNames```
    - Example: ```@[@"work.png", @"play".png, @"work.png", @"play".png, @"work.png", @"play".png, @"work.png", @"nap.png"]```
  - In the cellForRowAtIndexPath method, set the image of the imageView of the cell to a UIImage with file named ```[Rounds Controller imageNames][indexPath.row]```

##Day 3 - UILocalNotifications and UIAlertController

### Step 9: Add an ```expirationDate``` property to ```Timer```
- Create a private, NSDate property on ```Timer``` called ```expirationDate```
- In the ```startTimer``` method, set ```expirationDate``` to the date (time)
 when the timer will expire

### Step 10: Add a UILocalNotification
- Import UIKit to ```Timer```
- In the ```startTimer``` method of ```Timer```, instantiate a UILocalNotification.
- Set the following properties on your UILocalNotifiation
  - fireDate
  - timeZone
  - soundName
  - alertBody
- Don't forget to schedule the notification
- In ```cancelTimer```, cancel all local notifications
- In the AppDelegate, in applicationDidBecomeActive, registerUserNotifcationsSettings

### Step 11: Add a UIAlertController to handle UILocalNotifications while in app
- Implement the didRecieveLocalNotification method in AppDelegate
  - Create a UIAlertController
  - Add an action to dismiss alert and do nothing
  - Add an action to start the next round
    - Use completion handler to call ```startTimer```
  - Present UIAlertController instance

### Step 12: Prepare and load the timer from background
- Add a public, void method called ```prepareForBackground``` to ```Timer```
  - store the ```expirationDate``` property to NSUserDefaults
  - syncronize the NSUserDefaults
- Add a public, void method called ```loadFromBackground``` to ```Timer```
  - set ```expirationDate``` to the expirationDate from NSUserDefault
  - get the time between now and ```expirationDate``` to set the timer
  - set the timer
- In the AppDelegate method applicationDidEnterBackground, call ```prepareForBackground``` on the ```Timer``` ```sharedInstance```
- In the AppDelegate method applicationWillEnterForeground, call ```loadFromBackground``` on the ```Timer``` ```sharedInstance```
