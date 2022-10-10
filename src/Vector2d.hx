class Vector2d {
    public var x: Float;
    public var y: Float;

    public function new(x: Float, y: Float) {
        this.x = x;
        this.y = y;
    }

    public function toString() {
        return 'Vector($x, $y)';
    }

    public function add(other: Vector2d) {
        return new Vector2d(x + other.x, y + other.y);
    }

    public function sub(other: Vector2d) {
        return new Vector2d(x - other.x, y - other.y);
    }

    public function mult(value: Float) {
        return new Vector2d(x * value, y * value);
    }

    public function div(value: Float) {
        return new Vector2d(x / value, y / value);
    }

    public function mag() {
        return Math.sqrt(x * x + y * y);
    }

    public function norm() {
        return div(mag());
    }

    public function limit(max: Float) {
        var mag: Float = mag();
        if (mag > max) {
            return norm().mult(max);
        }
        return copy();
    }

    public function copy() {
        return new Vector2d(x, y);
    }

    public static function zero() {
        return new Vector2d(0, 0);
    }

    public static function random(xmin, xmax, ymin, ymax) {
        return new Vector2d(Random.float(xmin, xmax), Random.float(ymin, ymax));
    }
}