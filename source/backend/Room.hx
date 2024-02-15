package backend;

import haxe.io.Path;
import haxe.Exception;
import flixel.FlxG;
import openfl.utils.Assets;

using StringTools;

class Room
{
	public static var data(default, null):Map<Int, {file:String, content:Xml}> = [];

	private static final directory:String = 'assets/data/rooms';

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
			final parsed:Xml = Xml.parse(Assets.getText(file)).firstElement();

			if (parsed.get('id') == null || parsed.get('id').length <= 0)
				continue;

			final id:Int = Std.parseInt(parsed.get('id'));

			if (data.exists(id))
				FlxG.log.notice('Overwriting room $id.');

			data.set(id, {file: Path.withoutExtension(file.replace(Path.addTrailingSlash(directory), '')), content: parsed});
		}
	}
}
