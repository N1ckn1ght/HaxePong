import format.hl.Data.AnyFunction;
import haxe.Constraints.Function;

class CustomEventHandler {
    var calls: Array<Function>;

    public function new() {
        calls = [];
    }

    public function addCallback(call: Function) {
        calls.push(call);
    }

    public function handleCollision(ball: Ball, angleAdd: Float, motionLeft: Float) {
        var angle = Math.atan2(ball.velocity.y, ball.velocity.x);
        trace('Old angle: $angle');
        var mag = ball.velocity.mag();
        if (ball.velocity.x < 0) {
            angle -= angleAdd;
            if (angle < Math.PI / 2 + Const.angleLimit && angle > 0) {
                angle =  Math.PI / 2 + Const.angleLimit;
            } else if (angle > -Math.PI / 2 - Const.angleLimit && angle < 0) {
                angle = -Math.PI / 2 - Const.angleLimit;
            }
        } else {
            angle += angleAdd;
            if (angle > Math.PI / 2 - Const.angleLimit) {
                angle =  Math.PI / 2 - Const.angleLimit;
            } else if (angle < -Math.PI / 2 + Const.angleLimit) {
                angle = -Math.PI / 2 + Const.angleLimit;
            }
        }
        trace('New angle: $angle');
        ball.velocity.x = -Math.cos(angle) * mag * Const.ballAccelerationCollision;
        ball.velocity.y = Math.sin(angle) * mag * Const.ballAccelerationCollision;
        // TODO - Not yet implemented: if (motionLeft > 0) {}
        trace('New ball velocity: ${ball.velocity}');
        trace('New ball coords: ${ball.location}');
        for (call in calls) {
            call();
        }
    }
}