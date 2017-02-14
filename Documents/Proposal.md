# FingerBlade
###### Eric T Cormack
Solo project

## Description
FingerBlade is an application that records user input and delivers it to an AWS
server for later use in training a neural network to recognize gestures.

## Background
I have been thinking of creating a pedogogical application of the Chicago
Swordplay Guild. In my head, it would have a game-like component which may be
used to study the guild's set plays when one is out or lacking one's sword by
substituting one's finger as both sword and feet. My intent is to do this with a
custom gesture recognizer. One would swipe one's finger across the screen for
the cut and to determine the length of the cut's tempo, the user would precede
the swipe with a number of taps.

While the treatise whence we draw our material defines seven different lines of
attack with a sword, this is more of a mnemonic device using medieval
numerology. By mine own reckoning, once I differentiate between false edge and
true edge cuts, or full versus half cuts, there are about fourteen different
cuts and thrusts that could be made and would need to be distinguished for a
programmatic representation.

My feeling is that the manual adjustments that are needed to let a custom
recognizer differentiate between some of these gestures (especially if one
includes *cavazioni* into the variations). It might be reasonable to train a
neural network to recognize the differences from these finger swipes.

Thus, my goal for this particular project is to build an application that
directs users to make examples of the proposed gestures, records them and sends
them to storage to be used in training the neural network.

## API's to be used
* **Multitouch**: for gesture recognition
* **Quartz 2D**: for illustrating the gestures
* **Amazon WebServices S3**: for transmitting captured gestures

## Screens
Screen on first load:<br />
![First time loaded](http://i.imgur.com/ZLYLjb3.png)

Transitions to:<br />
![Are you a toll or a smol?](http://imgur.com/1UtVydn.png)

Transitions to:<br />
![Who are you?](http://imgur.com/13axD2O.png)

Transitions to:<br />
![Tappy Swipey](http://imgur.com/RuOq46K.png)<br />
This will continue through 10(?) iterations of each cut, or until the user click
'Cancel'.

On complete, transitions to:<br />
![Thanks!](http://imgur.com/tV4f14v.png)

Previous screen transitions here, or if user canceled out of sampling:<br />
![Settings & al.](http://imgur.com/HCi0YsC.png)<br />
If user had canceled, they can resume. If they had completed it, it would start
anew.
