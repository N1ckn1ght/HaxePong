class CollisionDetector {
    var tracker: Array<TrackedPair>;
    var eventHandler: CustomEventHandler;

    public function new(eventHandler: CustomEventHandler) {
        this.eventHandler = eventHandler;
        tracker = [];
    }

    public function update(dt: Float) {
        var collide: Vector2d;
        for (pair in tracker) {
            var frontX = pair.racket.location.x;
            var collX = Const.racketWidth / 2 + pair.ball.radius;
            if (pair.ball.velocity.x < 0) {
                if (pair.racket.side == Racket.Side.Right) {
                    continue;
                }
                frontX += collX;
            } else {
                if (pair.racket.side == Racket.Side.Left) {
                    continue;
                }
                frontX -= collX;
            }

            var halfLength = pair.racket.length / 2 + pair.ball.radius;
            var lowerY = pair.racket.location.y + halfLength;
            var upperY = pair.racket.location.y - halfLength;
            var motionX = pair.ball.velocity.x * dt;
            var motionY = pair.ball.velocity.y * dt;

            // Front collision
            collide = getLineIntersection(
                new Vector2d(frontX, lowerY),
                new Vector2d(frontX, upperY),
                new Vector2d(pair.ball.location.x - motionX, pair.ball.location.y - motionY),
                new Vector2d(pair.ball.location.x, pair.ball.location.y));
            if (collide.x != -1) {
                trace('Front collide proc! For racket at: ${pair.racket.location.toString()}');
                // var motionLeft = Math.sqrt(motionX * motionX + motionY * motionY) - Math.sqrt((collide.x - pair.ball.location.x) * (collide.x - pair.ball.location.x) - (collide.y - pair.ball.location.y) * (collide.y - pair.ball.location.y));
                
                var z = (collide.y - pair.racket.location.y) / halfLength;
                trace('Passed z: $z, angle: ${Math.PI / 4 * z}');
                pair.ball.location.x = collide.x;
                pair.ball.location.y = collide.y;
                eventHandler.handleCollision(pair.ball, (Math.PI / 4) * z, 0);
                continue;
            }

            // TODO: Side collision, on lower and upper Y; probably even back collision for multiple possibly rackets on different x-axis.
            // Problem - need tracking of previous racket.location as well for side collision.
        }
    }

    public function track(racket: Racket, ball: Ball) {
        tracker.push(new TrackedPair(racket, ball));
    }

    function getLineIntersection(point00: Vector2d, point01: Vector2d, point10: Vector2d, point11: Vector2d): Vector2d {
        // Credit: https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
        var dx0 = point01.x - point00.x;
        var dx1 = point11.x - point10.x;
        var dy0 = point01.y - point00.y;
        var dy1 = point11.y - point10.y;
        var denum = (-dx1 * dy0 + dx0 * dy1);
        if (denum != 0) {
            var s = (dx0 * (point00.y - point10.y) - dy0 * (point00.x - point10.x)) / denum;
            var t = (dx1 * (point00.y - point10.y) - dy1 * (point00.x - point10.x)) / denum;
            if (s > 0 && s < 1 && t > 0 && t < 1) {
                return new Vector2d(point00.x + (t * dx0), point00.y + (t * dy0));
            }
        }
        return new Vector2d(-1, -1);
    }
}

class TrackedPair {
    public var racket: Racket;
    public var ball: Ball;
    
    public function new(racket: Racket, ball: Ball) {
        this.racket = racket;
        this.ball = ball;
    }
}