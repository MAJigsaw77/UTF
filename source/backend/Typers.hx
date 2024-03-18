package backend;

import backend.AssetPaths;
import haxe.io.Path;
import haxe.xml.Access;
import haxe.Exception;
import flixel.FlxG;
import openfl.utils.Assets;

using StringTools;

typedef TyperFont =
{
	name:String,
	size:Int
}

typedef TyperSound =
{
	name:String,
	volume:Float
}

typedef TyperData =
{
	font:TyperFont,
	sounds:Array<TyperSound>,
	delay:Float,
	spacing:Null<Float>
}

class Typers
{
	public static var data(default, null):Map<String, TyperData> = [];

	private static final directory:String = 'assets/data/typers';

	public static function reloadFiles():Void
	{
		if (data != null && Lambda.count(data) > 0)
			data.clear();

		final files:Array<String> = Assets.list(TEXT).filter(function(file:String):Bool
		{
			return Path.directory(file) == directory && Path.extension(file) == 'xml';
		});

		files.sort(function(a:String, b:String):Int
		{
			return (a < b) ? -1 : (a > b) ? 1 : 0;
		});

		for (file in files)
		{
			final parsed:Access = new Access(Xml.parse(Assets.getText(file)).firstElement());

			var typerFont:TyperFont = null;

			if (parsed.hasNode.font)
			{
				final font:Access = parsed.node.font;

				var fontName:String = 'DTM-Mono';

				if (font.hasNode.name && font.node.name.innerData != null && font.node.name.innerData.length > 0)
				{
					if (AssetPaths.font(font.node.name.innerData) != null)
						fontName = font.node.name.innerData;
				}

				var fontSize:Int = 32;

				if (font.hasNode.size && font.node.size.innerData != null && font.node.size.innerData.length > 0)
				{
					final parsedNumber:Null<Int> = Std.parseInt(font.node.size.innerData);

					if (parsedNumber != null)
						fontSize = parsedNumber;
				}

				typerFont = {name: fontName, size: fontSize};
			}

			var typerSounds:Array<TyperSound> = [];

			if (parsed.hasNode.sounds)
			{
				final sounds:Access = parsed.node.sounds;

				for (sound in sounds.nodes.sound)
				{
					var soundName:String = 'txt1';

					if (sound.hasNode.name && sound.node.name.innerData != null && sound.node.name.innerData.length > 0)
					{
						if (Assets.exists(AssetPaths.sound(sound.node.name.innerData), SOUND))
							soundName = sound.node.name.innerData;
					}

					var soundVolume:Float = 1;

					if (sound.hasNode.volume && sound.node.volume.innerData != null && sound.node.volume.innerData.length > 0)
					{
						final parsedNumber:Float = Std.parseFloat(sound.node.volume.innerData);

						if (!Math.isNaN(parsedNumber))
							soundVolume = parsedNumber;
					}

					typerSounds.push({name: soundName, volume: soundVolume});
				}

				if (typerSounds.length <= 0)
					typerSounds.push({name: 'txt1', volume: 1});
			}

			var typerDelay:Float = 0.05;

			if (parsed.hasNode.delay)
			{
				if (parsed.node.delay.innerData != null && parsed.node.delay.innerData.length > 0)
				{
					final parsedNumber:Float = Std.parseFloat(parsed.node.delay.innerData);

					if (!Math.isNaN(parsedNumber))
						typerDelay = parsedNumber;
				}
			}

			var typerSpacing:Null<Float> = null;

			if (parsed.hasNode.spacing)
			{
				if (parsed.node.spacing.innerData != null && parsed.node.spacing.innerData.length > 0)
				{
					final parsedNumber:Float = Std.parseFloat(parsed.node.spacing.innerData);

					if (!Math.isNaN(parsedNumber))
						typerSpacing = parsedNumber;
				}
			}

			data.set(new Path(file).file, {
				font: typerFont,
				sounds: typerSounds,
				delay: typerDelay,
				spacing: typerSpacing
			});
		}
	}
}
