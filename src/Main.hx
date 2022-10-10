import h2d.Graphics;
import h2d.Text;
import hxd.Cursor;
import hxd.Event;
import hxd.System;
import hxd.Window;
import hxd.res.Sound;

class Main extends hxd.App {
    var overrideControls: Bool;
    var pause: Bool;
    var side: Int;
    var timer: Float;
    var window: Window;

    var ball: Ball;
    var collisionDetector: CollisionDetector;
    var customEventHandler: CustomEventHandler;
    var followingAI: FollowingAI;
    var racketAI: Racket;
    var racketHuman: Racket;

    var over: Bool = false;
    var scoreHuman: Int = 0;
    var scoreAI: Int = 0;

    var fpsLabel: Text;
    var scoreHumanLabel: Text;
    var scoreAILabel: Text;

    var soundGameOver: Sound = null;
    var soundPong: Sound = null;
    var soundVictory: Sound = null;

    function initSound() {
        if (Sound.supportedFormat(Wav)) {
            soundGameOver = hxd.Res.gameover;
            soundPong = hxd.Res.pong;
            soundVictory = hxd.Res.victory;
        }
    }

    function initVisual() {
        s2d.scaleMode = Stretch(Const.width, Const.height);
        fpsLabel = new Text(hxd.res.DefaultFont.get(), s2d);
        fpsLabel.setScale(2);
        
        var atariClassic = hxd.Res.AtariClassic.toFont();
        var scoreColor = 0x505050;
        scoreHumanLabel = new Text(atariClassic, s2d);
        scoreHumanLabel.textAlign = Center;
        scoreHumanLabel.setPosition(Const.width / 4, 0);
        scoreHumanLabel.setScale(4);
        scoreHumanLabel.textColor = scoreColor;
        scoreAILabel = new Text(atariClassic, s2d);
        scoreAILabel.textAlign = Center;
        scoreAILabel.setPosition(Const.width * 3 / 4, 0);
        scoreAILabel.setScale(4);
        scoreAILabel.textColor = scoreColor;
        showScore();

        var line = new Graphics(s2d);
        var lineColor = 0x404040;
        line.beginFill(lineColor);
        line.drawRect(Const.width / 2 - 1, 0, 2, Const.height);
        line.endFill();

        var help = new Text(atariClassic, s2d);
        var helpColor = 0x303030;
        help.textAlign = Center;
        help.setPosition(Const.width / 2, Const.height * 5 / 6);
        help.setScale(1);
        help.textColor = helpColor;
        help.text = ('[P] - Pause\n[F] - Fullscreen\n[Q] - Quit');
    }

    function onEvent(event: Event) {
        if (event.kind == EKeyDown) {
            if (Const.debugMode) {
                if (event.keyCode == hxd.Key.NUMPAD_ADD) {
                    ball.velocity.x *= 2;
                    ball.velocity.y *= 2;
                }
                if (event.keyCode == hxd.Key.NUMPAD_SUB) {
                    ball.velocity.x /= 2;
                    ball.velocity.y /= 2;
                }
                if (event.keyCode == hxd.Key.NUMPAD_0) {
                    racketHuman.setLength(racketHuman.length + 50);
                    racketAI.setLength(racketAI.length + 50);
                }
                if (event.keyCode == hxd.Key.O) {
                    overrideControls = !overrideControls;
                }
            }
            if (event.keyCode == hxd.Key.F) {
                if (window.displayMode == DisplayMode.Borderless) {
                    window.displayMode = DisplayMode.Windowed;
                } else {
                    window.displayMode = DisplayMode.Borderless;
                }
            }
            if (event.keyCode == hxd.Key.P) {
                pause = !pause;
            }
            if (event.keyCode == hxd.Key.Q) {
                System.exit();    
            }
        }
    }

    function playSoundGameOver() {
        if (soundGameOver != null) {
            soundGameOver.play();
        }
    }

    function playSoundPong() {
        if (soundPong != null) {
            soundPong.play();
        }
    }

    function playSoundVictory() {
        if (soundVictory != null) {
            soundVictory.play();
        }
    }

    function restart() {
        ball.velocity = new Vector2d(0, 0);
        ball.location = new Vector2d(Const.width / 2, Const.height / 2);
        racketAI.setLength(Const.racketHeight - Const.racketShrinkPerWin * scoreAI);
        racketHuman.setLength(Const.racketHeight - Const.racketShrinkPerWin * scoreHuman);
        timer = Const.pauseTimer;
    }

    function showFPS(fps: Int) {
        if (fps < 60) {
            fpsLabel.textColor = 0xff0000;
        } else {
            fpsLabel.textColor = 0x00ff00;
        }
        fpsLabel.text = 'FPS = ${fps}';
    }

    function showScore() {
        scoreAILabel.text = '$scoreAI';
        scoreHumanLabel.text = '$scoreHuman';
    }

    override function init() {
        hxd.Res.initEmbed();
        @:privateAccess haxe.MainLoop.add(() -> {});

        window = Window.getInstance();
        window.displayMode = DisplayMode.Borderless;
        window.addEventTarget(onEvent);
        initSound();
        initVisual();
        
        ball = new Ball(new Vector2d(Const.width / 2, Const.height / 2), Const.ballRadius, s2d);
        racketAI = new Racket(new Vector2d(Const.width - Const.spacing, Const.height / 2), Racket.Side.Right, Const.racketHeight, Const.racketMissWindow, s2d);
        racketHuman = new Racket(new Vector2d(Const.spacing, Const.height / 2), Racket.Side.Left, Const.racketHeight, Const.racketMissWindow, s2d);
        customEventHandler = new CustomEventHandler();
        followingAI = new FollowingAI(racketAI, ball, Const.followingAISpeed);
        customEventHandler.addCallback(followingAI.randomizeOffsetY);
        customEventHandler.addCallback(playSoundPong);
        collisionDetector = new CollisionDetector(customEventHandler);        
        collisionDetector.track(racketHuman, ball);
        collisionDetector.track(racketAI, ball);

        overrideControls = false;
        pause = false;
        side = -1;
        timer = Const.pauseTimer;
    }
    
    override function update(dt: Float) {
        System.setNativeCursor(Cursor.Hide);
        if (Const.debugMode) {
            showFPS(Math.round(1 / dt));
        }
        if (pause || over) {
            return;
        }

        // Calculations to prevent "sticking" effect on sides of the screen
        racketHuman.location.y = s2d.mouseY * (1 - Const.racketMissWindow * 2 / Const.height) + Const.racketMissWindow;
        if (ball.velocity.x > 0) {
            followingAI.update(dt);
        }
        if (overrideControls) {
            racketAI.location.y = racketHuman.location.y;
        }

        if (timer > 0) {
            timer -= dt;
            if (timer <= 0) {
                ball.setInitialVelocity(new Vector2d(Const.ballSpeed * side, Random.float(-Const.ballSpeed / 3, Const.ballSpeed / 3)), Const.ballAccelerationDT);
            }
        }

        racketHuman.update(dt);
        racketAI.update(dt);
        ball.update(dt);
        collisionDetector.update(dt);

        if (ball.location.x < 0) {
            side = -1;
            scoreAI += 1;
            if (scoreAI > Const.winningScore - 1) {
                over = true;
                playSoundGameOver();
            } else {
                restart();
            }
            showScore();
        }
        if (ball.location.x > Const.width) {
            side = 1;
            scoreHuman += 1;
            if (scoreHuman > Const.winningScore - 1) {
                over = true;
                playSoundVictory();
            } else {
                restart();
            }
            showScore();
        }
    }

    public static function main() {
        new Main();
    }
}