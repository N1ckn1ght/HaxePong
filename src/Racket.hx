import h2d.Graphics;
import h2d.Scene;

enum Side {
    Left;
    Right;
}

class Racket {
    public var location(default, default): Vector2d;
    public var length(default, null): Float;
    public var side(default, null): Side;
    var racket: Graphics;
    var lowerBound: Float;
    var upperBound: Float;

    public function new(location: Vector2d, side: Side, length: Float, window: Float, scene: Scene) {
        racket = new Graphics(scene);
        this.location = location;
        this.length = length;
        this.side = side;
        lowerBound = length / 2 + window;
        upperBound = Const.height - lowerBound;
        redraw();
    }

    public function update(dt: Float) {
        applyBoundaries();
        racket.setPosition(location.x, location.y);
    }

    public function setLength(length: Float) {
        var diff = length - this.length;
        lowerBound += diff / 2;
        upperBound -= diff / 2;
        this.length = length;
        redraw();
    }

    function applyBoundaries() {
        if (location.y < lowerBound) {
            location.y = lowerBound;
        } else if (location.y > upperBound) {
            location.y = upperBound;
        }
    }

    function redraw() {
        racket.clear();
        racket.beginFill(0xFFFFFF);
        // racket.drawRect(-Const.racketWidth / 2, -length / 2, Const.racketWidth, length);
        if (side == Left) {
            racket.lineTo( Const.racketWidth / 2, -length / 2);
            racket.lineTo( Const.racketWidth / 2,  length / 2);
            racket.lineTo(-Const.racketWidth / 2, 0);
            racket.lineTo( Const.racketWidth / 2, -length / 2);
        } else {
            racket.lineTo(-Const.racketWidth / 2, -length / 2);
            racket.lineTo(-Const.racketWidth / 2,  length / 2);
            racket.lineTo( Const.racketWidth / 2, 0);
            racket.lineTo(-Const.racketWidth / 2, -length / 2);
        }
        racket.endFill();
    }
}