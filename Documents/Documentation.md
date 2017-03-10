# FingerBlade
Eric T Cormack<br />
CSC 471<br />
14 Mar 2017<br />
Final Project Documentation

## Welcome
![Welcome screen][Welcome]
Splash screen. Not much going on here.

## Hand Selection
![Hand selection screen][Hand]
Here the user selects their handedness. Animation will be flipped accordingly
for better simulation and to more accurately correspond to how the user would
make the cut. This is stored as a string in the `UserDefaults`.

## Subscription
![Email subscription screen][Email]
Here the user may enter their email if they wish to be informed when future apps
are made. The email is validated against a regex before it is saved. If the user
does enter their email, an action sheet will appear confirming their desire to
subscribe. If canceled the text field is cleared and no email is saved. An email
is not required to continue. The value is stored as a string in `UserDefaults`.

## Tutorial and Cut Input
![Tutorial screen][Tutorial]
After the subscription scene, a tutorial appears to show the user how to
interact using the custom made `UITapSwipeGestureRecognizer`. First the user
must tap at the dot. Then the user must swipe along the animated path. Finally,
the user is asked to tap and swipe along the path. All the dot and line
animations are made using the Core Animation/Quartz suite using `CAShapeLayer`s
animating along the stroke and line width of the generated Bezier paths. The
text animation is made with the same libraries but using `CAKeyframeAnimation`.
The count and completion flashes are also animated, this time using the
`CALayer` animation class.

Upon completion of the sample collection. The sample is written to a temporary
file and then uploaded to Amazon Web Services' Simple Storage Solution using
their API.

## Main Menu
![Main menu screen][Menu]
After the user completes the tutorial cuts and any time after when they open the
application, they will be taken to the main menu. From here they can return to
either the subscription or hand selection screens to alter their choices or
proceed to submit a new sample.

## Sample menu
![Sample menu screen][Setup]
Here the user can select which cuts they would like to submit for a new sample,
as well as how many iterations of the cuts that they would submit. Pressing
"Select all" will turn all the switches on. Selecting any of the cells labeled
with a cut will toggle its switch, as would touching the switch itself. From
here, they are taken to the cut input scene again to make new cuts.

[Welcome]: http://imgur.com/ypb3gcz
[Hand]: http://imgur.com/f9PKGVi
[Email]: http://imgur.com/027q3qD
[Tutorial]: http://imgur.com/vFsPJgv
[Menu]: http://imgur.com/OHzj92a
[Setup]: http://imgur.com/bRiSqvE
