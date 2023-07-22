package;

import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.io.Path;
import openfl.utils.Assets;

using StringTools;

class AssetPaths
{
	public static inline function data(key:String):String
	{
		return 'assets/data/$key.json';
	}

	public static inline function script(key:String):String
	{
		return 'assets/data/$key.hxs';
	}

	public static inline function sound(key:String):String
	{
		return 'assets/sounds/$key.wav';
	}

	public static inline function music(key:String):String
	{
		return 'assets/music/$key.ogg';
	}

	public static inline function shader(key:String):String
	{
		return 'assets/shaders/$key';
	}

	public static inline function font(key:String):String
	{
		return 'assets/fonts/$key';
	}

	public static inline function sprite(key:String):String
	{
		return 'assets/images/$key.png';
	}

	public static function spritesheet(key:String):FlxAtlasFrames
	{
		var atlas:FlxAtlas = new FlxAtlas('assets/images/$key');

		for (i in 0...Assets.list(IMAGE).filter(n -> n.startsWith('assets/images/$key').length)
			atlas.addNode('assets/images/$key_$i.png', '$key$i');

		return atlas.getAtlasFrames();
	}
}
