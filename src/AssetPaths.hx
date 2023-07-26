package;

import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.FlxG;
import openfl.utils.Assets;

class AssetPaths
{
	public static inline function background(key:String):String
	{
		return 'assets/backgrounds/$key.png';
	}

	public static inline function font(key:String):String
	{
		return 'assets/fonts/$key';
	}

	public static inline function script(key:String):String
	{
		return 'assets/data/$key.hx';
	}

	public static inline function data(key:String):String
	{
		return 'assets/data/$key.json';
	}

	public static inline function music(key:String):String
	{
		return 'assets/music/$key.ogg';
	}

	public static inline function shader(key:String):String
	{
		return 'assets/shaders/$key';
	}

	public static inline function sound(key:String):String
	{
		return 'assets/sounds/$key.wav';
	}

	public static inline function sprite(key:String):String
	{
		return 'assets/sprites/$key.png';
	}

	public static function spritesheet(key:String, frames:Array<Int>):FlxAtlasFrames
	{
		var atlas:FlxAtlas = new FlxAtlas(AssetPaths.sprite(key), FlxPoint.weak(0, 0));

		for (i in frames)
		{
			var file:String = AssetPaths.sprite('${key}_$i');
			if (Assets.exists(file))
				atlas.addNode(file, key.substring(key.lastIndexOf('/') + 1, key.length) + i);
			else
				FlxG.log.error("Couldn't find frame " + file);
		}

		return atlas.getAtlasFrames();
	}
}
