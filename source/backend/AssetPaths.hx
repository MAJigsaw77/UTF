package backend;

import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.FlxG;
import haxe.io.Path;
import haxe.Exception;
import openfl.utils.Assets;

typedef SheetData =
{
	animation:String,
	path:String,
	frames:Array<Int>
}

class AssetPaths
{
	public static inline function script(key:String):String
	{
		return 'assets/data/$key.hxs';
	}

	public static inline function data(key:String):String
	{
		return 'assets/data/$key.json';
	}

	public static inline function room(key:String):String
	{
		return 'assets/data/$key.xml';
	}

	public static inline function music(key:String):String
	{
		return 'assets/music/$key.ogg';
	}

	public static inline function sound(key:String):String
	{
		return 'assets/sounds/$key.wav';
	}

	public static inline function background(key:String):String
	{
		return 'assets/images/backgrounds/$key.png';
	}

	public static inline function sprite(key:String):String
	{
		return 'assets/images/sprites/$key.png';
	}

	public static function font(key:String):String
	{
		final path:String = 'assets/fonts/$key.ttf';

		try
		{
			if (Assets.exists(path, FONT))
				return Assets.getFont(path).fontName;
			else if (Assets.exists(Path.withoutExtension(path), FONT))
				return Assets.getFont(Path.withoutExtension(path)).fontName;
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static inline function shader(key:String):String
	{
		try
		{
			return Assets.getText('assets/shaders/$key');
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static function spritesheet(data:{key:String, sheet:Array<SheetData>}):FlxAtlasFrames
	{
		if (data == null)
			return null;

		var atlas:FlxAtlas = new FlxAtlas(AssetPaths.sprite(data.key), FlxPoint.weak(0, 0), FlxPoint.weak(0, 0));

		for (sheet in data.sheet)
		{
			for (frame in sheet.frames)
			{
				final path:String = AssetPaths.sprite(sheet.path + '_$frame');

				if (Assets.exists(path, IMAGE))
					atlas.addNode(Assets.getBitmapData(path, false), sheet.animation + frame);
				else
					atlas.addNode('flixel/images/logo/default.png', sheet.animation + frame);
			}
		}

		return atlas.getAtlasFrames();
	}
}
