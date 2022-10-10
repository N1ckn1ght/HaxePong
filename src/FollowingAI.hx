class FollowingAI {
    public var speed: Float;
    public var offset: Float;
    var racket: Racket;
    var ball: Ball;

    public function new(racket: Racket, ball: Ball, speed: Float) {
        this.racket = racket;
        this.ball = ball;
        this.speed = speed;
        offset = 0;
    }

    public function update(dt: Float) {
        var movement = dt * speed;
        var distance = racket.location.y - ball.location.y - offset;
        if (movement < Math.abs(distance)) {
            if (ball.location.y + offset > racket.location.y) {
                racket.location.y += movement;
            } else {
                racket.location.y -= movement;
            }
        } else {
            racket.location.y = ball.location.y + offset;
        }
    }

    public function randomizeOffsetY() {
        var half = racket.length / 2;
        offset = Random.float(-half, half);
    }
}