import h2d.Graphics;
import h2d.Scene;

class Ball {
    public var location(default, default): Vector2d;
    public var velocity(default, default) = Vector2d.zero();
    public var acceleration(default, null): Float = 0;
    public var radius(default, null): Float;
    var ball: Graphics;

    public function new(location: Vector2d, radius: Float, scene: Scene) {
        ball = new Graphics(scene);
        this.location = location;
        this.radius = radius;
        redraw();
    }

    public function update(dt: Float) {
        location = location.add(velocity.mult(dt));
        applyVerticalBoundaries();
        ball.setPosition(location.x, location.y);
        accelerate(acceleration * dt);
    }

    public function setInitialVelocity(velocity: Vector2d, acceleration: Float = 0) {
        this.velocity = velocity;
        this.acceleration = acceleration;
    }

    function accelerate(a: Float) {
        var unsignedVelocityX = Math.abs(velocity.x);
        var unsignedVelocityY = Math.abs(velocity.y);
        if (unsignedVelocityX + unsignedVelocityY == 0 || a == 0) {
            return;
        }
        var fractionX = unsignedVelocityX / (unsignedVelocityX + unsignedVelocityY);
        var fractionY = 1 - fractionX;
        if (velocity.x < 0) {
            velocity.x -= a * fractionX;
        } else {
            velocity.x += a * fractionX;
        }
        if (velocity.y < 0) {
            velocity.y -= a * fractionY;
        } else {
            velocity.y += a * fractionY;
        }
    }

    function applyVerticalBoundaries() {
        if (location.y < radius) {
            location.y = radius * 2 - location.y;
            velocity.y = -velocity.y;
        } else if (location.y > Const.height - radius) {
            location.y = Const.height * 2 - radius * 2 - location.y;
            velocity.y = -velocity.y;
        }
    }

    function redraw() {
        ball.clear();
        ball.beginFill(0xFF0000);
        ball.drawCircle(0, 0, radius);
        ball.endFill();
    }
}