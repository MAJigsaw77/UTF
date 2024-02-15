package backend;

import haxe.io.Path;
import haxe.Exception;
import flixel.FlxG;
import openfl.utils.Assets;

using StringTools;

class Room
{
	public static var data(default, null):Map<Int, {file:String, content:Xml}> = [];

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
			final parsed:Xml = Xml.parse(Assets.getText(file)).firstElement();

			if (parsed.get('id') == null || parsed.get('id').length <= 0)
				continue;

			data.set(Std.parseInt(parsed.get('id')), {file: new Path(file).file, content: parsed});
		}

		FlxG.log.notice(data);
	}
}
