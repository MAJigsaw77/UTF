package;

import openfl.utils.Assets;

class Paths
{
	public static inline function data(key:String):String
		return 'assets/data/$key.json';

	public static inline function script(key:String):String
		return 'assets/data/$key.hxs';

	public static inline function sprite(key:String):String
		return 'assets/images/$key.png';

	public static inline function sound(key:String):String
		return 'assets/sounds/$key.wav';

	public static inline function music(key:String):String
		return 'assets/music/$key.ogg';

	public static inline function font(key:String):String
		return 'assets/fonts/$key';
}
