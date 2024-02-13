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

		for (file in Assets.list(TEXT).filter(folder -> folder.startsWith('assets/data/rooms')))
		{
			if (Path.extension(file) != 'xml')
				continue;

			final parsed:Xml = Xml.parse(Assets.getText(file)).firstElement();

			if (parsed.get('id') == null || parsed.get('id').length <= 0)
				continue;

			data.set(Std.parseInt(parsed.get('id')), {file: file, content: parsed});
		}

		FlxG.log.notice(data);
	}
}
