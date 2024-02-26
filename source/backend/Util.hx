package backend;

import flixel.FlxG;

class Util
{
	public static inline function randomRange(a:Float, b:Float):Float
	{
		return FlxG.random.float(0, Math.abs(a - b)) + Math.min(a, b);
	}

	public static inline function mod(n:Int, m:Int):Int
	{
		return ((n % m) + m) % m;
	}

	public static function getWeather():Int
	{
		final curDate:Date = Date.now();

		switch (curDate.getMonth() + 1)
		{
			case 12 | 1 | 2: // Winter
				return 1;
			case 3 | 4 | 5: // Spring
				return 2;
			case 6 | 7 | 8: // Summer
				return 3;
			case 9 | 10 | 11: // Autumn
				return 4;
		}

		return 0;
	}
}
