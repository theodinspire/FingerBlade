# FingerBlade
Eric T Cormack<br />
CSC 471<br />
14 Mar 2017<br />
Final Project Documentation

## Description
### Welcome
![Welcome screen][Welcome]

Splash screen. Not much going on here.

### Hand Selection
![Hand selection screen][Hand]<br />
Here the user selects their handedness. Animation will be flipped accordingly
for better simulation and to more accurately correspond to how the user would
make the cut. This is stored as a string in the `UserDefaults`.

### Subscription
![Email subscription screen][Email]<br />
Here the user may enter their email if they wish to be informed when future apps
are made. The email is validated against a regex before it is saved. If the user
does enter their email, an action sheet will appear confirming their desire to
subscribe. If canceled the text field is cleared and no email is saved. An email
is not required to continue. The value is stored as a string in `UserDefaults`.

### Tutorial and Cut Input
![Tutorial screen][Tutorial]<br />
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

### Main Menu
![Main menu screen][Menu]<br />
After the user completes the tutorial cuts and any time after when they open the
application, they will be taken to the main menu. From here they can return to
either the subscription or hand selection screens to alter their choices or
proceed to submit a new sample.

### Sample menu
![Sample menu screen][Setup]<br />
Here the user can select which cuts they would like to submit for a new sample,
as well as how many iterations of the cuts that they would submit. Pressing
"Select all" will turn all the switches on. Selecting any of the cells labeled
with a cut will toggle its switch, as would touching the switch itself. From
here, they are taken to the cut input scene again to make new cuts.

## Discussion
### API
#### Quartz Animation
*FingerBlade* makes heavy use of iOS' native animation API: Quartz 2D and Core
Animation, with much of the working hours spent tweaking and finagling the
animation code to present well. I set up a collection of reference points, and
built the program to build animation paths between two of these points, often
using a third as an anchor for a Bezier curve. The program then asks the
animation API to first stroke the minimum distance,
`CGFloat.leastNonzeroMagnitude`, with the line weight growing from and shrinking
back to the line's regular weight to indicate where to tap the device. The
animation then follows to stroke down the remaining length of the path, with
the tail of the stroke to come chasing after.

I similarly used the animation suite to animate the position of the
instructions during the tutorial. The major difference between the word and the
line animations, since the words were placed with `UILabel` objects, whereas the
lines were in the animation objects themselves, is that the words were animated
by adding a `CAKeyframeAnimation` layer to the word's `UILabel` using the
`position` key, when the lines were animated with `CABasicAnimation` objects,
using the keys `lineWeight`, `strokeEnd` and `strokeStart`, grouped and timed
with `CAAnimationGroup`s and added to a `CAShapeLayer`.

Animation, again using the `CABasicAnimation` was also employed in the messages
telling the user what cut number they have made and whether they were done with
the cut set, on the keys `opacity` and `transform.scale`.

I'm not entirely certain which of these were or were not covered in lecture, as
I developed all these animations the weekend before this was discussed in class.
However, using all these animation, as well as refactoring them to make cleaner
code for the project really reinforced my understanding of the Core Animation
and Quartz 2D API's. I would be quite glad to be able to use these skills again
in more projects.

#### MultiTouch
*FingerBlade* makes use of a custom `UIGuestureRecognizer` to capture the cut
strokes inputted by the user. Because the native `UITapGestureRecognizer` and
`UISwipeGestureRecognizer` have been so tuned to their respective singular
gestures, but I wanted to employ zero, one or two taps preceding the swipe as a
stand in for sword fighting time—if perhaps in a false time—I felt it easiest
to create mine own `UITapSwipeGestureRecognizer`. Were I to have kept the native
gestures, my user would've been able to split the stroke up into two smaller
strokes, which goes against my desire that they commit to the tempo before they
make the stroke. Similarly, it can be a smidge difficult to pull the stroke
information out of swipe gesture. I have much more control over this with my own
gesture recognizer.

There is a bit of it that I changed once we covered the topic in class; I hadn't
realized that there was already a process going on that counted the number of
taps within a certain time frame, and as such, I had built a timer and counter
into my recognizer. Once the topic was covered in class, I removed the redundant
code and it made my code a bit cleaner.

#### Amazon Web Services, Simple Storage Solution
When I was looking for a way to collect the data that this app would generate,
a friend suggested that I simply set up an FTP server and collect the data that
way. But when I started researching the process on iOS, I found that the FTP
API was deprecated. So, instead of using outdated and unsupported methods, I
turned to AWS instead.

The whole process took multiple attempts. I don't know if the documentation on
the API wasn't very clear, or that I was so new to the process, but it just
wasn't clicking. (Thinking about it now, the AWS information might've been
written for Objective C, or was in general outdated.) But, after combing through
some examples on GitHub, I was able to get it to work for my needs.

The whole process involves setting up an access group through their Identity and
Access Management product, and then setting up a bucket on S3 that allows
unauthenticated users to add files to the bucket. I've stored this information
into a keys.plist file which is listed in the `.gitignore` file to prevent
semi-private information from being listed on the internet for everyone to see.
My program pulls these keys and establishes a connection when the user is
finished with a sample.

### Challenges

The biggest challenges that I faced in the production of this application were
making a custom gesture recognizer and getting my program to talk to AWS.

When I first started building the gesture recognizer, I was loading it into the
app through the story board. But when I then attempted to pull the trail data
from the gesture recognizer, the program would crash throwing a bad access
error. The only way by which I have been able to avoid that is by adding the
recognizer to the scene programatically. This really blows because I was hoping
to construct it in such a way that anyone could just drop it into their
application, and be able to adjust its setting through the storyboard.

As for the AWS, as I have mentioned, I found their documentation wanting.
Eventually, I went through their tutorial, and copied another person's S3
exercise from GitHub to make sure that I had all the pieces in place properly.
I then removed the code from my example that involved pulling data out of the
bucket, and cleaned up the language to handle keys from an external file instead
of baking it into my program. I further tucked the code away and put it into a
singleton to make my later access to it all the easier on myself.

### Limitations

The one piece of my application that I wish I had been able to get into my
program but couldn't was storing the state of a sample that was being worked
upon when the user switched out of the application. I built the functionality
into my controller classes and into the `SampleStore` class to handle it easily,
but when I tried to store it in the `UserDefaults`, it became complicated.
Firstly, one may only store `NSObject` classes or their derived Swift forms in
the `UserDefaults`. Secondly, Swift collections, like the dictionary I am
storing the swipe trails in, do not play well with the serializing of container
`NSObject` classes. If I am to continue improving this application, I believe my
first step would be to start with finding an easy means of storing the samples
so that if a user leaves, it can be easily set up where they were.

Secondly, I wish it had been easier to have the stroking animation swipe through
the endpoints of the line. Currently, they swipe into a dot whose diameter is
the line weight, as the animations are merely done as lines with rounded line
caps. I would like it if it were to keep swiping until the end disappears,
instead of just down to a dot that blinks away. This may require more
complicated animations.

Thirdly, I would like to tackle the color scheme. It is currently all white,
grey and default colors. I would like a more colorful application.

My biggest gripe with XCode is its git integration: it's a little wonky. One may
pull other branches into one's working branch, making a mess of the heads and
what commits are pushed to what branch on the remote. I found it particularly
frustrating. I had taken to doing anything other than committing and pushing
into Terminal to keep my local and remote repositories clean.

As for Swift itself, I don't think I have found much to complain about. I find
it quite clear, and the `Optional`s make writing safe code pretty easy. I can
also write whatsoever closures I want—in fact, I have had to limit myself lest
I write everything in closures. The one complaint that comes to mind also
applies to every language I've worked with: I have had to build code to iterate
my way through a complete set of enumerations.

### Final Notes

Overall, I have found iOS development quite enjoyable. The robustness of the
included toolsets are enough to get an application up and running very quickly,
but at the same time deep enough that one could spend hours tweaking and playing
with the various features to get it just so. I am very eager to continue working
at building iOS applications and think it would be fun to make a career of it.


[Welcome]: http://i.imgur.com/ypb3gcz.png
[Hand]: http://i.imgur.com/f9PKGVi.png
[Email]: http://i.imgur.com/027q3qD.png
[Tutorial]: http://i.imgur.com/vFsPJgv.png
[Menu]: http://i.imgur.com/OHzj92a.png
[Setup]: http://i.imgur.com/bRiSqvE.png
