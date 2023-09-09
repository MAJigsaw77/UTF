package backend;

import flixel.FlxG;

class Util
{
	public static function randomRange(a:Float, b:Float):Float
	{
		return FlxG.random.float(0, Math.abs(a - b)) + Math.min(a, b);
	}
}
