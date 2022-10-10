class Const {
    // Window
    // Screen size to scale from, width in pixels. Default = 1280;
    public static inline var width: Int = 1280;
    // Screen size to scale from, height in pixels. Default = 720;
    public static inline var height: Int = 720;

    // Gameplay elements
    // Score, required to win the game. Default = 10;
    public static inline var winningScore: Int = 10;
    // How close angle of flying ball could be to +-Pi/2, in radians. Default = 0.4;
    public static inline var angleLimit: Float = 0.4;
    // Ball radius (collision detector will see it as rectangle), in pixels. Default = 6;
    public static inline var ballRadius: Float = 6;
    // Ball's velocity multiplier on collision, optional. Default = 1;
    public static inline var ballAccelerationCollision: Float = 1;
    // Ball's velocity multipler on time. Default = 30;
    public static inline var ballAccelerationDT: Float = 30;
    // Initial ball speed on X axis by start of every round. Default = 120;
    public static inline var ballSpeed: Float = 120;
    // Racket width in pixels. Default = 14;
    public static inline var racketWidth: Float = 14;
    // Initial racket length. Default = height * 0.09;
    public static inline var racketHeight: Float = height * 0.09;
    // Upper and lower areas of the screen that racket can't cover, in pixels. Default = height / 26;
    public static inline var racketMissWindow: Float = height / 26;
    // How much of racket length player will lose by win a round, optional. Default = 0;
    public static inline var racketShrinkPerWin: Float = 0;
    // Timer in-between rounds and at the start of the game, in seconds. Default = 2;
    public static inline var pauseTimer: Float = 2;
    // Maximum speed of FollowingAI's Racket, pixels per second. Default = 480;
    public static inline var followingAISpeed: Float = 480;
    
    // Decorative spacings
    // Empty space between (center of) rackets and sides of the screen. Default = racketWidth;
    public static inline var spacing: Float = racketWidth;

    // Testing
    // Unlock additional (cheating) key commands and show FPS. Default = false;
    public static inline var debugMode = true;
}