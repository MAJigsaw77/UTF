package backend;

import haxe.io.Path;
import haxe.Exception;
import flixel.FlxG;
import openfl.utils.Assets;

using StringTools;

typedef RoomData =
{
	file:String,
	content:Xml
}

class Room
{
	public static var data(default, null):Map<Int, RoomData> = [];

	public static function reloadFiles():Void
	{
		if (data != null && Lambda.count(data) > 0)
			data.clear();

		final files:Array<String> = Assets.list(TEXT).filter(function(file:String):Bool
		{
			return Path.directory(file) == 'assets/data/rooms' && Path.extension(file) == 'xml';
		});

		files.sort(function(a:String, b:String):Int
		{
			return (a < b) ? -1 : (a > b) ? 1 : 0;
		});

		for (file in files)
		{
			try
			{
				final data:Xml = Xml.parse(Assets.getText(file)).firstElement();

				if (data.get('id') == null || data.get('id').length <= 0)
					continue;

				data.set(Std.parseInt(data.get('id')), {file: file, data: data});
			}
			catch (e:Exception)
				FlxG.log.error(e.message);
		}
	}
}
