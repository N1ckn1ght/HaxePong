## Pong!

![2](https://user-images.githubusercontent.com/50321432/194854879-57458d60-9a6e-4a73-9bcc-ea3329f0217f.png)

###### Controls:

Use mouse to move your racket;

P - Pause;

F - Fullscreen;

Q - Quit;

Additional commands, if you have debug mode on:

O - Override AI controls on the second racket;

NumPad+ - Double the ball's speed;

NumPad- - Halv the ball's speed;

NumPad0 - Increase length of both rackets by 50 pixels.

###### Known issues:

First collision with the ball may cause a lag spike because of first sound playback.

Collision calculations with ball are made like it is a square, not an actual ball.

No side collision.

###### Known features (completely not bugs):

As in original classic Atari Pong, there are such "windows" at the corners of the screen that any racket can't cover. Hit the ball at the right angle to get a guarantee win!

There's a limit on which angle ball can move on - it never will move from upper side to the lower side of the screen without (or with really low) moment on X axis.

Yep, rackets are not rectangles (kinda because of collision issue).

###### Want more?

Check out the "Const.hx" file to play with numbers as well.

###### Gameplay footage:

https://youtu.be/aHqnN17qG-w 

###### Executable:

Keep in mind, this is not official release. It will spam some debug information =)

https://disk.yandex.ru/d/Yx8Prj0OshaZBQ
